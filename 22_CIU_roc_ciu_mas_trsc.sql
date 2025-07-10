use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_mas_trsc (CIU) 22
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

DECLARE @CIUCRSCC INT;
SELECT @CIUCRSCC = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUCRSCC'),NULL);

DECLARE @CIUNRAS INT;
SELECT @CIUNRAS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNRAS'),NULL);

DECLARE @CIUNASC INT;
SELECT @CIUNASC = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNASC'),NULL);

DECLARE @CIUPCRFC INT;
SELECT @CIUPCRFC = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUPCRFC'),NULL);

DECLARE @CIUNSCSDK INT;
SELECT @CIUNSCSDK = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNSCSDK'),NULL);

DECLARE @CIUNCRA INT;
SELECT @CIUNCRA = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNCRA'),NULL);

DECLARE @CIUNID INT;
SELECT @CIUNID = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNID'),NULL);

DECLARE @CIUNCBANB INT;
SELECT @CIUNCBANB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNCBANB'),NULL);

DECLARE @CIUNSCFC INT;
SELECT @CIUNSCFC = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUNSCFC'),NULL);

DECLARE @CIUCRDMS INT;
SELECT @CIUCRDMS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where codetype='FormTypeCode' and modulecode='CIU' and codevalue1='CIUCRDMS'),NULL);

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcmt_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS version 
,1 AS rcmt_sts
,X.rc_id
,X.submission_id
,X.rcmt_com_nm
,X.rcmt_com_reg_no
,X.rcmt_flc_id
,X.rcmt_com_sts
,NULL AS rcmt_trg_btc_sche
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(max(CB.pk_userid), @SystemUserId) AS createdby
,ISNULL(max(MB.pk_userid), @SystemUserId) AS modifiedby
,FORMAT(ISNULL(MAX(a.dtcreatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(MAX(a.dtupdatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,d.rc_id AS rc_id
,b.submission_id AS submission_id
,ep.entity_name AS rcmt_com_nm
,ep.regno AS rcmt_com_reg_no
,ep.comp_sts_id AS rcmt_com_sts
,max(a.vchcompanyno) AS src_ref_key_col

,CASE WHEN a.vchformcode = 'C70' then @CIUCRSCC
		WHEN a.vchformcode = 'C21' then @CIUNRAS
		WHEN a.vchformcode = 'C22A' then @CIUNASC
		WHEN a.vchformcode in ('C31', 'C27') then @CIUPCRFC
		WHEN a.vchformcode = 'C29' then @CIUNSCSDK
		WHEN a.vchformcode = 'C30' then @CIUNCRA
		WHEN a.vchformcode= 'C30A' then @CIUNID
		WHEN a.vchformcode= 'CPD2' then @CIUNCBANB
		WHEN a.vchformcode= 'C49' and dt.vchformtrx in ('481(48A)','24','44','ROM','49') then @CIUNCRA 
		WHEN a.vchformcode= 'C22' and dt.vchformtrx in ('28','11') then @CIUNSCFC  
		WHEN a.vchformcode= 'C26' and dt.vchformtrx in ('490','49','45','46', '99','485','481(48A)','50','47','S237(3)') then @CIUCRDMS 
		ELSE NULL END AS rcmt_flc_id --INSERT INTO EXCEPTION REPORT

,ROW_NUMBER() OVER (PARTITION BY d.rc_id ORDER BY max(dt.srllodgingkeycode) DESC) AS row_num 

FROM crs_db.dbo.roclodgingmaster a
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref = b.refno and b.is_migrated='25'
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no = a.vchlodgingref and d.is_migrated='12'
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref = a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno
inner join crsdb2.informix.crs_ent_prf ep on a.vchcompanyno=ep.src_ref_key_col

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = a.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = a.vchupdateby

WHERE (a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and dt.vchformtrx not in ('99(308)'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

group by a.vchcompanyno,a.vchlodgingref,d.rc_id,b.submission_id,ep.entity_name,ep.regno,ep.comp_sts_id,a.vchformcode,dt.vchformtrx

)X
WHERE row_num = 1

/*
total time	: 5 min 46 sec
total record: 11,953,320

source table -----------------------------------------------------

select distinct a.vchlodgingref,d.rc_id, b.submission_id,p.ent_prf_id ,p.regno,a.vchformcode, p.comp_sts_id 
from crs_db.dbo.roclodgingmaster a 
left join crsdb2.informix.ciu_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
left join crsdb2.informix.ciu_roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=1
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno  
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27',
'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union 

select distinct d.rc_id, b.submission_id,p.ent_prf_id ,p.regno,a.vchformcode, p.comp_sts_id 
from crs_db.dbo.roclodgingmaster a 
left join crsdb2.informix.ciu_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
left join crsdb2.informix.ciu_roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated=1
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno=a.vchcompanyno 
inner join crsdb2.informix.crs_ent_prf p on p.src_ref_key_col=a.vchcompanyno  
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27',
'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_type

*/
