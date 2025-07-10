use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_sh_dtls (CIU) 20
*/

DECLARE @SystemUserId INT;
SELECT @SystemUserId = pk_userid FROM crsdb2.informix.tbusr_m_user WHERE username = 'system';

DECLARE @Defaultdate datetime2 = '1900-01-01 00:00:00.00000';

DECLARE @StatusStartDT DATE;
SELECT @StatusStartDT = StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @StatusEndDT DATE;
SELECT @StatusEndDT = StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @DVQStartDT DATE;
SELECT @DVQStartDT = DVQStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @DVQEndDT DATE;
SELECT @DVQEndDT = DVQEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @DataLoadStatus INT;
SELECT @DataLoadStatus = DataLoadStatus from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @NullDT INT;
SELECT @NullDT = NullDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot where module='CIU';

DECLARE @SHARE_TYP_1 INT;
SELECT @SHARE_TYP_1 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'TypeOfShare' AND codevalue1='SHARE_TYP_1'),NULL);

DECLARE @SHARE_TYP_2 INT;
SELECT @SHARE_TYP_2 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'TypeOfShare' AND codevalue1='SHARE_TYP_2'),NULL);

DECLARE @CLASS_A INT;
SELECT @CLASS_A = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'ClassOfShare' AND codevalue1 = 'CLASS_A'),NULL);

DECLARE @CLASS_B INT;
SELECT @CLASS_B = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'ClassOfShare' AND codevalue1 = 'CLASS_B'),NULL);

DECLARE @SHARE_DT_1 INT;
SELECT @SHARE_DT_1 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'DetailsOfShare' AND codevalue1 = 'SHARE_DT_1'),NULL);

DECLARE @SHARE_DT_2 INT;
SELECT @SHARE_DT_2 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'DetailsOfShare' AND codevalue1 = 'SHARE_DT_2'),NULL);

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1),

Base_Data AS (

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD A' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  
inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21' AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash ,'ORD A' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21' AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash , ishr.dblprefbissuednoncash , 'ORD B' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union  

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'ORD B' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union  

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE A' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'CSH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union

select distinct rcs.rcsh_id, sh.intcurrentshare, ishr.dblordissuedcash , ishr.dblordissuednoncash ,
ishr.dblprefissuedcash , ishr.dblprefissuednoncash ,ishr.dblordaissuedcash , ishr.dblordbissuedcash ,
ishr.dblordaissuednoncash ,ishr.dblordbissuednoncash , ishr.dblprefaissuedcash ,ishr.dblprefbissuedcash ,ishr.dblprefaissuednoncash ,ishr.dblprefbissuednoncash ,'PRE B' as shtype, 'OTH' as shdtls,sh.dtcreatedate,sh.dtupdatedate,sh.vchcreateby,sh.vchupdateby,sh.srlshareholderkeycode,rcs.rc_id
from crs_db.dbo.rocshareholders sh  inner join crsdb2.informix.crs_ent_prf p on sh.vchcompanyno=p.src_ref_key_col 
left join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno=sh.vchcompanyno
left join crs_db.dbo.roclodgingmaster m on m.vchlodgingref=dt.vchlodgingref and m.vchcompanyno=dt.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr on ishr.vchcompanyno =sh.vchcompanyno and ishr.srlissuedsharekeycode=sh.intissuedsharekeycode
inner join crsdb2.informix.CIU_roc_ciu_shldr rcs on rcs.src_ref_key_col=sh.srlshareholderkeycode --as varchar) 
where (m.vchformcode='C21'  AND rcs.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)

--select count(*) from (

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
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,5 AS is_migrated
,'CBS_ROC' AS source_of_data

into crsdb2.informix.CIU_roc_ciu_sh_dtls

FROM (

SELECT DISTINCT 
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcsd_id
,ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,FORMAT(ISNULL(base.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(base.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate

,0 AS version
,1 AS rcsd_sts

,CASE WHEN base.shtype IN ('ORD A', 'ORD B') THEN @SHARE_TYP_1
    ELSE @SHARE_TYP_2 END AS rcsd_type_id

,CASE WHEN base.shtype IN ('ORD A', 'PRE A') THEN @CLASS_A
    ELSE @CLASS_B END AS rcsd_class_id

,CASE WHEN base.shdtls = 'CSH' THEN @SHARE_DT_1
    ELSE @SHARE_DT_2 END AS rcsd_dtls_id

,CASE WHEN base.shtype = 'ORD A' AND base.shdtls = 'CSH' THEN base.dblordissuedcash
    WHEN base.shtype = 'ORD A' AND base.shdtls = 'OTH' THEN base.dblordaissuednoncash
    WHEN base.shtype = 'ORD B' AND base.shdtls = 'CSH' THEN base.dblordissuedcash
    WHEN base.shtype = 'ORD B' AND base.shdtls = 'OTH' THEN base.dblordaissuednoncash
    WHEN base.shtype = 'PRE A' AND base.shdtls = 'CSH' THEN base.dblprefbissuedcash
    WHEN base.shtype = 'PRE A' AND base.shdtls = 'OTH' THEN base.dblordbissuednoncash
    WHEN base.shtype = 'PRE B' AND base.shdtls = 'CSH' THEN base.dblprefbissuedcash
    WHEN base.shtype = 'PRE B' AND base.shdtls = 'OTH' THEN base.dblordbissuednoncash	
	ELSE NULL END AS rcsd_unit_no

,CASE WHEN base.shtype = 'ORD A' AND base.shdtls = 'CSH' THEN base.dblordaissuedcash
	WHEN base.shtype = 'ORD A' AND base.shdtls = 'OTH' THEN base.dblordaissuednoncash
	WHEN base.shtype = 'ORD B' AND base.shdtls = 'CSH' THEN base.dblordbissuedcash
	WHEN base.shtype = 'ORD B' AND base.shdtls = 'OTH' THEN base.dblordbissuednoncash
	WHEN base.shtype = 'PRE A' AND base.shdtls = 'CSH' THEN base.dblprefaissuedcash
	WHEN base.shtype = 'PRE A' AND base.shdtls = 'OTH' THEN base.dblprefaissuednoncash
	WHEN base.shtype = 'PRE B' AND base.shdtls = 'CSH' THEN base.dblprefbissuedcash
	--WHEN base.shtype = 'PRE B' AND base.shdtls = 'OTH' THEN base.dblprefbissuednoncash
	ELSE base.dblprefbissuednoncash END AS rcsd_issued

,ISNULL(base.intcurrentshare, 0.00) AS rcsd_amount
,base.rcsh_id AS rcsh_id
,base.rc_id AS rc_id
,base.srlshareholderkeycode AS src_ref_key_col

FROM Base_Data AS base

LEFT JOIN CTE_CREATED CB 
ON CB.vchuserid = base.vchcreateby
 
LEFT JOIN CTE_CREATED MB 
ON MB.vchuserid = base.vchupdateby

)X
--)Z; --17,220,944

/*
total time	: 58 min 03 Sec
total record: 17,476,912


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
