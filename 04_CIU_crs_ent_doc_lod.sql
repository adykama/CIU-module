use crs_db;
/*
	base query for
	table: crsdb2.informix.crs_ent_doc_lod (CIU)
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

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS doc_lodging_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,X.doc_dt
,X.event_dt
,X.lodge_dt 
,X.receive_dt​ 
,1 AS [status]
,X.ent_prf_id
,X.status_doc_code
,X.refno
,NULL AS doc_code_id
,NULL AS section_id
,X.submission_id
,X.entity_name
,NULL AS crs_remark_id
,NULL AS applicant_name
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,25 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ep.ent_prf_id AS ent_prf_id
,dt.vchlodgingref AS refno
,FORMAT(ISNULL(dt.dtdocumentdate,'1900-01-01'), 'yyyy-MM-dd HH:mm:ss') AS doc_dt
,FORMAT(ISNULL(dt.dteventdate,'1900-01-01'), 'yyyy-MM-dd HH:mm:ss') AS event_dt
,FORMAT(ISNULL(dt.dtdatereceived,'1900-01-01'), 'yyyy-MM-dd HH:mm:ss') AS receive_dt
,FORMAT(ISNULL(dt.dtdatelodged,'1900-01-01'), 'yyyy-MM-dd HH:mm:ss') AS lodge_dt
,cs.submission_id AS submission_id
,NULL AS entity_name
,dt.srllodgingkeycode AS src_ref_key_col

,CASE WHEN dt.vchstatus = 'D' THEN 'E'
  		WHEN dt.vchstatus = 'S' THEN 'S'
  		WHEN dt.vchstatus = 'Q' THEN 'Q'
  		WHEN dt.vchstatus = 'A' THEN 'A'
  		WHEN dt.vchstatus IN ('R','T') THEN 'R'
  		WHEN dt.vchstatus IN ('V','M') THEN 'V'
		WHEN dt.vchstatus IN ('P') THEN 'O'
  		WHEN dt.vchstatus IN ('O','C') THEN 'P'
		ELSE NULL END AS status_doc_code​​ --INSERT INTO EXCEPTION REPORT
	
,ROW_NUMBER() OVER (PARTITION BY cs.submission_id ORDER BY cs.src_ref_key_col DESC) AS row_num
FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt 
ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

LEFT JOIN crsdb2.informix.crs_ent_prf ep 
ON ep.src_ref_key_col = dt.vchcompanyno

INNER JOIN crsdb2.informix.crs_submission cs 
ON cs.src_ref_key_col = dt.srllodgingkeycode
AND cs.is_migrated = 25

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby

WHERE (a.vchformcode in ('C49','C77','CIU_', 'C70','C73','C31','C21','C22','C22A','C26','C27','C28','C29','C30','C30A','CPD2') and dt.vchformtrx not in ('99(308)'))
OR (a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87'))


AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL AND @DataLoadStatus IS NULL AND @NullDT = 1))

)X
WHERE X.row_num = 1;

/*
total time	: 10 min 08 Sec
total record: 21,624,699


source table -----------------------------------------------------

select distinct a.vchlodgingref, dt.vchstatus,dt.dtdocumentdate , dt.dteventdate ,dt.dtdatereceived,  dt.dtdatelodged,p.ent_prf_id from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_crs_submission_V1 sb on sb.refno=a.vchlodgingref 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

UNION 

SELECT distinct a.vchlodgingref, dt.vchstatus,dt.dtdocumentdate , dt.dteventdate ,dt.dtdatereceived,  dt.dtdatelodged,p.ent_prf_id FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
inner join crsdb2.informix.CIU_crs_submission_V1 sb on sb.refno=a.vchlodgingref 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno  
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union 

select distinct a.vchlodgingref, dt.vchstatus,dt.dtdocumentdate , dt.dteventdate ,dt.dtdatereceived,dt.dtdatelodged,p.ent_prf_id from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on a.vchlodgingref=dt.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_crs_submission_V1 sb on sb.refno=a.vchlodgingref 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.dtupdatedate is null

UNION 

SELECT distinct a.vchlodgingref, dt.vchstatus,dt.dtdocumentdate , dt.dteventdate ,dt.dtdatereceived, dt.dtdatelodged,p.ent_prf_id FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
inner join crsdb2.informix.CIU_crs_submission_V1 sb on sb.refno=a.vchlodgingref 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno  
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87') and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.crs_ent_doc_lod

*/
