use crs_db;
/*
	ishr query for
	table: crsdb2.informix.roc_ciu_shc (CIU)
*/
DECLARE @SystemUserId INT;
SELECT @SystemUserId = pk_userid FROM crsdb2.informix.tbusr_m_user WHERE username = 'system';

DECLARE @Defaultdate datetime2 = '1900-01-01 00:00:00.00000';

-- Get snapshot dates and flags in one go
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

-- Get code setup values in one go
DECLARE 
    @SHARE_TYP_1 INT,
    @SHARE_TYP_2 INT,
    @CLASS_A INT,
    @CLASS_B INT;

SELECT 
    @SHARE_TYP_1 = MAX(CASE WHEN codevalue1 = 'SHARE_TYP_1' THEN pk_codesetupid END),
    @SHARE_TYP_2 = MAX(CASE WHEN codevalue1 = 'SHARE_TYP_2' THEN pk_codesetupid END),
    @CLASS_A     = MAX(CASE WHEN codevalue1 = 'CLASS_A' THEN pk_codesetupid END),
    @CLASS_B     = MAX(CASE WHEN codevalue1 = 'CLASS_B' THEN pk_codesetupid END)
FROM crsdb2.informix.tbsys_m_codesetup
WHERE modulecode = 'CMN' 
  AND codetype IN ('TypeOfShare', 'ClassOfShare')
  AND codevalue1 IN ('SHARE_TYP_1', 'SHARE_TYP_2', 'CLASS_A', 'CLASS_B');

