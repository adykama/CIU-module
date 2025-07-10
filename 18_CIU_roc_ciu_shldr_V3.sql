use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_shldr (CIU) 18
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

DECLARE @NA INT;
SELECT @NA = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='SubCategoryMemberDetails' and codevalue1= 'N/A'),NULL);

DECLARE @INDIVIDUAL INT;
SELECT @INDIVIDUAL = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='RocUserType' and codevalue1='INDIVIDUAL'),NULL);

DECLARE @BODY_CORPORATE INT;
SELECT @BODY_CORPORATE = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='RocUserType' and codevalue1='BODY_CORPORATE'),NULL);

DECLARE @CAT_MEMBO_1 INT;
SELECT @CAT_MEMBO_1 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_1'),NULL);

DECLARE @CAT_MEMBO_4 INT;
SELECT @CAT_MEMBO_4 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_4'),NULL);

DECLARE @CAT_MEMBO_12 INT;
SELECT @CAT_MEMBO_12 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_12'),NULL);

DECLARE @CAT_MEMBO_2 INT;
SELECT @CAT_MEMBO_2 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_2'),NULL);

DECLARE @CAT_MEMBO_5 INT;
SELECT @CAT_MEMBO_5 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_5'),NULL);

DECLARE @CAT_MEMBO_14 INT;
SELECT @CAT_MEMBO_14 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_14'),NULL);

DECLARE @CAT_MEMBO_15 INT;
SELECT @CAT_MEMBO_15 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_15'),NULL);

DECLARE @CAT_MEMBO_7 INT;
SELECT @CAT_MEMBO_7 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_7'),NULL);

DECLARE @CAT_MEMBO_8 INT;
SELECT @CAT_MEMBO_8 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_8'),NULL);

DECLARE @CAT_MEMBO_11 INT;
SELECT @CAT_MEMBO_11 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_11'),NULL);

DECLARE @CAT_MEMBO_3 INT;
SELECT @CAT_MEMBO_3 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='CategoryOfMemberBO' and codevalue1='CAT_MEMBO_3'),NULL);

;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1)

