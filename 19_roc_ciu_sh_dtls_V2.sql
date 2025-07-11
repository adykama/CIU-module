use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_sh_dtls (CIU) 20
*/

-- System user
DECLARE @SystemUserId INT = (
    SELECT pk_userid 
    FROM crsdb2.informix.tbusr_m_user 
    WHERE username = 'system'
);

-- Default date
DECLARE @Defaultdate DATETIME2 = '1900-01-01 00:00:00.00000';

-- Snapshot values
DECLARE 
    @StatusStartDT DATE,
    @StatusEndDT DATE,
    @DVQStartDT DATE,
    @DVQEndDT DATE,
    @DataLoadStatus INT,
    @NullDT INT;

SELECT 
    @StatusStartDT = StatusStartDT,
    @StatusEndDT = StatusEndDT,
    @DVQStartDT = DVQStartDT,
    @DVQEndDT = DVQEndDT,
    @DataLoadStatus = DataLoadStatus,
    @NullDT = NullDT
FROM crs_db.dbo.tbSSIS_m_IncrementalSnapShot 
WHERE module = 'CIU';

-- Code setup values
DECLARE 
    @SHARE_TYP_1 INT,
    @SHARE_TYP_2 INT,
    @CLASS_A INT,
    @CLASS_B INT,
    @SHARE_DT_1 INT,
    @SHARE_DT_2 INT;

SELECT
    @SHARE_TYP_1 = MAX(CASE WHEN codetype = 'TypeOfShare' AND codevalue1 = 'SHARE_TYP_1' THEN pk_codesetupid END),
    @SHARE_TYP_2 = MAX(CASE WHEN codetype = 'TypeOfShare' AND codevalue1 = 'SHARE_TYP_2' THEN pk_codesetupid END),
    @CLASS_A     = MAX(CASE WHEN codetype = 'ClassOfShare' AND codevalue1 = 'CLASS_A' THEN pk_codesetupid END),
    @CLASS_B     = MAX(CASE WHEN codetype = 'ClassOfShare' AND codevalue1 = 'CLASS_B' THEN pk_codesetupid END),
    @SHARE_DT_1  = MAX(CASE WHEN codetype = 'DetailsOfShare' AND codevalue1 = 'SHARE_DT_1' THEN pk_codesetupid END),
    @SHARE_DT_2  = MAX(CASE WHEN codetype = 'DetailsOfShare' AND codevalue1 = 'SHARE_DT_2' THEN pk_codesetupid END)
FROM crsdb2.informix.tbsys_m_codesetup 
WHERE modulecode = 'CMN' 
  AND codetype IN ('TypeOfShare', 'ClassOfShare', 'DetailsOfShare')
  AND codevalue1 IN ('SHARE_TYP_1', 'SHARE_TYP_2', 'CLASS_A', 'CLASS_B', 'SHARE_DT_1', 'SHARE_DT_2');

