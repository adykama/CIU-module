use crs_db;
/*
	base query for
	table: crsdb2.informix.roc_ciu_personal
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

DECLARE @MYKAD INT;
SELECT @MYKAD = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAD'),NULL);

DECLARE @MYKAS INT;
SELECT @MYKAS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAS'),NULL);

DECLARE @MYPR INT;
SELECT @MYPR = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYPR'),NULL);

DECLARE @MYTENTERA INT;
SELECT @MYTENTERA = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYTENTERA'),NULL);

DECLARE @NID INT;
SELECT @NID = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NID'),NULL);

DECLARE @OTHERS INT;
SELECT @OTHERS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='OTHERS'),NULL);

DECLARE @NRIC INT;
SELECT @NRIC = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NRIC'),NULL);

DECLARE @K INT;
SELECT @K = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='K'),NULL);

DECLARE @P INT;
SELECT @P = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='P'),NULL);

DECLARE @Y INT;
SELECT @Y = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='Y'),NULL);

/*DECLARE @OTHERS2 INT;
SELECT @OTHERS2 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='OTHERS'),NULL);*/

DECLARE @N INT;
SELECT @N = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='N'),NULL);

DECLARE @L INT;
SELECT @L = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'L'),NULL);

DECLARE @P1 INT;
SELECT @P1 = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'P'),NULL);

DECLARE @CATL INT;
SELECT @CATL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='L'),NULL);

DECLARE @CATF INT;
SELECT @CATF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='F'),NULL);

DECLARE @S INT;
SELECT @S = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='S'),NULL);

DECLARE @D INT;
SELECT @D = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='D'),NULL);

DECLARE @M INT;
SELECT @M = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='M'),NULL);

DECLARE @Q INT;
SELECT @Q = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='Q'),NULL);

DECLARE @MYS INT;
SELECT @MYS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MYS'),NULL);

DECLARE @BRB INT;
SELECT @BRB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BRB'),NULL);

DECLARE @BMU INT;
SELECT @BMU = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BMU'),NULL);

DECLARE @BHS INT;
SELECT @BHS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BHS'),NULL);

DECLARE @BGR INT;
SELECT @BGR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BGR'),NULL);

DECLARE @MMR INT;
SELECT @MMR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MMR'),NULL);

DECLARE @PRK INT;
SELECT @PRK = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='PRK'),NULL);

DECLARE @NPL INT;
SELECT @NPL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NPL'),NULL);

DECLARE @NLD INT;
SELECT @NLD = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NLD'),NULL);

DECLARE @NZL INT;
SELECT @NZL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NZL'),NULL);

DECLARE @OMN INT;
SELECT @OMN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='OMN'),NULL);

DECLARE @CHN INT;
SELECT @CHN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='CHN'),NULL);

DECLARE @ZAF INT;
SELECT @ZAF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ZAF'),NULL);

DECLARE @ESP INT;
SELECT @ESP = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ESP'),NULL);

DECLARE @LKA INT;
SELECT @LKA = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='LKA'),NULL);

DECLARE @TWN INT;
SELECT @TWN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='TWN'),NULL);

DECLARE @ARE INT;
SELECT @ARE = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ARE'),NULL);

DECLARE @UZB INT;
SELECT @UZB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='UZB'),NULL);

DECLARE @GBR INT;
SELECT @GBR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='GBR'),NULL);

DECLARE @VNM INT;
SELECT @VNM = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VNM'),NULL);

DECLARE @VIR INT;
SELECT @VIR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VIR'),NULL);


;WITH CTE_CREATED AS(SELECT DISTINCT muser.pk_userid,uam.vchuserid
FROM crsdb2.informix.tbusr_m_user muser
JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
WHERE muser.pk_userid IS NOT NULL
AND muser.is_migrated = 1
AND mprofile.is_migrated = 1),

/*CTE_STP AS(select distinct stp.codevalue1,stp.pk_codesetupid
from crsdb2.informix.tbsys_m_codesetup stp
where stp.modulecode='CMN' and stp.codetype='NationalityCountryCodeCode'),*/

CTE_STP AS(select distinct stp.codevalue1,stp.pk_codesetupid
from crsdb2.informix.tbsys_m_codesetup stp
where stp.modulecode='SYS' and stp.codetype='CountryCode'),

CTE_STP2 AS(select distinct stp2.codevalue1,stp2.pk_codesetupid
from crsdb2.informix.tbsys_m_codesetup stp2
where stp2.modulecode='CMN' and stp2.codetype='RaceCode')