;WITH CTE_CREATED AS(
SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

,sharetypes AS (
    SELECT 'ORDINARY B' AS sharetype, 'ORD B' AS shtype, 'CSH' AS shdtls UNION ALL
    SELECT 'ORDINARY B', 'ORD B', 'OTH' UNION ALL
	SELECT 'ORDINARY A', 'ORD A', 'CSH' UNION ALL
	SELECT 'ORDINARY A', 'ORD A', 'OTH' UNION ALL
    SELECT 'PREFERENCE A', 'PRE A', 'CSH' UNION ALL
    SELECT 'PREFERENCE A', 'PRE A', 'OTH' UNION ALL
    SELECT 'PREFERENCE B', 'PRE B', 'CSH' UNION ALL
    SELECT 'PREFERENCE B', 'PRE B', 'OTH'
)

,CTE_MAIN AS (
SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(ishr.dtcreatedate, @Defaultdate) AS createddate
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,ISNULL(ishr.dtupdatedate, @Defaultdate) AS modifieddate
,0 AS version
,1 AS rcs_sts
,d.rc_id AS rc_id

,CASE WHEN st.shtype IN ('ORD A', 'ORD B') THEN @SHARE_TYP_1
    ELSE @SHARE_TYP_2 END AS typ_sh_id

,CASE WHEN st.shtype IN ('ORD A', 'PRE A') THEN @CLASS_A
    ELSE @CLASS_B END AS class_sh_id

,CASE WHEN st.shtype = 'ORD A' THEN ishr.dblordissuedcash
        WHEN st.shtype = 'ORD B' THEN ishr.dblordbissuedcash
        WHEN st.shtype = 'PRE A' THEN ishr.dblprefaissuedcash
        WHEN st.shtype = 'PRE B' THEN ishr.dblprefbissuedcash
    ELSE NULL END AS cash_unit

,CASE WHEN st.shtype = 'ORD A' THEN ishr.dblordaissuednoncash
        WHEN st.shtype = 'ORD B' THEN ishr.dblordbissuednoncash
        WHEN st.shtype = 'PRE A' THEN ishr.dblprefaissuednoncash
        WHEN st.shtype = 'PRE B' THEN ishr.dblprefbissuednoncash
    ELSE NULL END AS otherwise_unit

,CASE WHEN st.shtype = 'ORD A' THEN r.intordanumberofshares
        WHEN st.shtype = 'ORD B' THEN r.intordbnumberofshares
        WHEN st.shtype = 'PRE A' THEN r.intprefanumberofshares
        WHEN st.shtype = 'PRE B' THEN r.intprefbnumberofshares
    ELSE NULL END AS no_unit

,CASE WHEN st.shtype = 'ORD A' AND st.sharetype = 'ORDINARY A' THEN myshr.intpricepershare
        WHEN st.shtype = 'ORD B' AND st.sharetype = 'ORDINARY B' THEN myshr.intpricepershare
        WHEN st.shtype = 'PRE A' AND st.sharetype = 'PREFERENCE A' THEN myshr.intpricepershare
        WHEN st.shtype = 'PRE B' AND st.sharetype = 'PREFERENCE B' THEN myshr.intpricepershare 
	ELSE NULL END AS price_sh

,CASE 
        WHEN st.shtype = 'ORD A' AND st.shdtls = 'CSH' THEN ishr.dblordaissuedcash
        WHEN st.shtype = 'ORD A' AND st.shdtls = 'OTH' THEN ishr.dblordaissuednoncash
        WHEN st.shtype = 'ORD B' AND st.shdtls = 'CSH' THEN ishr.dblordbissuedcash
        WHEN st.shtype = 'ORD B' AND st.shdtls = 'OTH' THEN ishr.dblordbissuednoncash
        WHEN st.shtype = 'PRE A' AND st.shdtls = 'CSH' THEN ishr.dblprefaissuedcash
        WHEN st.shtype = 'PRE A' AND st.shdtls = 'OTH' THEN ishr.dblprefaissuednoncash
        WHEN st.shtype = 'PRE B' AND st.shdtls = 'CSH' THEN ishr.dblprefbissuedcash
        WHEN st.shtype = 'PRE B' AND st.shdtls = 'OTH' THEN ishr.dblprefbissuednoncash
    ELSE ishr.dblprefbissuednoncash END AS amount_sh

,rsd.rcsd_id AS rcsd_id
,ishr.srlissuedsharekeycode AS src_ref_key_col

FROM sharetypes st

CROSS JOIN crs_db.dbo.rocincorporation r 

INNER JOIN 
	(SELECT vchcompanyno,vchlodgingref FROM crs_db.dbo.roclodgingmaster
		WHERE vchformcode IN ('C22', 'C22A') ) a 
	ON a.vchcompanyno = r.vchcompanyno  

INNER JOIN (SELECT refno FROM crsdb2.informix.crs_submission WHERE is_migrated = 25 ) b 
	ON a.vchlodgingref = b.refno 

INNER JOIN (SELECT src_ref_key_col FROM crsdb2.informix.crs_ent_prf) p 
	ON p.src_ref_key_col = a.vchcompanyno

INNER JOIN (SELECT rc_ref_no,rc_id FROM crsdb2.informix.roc_ciu WHERE is_migrated = 12) d 
	ON d.rc_ref_no = a.vchlodgingref 

INNER JOIN (SELECT vchlodgingref,vchcompanyno,dtupdatedate FROM crs_db.dbo.roclodgingdetails) dt 
	ON a.vchlodgingref = dt.vchlodgingref 
	AND a.vchcompanyno = dt.vchcompanyno

INNER JOIN (SELECT vchcompanyno,intissuedsharekeycode,srlshareholderkeycode FROM crs_db.dbo.rocshareholders) sh 
	ON sh.vchcompanyno = a.vchcompanyno 

INNER JOIN (SELECT vchcompanyno,srlissuedsharekeycode,dblordissuedcash, dblordaissuedcash, 
			dblordissuednoncash,dblordbissuednoncash, dblordbissuedcash, dblordaissuednoncash,dblprefbissuednoncash,dblprefissuednoncash,dblprefaissuednoncash,
			dblprefaissuedcash, dblprefissuedcash , dblprefbissuedcash,dtcreatedate,dtupdatedate,vchcreateby,vchupdateby
	FROM crs_db.dbo.rocallotmentofissuedshares) ishr 
	ON ishr.vchcompanyno = p.src_ref_key_col 
	AND sh.intissuedsharekeycode = ishr.srlissuedsharekeycode

LEFT JOIN (SELECT src_ref_key_col,rcsd_id FROM crsdb2.informix.CIU_roc_ciu_sh_dtls WHERE is_migrated = 5) rsd 
	ON rsd.src_ref_key_col = sh.srlshareholderkeycode

LEFT JOIN (select vchcompanyno,intpricepershare from crs_db.dbo.mycoidallotmentofshares) myshr 
	ON r.vchcompanyno = myshr.vchcompanyno 

LEFT JOIN CTE_CREATED CB 
	ON CB.vchuserid = ishr.vchcreateby
 
LEFT JOIN CTE_CREATED MB 
ON MB.vchuserid = ishr.vchupdateby

WHERE 
    (
        (dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
        OR dt.dtupdatedate IS NULL
    )
)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcs_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,X.version 
,X.rcs_sts
,X.rc_id
,X.typ_sh_id
,X.class_sh_id
,X.cash_unit
,X.no_unit
,X.otherwise_unit
,X.rcsd_id
,'rocallotmentofissuedshares' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

--into crsdb2.informix.CIU_roc_ciu_shc

FROM CTE_MAIN X)A;


/*
total time	: 11 min 48 sec
total record: 38,900,808


source table -----------------------------------------------------

select count(*) from (
select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,ishr.dblprefaissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

union all 

select distinct p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

Union ALL 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

Union ALL 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

union ALL 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

union ALL 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

Union ALL 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5

union all

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5
)Z 

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_shc
*/

/*
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
ishr.dblprefaissuedcash, myshr.intpricepershare ,myshr.vchsharedtl, 
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
union all 
select distinct ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'OTH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
Union ALL 
select distinct ishr.srlissuedsharekeycode, p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'CSH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
Union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'OTH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
union ALL 
select distinct ishr.srlissuedsharekeycode, p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'CSH' as st.shdtls, amt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
Union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
union all
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union all
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
ishr.dblprefaissuedcash, myshr.intpricepershare ,myshr.vchsharedtl, 
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
union all 
select distinct ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY A' as st.sharetype, 'ORD A' as st.shtype, 'OTH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
Union ALL 
select distinct ishr.srlissuedsharekeycode, p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'CSH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
Union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'ORDINARY B' as st.sharetype, 'ORD B' as st.shtype, 'OTH' as st.shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
union ALL 
select distinct ishr.srlissuedsharekeycode, p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'CSH' as st.shdtls, amt.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE A' as st.sharetype, 'PRE A' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
Union ALL 
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'CSH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null
union all
select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as st.sharetype, 'PRE B' as st.shtype, 'OTH' as st.shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated =25
inner join informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col 
and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join informix.roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=cast(sh.srlshareholderkeycode as varchar)
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where a.vchformcode in ('C22','C22A') and dt.dtupdatedate is null

Total : 1120536
*/