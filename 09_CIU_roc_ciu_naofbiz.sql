use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_naofbiz (CIU)
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

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

SELECT  
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcn_id
,@SystemUserId AS createdby
,X.createddate
,@SystemUserId AS modifiedby
,X.modifieddate
,0 AS [version]
,1 AS rcn_sts
,X.rc_id
,X.rcn_chg_dte
,X.rcn_naofbiz
,'rocincorporation' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT distinct
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,ISNULL(roc.dtcreatedate,TRY_CAST('1900-01-01 00:00:00' AS DATETIME)) AS createddate 
,ISNULL(roc.dtupdatedate,TRY_CAST('1900-01-01 00:00:00' AS DATETIME)) AS modifieddate
,ISNULL(ciu.rc_id,NULL) AS rc_id 
,TRY_CAST(ISNULL(dtdateofchange, @Defaultdate) AS DATETIME) AS rcn_chg_dte
,ISNULL(roc.vchbusinessdescription,NULL) AS rcn_naofbiz
,roc.vchcompanyno AS src_ref_key_col

FROM crs_db.dbo.rocincorporation roc 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col =roc.vchcompanyno
inner join crs_db.dbo.roclodgingmaster a on roc.vchcompanyno=a.vchcompanyno
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated = 25
inner join crsdb2.informix.roc_ciu ciu on ciu.rc_ref_no =b.refno and ciu.is_migrated = 12 AND ciu.rc_ref_no <> ''
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = roc.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = roc.vchupdateby 
 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
and dt.vchformtrx not in ('99(308)') 
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X 

/*
total time	: 6 min 35 sec
total record: 11,953,431


source table -----------------------------------------------------

select distinct isnull(c.dtdateofchange,'1900-01-01') dtchg , c.vchbusinessdescription,d.rc_id,c.dtcreatedate,c.dtupdatedate,c.vchcompanyno from crs_db.dbo.rocincorporation c 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col =c.vchcompanyno
inner join crs_db.dbo.roclodgingmaster a on c.vchcompanyno=a.vchcompanyno
inner join crsdb2.informix.ciu_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crsdb2.informix.ciu_roc_ciu d on d.rc_ref_no =b.refno and d.is_migrated =12
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
and dt.vchformtrx not in ('99(308)')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union 

select distinct isnull(c.dtdateofchange,'1900-01-01') dtchg , c.vchbusinessdescription,d.rc_id,c.dtcreatedate,c.dtupdatedate,c.vchcompanyno from crs_db.dbo.rocincorporation c 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col =c.vchcompanyno
inner join crs_db.dbo.roclodgingmaster a on c.vchcompanyno=a.vchcompanyno
inner join crsdb2.informix.ciu_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crsdb2.informix.ciu_roc_ciu d on d.rc_ref_no =b.refno and d.is_migrated =12
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
and dt.vchformtrx not in ('99(308)')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_naofbiz

*/