;WITH CTE_CREATED AS(
SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

,BaseData AS (
    SELECT DISTINCT
        rcs.rcsh_id,
        sh.intcurrentshare,
        ishr.dblordissuedcash,
        ishr.dblordissuednoncash,
        ishr.dblprefissuedcash,
        ishr.dblprefissuednoncash,
        ishr.dblordaissuedcash,
        ishr.dblordbissuedcash,
        ishr.dblordaissuednoncash,
        ishr.dblordbissuednoncash,
        ishr.dblprefaissuedcash,
        ishr.dblprefbissuedcash,
        ishr.dblprefaissuednoncash,
        ishr.dblprefbissuednoncash,
        sh.dtcreatedate,
        sh.dtupdatedate,
        sh.vchcreateby,
        sh.vchupdateby,
        sh.srlshareholderkeycode,
        rcs.rc_id
    FROM (SELECT intcurrentshare,vchcompanyno,srlshareholderkeycode,dtcreatedate,dtupdatedate,vchcreateby,vchupdateby,intissuedsharekeycode 
		FROM crs_db.dbo.rocshareholders) sh
    
	INNER JOIN (SELECT src_ref_key_col FROM crsdb2.informix.crs_ent_prf) p 
		ON sh.vchcompanyno = p.src_ref_key_col
    
	LEFT JOIN (SELECT vchcompanyno,vchlodgingref,dtupdatedate FROM crs_db.dbo.roclodgingdetails) dt 
		ON dt.vchcompanyno = sh.vchcompanyno
    
	LEFT JOIN (SELECT vchlodgingref,vchcompanyno FROM crs_db.dbo.roclodgingmaster WHERE vchformcode = 'C21') m 
		ON m.vchlodgingref = dt.vchlodgingref AND m.vchcompanyno = dt.vchcompanyno

    INNER JOIN (SELECT vchcompanyno,srlissuedsharekeycode,dblordissuedcash,dblordissuednoncash,dblprefissuedcash,dblprefissuednoncash,dblordaissuedcash,dblordbissuedcash,
					dblordaissuednoncash,dblordbissuednoncash,dblprefaissuedcash,dblprefbissuedcash,dblprefaissuednoncash,dblprefbissuednoncash
		FROM crs_db.dbo.rocallotmentofissuedshares) ishr 
		ON ishr.vchcompanyno = sh.vchcompanyno AND ishr.srlissuedsharekeycode = sh.intissuedsharekeycode

    INNER JOIN (SELECT src_ref_key_col,rc_id,rcsh_id FROM crsdb2.informix.CIU_roc_ciu_shldr WHERE is_migrated = 5) rcs 
		ON rcs.src_ref_key_col = sh.srlshareholderkeycode

    WHERE 
	  (
		(@DataLoadStatus IS NULL AND dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT)
		OR dt.dtupdatedate IS NULL
      )
)

,ShareTypes AS (
    SELECT 'ORD A' AS shtype, 'CSH' AS shdtls UNION ALL
    SELECT 'ORD A', 'OTH' UNION ALL
    SELECT 'ORD B', 'CSH' UNION ALL
    SELECT 'ORD B', 'OTH' UNION ALL
    SELECT 'PRE A', 'CSH' UNION ALL
    SELECT 'PRE A', 'OTH' UNION ALL
    SELECT 'PRE B', 'CSH' UNION ALL
    SELECT 'PRE B', 'OTH'
)

--,CTE_BASE AS (
--	SELECT 
--    bd.rcsh_id,
--    bd.intcurrentshare,
--    bd.dblordissuedcash,
--    bd.dblordissuednoncash,
--    bd.dblprefissuedcash,
--    bd.dblprefissuednoncash,
--    bd.dblordaissuedcash,
--    bd.dblordbissuedcash,
--    bd.dblordaissuednoncash,
--    bd.dblordbissuednoncash,
--    bd.dblprefaissuedcash,
--    bd.dblprefbissuedcash,
--    bd.dblprefaissuednoncash,
--    bd.dblprefbissuednoncash,
--    st.shtype,
--    st.shdtls,
--    bd.dtcreatedate,
--    bd.dtupdatedate,
--    bd.vchcreateby,
--    bd.vchupdateby,
--    bd.srlshareholderkeycode,
--    bd.rc_id
--FROM BaseData bd
--CROSS JOIN ShareTypes st
--)

,CTE_MAIN AS (
SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(base.dtcreatedate, @Defaultdate) AS createddate
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,ISNULL(base.dtupdatedate, @Defaultdate) AS modifieddate

,0 AS version
,1 AS rcsd_sts

,CASE WHEN st.shtype IN ('ORD A', 'ORD B') THEN @SHARE_TYP_1
    ELSE @SHARE_TYP_2 END AS rcsd_type_id

,CASE WHEN st.shtype IN ('ORD A', 'PRE A') THEN @CLASS_A
    ELSE @CLASS_B END AS rcsd_class_id

,CASE WHEN st.shdtls = 'CSH' THEN @SHARE_DT_1
    ELSE @SHARE_DT_2 END AS rcsd_dtls_id

,CASE WHEN st.shtype = 'ORD A' AND st.shdtls = 'CSH' THEN base.dblordissuedcash
    WHEN st.shtype = 'ORD A' AND st.shdtls = 'OTH' THEN base.dblordaissuednoncash
    WHEN st.shtype = 'ORD B' AND st.shdtls = 'CSH' THEN base.dblordissuedcash
    WHEN st.shtype = 'ORD B' AND st.shdtls = 'OTH' THEN base.dblordaissuednoncash
    WHEN st.shtype = 'PRE A' AND st.shdtls = 'CSH' THEN base.dblprefbissuedcash
    WHEN st.shtype = 'PRE A' AND st.shdtls = 'OTH' THEN base.dblordbissuednoncash
    WHEN st.shtype = 'PRE B' AND st.shdtls = 'CSH' THEN base.dblprefbissuedcash
    WHEN st.shtype = 'PRE B' AND st.shdtls = 'OTH' THEN base.dblordbissuednoncash	
	ELSE NULL END AS rcsd_unit_no

,CASE WHEN st.shtype = 'ORD A' AND st.shdtls = 'CSH' THEN base.dblordaissuedcash
	WHEN st.shtype = 'ORD A' AND st.shdtls = 'OTH' THEN base.dblordaissuednoncash
	WHEN st.shtype = 'ORD B' AND st.shdtls = 'CSH' THEN base.dblordbissuedcash
	WHEN st.shtype = 'ORD B' AND st.shdtls = 'OTH' THEN base.dblordbissuednoncash
	WHEN st.shtype = 'PRE A' AND st.shdtls = 'CSH' THEN base.dblprefaissuedcash
	WHEN st.shtype = 'PRE A' AND st.shdtls = 'OTH' THEN base.dblprefaissuednoncash
	WHEN st.shtype = 'PRE B' AND st.shdtls = 'CSH' THEN base.dblprefbissuedcash
	WHEN st.shtype = 'PRE B' AND st.shdtls = 'OTH' THEN base.dblprefbissuednoncash
	ELSE base.dblprefbissuednoncash END AS rcsd_issued

,ISNULL(base.intcurrentshare, 0.00) AS rcsd_amount
,base.rcsh_id AS rcsh_id
,base.rc_id AS rc_id
,base.srlshareholderkeycode AS src_ref_key_col

FROM BaseData base
CROSS JOIN ShareTypes st
--CTE_BASE AS base

LEFT JOIN CTE_CREATED CB 
ON CB.vchuserid = base.vchcreateby
 
LEFT JOIN CTE_CREATED MB 
ON MB.vchuserid = base.vchupdateby
)

--Final Table
SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcsd_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,X.version 
,X.rcsd_sts
,X.rcsd_type_id
,X.rcsd_class_id
,X.rcsd_dtls_id
,X.rcsd_unit_no
,X.rcsd_issued
,X.rcsh_id
,X.rc_id 
,'rocshareholders' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS etl_mig_ref_id
,5 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM CTE_MAIN X

/*
total time	: 9 min 26 Sec
total record: 27,678,056


source table -----------------------------------------------------

select count(*) from (
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD A' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  
inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash ,'ORD A' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD B' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'ORD B' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5

union all

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  AND rcs.is_migrated = 5
)Z 

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_sh_dtls

*/

/*
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD A' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash ,'ORD A' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD B' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'ORD B' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union all

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union all 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD A' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash ,'ORD A' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD B' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21'  and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'ORD B' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union ALL 
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'CSH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null
union all
select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'OTH' as shdtls
from crs_db.dbo.rocshareholders sh  inner join informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join informix.roc_ciu_shldr rcs on rcs.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar) 
where m.vchformcode='C21' and dt.dtupdatedate is null

*/