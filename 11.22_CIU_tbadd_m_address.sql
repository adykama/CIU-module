use crs_db;
/*
	base query for
	table: crsdb2.informix.tbadd_m_address - roc_ciu_addr_typ (CIU)
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
LOWER(CONVERT(VARCHAR(36), NEWID())) AS pk_addressid
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS version 
,X.address1
,X.address2
,X.address3
,NULL AS city
,NULL AS country 
,NULL AS isothers 
,NULL AS postcode
,NULL AS [state]
,1 AS status
,NULL AS fk_cityid
,NULL AS fk_countryid 
,NULL AS fk_postcodeid
,NULL AS fk_stateid
,'rocforeignaddress' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,34 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(e.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate 
,FORMAT(ISNULL(e.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,e.vchforeignaddress1 AS address1
,e.vchforeignaddress2 AS address2
,e.vchforeignaddress3 AS address3
,e.vchcompanyno AS src_ref_key_col

from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.rocforeignaddress e on e.vchcompanyno=a.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref 

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = e.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = e.vchupdateby

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)') 
and e.chrrecordstatus ='C')
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X

/*

total time	: 1 Sec
total record: 572


source table -----------------------------------------------------

select distinct e.srlforeignaddrkeycode  ,e.vchforeignaddress1, e.vchforeignaddress2, e.vchforeignaddress3,
e.vchcreateby, e.dtcreatedate, e.dtdateofchange
from  crs_db.dbo.rocforeignaddress e inner join informix.crs_ent_prf p on p.src_ref_key_col =e.vchcompanyno where e.chrrecordstatus ='C' 

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_branch where is_migrated='34' and src_tablename='rocforeignaddress_NID'

*/