--select count(*) from (

insert into crsdb2.informix.roc_ciu_personal(rcp_id
,createdby
,createddate
,modifiedby
,modifieddate
,[version]
,rcp_sts
,rc_id
,rcp_salut_id 
,rcp_nm
,rcp_id_typ_id
,rcp_id_no
,rcp_sid_typ_id
,rcp_sid_no
,rcp_sid_exy
,rcp_nat_id
,rcp_nat_id AS rcp_country_id
,rcp_dtobir
,rcp_race_id 
,rcp_resi_addr_id 
,rcp_off_addr_id 
,rcp_email_id 
,rcp_phone_no_id 
,rcp_addr_same
,rcp_occ
,rcp_gender
,rcp_desig_id 
,rcp_biz_addr_id 
,rcp_ori_incorp_id
,rcp_ent_addr_id 
,rcp_sh_addr_id 
,rcp_com_reg_no 
,rcp_com_reg_no_new
,rcp_local_sh_addr 
,rcp_local_addr 
,src_tablename
,src_ref_key_col
,etl_mig_ref_id
,5 AS is_migrated
,source_of_data)

SELECT DISTINCT
LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcp_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS rcp_sts
,X.rc_id
,NULL AS rcp_salut_id 
,X.rcp_nm
,X.rcp_id_typ_id
,X.rcp_id_no
,X.rcp_sid_typ_id
,X.rcp_sid_no
,NULL AS rcp_sid_exy
,X.rcp_nat_id
,X.rcp_nat_id AS rcp_country_id
,X.rcp_dtobir
,X.rcp_race_id 
,X.rcp_resi_addr_id 
,X.rcp_off_addr_id 
,NULL AS rcp_email_id 
,NULL AS rcp_phone_no_id 
,NULL AS rcp_addr_same
,NULL AS rcp_occ
,X.rcp_gender
,X.rcp_desig_id 
,NULL AS rcp_biz_addr_id 
,X.rcp_ori_incorp_id
,NULL AS rcp_ent_addr_id 
,NULL AS rcp_sh_addr_id 
,NULL AS rcp_com_reg_no 
,NULL AS rcp_com_reg_no_new
,NULL AS rcp_local_sh_addr 
,NULL AS rcp_local_addr 
,'roccompanyofficer' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,15 AS is_migrated
,'CBS_ROC' AS source_of_data

--into crsdb2.informix.CIU_roc_ciu_personal

FROM (

SELECT DISTINCT 
ISNULL(max(CB.pk_userid), @SystemUserId) AS createdby
,ISNULL(max(MB.pk_userid), @SystemUserId) AS modifiedby
,FORMAT(ISNULL(max(i.dtcreatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate 
,FORMAT(ISNULL(max(i.dtupdatedate), @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(d.rc_id,NULL) AS rc_id 
,ISNULL(h.vchname,NULL) AS rcp_nm
,maddr.pk_addressid AS rcp_resi_addr_id
,maddo.pk_addressid AS rcp_off_addr_id

,CASE WHEN g.vchidtype2 is not null and g.vchidtype2 = 'MK' then NULLIF(@MYKAD,NULL)
		WHEN g.vchidtype2 is not null and g.vchidtype2 = 'D' then NULLIF(@MYKAS,NULL)
		WHEN g.vchidtype2 is not null and g.vchidtype2 in ('H','PR') then NULLIF(@MYPR,NULL)
		WHEN g.vchidtype2 is not null and g.vchidtype2 = 'Z' then NULLIF(@MYTENTERA,NULL)
		WHEN g.vchidtype2 is not null and g.vchidtype2 = 'S' then NULLIF(@NID,NULL)
		--WHEN g.vchidtype2 is not null and g.vchidtype2 = 'XEX' then NULLIF(@NRIC,NULL)
		ELSE @OTHERS
		END AS rcp_id_typ_id --INSERT INTO EXCEPTION REPORT

,CASE WHEN g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') THEN g.vchpersonid
		ELSE NULL END AS rcp_id_no --INSERT INTO EXCEPTION REPORT
		
,CASE WHEN g.vchidtype2 is not null and g.vchidtype2 in ('B','M') then @K
		WHEN g.vchidtype2 is not null and g.vchidtype2='P' then @P
		WHEN g.vchidtype2 is not null and g.vchidtype2='Y' then @Y
		ELSE @N END AS rcp_sid_typ_id --@OTHERS2
		
,CASE WHEN g.vchidtype2 in ('XEX','B','M','P','Y') THEN g.vchpersonid 
		ELSE NULL END AS rcp_sid_no

/*,CASE WHEN h.vchnationality IS NOT NULL THEN NULLIF(max(stp.pk_codesetupid),NULL)
		ELSE NULL END AS rcp_nat_id --INSERT INTO EXCEPTION REPORT*/

,CASE WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='MAL' THEN @MYS
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality IN ('BAR','BEL') then @BRB
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='BER' then @BMU
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='BHM' then @BHS
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='BUL' then @BGR
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='BUR' then @MMR
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='DRK' then @PRK
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='NEP' then @NPL
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='NET' then @NLD
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='NZD' then @NZL
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='OMA' then @OMN
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='PRC' then @CHN
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='SAF' then @ZAF
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='SPA' then @ESP
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='SRI' then @LKA
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='TAI' then @TWN
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='UAE' then @ARE
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='UBK' then @UZB
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='UKG' then @GBR
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='VIE' then @VNM
		WHEN stp.codevalue1 <> h.vchnationality AND h.vchnationality='VIB' then @VIR
		ELSE NULL END AS rcp_nat_id
		
,ISNULL(h.dtbirthdate,NULL) AS rcp_dtobir

,CASE WHEN h.chrraceofficer IS NOT NULL THEN NULLIF(max(stp2.pk_codesetupid),NULL)
		ELSE NULL END AS rcp_race_id --INSERT INTO EXCEPTION REPORT
		
,CASE WHEN h.chrsexofficer in ('L','M')  then 'L' 
		WHEN h.chrsexofficer in ('P','F' ) then 'P' 
		WHEN g.vchpersonid is not null and g.vchidtype2='MK' or RIGHT(g.new_ic, 1) IN ('0', '2', '4', '6', '8') THEN 'P' 
		ELSE 'L'  
		END AS rcp_gender --INSERT INTO EXCEPTION REPORT 
		
,CASE WHEN j.chrlocalforeign='L' THEN @CATL
		WHEN j.chrlocalforeign='F' THEN @CATF
		ELSE NULL END AS rcp_ori_incorp_id
		
,CASE WHEN i.chrdesignationcode='S' THEN @S
		WHEN i.chrdesignationcode='D' THEN @D
		WHEN i.chrdesignationcode='M' THEN @M
		ELSE @Q END AS rcp_desig_id

,max(i.srlofficerkeycode) AS src_ref_key_col

,ROW_NUMBER() OVER (PARTITION BY max(i.srlofficerkeycode) ORDER BY d.rc_id DESC) AS row_num 
--select count(*) from crsdb2.informix.crs_submission --31,871,874
from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref 
inner join crsdb2.informix.CIU_crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
--inner join crsdb2.informix.CIU_roc_ciu d on  d.rc_ref_no=r.vchlodgingref and d.is_migrated='12' 
inner join crsdb2.informix.CIU_roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated='12' 
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno and r.vchcompanyno =e.vchcompanyno and r.vchlodgingref =e.vchlodgingref and r.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode 
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode 
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode  
inner join crs_db.dbo.rocincorporation j on j.vchcompanyno =r.vchcompanyno 

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = i.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = i.vchupdateby

LEFT JOIN CTE_STP stp
ON stp.codevalue1=h.vchnationality

LEFT JOIN CTE_STP2 stp2
ON stp2.codevalue1=h.chrraceofficer

INNER JOIN crsdb2.informix.CIU_tbadd_m_address_RESI maddr
ON maddr.src_ref_key_col=i.srlofficerkeycode
AND maddr.src_tablename='rocpersonprofile_ciu'
AND maddr.is_migrated='41'

INNER JOIN crsdb2.informix.CIU_tbadd_m_address_OFFICER maddo
ON maddo.src_ref_key_col=i.srlofficerkeycode
AND maddo.src_tablename='roccompanyofficer_ciu'
AND maddo.is_migrated='42'

where (a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and r.vchformtrx not in ('99(308)') and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') 
and i.chrdesignationcode in ('S','D','M','Q'))
AND ((r.dtupdatedate > @StatusStartDT AND r.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (r.dtupdatedate IS NULL))

GROUP BY r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,g.vchidtype2,g.vchpersonid,h.dtbirthdate,stp.pk_codesetupid,stp2.pk_codesetupid,h.vchnationality,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode,stp.codevalue1,h.vchnationality,maddr.pk_addressid,maddo.pk_addressid

)X 
where X.row_num = 1
)Z; --2,960,675

/*
total time	: 20 min 17 Sec
total record: 1,315,151


source table -----------------------------------------------------

SELECT count(*) 
select distinct r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,max(i.srlofficerkeycode) keycode,max(i.dtcreatedate) dtcreatedate,max(i.dtupdatedate) dtupdatedate,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode
from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref 
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated='12' 
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno and r.vchcompanyno =e.vchcompanyno and r.vchlodgingref =e.vchlodgingref and r.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode 
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode 
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode  
inner join crs_db.dbo.rocincorporation j on j.vchcompanyno =r.vchcompanyno 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and r.vchformtrx not in ('99(308)')  
and i.chrdesignationcode in ('S','D','M','Q')
group by r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode 
)Z

target table -----------------------------------------------------
select * from crsdb2.informix.roc_ciu_personal


SELECT count(*) from (
select distinct r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,max(i.srlofficerkeycode) keycode,max(i.dtcreatedate) dtcreatedate,max(i.dtupdatedate) dtupdatedate,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode
from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref 
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated='12' 
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno and r.vchcompanyno =e.vchcompanyno and r.vchlodgingref =e.vchlodgingref and r.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode 
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode 
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode  
inner join crs_db.dbo.rocincorporation j on j.vchcompanyno =r.vchcompanyno 
where (a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and r.vchformtrx not in ('99(308)') and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') 
and i.chrdesignationcode in ('S','D','M','Q'))
and ((r.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and r.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null)) or r.dtupdatedate is null)
group by r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode 
)Z

*/

select distinct top 100 g.vchidtype2, h.vchname, d.rc_id, g.vchpersonid , h.vchnationality, h.dtbirthdate,
h.chrraceofficer,h.chrsexofficer,h.vchaddressperson1,h.vchaddressperson2,h.vchaddressperson3,
h.vchpostcodeperson,h.vchtownperson,h.vchstateperson,i.vchaddressofficer1,i.vchaddressofficer2 ,
i.vchaddressofficer3 ,i.vchpostcodeofficer ,i.vchtownofficer ,i.chrstateofficer ,chrlocalforeign,i.chrdesignationcode
from  crs_db.dbo.roclodgingmaster a 
left join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 
left join crsdb2.informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated=12
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno 
and e.vchlodgingref =a.vchlodgingref and dt.vchcompanyno =e.vchcompanyno and dt.vchlodgingref =e.vchlodgingref 
and dt.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocincorporation ri on ri.vchcompanyno =a.vchcompanyno 
and i.chrdesignationcode in ('S','D', 'M','A') 
where  a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 
'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30','C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

UNION 

select distinct top 100 g.vchidtype2, h.vchname, d.rc_id, g.vchpersonid , h.vchnationality, h.dtbirthdate,
h.chrraceofficer,h.chrsexofficer,h.vchaddressperson1,h.vchaddressperson2,h.vchaddressperson3,
h.vchpostcodeperson,h.vchtownperson,h.vchstateperson,i.vchaddressofficer1,i.vchaddressofficer2 ,
i.vchaddressofficer3 ,i.vchpostcodeofficer ,i.vchtownofficer ,i.chrstateofficer ,chrlocalforeign,i.chrdesignationcode
from  crs_db.dbo.roclodgingmaster a 
left join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 
left join crsdb2.informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated=12
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno 
and e.vchlodgingref =a.vchlodgingref and dt.vchcompanyno =e.vchcompanyno and dt.vchlodgingref =e.vchlodgingref 
and dt.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocincorporation ri on ri.vchcompanyno =a.vchcompanyno 
and i.chrdesignationcode in ('S','D', 'M','A') 
where  a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 
'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30','C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') 
and dt.dtupdatedate is null


CREATE NONCLUSTERED INDEX IDX_tbusr_m_user_username
ON crsdb2.informix.tbusr_m_user (username);

CREATE NONCLUSTERED INDEX IDX_tbSSIS_m_IncrementalSnapShot_module
ON crs_db.dbo.tbSSIS_m_IncrementalSnapShot (module);

CREATE NONCLUSTERED INDEX IDX_tbsys_m_codesetup_modcodetypevalue
ON crsdb2.informix.tbsys_m_codesetup (modulecode, codetype, codevalue1);

CREATE NONCLUSTERED INDEX IDX_crs_submission_refno_migrated
ON crsdb2.informix.CIU_crs_submission (refno, is_migrated);

CREATE NONCLUSTERED INDEX IDX_roc_ciu_refno_migrated
ON crsdb2.informix.CIU_roc_ciu (rc_ref_no, is_migrated);

CREATE NONCLUSTERED INDEX IDX_rocauthentication_authkey
ON crs_db.dbo.rocauthentication (srlauthenticatekeycode);

CREATE NONCLUSTERED INDEX IDX_rocpersonids_keycode_type2
ON crs_db.dbo.rocpersonids (srlpersonidkeycode, vchidtype2);

CREATE NONCLUSTERED INDEX IDX_roclodgingmaster_formcode
ON crs_db.dbo.roclodgingmaster (vchformcode, vchcompanyno, vchlodgingref);

CREATE NONCLUSTERED INDEX IDX_roclodgingdetails_updatedate
ON crs_db.dbo.roclodgingdetails (dtupdatedate);

CREATE NONCLUSTERED INDEX IDX_roccompanyofficer_authcode_designation
ON crs_db.dbo.roccompanyofficer (intauthenticatekeycode, chrdesignationcode);

CREATE NONCLUSTERED INDEX IDX_roccompanyofficer_createby_updateby
ON crs_db.dbo.roccompanyofficer (vchcreateby, vchupdateby);





SELECT count(1) from (
select distinct r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,max(i.srlofficerkeycode) keycode,max(i.dtcreatedate) dtcreatedate,max(i.dtupdatedate) dtupdatedate,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode
from crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails r on r.vchcompanyno =a.vchcompanyno and r.vchlodgingref =a.vchlodgingref 
inner join crsdb2.informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated='25'
inner join crsdb2.informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated='12' 
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno and r.vchcompanyno =e.vchcompanyno and r.vchlodgingref =e.vchlodgingref and r.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode 
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode 
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode  
inner join crs_db.dbo.rocincorporation j on j.vchcompanyno =r.vchcompanyno 
where (a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') 
and r.vchformtrx not in ('99(308)') and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y') 
and i.chrdesignationcode in ('S','D','M','Q'))
and ((r.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and r.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null)) or r.dtupdatedate is null)

--and a.vchcompanyno = '809647'

group by r.vchlodgingref,r.vchcompanyno,h.vchname,d.rc_id,h.dtbirthdate,g.vchidtype2,g.vchpersonid,h.vchnationality,h.chrraceofficer,h.chrsexofficer,g.new_ic,j.chrlocalforeign,i.chrdesignationcode 
)Z --8,015,620 (2h05m)








select distinct top 100 g.vchidtype2, h.vchname, d.rc_id, g.vchpersonid , h.vchnationality, h.dtbirthdate,
h.chrraceofficer,h.chrsexofficer,h.vchaddressperson1,h.vchaddressperson2,h.vchaddressperson3,
h.vchpostcodeperson,h.vchtownperson,h.vchstateperson,i.vchaddressofficer1,i.vchaddressofficer2 ,
i.vchaddressofficer3 ,i.vchpostcodeofficer ,i.vchtownofficer ,i.chrstateofficer ,chrlocalforeign,i.chrdesignationcode, 
addP.pk_addressid ,addO.pk_addressid 
from  crs_db.dbo.roclodgingmaster a left join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 
left join informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated=12
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno 
and e.vchlodgingref =a.vchlodgingref and dt.vchcompanyno =e.vchcompanyno and dt.vchlodgingref =e.vchlodgingref 
and dt.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocincorporation ri on ri.vchcompanyno =a.vchcompanyno 
and i.chrdesignationcode in ('S','D', 'M','A') 
left join informix.tbadd_m_address addP on addP.src_tablename ='rocpersonprofile_ciu' and addP.src_ref_key_col =h.srlprofilekeycode
left join informix.tbadd_m_address addO on addO.src_tablename ='roccompanyofficer_ciu' and addO.src_ref_key_col =h.srlprofilekeycode
where  a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 
'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30','C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

union

select distinct top 100 g.vchidtype2, h.vchname, d.rc_id, g.vchpersonid , h.vchnationality, h.dtbirthdate,
h.chrraceofficer,h.chrsexofficer,h.vchaddressperson1,h.vchaddressperson2,h.vchaddressperson3,
h.vchpostcodeperson,h.vchtownperson,h.vchstateperson,i.vchaddressofficer1,i.vchaddressofficer2 ,
i.vchaddressofficer3 ,i.vchpostcodeofficer ,i.vchtownofficer ,i.chrstateofficer ,chrlocalforeign,i.chrdesignationcode, 
addP.pk_addressid ,addO.pk_addressid 
from  crs_db.dbo.roclodgingmaster a left join informix.crs_submission b on a.vchlodgingref=b.refno and b.is_migrated=25
inner join crs_db.dbo.roclodgingdetails dt on dt.vchcompanyno =a.vchcompanyno and dt.vchlodgingref =a.vchlodgingref 
left join informix.roc_ciu d on  d.rc_ref_no=b.refno and d.is_migrated=12
inner join crs_db.dbo.rocform49_trx e on e.vchlodgingref=a.vchlodgingref and e.vchcompanyno =a.vchcompanyno 
and e.vchlodgingref =a.vchlodgingref and dt.vchcompanyno =e.vchcompanyno and dt.vchlodgingref =e.vchlodgingref 
and dt.srllodgingkeycode=e.intlodgingkeycode 
inner join crs_db.dbo.rocauthentication f on e.intauthenticatekeycode=f.srlauthenticatekeycode
inner join crs_db.dbo.rocpersonids g on g.srlpersonidkeycode=f.intpersonidkeycode
inner join crs_db.dbo.rocpersonprofile h on h.srlprofilekeycode =f.intpersonidkeycode
inner join crs_db.dbo.roccompanyofficer i on i.intauthenticatekeycode=f.srlauthenticatekeycode 
inner join crs_db.dbo.rocincorporation ri on ri.vchcompanyno =a.vchcompanyno 
and i.chrdesignationcode in ('S','D', 'M','A') 
left join informix.tbadd_m_address addP on addP.src_tablename ='rocpersonprofile_ciu' and addP.src_ref_key_col =h.srlprofilekeycode
left join informix.tbadd_m_address addO on addO.src_tablename ='roccompanyofficer_ciu' and addO.src_ref_key_col =h.srlprofilekeycode
where  a.vchformcode in ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 
'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30','C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and g.vchidtype2 in ('B','MK','M','Z','S','PR','H','D','XEX', 'P','Y')
and dt.dtupdatedate is null







DECLARE 
    @SystemUserId INT,
    @Defaultdate datetime2 = '1900-01-01 00:00:00.00000',
    @StatusStartDT DATE,
    @StatusEndDT DATE,
    @DVQStartDT DATE,
    @DVQEndDT DATE,
    @DataLoadStatus INT,
    @NullDT INT;

SELECT 
    @SystemUserId = u.pk_userid
FROM crsdb2.informix.tbusr_m_user u
WHERE u.username = 'system';

SELECT 
    @StatusStartDT = StatusStartDT,
    @StatusEndDT = StatusEndDT,
    @DVQStartDT = DVQStartDT,
    @DVQEndDT = DVQEndDT,
    @DataLoadStatus = DataLoadStatus,
    @NullDT = NullDT
FROM crs_db.dbo.tbSSIS_m_IncrementalSnapShot
WHERE module = 'CIU';





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

DECLARE @MYKAD INT;
SELECT @MYKAD = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAD'),NULL);

DECLARE @MYKAS INT;
SELECT @MYKAS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAS'),NULL);

DECLARE @MYPR INT;
SELECT @MYPR = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYPR'),NULL);

DECLARE @MYTENTERA INT;
SELECT @MYTENTERA = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYTENTERA'),NULL);

DECLARE @NID INT;
SELECT @NID = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NID'),NULL);

DECLARE @OTHERS INT;
SELECT @OTHERS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='OTHERS'),NULL);

DECLARE @NRIC INT;
SELECT @NRIC = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NRIC'),NULL);

DECLARE @K INT;
SELECT @K = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='K'),NULL);

