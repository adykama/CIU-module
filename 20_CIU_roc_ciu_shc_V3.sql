use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_shc (CIU)
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
SELECT @SHARE_TYP_1 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup where modulecode = 'CMN' AND codetype = 'TypeOfShare' AND codevalue1 = 'SHARE_TYP_1'),NULL);

DECLARE @SHARE_TYP_2 INT;
SELECT @SHARE_TYP_2 = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup where modulecode = 'CMN' AND codetype = 'TypeOfShare' AND codevalue1 = 'SHARE_TYP_2'),NULL);

DECLARE @CLASS_A INT;
SELECT @CLASS_A = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'ClassOfShare' AND codevalue1='CLASS_A'),NULL);

DECLARE @CLASS_B INT;
SELECT @CLASS_B = NULLIF((SELECT pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'ClassOfShare' AND codevalue1='CLASS_B'),NULL)

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1),

Base_Data AS (

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,ishr.dblprefaissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'CSH' as shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union

select distinct p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

Union

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

Union 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

Union  

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union 

select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
from crs_db.dbo.rocincorporation r 
inner join crs_db.dbo.roclodgingmaster a on a.vchcompanyno  =r.vchcompanyno  
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno --and b.is_migrated =25
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref --and d.is_migrated=12
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and a.vchcompanyno=dt.vchcompanyno
inner join crs_db.dbo.rocshareholders sh on sh.vchcompanyno =a.vchcompanyno 
inner join crs_db.dbo.rocallotmentofissuedshares ishr  on ishr.vchcompanyno=p.src_ref_key_col and sh.intissuedsharekeycode=ishr.srlissuedsharekeycode
left join crsdb2.informix.CIU_roc_ciu_sh_dtls rsd on rsd.src_ref_key_col=sh.srlshareholderkeycode
left join crs_db.dbo.mycoidallotmentofshares myshr on r.vchcompanyno=myshr.vchcompanyno 
where (a.vchformcode in ('C22','C22A') AND b.is_migrated = 25 AND d.is_migrated = 12 AND rsd.is_migrated = 5)
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))
)

