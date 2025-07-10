use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_bizcode (CIU)
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
JOIN crs_db.dbo.roccompanybusinessobject bo ON uam.vchuserid = bo.vchcreateby
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

SELECT 
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcb_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS rcb_sts
,X.rc_id
,X.rcb_bizcode_id
,X.rcb_bizcode
,X.rcb_desc
,NULL AS rcb_ctt
,'roccompanybusinessobject' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT
 ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(bo.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(bo.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(rc.rc_id,NULL) AS rc_id 

,CASE WHEN bo.vchbusinesscode IS NOT NULL THEN NULLIF(stp.pk_codesetupid,NULL)
		ELSE NULL END AS rcb_bizcode_id 
		
,ISNULL(bo.vchbusinesscode,NULL) AS rcb_bizcode	

,ISNULL(oc.vchbusinessdesceng,NULL) AS rcb_desc 

,bo.srlbusinessobjectkeycode AS src_ref_key_col

FROM crs_db.dbo.roclodgingmaster a
INNER join crs_db.dbo.roccompanybusinessobject bo on bo.vchlodgingref = a.vchlodgingref and bo.vchcompanyno = a.vchcompanyno
INNER join crs_db.dbo.rocbusinessobjectcode oc on oc.vchbusinesscode =bo.vchbusinesscode 
INNER JOIN crs_db.dbo.roclodgingdetails dt ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno
INNER join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col = a.vchcompanyno 

INNER JOIN crsdb2.informix.roc_ciu rc 
ON rc.rc_ref_no = a.vchlodgingref
and rc.is_migrated='12'

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = bo.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = bo.vchupdateby

LEFT JOIN crsdb2.informix.tbsys_m_codesetup stp
on stp.codevalue1 = bo.vchbusinesscode
and stp.modulecode ='CMN' and stp.codetype = 'msicCode'

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)') and bo.vchbusinesscode is not null) 
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (bo.vchbusinesscode is not null and dt.dtupdatedate IS NULL))

)X

/*
 
total time	: 7 Sec
total record: 34


source table -----------------------------------------------------

select bo.vchbusinesscode, d.rc_id, oc.vchbusinessdesceng  from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no =dt.vchlodgingref and d.src_ref_key_col =dt.srllodgingkeycode and d.is_migrated='12'
left join crs_db.dbo.roccompanybusinessobject bo on bo.vchlodgingref= a.vchlodgingref and bo.vchcompanyno=a.vchcompanyno
left join crs_db.dbo.rocbusinessobjectcode oc on oc.vchbusinesscode =bo.vchbusinesscode 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')  
and bo.vchbusinesscode is not null and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union

select bo.vchbusinesscode, d.rc_id, oc.vchbusinessdesceng  from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no =dt.vchlodgingref and d.src_ref_key_col =dt.srllodgingkeycode and d.is_migrated='12' 
left join crs_db.dbo.roccompanybusinessobject bo on bo.vchlodgingref= a.vchlodgingref and bo.vchcompanyno=a.vchcompanyno
left join crs_db.dbo.rocbusinessobjectcode oc on oc.vchbusinesscode =bo.vchbusinesscode 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')  and dt.vchformtrx not in ('99(308)')  
and bo.vchbusinesscode is not null and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_bizcode

*/