DECLARE @P INT;
SELECT @P = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='P'),NULL);

DECLARE @Y INT;
SELECT @Y = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='Y'),NULL);

/*DECLARE @OTHERS2 INT;
SELECT @OTHERS2 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='OTHERS'),NULL);*/

DECLARE @N INT;
SELECT @N = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='N'),NULL);

DECLARE @L INT;
SELECT @L = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'L'),NULL);

DECLARE @P1 INT;
SELECT @P1 = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'P'),NULL);

DECLARE @CATL INT;
SELECT @CATL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='L'),NULL);

DECLARE @CATF INT;
SELECT @CATF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='F'),NULL);

DECLARE @S INT;
SELECT @S = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='S'),NULL);

DECLARE @D INT;
SELECT @D = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='D'),NULL);

DECLARE @M INT;
SELECT @M = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='M'),NULL);

DECLARE @Q INT;
SELECT @Q = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='Q'),NULL);

DECLARE @MYS INT;
SELECT @MYS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MYS'),NULL);

DECLARE @BRB INT;
SELECT @BRB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BRB'),NULL);

DECLARE @BMU INT;
SELECT @BMU = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BMU'),NULL);

DECLARE @BHS INT;
SELECT @BHS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BHS'),NULL);

DECLARE @BGR INT;
SELECT @BGR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BGR'),NULL);

