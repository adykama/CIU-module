use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_branch (CIU)
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

DECLARE @BRANCH_TYP INT;
SELECT @BRANCH_TYP = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'CMN' and codetype = 'TypeOfAddress' and codevalue1 = 'BRANCH_TYP'),NULL);

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.src_tablename = 'uamuserprofile'
AND muser.is_migrated = '1'),

CTE_ADDR AS (select distinct ed.ent_addr_id,a.vchcompanyno 
from crs_db.dbo.roclodgingmaster a 
inner join crsdb2.informix.crs_ent_prf ep on a.vchcompanyno = ep.src_ref_key_col 
inner join crsdb2.informix.crs_ent_addr ed on ed.ent_prf_id = ep.ent_prf_id)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcb_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS rcb_sts
,X.rc_id
,X.rcb_addr_id
,X.rcb_chg_dte
,NULL AS rcb_seq
,X.rcb_addr_typ_id
,NULL AS rcb_updt_chg
,NULL AS rcb_pradd
,X.rcb_mas_id
,'rocbranchmembersaddresskept' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,1 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(md.dtcreatedate, 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(md.dtupdatedate, 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(rc.rc_id,NULL) AS rc_id 
,@BRANCH_TYP AS rcb_addr_typ_id
,adr.pk_addressid AS rcb_addr_id
,addr.ent_addr_id AS rcb_mas_id
,md.srlbranchmembersaddrkeycode AS src_ref_key_col

,CASE WHEN md.dtdateofchange IS NOT NULL THEN md.dtdateofchange
		WHEN md.dtdateofchange IS NULL OR md.dtdateofchange ='' THEN '1900-01-01'
		END AS rcb_chg_dte

,ROW_NUMBER() OVER (PARTITION BY md.srlbranchmembersaddrkeycode ORDER BY rc.rc_id DESC) AS row_num 

FROM crs_db.dbo.roclodgingmaster a

inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 

INNER JOIN crs_db.dbo.rocbranchmembersaddresskept md
ON a.vchcompanyno = md.vchcompanyno

LEFT JOIN crsdb2.informix.roc_ciu rc 
ON rc.rc_ref_no = a.vchlodgingref
AND is_migrated = '12'

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = md.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = md.vchupdateby

LEFT JOIN CTE_ADDR addr
ON addr.vchcompanyno = md.vchcompanyno

INNER JOIN crsdb2.informix.tbadd_m_address adr
ON adr.src_ref_key_col=md.srlbranchmembersaddrkeycode
AND adr.src_tablename='rocbranchmembersaddresskept'
AND adr.is_migrated='35'

WHERE a.vchformcode ='C73' 
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X
where X.row_num = 1

/*
 
total time	: 2 Sec
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
select * from crsdb2.informix.roc_ciu_branch

*/
