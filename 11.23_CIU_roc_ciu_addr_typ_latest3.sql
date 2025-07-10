use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_addr_typ (CIU)
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

CTE_EAD AS(select distinct c.ent_addr_id,a.vchcompanyno
from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.crs_ent_prf b on a.vchcompanyno = b.src_ref_key_col 
inner join crsdb2.informix.crs_ent_addr c on c.ent_prf_id = b.ent_prf_id) 

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcat_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS version
,1 AS rcat_sts
,X.rc_id
,2 AS rcat_type
,X.rcat_current_id 
,X.rcat_new_id 
,X.rcat_chg_dte
,NULL AS rcat_email_id
,NULL AS rcat_off_no_id
,NULL AS rcat_bizdfr_id
,NULL AS rcat_bizdto_id
,NULL AS rcat_bizhfr
,NULL AS rcat_bizhto
,X.rcat_mas_id
,'rocforeignaddress' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,2 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(max(CB.pk_userid), @SystemUserId) AS createdby
,ISNULL(max(MB.pk_userid), @SystemUserId) AS modifiedby
,FORMAT(ISNULL(max(e.dtcreatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate 
,FORMAT(ISNULL(max(e.dtupdatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,d.rc_id AS rc_id
,e.dtdateofchange AS rcat_chg_dte
,ea.ent_addr_id AS rcat_mas_id
,maddn.pk_addressid AS rcat_current_id
,maddn.pk_addressid AS rcat_new_id 
,max(e.srlforeignaddrkeycode) AS src_ref_key_col 

from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crs_db.dbo.rocforeignaddress e on e.vchcompanyno=a.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref 

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = e.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = e.vchupdateby

LEFT JOIN CTE_EAD ea
ON ea.vchcompanyno = a.vchcompanyno

INNER JOIN crsdb2.informix.CIU_tbadd_m_address_NID2 maddn
ON maddn.src_ref_key_col=e.srlforeignaddrkeycode
and maddn.src_tablename='rocforeignaddress'
and maddn.is_migrated='34'  
and e.chrrecordstatus = 'C'

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

group by dt.vchlodgingref,dt.vchcompanyno,d.rc_id,e.dtdateofchange,ea.ent_addr_id,maddn.pk_addressid--,maddc.pk_addressid

)X

/*
total time	: 3 Sec
total record: 812


source table -----------------------------------------------------

select distinct dt.vchlodgingref,dt.vchcompanyno ,e.chrrecordstatus ,adr.ent_addr_id,d.rc_id ,radd.pk_addressid ,
e.vchcreateby, e.dtcreatedate, e.dtdateofchange, e.srlforeignaddrkeycode
from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref 
inner join crs_db.dbo.rocforeignaddress e on e.vchcompanyno=a.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref 
inner join informix.crs_ent_prf p on p.src_ref_key_col =dt.vchcompanyno 
left join informix.crs_ent_addr adr on adr.ent_prf_id =p.ent_prf_id  
left join informix.tbadd_m_address radd on radd.src_tablename ='rocforeignaddress' and radd.src_ref_key_col =dt.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30',
'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')  
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
union 
select distinct dt.vchlodgingref,dt.vchcompanyno ,e.chrrecordstatus ,adr.ent_addr_id,d.rc_id ,radd.pk_addressid ,
e.vchcreateby, e.dtcreatedate, e.dtdateofchange, e.srlforeignaddrkeycode
from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref 
inner join crs_db.dbo.rocforeignaddress e on e.vchcompanyno=a.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref 
inner join informix.crs_ent_prf p on p.src_ref_key_col =dt.vchcompanyno 
left join informix.crs_ent_addr adr on adr.ent_prf_id =p.ent_prf_id  
left join informix.tbadd_m_address radd on radd.src_tablename ='rocforeignaddress' and radd.src_ref_key_col =dt.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30',
'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_addr_typ where is_migrated='2' and src_tablename='rocforeignaddress'

*/
