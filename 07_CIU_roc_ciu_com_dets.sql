use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_com_dets (CIU)  
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

SELECT 
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rccd_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,X.rc_id
,X.ent_prf_id
,X.rccd_com_nm
,X.rccd_com_reg_no
,X.reg_date
,X.incorp_date
,X.comp_sts_id
,X.comp_sts_addl_id
,X.comp_typ_id
,X.comp_origin_id
,X.comp_origin_addl
,X.dtl_comp_typ_id
,X.dtl_comp_typ_id AS dtl_comp_ty_addl_id 
,X.rccd_com_reg_no_old
,1 AS rccd_sts
,NULL AS rccd_cdis
,X.rccd_reg_addr
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,5 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(roc.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(roc.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(rc.rc_id,NULL) AS rc_id
,roc.vchcompanyno AS src_ref_key_col
,ISNULL(ep.entity_name,NULL) AS rccd_com_nm 
,ISNULL(ep.regno,NULL) AS rccd_com_reg_no
,ISNULL(roc.dtregistrationdate,NULL) AS reg_date
,ISNULL(roc.dtincorporationdate,NULL) AS incorp_date
,ISNULL(ep.regno,NULL) AS rccd_com_reg_no_old
,ISNULL(ep.comp_sts_id,NULL) AS comp_sts_id
,ISNULL(ep.comp_sts_addl_id,NULL) AS comp_sts_addl_id
,ISNULL(ep.comp_typ_id,NULL) AS comp_typ_id
,ISNULL(ep.comp_origin_id,NULL) AS comp_origin_id
,ISNULL(ep.comp_origin_addl,NULL) AS comp_origin_addl
,ISNULL(ep.dtl_comp_typ_id,NULL) AS dtl_comp_typ_id

,CONCAT(
    COALESCE(ad.vchregisteredaddress1, ''), ' ',
    COALESCE(ad.vchregisteredaddress2, ''), ' ',
    COALESCE(ad.vchregisteredaddress3, ''), ' ',
    COALESCE(ad.vchregaddresspostcode, ''), ' ',
    COALESCE(ad.vchregaddresstown, ''), ' ',
    COALESCE(ad.chrregaddressstate, '')
) AS rccd_reg_addr

,ep.ent_prf_id AS ent_prf_id

,ROW_NUMBER() OVER (PARTITION BY roc.vchcompanyno ORDER BY rc.rc_id DESC) AS row_num

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt 
ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

INNER JOIN crsdb2.informix.roc_ciu rc 
ON rc.src_ref_key_col = dt.srllodgingkeycode
AND rc.is_migrated = '12'

INNER JOIN crs_db.dbo.rocregisteredaddress ad 
ON ad.vchcompanyno = a.vchcompanyno
and ad.chrrecordstatus='C'

left JOIN crsdb2.informix.crs_ent_prf ep 
ON ep.src_ref_key_col = dt.vchcompanyno

INNER JOIN crs_db.dbo.rocincorporation roc 
ON roc.vchcompanyno = a.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = roc.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = roc.vchupdateby

WHERE (a.vchformcode IN  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
AND dt.vchformtrx NOT IN ('99(308)'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X 
WHERE X.row_num = 1;

/*
total time	: 2 min 56 Sec
total record: 1,274,130

source table -----------------------------------------------------

select distinct a.vchcompanyno, p.ent_prf_id ,p.entity_name, d.rc_id, p.regno , r.dtregistrationdate ,p.comp_sts_id ,p.comp_sts_addl_id ,p.comp_typ_id ,
p.comp_origin_id ,p.comp_origin_addl ,p.dtl_comp_typ_id, concat(radd.vchregisteredaddress1,radd.vchregisteredaddress2,radd.vchregisteredaddress3,radd.vchregaddresspostcode,
radd.vchregaddresstown,radd.chrregaddressstate)  as reg_addr
from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno 
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref  
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crs_db.dbo.rocincorporation r on r.vchcompanyno =p.src_ref_key_col 
left join crs_db.dbo.rocregisteredaddress radd on radd.vchcompanyno =r.vchcompanyno and radd.chrrecordstatus ='C'
where a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union

select distinct a.vchcompanyno, p.ent_prf_id ,p.entity_name, d.rc_id, p.regno , r.dtregistrationdate ,p.comp_sts_id ,p.comp_sts_addl_id ,p.comp_typ_id ,
p.comp_origin_id ,p.comp_origin_addl ,p.dtl_comp_typ_id, concat(radd.vchregisteredaddress1,radd.vchregisteredaddress2,radd.vchregisteredaddress3,radd.vchregaddresspostcode,
radd.vchregaddresstown,radd.chrregaddressstate)  as reg_addr
from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno 
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref  
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno
inner join crs_db.dbo.rocincorporation r on r.vchcompanyno =p.src_ref_key_col 
left join crs_db.dbo.rocregisteredaddress radd on radd.vchcompanyno =r.vchcompanyno and radd.chrrecordstatus ='C'
where a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.dtupdatedate  is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_com_dets where is_migrated = 5

*/