DECLARE @MMR INT;
SELECT @MMR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MMR'),NULL);

DECLARE @PRK INT;
SELECT @PRK = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='PRK'),NULL);

DECLARE @NPL INT;
SELECT @NPL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NPL'),NULL);

DECLARE @NLD INT;
SELECT @NLD = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NLD'),NULL);

DECLARE @NZL INT;
SELECT @NZL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NZL'),NULL);

DECLARE @OMN INT;
SELECT @OMN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='OMN'),NULL);

DECLARE @CHN INT;
SELECT @CHN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='CHN'),NULL);

DECLARE @ZAF INT;
SELECT @ZAF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ZAF'),NULL);

DECLARE @ESP INT;
SELECT @ESP = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ESP'),NULL);

DECLARE @LKA INT;
SELECT @LKA = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='LKA'),NULL);

DECLARE @TWN INT;
SELECT @TWN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='TWN'),NULL);

DECLARE @ARE INT;
SELECT @ARE = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ARE'),NULL);

DECLARE @UZB INT;
SELECT @UZB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='UZB'),NULL);

DECLARE @GBR INT;
SELECT @GBR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='GBR'),NULL);

DECLARE @VNM INT;
SELECT @VNM = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VNM'),NULL);

DECLARE @VIR INT;
SELECT @VIR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VIR'),NULL);

