use crs_db;
/*
	base query for
	table: crsdb2.informix.tbadd_m_address - roc_ciu_branch (CIU)
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
AND mprofile.is_migrated = 1),

CTE_TOWN AS(select distinct child.pk_codesetupid,md.srlbranchmembersaddrkeycode,md.vchcompanyno
from crsdb2.informix.tbsys_t_codesetupdetails csd
left join crsdb2.informix.tbsys_t_codesetupdetails prtd on prtd.pk_codesetupdetailsid =  csd.fk_parentid
left join crsdb2.informix.tbsys_m_codesetup parent on parent.pk_codesetupid = prtd.fk_childid
left join crsdb2.informix.tbsys_m_codesetup child on child.pk_codesetupid = csd.fk_childid
inner join crs_db.dbo.rocbranchmembersaddresskept md on parent.mig_codevalue1 = md.chrmembersstatecode
where csd.status = 1 and prtd.status = 1 and parent.status = 1 and child.status = 1 and csd.fk_categoryid = 21 and parent.codetype = 'StateCode'
and child.modulecode = 'SYS' AND child.codetype = 'CityCode' and child.codevalue2 = md.vchmemberstown
and parent.mig_codevalue1 = md.chrmembersstatecode)

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
,X.city
,NULL AS country 
,NULL AS isothers 
,X.postcode
,X.[state]
,1 AS status
,X.fk_cityid
,NULL AS fk_countryid 
,X.fk_postcodeid
,X.fk_stateid
,'rocbranchmembersaddresskept' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,35 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(md.dtcreatedate, 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(md.dtupdatedate, 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,md.vchmembersaddress1 AS address1
,md.vchmembersaddress2 AS address2
,md.vchmembersaddress3 AS address3
,md.vchmemberspostcode AS postcode
,md.vchmemberstown AS city
,md.chrmembersstatecode AS [state]
,ste.pk_codesetupid AS fk_stateid
,tw.pk_codesetupid AS fk_cityid
,cd.pk_codesetupid AS fk_postcodeid
,md.srlbranchmembersaddrkeycode AS src_ref_key_col
	
FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.rocbranchmembersaddresskept md
ON a.vchcompanyno = md.vchcompanyno

inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = md.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = md.vchupdateby

LEFT JOIN crsdb2.informix.tbsys_m_codesetup ste
ON ste.mig_codevalue1 = md.chrmembersstatecode
AND ste.modulecode = 'SYS' AND ste.codetype = 'StateCode'

LEFT JOIN CTE_TOWN tw
ON tw.srlbranchmembersaddrkeycode=md.srlbranchmembersaddrkeycode

LEFT JOIN crsdb2.informix.tbsys_m_codesetup cd
ON cd.codevalue1 = md.vchmemberspostcode
AND cd.modulecode = 'SYS' AND cd.codetype = 'PostcodeCode'

WHERE a.vchformcode ='C73' 
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X

/*
total time	: 0.603 Sec
total record: 84


source table -----------------------------------------------------

SELECT distinct c.ent_addr_id,y.srlbranchmembersaddrkeycode ,y.vchmembersaddress1, y.vchmembersaddress2, y.vchmembersaddress3, y.vchmemberspostcode, y.vchmemberstown, 
y.chrmembersstatecode, y.vchcreateby, y.dtcreatedate ,y.dtdateofchange
FROM crs_db.dbo.roclodgingmaster z inner join crs_db.dbo.rocbranchmembersaddresskept y on z.vchcompanyno=y.vchcompanyno
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =z.vchcompanyno and dt.vchlodgingref =z.vchlodgingref 
inner join informix.crs_ent_prf b on dt.vchcompanyno=b.src_ref_key_col inner join informix.crs_ent_addr c on c.ent_prf_id=b.ent_prf_id 
inner join informix.crs_submission cs on cs.refno =dt.vchlodgingref and cs.is_migrated =25
inner join informix.roc_ciu d on d.rc_ref_no =cs.refno and d.is_migrated =12
where (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union ALL 

SELECT distinct c.ent_addr_id,y.srlbranchmembersaddrkeycode ,y.vchmembersaddress1, y.vchmembersaddress2, y.vchmembersaddress3, y.vchmemberspostcode, y.vchmemberstown, 
y.chrmembersstatecode, y.vchcreateby, y.dtcreatedate ,y.dtdateofchange
FROM crs_db.dbo.roclodgingmaster z inner join crs_db.dbo.rocbranchmembersaddresskept y on z.vchcompanyno=y.vchcompanyno
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =z.vchcompanyno and dt.vchlodgingref =z.vchlodgingref 
inner join informix.crs_ent_prf b on dt.vchcompanyno=b.src_ref_key_col inner join informix.crs_ent_addr c on c.ent_prf_id=b.ent_prf_id 
inner join informix.crs_submission cs on cs.refno =dt.vchlodgingref and cs.is_migrated =25
inner join informix.roc_ciu d on d.rc_ref_no =cs.refno and d.is_migrated =12
where dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.tbadd_m_address where is_migrated='25' and src_tablename='rocbranchmembersaddresskept'

*/