--select count(*) from (

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
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

into crsdb2.informix.CIU_roc_ciu_shc

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,FORMAT(ISNULL(base.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(base.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate

,0 AS version
,1 AS rcs_sts
,base.rc_id AS rc_id

,CASE WHEN base.shtype IN ('ORD A', 'ORD B') THEN @SHARE_TYP_1
    ELSE @SHARE_TYP_2 END AS typ_sh_id

,CASE WHEN base.shtype IN ('ORD A', 'PRE A') THEN @CLASS_A
    ELSE @CLASS_B END AS class_sh_id

,CASE WHEN shtype = 'ORD A' THEN base.dblordissuedcash
        WHEN shtype = 'ORD B' THEN base.dblordbissuedcash
        WHEN shtype = 'PRE A' THEN base.dblprefaissuedcash
        WHEN shtype = 'PRE B' THEN base.dblprefbissuedcash
    ELSE NULL END AS cash_unit

,CASE WHEN shtype = 'ORD A' THEN base.dblordaissuednoncash
        WHEN shtype = 'ORD B' THEN base.dblordbissuednoncash
        WHEN shtype = 'PRE A' THEN base.dblprefaissuednoncash
        WHEN shtype = 'PRE B' THEN base.dblprefbissuednoncash
    ELSE NULL END AS otherwise_unit

,CASE WHEN shtype = 'ORD A' THEN base.intordanumberofshares
        WHEN shtype = 'ORD B' THEN base.intordbnumberofshares
        WHEN shtype = 'PRE A' THEN base.intprefanumberofshares
        WHEN shtype = 'PRE B' THEN base.intprefbnumberofshares
    ELSE NULL END AS no_unit

,CASE WHEN shtype = 'ORD A' AND sharetype = 'ORDINARY A' THEN base.intpricepershare
        WHEN shtype = 'ORD B' AND sharetype = 'ORDINARY B' THEN base.intpricepershare
        WHEN shtype = 'PRE A' AND sharetype = 'PREFERENCE A' THEN base.intpricepershare
        WHEN shtype = 'PRE B' AND sharetype = 'PREFERENCE B' THEN base.intpricepershare 
	ELSE NULL END AS price_sh

,CASE 
        WHEN shtype = 'ORD A' AND shdtls = 'CSH' THEN base.dblordaissuedcash
        WHEN shtype = 'ORD A' AND shdtls = 'OTH' THEN base.dblordaissuednoncash
        WHEN shtype = 'ORD B' AND shdtls = 'CSH' THEN base.dblordbissuedcash
        WHEN shtype = 'ORD B' AND shdtls = 'OTH' THEN base.dblordbissuednoncash
        WHEN shtype = 'PRE A' AND shdtls = 'CSH' THEN base.dblprefaissuedcash
        WHEN shtype = 'PRE A' AND shdtls = 'OTH' THEN base.dblprefaissuednoncash
        WHEN shtype = 'PRE B' AND shdtls = 'CSH' THEN base.dblprefbissuedcash
        --WHEN shtype = 'PRE B' AND shdtls = 'OTH' THEN base.dblprefbissuednoncash
    ELSE base.dblprefbissuednoncash END AS amount_sh

,base.rcsd_id AS rcsd_id
,base.srlissuedsharekeycode AS src_ref_key_col

FROM Base_Data AS base

LEFT JOIN CTE_CREATED CB 
ON CB.vchuserid = base.vchcreateby
 
LEFT JOIN CTE_CREATED MB 
ON MB.vchuserid = base.vchupdateby

)X --new: 24,413
--)Z; --38,084,144 22m36s select count

/*
total time	: 1 hour 29 min 48 sec
total record: 38,084,144


source table -----------------------------------------------------

select count(*) from (
select distinct  p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,ishr.dblprefaissuedcash, 
myshr.intpricepershare ,myshr.vchsharedtl,ishr.dtcreatedate,ishr.dtupdatedate,ishr.srlissuedsharekeycode,ishr.vchcreateby,ishr.vchupdateby,
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'CSH' as shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
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
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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


select distinct  ishr.srlissuedsharekeycode,p.regno, r.vchcurrency , r.mnyauthorisedcapital, 
r.intordnumberofshares, r.intordanumberofshares, r.intordbnumberofshares, ishr.dblordissuedcash, ishr.dblordaissuedcash, 
ishr.dblordissuednoncash, ishr.dblordbissuednoncash, ishr.dblordbissuedcash, ishr.dblordaissuednoncash,
r.intprefnumberofshares, r.intprefanumberofshares, r.intprefbnumberofshares ,ishr.dblprefbissuednoncash,
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash, ishr.dblprefissuedcash , ishr.dblprefbissuedcash,
ishr.dblprefaissuedcash, myshr.intpricepershare ,myshr.vchsharedtl, 
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'CSH' as shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
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
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'OTH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'CSH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'OTH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'CSH' as shdtls, amt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'CSH' as shdtls, p.ent_prf_id, rsd.rcsd_id, d.rc_id
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
'ORDINARY A' as sharetype, 'ORD A' as shtype, 'OTH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'CSH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'ORDINARY B' as sharetype, 'ORD B' as shtype, 'OTH' as shdtls, almt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'CSH' as shdtls, amt.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE A' as sharetype, 'PRE A' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'CSH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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
ishr.dblprefissuednoncash ,ishr.dblprefaissuednoncash,ishr.dblprefaissuedcash,, ishr.dblprefissuedcash , ishr.dblprefbissuedcash, 'PREFERENCE B' as sharetype, 'PRE B' as shtype, 'OTH' as shdtls, p.ent_prf_id,rsd.rcsd_id, d.rc_id
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