-- Prepare reusable CTEs
;WITH CTE_CREATED AS (
    SELECT DISTINCT muser.pk_userid, uam.vchuserid
    FROM crsdb2.informix.tbusr_m_user muser
    JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
    JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
    WHERE muser.pk_userid IS NOT NULL
      AND muser.is_migrated = 1
      AND mprofile.is_migrated = 1
),
CTE_STP AS (
    SELECT DISTINCT codevalue1, pk_codesetupid
    FROM crsdb2.informix.tbsys_m_codesetup
    WHERE modulecode = 'SYS' AND codetype = 'CountryCode'
),
CTE_STP2 AS (
    SELECT DISTINCT codevalue1, pk_codesetupid
    FROM crsdb2.informix.tbsys_m_codesetup
    WHERE modulecode = 'CMN' AND codetype = 'RaceCode'
)

insert into crsdb2.informix.roc_ciu_personal(
rcp_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS rcp_sts
,X.rc_id
,NULL AS rcp_salut_id 
,X.rcp_nm
,X.rcp_id_typ_id
,X.rcp_id_no
,X.rcp_sid_typ_id
,X.rcp_sid_no
,NULL AS rcp_sid_exy
,X.rcp_nat_id
,X.rcp_nat_id AS rcp_country_id
,X.rcp_dtobir
,X.rcp_race_id 
,X.rcp_resi_addr_id 
,X.rcp_off_addr_id 
,NULL AS rcp_email_id 
,NULL AS rcp_phone_no_id 
,NULL AS rcp_addr_same
,NULL AS rcp_occ
,X.rcp_gender
,X.rcp_desig_id 
,NULL AS rcp_biz_addr_id 
,X.rcp_ori_incorp_id
,'roccompanyofficer' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,15 AS is_migrated
,'CBS_ROC' AS source_of_data)

 --Final Query (Count of Distinct Records)
