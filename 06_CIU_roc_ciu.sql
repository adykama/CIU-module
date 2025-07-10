use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu (CIU)
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

insert into crsdb2.informix.roc_ciu(rc_id
,createdby
,createddate
,modifiedby
,modifieddate
,[version]
,ciu_id
,lodger_info_id
,rc_ref_no
,decl_content_id
,rc_sts
,rc_action_id
,usr_addl_info_id
,src_tablename
,src_ref_key_col
,etl_mig_ref_id
,is_migrated
,source_of_data)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rc_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,X.ciu_id
,NULL AS lodger_info_id
,X.rc_ref_no
,NULL AS decl_content_id
,1 AS rc_sts
,NULL AS rc_action_id
,NULL AS usr_addl_info_id
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,112 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(cc.ciu_id,NULL) AS ciu_id 
,ISNULL(dt.vchlodgingref,NULL) AS rc_ref_no 
,dt.srllodgingkeycode AS src_ref_key_col

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt 
ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

INNER JOIN crsdb2.informix.CIU_crs_ciu cc
ON cc.src_ref_key_col=dt.srllodgingkeycode
AND cc.is_migrated = '12'

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)'))
AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X

/*
total time	: 1 min 55 Sec
total record: 11,953,708


source table -----------------------------------------------------

select distinct c.ciu_id from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.crs_ciu c on c.submission_id=b.submission_id 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

UNION 

select distinct c.ciu_id from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.crs_ciu c on c.submission_id=b.submission_id 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu

*/
