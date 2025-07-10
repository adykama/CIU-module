use crs_db;
/*
	base query for
	table: crsdb2.informix.crs_ciu (CIU)
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
JOIN crs_db.dbo.roclodgingmaster rlm ON uam.vchuserid = rlm.vchcreateby
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS ciu_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS ciu_sts
,X.submission_id
,NULL AS ciu_mk_sbm
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,12 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(cs.submission_id,NULL) AS submission_id 

,dt.srllodgingkeycode AS src_ref_key_col

,ROW_NUMBER() OVER (PARTITION BY cs.submission_id ORDER BY dt.srllodgingkeycode DESC) AS row_num

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt 
ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

INNER JOIN crsdb2.informix.crs_submission cs 
ON cs.src_ref_key_col = dt.srllodgingkeycode
AND cs.is_migrated = '25'

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)'))
AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X
WHERE X.row_num = 1;

/*
total time	: 2 min 15 Sec
total record: 11,953,708


source table -----------------------------------------------------

select distinct dt.srllodgingkeycode,b.submission_id from crs_db.dbo.roclodgingdetails dt inner join informix.crs_submission b 
on dt.vchlodgingref=b.refno and b.is_migrated =25 
inner join crs_db.dbo.roclodgingmaster a on dt.vchlodgingref=a.vchlodgingref 
and dt.vchcompanyno =a.vchcompanyno where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
where (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

union
select distinct dt.srllodgingkeycode,b.submission_id from crs_db.dbo.roclodgingdetails dt inner join informix.crs_submission b 
on dt.vchlodgingref=b.refno and b.is_migrated =25 
inner join crs_db.dbo.roclodgingmaster a on dt.vchlodgingref=a.vchlodgingref 
and dt.vchcompanyno =a.vchcompanyno where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
where dt.dtupdatedate is null

target table -----------------------------------------------------
select count(1) from crsdb2.informix.crs_ciu where is_migrated = 12 -- 8892433

*/