--SELECT COUNT(*) FROM (
    SELECT *
	--into crsdb2.informix.roc_ciu_personal
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY src_ref_key_col ORDER BY rc_id DESC) AS row_num
        FROM (
            SELECT DISTINCT
                LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcp_id,
                ISNULL(CB.pk_userid, @SystemUserId) AS createdby,
                ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby,
                CAST(ISNULL(i.dtcreatedate, @Defaultdate) AS DATETIME2) AS createddate,
                CAST(ISNULL(i.dtupdatedate, @Defaultdate) AS DATETIME2) AS modifieddate,
                d.rc_id,
                h.vchname AS rcp_nm,
                maddr.pk_addressid AS rcp_resi_addr_id,
                maddo.pk_addressid AS rcp_off_addr_id,
                CASE g.vchidtype2
                    WHEN 'MK' THEN @MYKAD
                    WHEN 'D'  THEN @MYKAS
                    WHEN 'PR' THEN @MYPR
                    WHEN 'H'  THEN @MYPR
                    WHEN 'Z'  THEN @MYTENTERA
                    WHEN 'S'  THEN @NID
                    ELSE @OTHERS
                END AS rcp_id_typ_id,
                CASE WHEN g.vchidtype2 IN ('MK','Z','S','PR','H','D') THEN g.vchpersonid ELSE NULL END AS rcp_id_no,
                CASE g.vchidtype2
                    WHEN 'B' THEN @K
                    WHEN 'M' THEN @K
                    WHEN 'P' THEN @P
                    WHEN 'Y' THEN @Y
                    ELSE @N
                END AS rcp_sid_typ_id,
                CASE WHEN g.vchidtype2 IN ('XEX','B','M','P','Y') THEN g.vchpersonid ELSE NULL END AS rcp_sid_no,
                CASE h.vchnationality
                    WHEN 'MAL' THEN @MYS
                    WHEN 'BAR' THEN @BRB
                    WHEN 'BEL' THEN @BRB
                    WHEN 'BER' THEN @BMU
                    WHEN 'BHM' THEN @BHS
                    WHEN 'BUL' THEN @BGR
                    WHEN 'BUR' THEN @MMR
                    WHEN 'DRK' THEN @PRK
                    WHEN 'NEP' THEN @NPL
                    WHEN 'NET' THEN @NLD
                    WHEN 'NZD' THEN @NZL
                    WHEN 'OMA' THEN @OMN
                    WHEN 'PRC' THEN @CHN
                    WHEN 'SAF' THEN @ZAF
                    WHEN 'SPA' THEN @ESP
                    WHEN 'SRI' THEN @LKA
                    WHEN 'TAI' THEN @TWN
                    WHEN 'UAE' THEN @ARE
                    WHEN 'UBK' THEN @UZB
                    WHEN 'UKG' THEN @GBR
                    WHEN 'VIE' THEN @VNM
                    WHEN 'VIB' THEN @VIR
                    ELSE NULL
                END AS rcp_nat_id,
                h.dtbirthdate AS rcp_dtobir,
                CASE WHEN h.chrraceofficer IS NOT NULL THEN stp2.pk_codesetupid ELSE NULL END AS rcp_race_id,
                CASE
                    WHEN h.chrsexofficer IN ('L','M') THEN 'L'
                    WHEN h.chrsexofficer IN ('P','F') THEN 'P'
                    WHEN g.vchpersonid IS NOT NULL AND g.vchidtype2='MK' OR RIGHT(g.new_ic,1) IN ('0','2','4','6','8') THEN 'P'
                    ELSE 'L'
                END AS rcp_gender,
                CASE j.chrlocalforeign
                    WHEN 'L' THEN @CATL
                    WHEN 'F' THEN @CATF
                    ELSE NULL
                END AS rcp_ori_incorp_id,
                CASE i.chrdesignationcode
                    WHEN 'S' THEN @S
                    WHEN 'D' THEN @D
                    WHEN 'M' THEN @M
                    ELSE @Q
                END AS rcp_desig_id,
                i.srlofficerkeycode AS src_ref_key_col,
                'roccompanyofficer' AS src_tablename,
                15 AS is_migrated,
                'CBS_ROC' AS source_of_data
			
            FROM crs_db.dbo.roclodgingmaster a
            INNER JOIN crs_db.dbo.roclodgingdetails r ON r.vchcompanyno = a.vchcompanyno AND r.vchlodgingref = a.vchlodgingref
            INNER JOIN crsdb2.informix.CIU_crs_submission b ON a.vchlodgingref = b.refno AND b.is_migrated = '25'
            INNER JOIN crsdb2.informix.CIU_roc_ciu d ON d.rc_ref_no = b.refno AND d.is_migrated = '12'
            INNER JOIN crs_db.dbo.rocform49_trx e ON e.vchlodgingref = a.vchlodgingref AND r.vchcompanyno = e.vchcompanyno AND r.vchlodgingref = e.vchlodgingref AND r.srllodgingkeycode = e.intlodgingkeycode
            INNER JOIN crs_db.dbo.rocauthentication f ON e.intauthenticatekeycode = f.srlauthenticatekeycode
            INNER JOIN crs_db.dbo.rocpersonids g ON g.srlpersonidkeycode = f.intpersonidkeycode
            INNER JOIN crs_db.dbo.rocpersonprofile h ON h.srlprofilekeycode = f.intpersonidkeycode
            INNER JOIN crs_db.dbo.roccompanyofficer i ON i.intauthenticatekeycode = f.srlauthenticatekeycode
            INNER JOIN crs_db.dbo.rocincorporation j ON j.vchcompanyno = r.vchcompanyno
            LEFT JOIN CTE_CREATED CB ON CB.vchuserid = i.vchcreateby
            LEFT JOIN CTE_CREATED MB ON MB.vchuserid = i.vchupdateby
            LEFT JOIN CTE_STP stp ON stp.codevalue1 = h.vchnationality
            LEFT JOIN CTE_STP2 stp2 ON stp2.codevalue1 = h.chrraceofficer
            INNER JOIN crsdb2.informix.CIU_tbadd_m_address_RESI maddr ON maddr.src_ref_key_col = i.srlofficerkeycode AND maddr.src_tablename = 'rocpersonprofile_ciu' AND maddr.is_migrated = '41'
            INNER JOIN crsdb2.informix.CIU_tbadd_m_address_OFFICER maddo ON maddo.src_ref_key_col = i.srlofficerkeycode AND maddo.src_tablename = 'roccompanyofficer_ciu' AND maddo.is_migrated = '42'
            WHERE a.vchformcode IN ('C49', 'C77', 'CIU_', 'C70', 'C73', 'C31', 'C21', 'C22', 'C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
              AND r.vchformtrx NOT IN ('99(308)')
              AND g.vchidtype2 IN ('B','MK','M','Z','S','PR','H','D','XEX','P','Y')
              AND i.chrdesignationcode IN ('S','D','M','Q')
              AND ((r.dtupdatedate > @StatusStartDT AND r.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL) OR r.dtupdatedate IS NULL)
        ) Sub
    ) Deduped
    WHERE Deduped.row_num = 1
--) FinalResult; --279,759 (14m 19s) --100,930,184(28m20s)


select src_ref_key_col,count(*) 
from crsdb2.informix.CIU_roc_ciu_personal
group by src_ref_key_col
having count(*) >1

SELECT *
FROM crsdb2.informix.CIU_roc_ciu_personal
WHERE src_ref_key_col IN (
    SELECT src_ref_key_col
    FROM crsdb2.informix.CIU_roc_ciu_personal
    GROUP BY src_ref_key_col
    HAVING COUNT(*) > 1
)
ORDER BY src_ref_key_col;


























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

DECLARE @MYKAD INT;
SELECT @MYKAD = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAD'),NULL);

DECLARE @MYKAS INT;
SELECT @MYKAS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYKAS'),NULL);

DECLARE @MYPR INT;
SELECT @MYPR = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYPR'),NULL);

DECLARE @MYTENTERA INT;
SELECT @MYTENTERA = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='MYTENTERA'),NULL);

DECLARE @NID INT;
SELECT @NID = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NID'),NULL);

DECLARE @OTHERS INT;
SELECT @OTHERS = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='OTHERS'),NULL);

DECLARE @NRIC INT;
SELECT @NRIC = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeCode' and codevalue1='NRIC'),NULL);

DECLARE @K INT;
SELECT @K = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='K'),NULL);

DECLARE @P INT;
SELECT @P = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='P'),NULL);

