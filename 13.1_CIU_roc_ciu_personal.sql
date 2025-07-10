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
AND mprofile.is_migrated = 1),

CTE_TOWN AS (
SELECT DISTINCT child.pk_codesetupid, h.srlprofilekeycode
FROM crsdb2.informix.tbsys_t_codesetupdetails csd
LEFT JOIN crsdb2.informix.tbsys_t_codesetupdetails prtd ON prtd.pk_codesetupdetailsid = csd.fk_parentid
LEFT JOIN crsdb2.informix.tbsys_m_codesetup parent ON parent.pk_codesetupid = prtd.fk_childid
LEFT JOIN crsdb2.informix.tbsys_m_codesetup child ON child.pk_codesetupid = csd.fk_childid
INNER JOIN crs_db.dbo.rocpersonprofile h ON parent.mig_codevalue1 = h.vchstateperson
WHERE csd.status = 1 AND prtd.status = 1 AND parent.status = 1 AND child.status = 1 
AND csd.fk_categoryid = 21
AND parent.codetype = 'StateCode'
AND child.modulecode = 'SYS' 
AND child.codetype = 'CityCode'
AND child.codevalue2 = h.vchtownperson)

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
,X.postcode
,X.[state]
,1 AS status
,X.fk_cityid
,X.fk_postcodeid
,X.fk_stateid
,'rocpersonprofile_ciu' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,41 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT
ISNULL(CB.pk_userid, @SystemUserId) AS createdby,
ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby,
ISNULL(MAX(i.dtcreatedate), @Defaultdate) AS createddate,
ISNULL(MAX(i.dtupdatedate), @Defaultdate) AS modifieddate,
max(h.vchaddressperson1) AS address1,
max(h.vchaddressperson2) AS address2,
max(h.vchaddressperson3) AS address3,
h.vchtownperson AS city,
NULL AS country,
NULL AS isothers,
h.vchpostcodeperson AS postcode,
h.vchstateperson AS [state],
ste.pk_codesetupid AS fk_stateid,
tw.pk_codesetupid AS fk_cityid,
cd.pk_codesetupid AS fk_postcodeid,
MAX(i.srlofficerkeycode) AS src_ref_key_col,

FROM crs_db.dbo.rocauthentication f
INNER JOIN crs_db.dbo.rocpersonids g ON g.srlpersonidkeycode = f.intpersonidkeycode
INNER JOIN crs_db.dbo.rocpersonprofile h ON h.srlprofilekeycode = f.intpersonidkeycode
INNER JOIN crs_db.dbo.roccompanyofficer i ON i.intauthenticatekeycode = f.srlauthenticatekeycode
LEFT JOIN CTE_CREATED CB ON CB.vchuserid = i.vchcreateby
LEFT JOIN CTE_CREATED MB ON MB.vchuserid = i.vchupdateby
LEFT JOIN crsdb2.informix.tbsys_m_codesetup ste ON ste.mig_codevalue1 = h.vchstateperson AND ste.modulecode = 'SYS' AND ste.codetype = 'StateCode'
LEFT JOIN CTE_TOWN tw ON tw.srlprofilekeycode = h.srlprofilekeycode
LEFT JOIN crsdb2.informix.tbsys_m_codesetup cd ON cd.codevalue1 = h.vchpostcodeperson AND cd.modulecode = 'SYS' AND cd.codetype = 'PostcodeCode'

GROUP BY CB.pk_userid, MB.pk_userid, h.vchpostcodeperson, h.vchtownperson, h.vchstateperson, ste.pk_codesetupid, tw.pk_codesetupid, cd.pk_codesetupid, i.srlofficerkeycode

)X

/*
total time	: 34 min 
total record: 8,660,060

select h.srlprofilekeycode ,h.vchaddressperson1 ,h.vchaddressperson2 ,h.vchaddressperson3 ,h.vchpostcodeperson ,h.vchstateperson from 
crs_db.dbo.rocauthentication f 
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode 

target table -----------------------------------------------------
select * from crsdb2.informix.tbadd_m_address where is_migrated='41'

*/