--select count(*) from (

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcsh_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS version 
,1 AS rcsh_sts
,X.rcsh_typ_id
,X.rcsh_cat_id
,X.rcsh_sub_dtls_id
,X.rcp_id
,X.rc_id
,X.rcsh_amt
,X.rcsh_mas_id
,'rocshareholders' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,5 AS is_migrated
,'CBS_ROC' AS source_of_data

into crsdb2.informix.CIU_roc_ciu_shldr

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,ISNULL(sh.dtcreatedate,TRY_CAST('1900-01-01 00:00:00' AS DATETIME)) AS createddate 
,ISNULL(sh.dtupdatedate,TRY_CAST('1900-01-01 00:00:00' AS DATETIME)) AS modifieddate
,sh.srlshareholderkeycode AS src_ref_key_col
,sh.intcurrentshare AS rcsh_amt 
,@NA AS rcsh_sub_dtls_id 
,d.rc_id AS rc_id 
,oc.ent_ofc_id AS rcsh_mas_id
,ISNULL(c.rcp_id,NULL) AS rcp_id 

,CASE WHEN g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX','P','Y')  and g.vchidtype2 is not null THEN @INDIVIDUAL
		WHEN g.vchidtype2 not in ('B','MK','M','Z','S','PR','H','D','XEX','P','Y') and g.vchidtype2 is not null THEN @BODY_CORPORATE
		ELSE NULL END AS rcsh_typ_id
		
,CASE WHEN g.chridtype1 in ('L','F') and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX','P','Y','OR')  then @CAT_MEMBO_1
		WHEN g.chridtype1='P' and g.vchidtype2 ='LLP'  then @CAT_MEMBO_4
		WHEN g.chridtype1='X' and g.vchidtype2='XLS' then @CAT_MEMBO_12
		WHEN g.chridtype1='X' and g.vchidtype2='XLT' then @CAT_MEMBO_2
		WHEN g.chridtype1='X' and g.vchidtype2='XLZ' then @CAT_MEMBO_5
		WHEN g.chridtype1='X' and g.vchidtype2 in ('XGA','XGR','XGK','XGP','XGC','XGD','XGT','XGB','XGW','XGM','XGN','XGJ','XGS','XGQ','XGE') then @CAT_MEMBO_14
		WHEN g.chridtype1='X' and g.vchidtype2='XGF' then @CAT_MEMBO_15
		WHEN g.chridtype1='X' and g.vchidtype2 in ('XAX','XAU') then @CAT_MEMBO_7
		WHEN g.chridtype1='X' and g.vchidtype2 in ('XAL','XAK') then @CAT_MEMBO_8
		WHEN g.chridtype1='X' and g.vchidtype2='XFS' then @CAT_MEMBO_11
		WHEN g.chridtype1='C' and g.vchidtype2 in ('C','F') then @CAT_MEMBO_3
		ELSE NULL END AS rcsh_cat_id

from  crs_db.dbo.roclodgingmaster a
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.CIU_roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crsdb2.informix.CIU_roc_ciu_personal c on c.rc_id=d.rc_id and c.is_migrated='5'
inner join crs_db.dbo.rocform49_trx ft on ft.vchlodgingref =a.vchlodgingref
inner join crs_db.dbo.rocauthentication ca on ft.intauthenticatekeycode=ca.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on (g.vchpersonid=c.rcp_id_no or g.vchpersonid= c.rcp_sid_no) and ca.intpersonidkeycode =g.srlpersonidkeycode
inner join crs_db.dbo.roccompanyofficer co on co.intauthenticatekeycode =ca.srlauthenticatekeycode
inner join crs_db.dbo.rocshareholders sh on sh.intauthenticatekeycode =ca.srlauthenticatekeycode and sh.vchcompanyno =a.vchcompanyno and sh.vchcompanyno =co.vchcompanyno
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref and dt.srllodgingkeycode=ft.intlodgingkeycode
inner join crsdb2.informix.crs_ent_prf ep on ep.src_ref_key_col=a.vchcompanyno and ep.src_ref_key_col =dt.vchcompanyno
left join crsdb2.informix.tbprf_m_profile pf on  pf.id=c.rcp_id_no 
left join crsdb2.informix.crs_ent_ofc oc on oc.ent_prf_id=ep.ent_prf_id and oc.src_ref_key_col=co.srlofficerkeycode 

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = sh.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = sh.vchupdateby

where (a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and dt.vchformtrx not in ('99(308)'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X
--)Z; --3,150,082

/*

total time	: 11 min 04 sec
total record: 3,463,666


source table -----------------------------------------------------

select count(*) from (
select distinct r.vchcompanyno,r.vchlodgingref, sh.srlshareholderkeycode, sh.dtupdatedate,sh.dtcreatedate ,sh.intcurrentshare,
d.rc_id,g.vchidtype2,g.chridtype1, oc.ent_ofc_id
from  crs_db.dbo.roclodgingmaster a
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crsdb2.informix.roc_ciu_personal c on c.rc_id=d.rc_id and c.is_migrated='5'
inner join crs_db.dbo.rocform49_trx ft on ft.vchlodgingref =a.vchlodgingref
inner join crs_db.dbo.rocauthentication ca on ft.intauthenticatekeycode=ca.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on (g.vchpersonid=c.rcp_id_no or g.vchpersonid= c.rcp_sid_no) and ca.intpersonidkeycode =g.srlpersonidkeycode
inner join crs_db.dbo.roccompanyofficer co on co.intauthenticatekeycode =ca.srlauthenticatekeycode
inner join crs_db.dbo.rocshareholders sh on sh.intauthenticatekeycode =ca.srlauthenticatekeycode and sh.vchcompanyno =a.vchcompanyno and sh.vchcompanyno =co.vchcompanyno
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref and r.srllodgingkeycode=ft.intlodgingkeycode
inner join crsdb2.informix.crs_ent_prf ep on ep.src_ref_key_col=a.vchcompanyno and ep.src_ref_key_col =r.vchcompanyno
left join crsdb2.informix.tbprf_m_profile pf on  pf.id=c.rcp_id_no --and pf.idtype<>'OTHERS'
--left join crsdb2.informix.crs_ent_ofc oc on oc.ent_prf_id=ep.ent_prf_id and oc.src_ref_key_col=co.srlofficerkeycode and oc.ofc_prf_id = pf.pk_profileid
left join crsdb2.informix.crs_ent_ofc oc on oc.ent_prf_id=ep.ent_prf_id and oc.src_ref_key_col=co.srlofficerkeycode --or oc.ofc_prf_id = pf.pk_profileid
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
and r.vchformtrx not in ('99(308)') --and sh.srlshareholderkeycode =2629057
)Z 

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_shldr

*/


select distinct r.vchcompanyno,r.vchlodgingref, sh.srlshareholderkeycode, sh.dtupdatedate,sh.dtcreatedate ,sh.intcurrentshare,d.rc_id,
g.vchidtype2,g.chridtype1,c.rcp_id, oc.ent_ofc_id
from  crs_db.dbo.roclodgingmaster a
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crsdb2.informix.roc_ciu_personal c on c.rc_id=d.rc_id and c.is_migrated='5'
inner join crs_db.dbo.rocform49_trx ft on ft.vchlodgingref =a.vchlodgingref
inner join crs_db.dbo.rocauthentication ca on ft.intauthenticatekeycode=ca.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on (g.vchpersonid=c.rcp_id_no or g.vchpersonid= c.rcp_sid_no) and ca.intpersonidkeycode =g.srlpersonidkeycode
inner join crs_db.dbo.roccompanyofficer co on co.intauthenticatekeycode =ca.srlauthenticatekeycode
inner join crs_db.dbo.rocshareholders sh on sh.intauthenticatekeycode =ca.srlauthenticatekeycode and sh.vchcompanyno =a.vchcompanyno and sh.vchcompanyno =co.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref and r.srllodgingkeycode=ft.intlodgingkeycode
inner join crsdb2.informix.crs_ent_prf ep on ep.src_ref_key_col=a.vchcompanyno and ep.src_ref_key_col =r.vchcompanyno 
left join crsdb2.informix.tbprf_m_profile pf on pf.id=g.vchpersonid and pf.idtype<>'OTHERS'
left join crsdb2.informix.crs_ent_ofc oc on oc.ent_prf_id=ep.ent_prf_id and oc.src_ref_key_col=co.srlofficerkeycode 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and r.vchformtrx not in ('99(308)') and (r.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and r.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union

select distinct r.vchcompanyno,r.vchlodgingref, sh.srlshareholderkeycode, sh.dtupdatedate,sh.dtcreatedate ,sh.intcurrentshare,d.rc_id,
g.vchidtype2,g.chridtype1,c.rcp_id, oc.ent_ofc_id
from  crs_db.dbo.roclodgingmaster a
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on d.rc_ref_no=a.vchlodgingref and d.is_migrated='12'
inner join crsdb2.informix.roc_ciu_personal c on c.rc_id=d.rc_id and c.is_migrated='5'
inner join crs_db.dbo.rocform49_trx ft on ft.vchlodgingref =a.vchlodgingref
inner join crs_db.dbo.rocauthentication ca on ft.intauthenticatekeycode=ca.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on (g.vchpersonid=c.rcp_id_no or g.vchpersonid= c.rcp_sid_no) and ca.intpersonidkeycode =g.srlpersonidkeycode
inner join crs_db.dbo.roccompanyofficer co on co.intauthenticatekeycode =ca.srlauthenticatekeycode
inner join crs_db.dbo.rocshareholders sh on sh.intauthenticatekeycode =ca.srlauthenticatekeycode and sh.vchcompanyno =a.vchcompanyno and sh.vchcompanyno =co.vchcompanyno 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref and r.srllodgingkeycode=ft.intlodgingkeycode
inner join crsdb2.informix.crs_ent_prf ep on ep.src_ref_key_col=a.vchcompanyno and ep.src_ref_key_col =r.vchcompanyno 
left join crsdb2.informix.tbprf_m_profile pf on pf.id=g.vchpersonid and pf.idtype<>'OTHERS'
left join crsdb2.informix.crs_ent_ofc oc on oc.ent_prf_id=ep.ent_prf_id and oc.src_ref_key_col=co.srlofficerkeycode 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and r.vchformtrx not in ('99(308)') and r.dtupdatedate is null