DECLARE @Y INT;
SELECT @Y = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='Y'),NULL);

/*DECLARE @OTHERS2 INT;
SELECT @OTHERS2 = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='OTHERS'),NULL);*/

DECLARE @N INT;
SELECT @N = NULLIF((Select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and codetype='IdTypeSecondaryCode' and codevalue1='N'),NULL);

DECLARE @L INT;
SELECT @L = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'L'),NULL);

DECLARE @P1 INT;
SELECT @P1 = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='GenderCode' and codevalue1 = 'P'),NULL);

DECLARE @CATL INT;
SELECT @CATL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='L'),NULL);

DECLARE @CATF INT;
SELECT @CATF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='RocCompanyCategory' and codevalue1='F'),NULL);

DECLARE @S INT;
SELECT @S = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='S'),NULL);

DECLARE @D INT;
SELECT @D = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='D'),NULL);

DECLARE @M INT;
SELECT @M = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='M'),NULL);

DECLARE @Q INT;
SELECT @Q = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and codetype='Designation' and codevalue1='Q'),NULL);

DECLARE @MYS INT;
SELECT @MYS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MYS'),NULL);

DECLARE @BRB INT;
SELECT @BRB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BRB'),NULL);

DECLARE @BMU INT;
SELECT @BMU = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BMU'),NULL);

DECLARE @BHS INT;
SELECT @BHS = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BHS'),NULL);

DECLARE @BGR INT;
SELECT @BGR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='BGR'),NULL);

DECLARE @MMR INT;
SELECT @MMR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='MMR'),NULL);

DECLARE @PRK INT;
SELECT @PRK = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='PRK'),NULL);

DECLARE @NPL INT;
SELECT @NPL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NPL'),NULL);

DECLARE @NLD INT;
SELECT @NLD = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NLD'),NULL);

DECLARE @NZL INT;
SELECT @NZL = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='NZL'),NULL);

DECLARE @OMN INT;
SELECT @OMN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='OMN'),NULL);

DECLARE @CHN INT;
SELECT @CHN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='CHN'),NULL);

DECLARE @ZAF INT;
SELECT @ZAF = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ZAF'),NULL);

DECLARE @ESP INT;
SELECT @ESP = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ESP'),NULL);

DECLARE @LKA INT;
SELECT @LKA = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='LKA'),NULL);

DECLARE @TWN INT;
SELECT @TWN = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='TWN'),NULL);

DECLARE @ARE INT;
SELECT @ARE = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='ARE'),NULL);

DECLARE @UZB INT;
SELECT @UZB = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='UZB'),NULL);

DECLARE @GBR INT;
SELECT @GBR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='GBR'),NULL);

DECLARE @VNM INT;
SELECT @VNM = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VNM'),NULL);

DECLARE @VIR INT;
SELECT @VIR = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='SYS'  and codetype='CountryCode' and codevalue1='VIR'),NULL);

-- Prepare reusable CTEs
;WITH CTE_CREATED AS (
    SELECT DISTINCT muser.pk_userid, uam.vchuserid
    FROM crsdb2.informix.tbusr_m_user muser
    JOIN crsdb2.informix.tbprf_m_profile mprofile ON muser.fk_profileid = mprofile.pk_profileid
    JOIN crs_db.dbo.uamuserprofile uam ON mprofile.email = uam.vchemail
    WHERE muser.pk_userid IS NOT NULL
      AND muser.is_migrated = 1
      AND mprofile.is_migrated = 1
),
CTE_STP AS (
    SELECT DISTINCT codevalue1, pk_codesetupid
    FROM crsdb2.informix.tbsys_m_codesetup
    WHERE modulecode = 'SYS' AND codetype = 'CountryCode'
),
CTE_STP2 AS (
    SELECT DISTINCT codevalue1, pk_codesetupid
    FROM crsdb2.informix.tbsys_m_codesetup
    WHERE modulecode = 'CMN' AND codetype = 'RaceCode'
)


