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
AND mprofile.is_migrated = 1)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcat_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS version
,1 AS rcat_sts
,X.rc_id
,1 AS rcat_type
,rcat_current_id 
,rcat_new_id 
,X.rcat_chg_dte
,NULL AS rcat_email_id
,NULL AS rcat_off_no_id
,X.rcat_bizdfr_id
,X.rcat_bizdto_id
,X.rcat_bizhfr
,X.rcat_bizhto
,X.rcat_mas_id
,'rocregisteredaddrtrx' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(max(e.dtcreatedate),@Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate 
,FORMAT(ISNULL(max(e.dtupdatedate),@Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,d.rc_id AS rc_id
,e.dtdateofchange AS rcat_chg_dte
,adr.ent_addr_id AS rcat_mas_id
,maddn.pk_addressid AS rcat_new_id 
,maddn.pk_addressid AS rcat_current_id 
,e.changedaysfrom AS rcat_bizdfr_id
,e.changedaysto AS rcat_bizdto_id
,e.changeofficehourfrom AS rcat_bizhfr
,e.changeofficehourto AS rcat_bizhto

,max(e.srlform44keytrx) AS src_ref_key_col 

,ROW_NUMBER() OVER (PARTITION BY max(e.srlform44keytrx) ORDER BY d.rc_id DESC) AS row_num

from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crs_db.dbo.rocregisteredaddrtrx e on e.vchcompanyno=a.vchcompanyno and e.vchlodgingref=a.vchlodgingref 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.srllodgingkeycode =e.srllodgingkeycode 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col =dt.vchcompanyno 
left join crsdb2.informix.crs_ent_addr adr on adr.ent_prf_id =p.ent_prf_id and adr.src_tablename ='rocregisteredaddress'

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = e.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = e.vchupdateby

INNER JOIN crsdb2.informix.tbadd_m_address maddn
ON maddn.src_ref_key_col=dt.vchcompanyno
AND maddn.src_tablename='rocregisteredaddress'
AND maddn.is_migrated='7'

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

group by CB.pk_userid,MB.pk_userid,dt.vchlodgingref,dt.vchcompanyno,d.rc_id,e.dtdateofchange,adr.ent_addr_id,maddn.pk_addressid,e.changedaysfrom,e.changedaysto,e.changeofficehourfrom,e.changeofficehourto --,maddc.pk_addressid

)X
WHERE X.row_num = 1

/*

total time	: 1 min 39 Sec
total record: 1,234,245


source table -----------------------------------------------------

select distinct   e.vchcompanyno ,e.vchlodgingref,dt.vchstatus ,
adr.ent_addr_id,d.rc_id , e. srlform44keytrx,e.vchcreateby, e.dtcreatedate, e.dtdateofchange,e.changedaysfrom , radd.pk_addressid ,
e.changeofficehourfrom, e.changeofficehourto,e.changedaysto,e.changedaysfrom
from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref 
inner join crs_db.dbo.rocregisteredaddrtrx e on e.vchcompanyno=a.vchcompanyno and e.vchlodgingref=a.vchlodgingref 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.srllodgingkeycode =e.srllodgingkeycode 
inner join informix.crs_ent_prf p on p.src_ref_key_col =dt.vchcompanyno 
left join informix.crs_ent_addr adr on adr.ent_prf_id =p.ent_prf_id and adr.src_tablename ='rocregisteredaddress'
left join informix.tbadd_m_address radd on radd.src_tablename ='rocregisteredaddress' and radd.src_ref_key_col =dt.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30',
'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union 

select distinct   e.vchcompanyno ,e.vchlodgingref,dt.vchstatus ,
adr.ent_addr_id,d.rc_id , e. srlform44keytrx,e.vchcreateby, e.dtcreatedate, e.dtdateofchange,e.changedaysfrom , radd.pk_addressid ,
e.changeofficehourfrom, e.changeofficehourto,e.changedaysto,e.changedaysfrom
from crs_db.dbo.roclodgingmaster a inner join informix.crs_submission b on a.vchlodgingref=b.refno
inner join informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref 
inner join crs_db.dbo.rocregisteredaddrtrx e on e.vchcompanyno=a.vchcompanyno and e.vchlodgingref=a.vchlodgingref 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.srllodgingkeycode =e.srllodgingkeycode 
inner join informix.crs_ent_prf p on p.src_ref_key_col =dt.vchcompanyno 
left join informix.crs_ent_addr adr on adr.ent_prf_id =p.ent_prf_id and adr.src_tablename ='rocregisteredaddress'
left join informix.tbadd_m_address radd on radd.src_tablename ='rocregisteredaddress' and radd.src_ref_key_col =dt.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30',
'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_addr_typ

*/