INSERT INTO crsdb2.informix.roc_ciu_personal (
    rcp_id,
    createdby,
    createddate,
    modifiedby,
    modifieddate,
    [version],
    rcp_sts,
    rc_id,
    rcp_salut_id,
    rcp_nm,
    rcp_id_typ_id,
    rcp_id_no,
    rcp_sid_typ_id,
    rcp_sid_no,
    rcp_sid_exy,
    rcp_nat_id,
    rcp_country_id,
    rcp_dtobir,
    rcp_race_id,
    rcp_resi_addr_id,
    rcp_off_addr_id,
    rcp_email_id,
    rcp_phone_no_id,
    rcp_addr_same,
    rcp_occ,
    rcp_gender,
    rcp_desig_id,
    rcp_biz_addr_id,
    rcp_ori_incorp_id,
    src_tablename,
    src_ref_key_col,
    etl_mig_ref_id,
    is_migrated,
    source_of_data
)
SELECT
    rcp_id,
    createdby,
    createddate,
    modifiedby,
    modifieddate,
    0 AS [version],
    1 AS rcp_sts,
    rc_id,
    NULL AS rcp_salut_id,
    rcp_nm,
    rcp_id_typ_id,
    rcp_id_no,
    rcp_sid_typ_id,
    rcp_sid_no,
    NULL AS rcp_sid_exy,
    rcp_nat_id,
    rcp_nat_id AS rcp_country_id,
    rcp_dtobir,
    rcp_race_id,
    rcp_resi_addr_id,
    rcp_off_addr_id,
    NULL AS rcp_email_id,
    NULL AS rcp_phone_no_id,
    NULL AS rcp_addr_same,
    NULL AS rcp_occ,
    rcp_gender,
    rcp_desig_id,
    NULL AS rcp_biz_addr_id,
    rcp_ori_incorp_id,
    src_tablename,
    src_ref_key_col,
    ROW_NUMBER() OVER (ORDER BY src_ref_key_col) AS etl_mig_ref_id,
    is_migrated,
    source_of_data
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY src_ref_key_col ORDER BY rc_id DESC) AS row_num
    FROM (
        SELECT DISTINCT
                LOWER(CONVERT(VARCHAR(36), NEWID())) AS rcp_id,
                ISNULL(CB.pk_userid, @SystemUserId) AS createdby,
                ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby,
                CAST(ISNULL(i.dtcreatedate, @Defaultdate) AS DATETIME2) AS createddate,
                CAST(ISNULL(i.dtupdatedate, @Defaultdate) AS DATETIME2) AS modifieddate,
                d.rc_id,
                h.vchname AS rcp_nm,
                maddr.pk_addressid AS rcp_resi_addr_id,
                maddo.pk_addressid AS rcp_off_addr_id,
                CASE g.vchidtype2
                    WHEN 'MK' THEN @MYKAD
                    WHEN 'D'  THEN @MYKAS
                    WHEN 'PR' THEN @MYPR
                    WHEN 'H'  THEN @MYPR
                    WHEN 'Z'  THEN @MYTENTERA
                    WHEN 'S'  THEN @NID
                    ELSE @OTHERS
                END AS rcp_id_typ_id,
                CASE WHEN g.vchidtype2 IN ('MK','Z','S','PR','H','D') THEN g.vchpersonid ELSE NULL END AS rcp_id_no,
                CASE g.vchidtype2
                    WHEN 'B' THEN @K
                    WHEN 'M' THEN @K
                    WHEN 'P' THEN @P
                    WHEN 'Y' THEN @Y
                    ELSE @N
                END AS rcp_sid_typ_id,
                CASE WHEN g.vchidtype2 IN ('XEX','B','M','P','Y') THEN g.vchpersonid ELSE NULL END AS rcp_sid_no,
                CASE h.vchnationality
                    WHEN 'MAL' THEN @MYS
                    WHEN 'BAR' THEN @BRB
                    WHEN 'BEL' THEN @BRB
                    WHEN 'BER' THEN @BMU
                    WHEN 'BHM' THEN @BHS
                    WHEN 'BUL' THEN @BGR
                    WHEN 'BUR' THEN @MMR
                    WHEN 'DRK' THEN @PRK
                    WHEN 'NEP' THEN @NPL
                    WHEN 'NET' THEN @NLD
                    WHEN 'NZD' THEN @NZL
                    WHEN 'OMA' THEN @OMN
                    WHEN 'PRC' THEN @CHN
                    WHEN 'SAF' THEN @ZAF
                    WHEN 'SPA' THEN @ESP
                    WHEN 'SRI' THEN @LKA
                    WHEN 'TAI' THEN @TWN
                    WHEN 'UAE' THEN @ARE
                    WHEN 'UBK' THEN @UZB
                    WHEN 'UKG' THEN @GBR
                    WHEN 'VIE' THEN @VNM
                    WHEN 'VIB' THEN @VIR
                    ELSE NULL
                END AS rcp_nat_id,
                h.dtbirthdate AS rcp_dtobir,
                CASE WHEN h.chrraceofficer IS NOT NULL THEN stp2.pk_codesetupid ELSE NULL END AS rcp_race_id,
                CASE
                    WHEN h.chrsexofficer IN ('L','M') THEN 'L'
                    WHEN h.chrsexofficer IN ('P','F') THEN 'P'
                    WHEN g.vchpersonid IS NOT NULL AND g.vchidtype2='MK' OR RIGHT(g.new_ic,1) IN ('0','2','4','6','8') THEN 'P'
                    ELSE 'L'
                END AS rcp_gender,
                CASE j.chrlocalforeign
                    WHEN 'L' THEN @CATL
                    WHEN 'F' THEN @CATF
                    ELSE NULL
                END AS rcp_ori_incorp_id,
                CASE i.chrdesignationcode
                    WHEN 'S' THEN @S
                    WHEN 'D' THEN @D
                    WHEN 'M' THEN @M
                    ELSE @Q
                END AS rcp_desig_id,
                i.srlofficerkeycode AS src_ref_key_col,
                'roccompanyofficer' AS src_tablename,
                15 AS is_migrated,
                'CBS_ROC' AS source_of_data
			
            FROM crs_db.dbo.roclodgingmaster a
            INNER JOIN crs_db.dbo.roclodgingdetails r ON r.vchcompanyno = a.vchcompanyno AND r.vchlodgingref = a.vchlodgingref
            INNER JOIN crsdb2.informix.CIU_crs_submission b ON a.vchlodgingref = b.refno AND b.is_migrated = '25'
            INNER JOIN crsdb2.informix.CIU_roc_ciu d ON d.rc_ref_no = b.refno AND d.is_migrated = '12'
            INNER JOIN crs_db.dbo.rocform49_trx e ON e.vchlodgingref = a.vchlodgingref AND r.vchcompanyno = e.vchcompanyno AND r.vchlodgingref = e.vchlodgingref AND r.srllodgingkeycode = e.intlodgingkeycode
            INNER JOIN crs_db.dbo.rocauthentication f ON e.intauthenticatekeycode = f.srlauthenticatekeycode
            INNER JOIN crs_db.dbo.rocpersonids g ON g.srlpersonidkeycode = f.intpersonidkeycode
            INNER JOIN crs_db.dbo.rocpersonprofile h ON h.srlprofilekeycode = f.intpersonidkeycode
            INNER JOIN crs_db.dbo.roccompanyofficer i ON i.intauthenticatekeycode = f.srlauthenticatekeycode
            INNER JOIN crs_db.dbo.rocincorporation j ON j.vchcompanyno = r.vchcompanyno
            LEFT JOIN CTE_CREATED CB ON CB.vchuserid = i.vchcreateby
            LEFT JOIN CTE_CREATED MB ON MB.vchuserid = i.vchupdateby
            LEFT JOIN CTE_STP stp ON stp.codevalue1 = h.vchnationality
            LEFT JOIN CTE_STP2 stp2 ON stp2.codevalue1 = h.chrraceofficer
            INNER JOIN crsdb2.informix.CIU_tbadd_m_address_RESI maddr ON maddr.src_ref_key_col = i.srlofficerkeycode AND maddr.src_tablename = 'rocpersonprofile_ciu' AND maddr.is_migrated = '41'
            INNER JOIN crsdb2.informix.CIU_tbadd_m_address_OFFICER maddo ON maddo.src_ref_key_col = i.srlofficerkeycode AND maddo.src_tablename = 'roccompanyofficer_ciu' AND maddo.is_migrated = '42'
            WHERE a.vchformcode IN ('C49', 'C77', 'CIU_', 'C70', 'C73', 'C31', 'C21', 'C22', 'C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2')
              AND r.vchformtrx NOT IN ('99(308)')
              AND g.vchidtype2 IN ('B','MK','M','Z','S','PR','H','D','XEX','P','Y')
              AND i.chrdesignationcode IN ('S','D','M','Q')
              AND ((r.dtupdatedate > @StatusStartDT AND r.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL) OR r.dtupdatedate IS NULL)
    ) Sub
) Deduped
WHERE Deduped.row_num = 1;
