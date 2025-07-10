use crs_db;
/*
	base query for
	table: crsdb2.informix.tbwfr_m_workflowsubmission (CIU)
*/

DECLARE @SystemUserId INT;
SELECT @SystemUserId = pk_userid FROM crsdb2.informix.tbusr_m_user  WHERE username = 'system';

DECLARE @Defaultdate datetime2 = '1900-01-01 00:00:00.00000';

DECLARE @CIUCRSCC NVARCHAR(36);
SELECT @CIUCRSCC = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUCRSCC'),NULL);

DECLARE @CIUNRAS NVARCHAR(36);
SELECT @CIUNRAS = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNRAS'),NULL);

DECLARE @CIUNASC NVARCHAR(36);
SELECT @CIUNASC = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNASC'),NULL);

DECLARE @CIUPCRFC NVARCHAR(36);
SELECT @CIUPCRFC = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUPCRFC'),NULL);

DECLARE @CIUNSCSDK NVARCHAR(36);
SELECT @CIUNSCSDK = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNSCSDK'),NULL);

DECLARE @CIUNCRA1 NVARCHAR(36);
SELECT @CIUNCRA1 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNCRA'),NULL);

DECLARE @CIUNID NVARCHAR(36);
SELECT @CIUNID = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNID'),NULL);

DECLARE @CIUNCBANB NVARCHAR(36);
SELECT @CIUNCBANB = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNCBANB'),NULL);

DECLARE @CIUNCRMR NVARCHAR(36);
SELECT @CIUNCRMR = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNCRMR'),NULL);

DECLARE @CIUNCRA2 NVARCHAR(36);
SELECT @CIUNCRA2 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNCRA'),NULL);

DECLARE @CIUNSCFC NVARCHAR(36);
SELECT @CIUNSCFC = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNSCFC'),NULL);

DECLARE @CIUCRDMS NVARCHAR(36);
SELECT @CIUCRDMS = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUCRDMS'),NULL);

DECLARE @CIUNIVOS NVARCHAR(36);
SELECT @CIUNIVOS = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='CIUNIVOS'),NULL);

DECLARE @MBRSAR55 NVARCHAR(36);
SELECT @MBRSAR55 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSAR55'),NULL);

DECLARE @MBRSAR555R NVARCHAR(36);
SELECT @MBRSAR555R = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSAR555R'),NULL);

DECLARE @MBRSFS554 NVARCHAR(36);
SELECT @MBRSFS554 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSFS554'),NULL);

DECLARE @MBRSFS557 NVARCHAR(36);
SELECT @MBRSFS557 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSFS557'),NULL);

DECLARE @MBRSEA558 NVARCHAR(36);
SELECT @MBRSEA558 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSEA558'),NULL);

DECLARE @MBRSEA558Q NVARCHAR(36);
SELECT @MBRSEA558Q = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSEA558Q'),NULL);

DECLARE @MBRSAR559NoAGM NVARCHAR(36);
SELECT @MBRSAR559NoAGM = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSAR559NoAGM'),NULL);

DECLARE @MBRSAR559 NVARCHAR(36);
SELECT @MBRSAR559 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSAR559'),NULL);

DECLARE @MBRSAR551 NVARCHAR(36);
SELECT @MBRSAR551 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSAR551'),NULL);

DECLARE @MBRSARF801 NVARCHAR(36);
SELECT @MBRSARF801 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSARF801'),NULL);

DECLARE @MBRSARR802 NVARCHAR(36);
SELECT @MBRSARR802 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSARR802'),NULL); 

DECLARE @MBRSFS87 NVARCHAR(36);
SELECT @MBRSFS87 = NULLIF((select pk_containerprocessid from crsdb2.informix.tbwfr_m_containerprocess where processid='MBRSFS87'),NULL);

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

SELECT DISTINCT 
LOWER(CONVERT(VARCHAR(36), NEWID())) AS pk_workflowsubmissionid
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,X.completeddate
,X.iscompleted
,1 AS isfinal
,X.issubmitted
,NULL AS processinstanceid
,1 AS [status]
,X.submitteddate
,X.fk_containerprocessid
,X.submittedby
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,25 AS is_migrated
,'CBS_ROC' AS source_of_data

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(CB.pk_userid, @SystemUserId) AS submittedby
,dt.srllodgingkeycode AS src_ref_key_col

,CASE 
    WHEN dt.vchstatus IN ('A','R','P','C','O','T','S','D','E','M','Q','V') OR dt.vchstatus IS NOT NULL OR dt.vchstatus <> '' THEN
        CASE 
            WHEN dt.dtupdatedate <= @DVQEndDT THEN ISNULL(dt.dtupdatedate, dt.dtcreatedate)
			WHEN dt.dtupdatedate IS NOT NULL AND dt.vchstatus NOT IN ('D','V','M','Q') THEN ISNULL(dt.dtupdatedate, dt.dtcreatedate)
            WHEN dt.dtupdatedate IS NULL THEN NULL --INSERT INTO EXCEPTION REPORT
            ELSE NULL --INSERT INTO EXCEPTION REPORT
        END
    ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS completeddate

,CASE WHEN dt.vchstatus IN ('A','R','P','C','O','T','S','D','E','M','Q','V') OR dt.vchstatus IS NOT NULL OR dt.vchstatus <> '' THEN 
		CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN 1
        WHEN dt.dtupdatedate IS NOT NULL AND dt.vchstatus NOT IN ('D','V','M','Q') THEN 1
		WHEN dt.dtupdatedate IS NULL THEN NULL --INSERT INTO EXCEPTION REPORT
		 ELSE NULL --INSERT INTO EXCEPTION REPORT
			END
		ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS iscompleted

,CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN 1 
	  WHEN dt.vchstatus not in ('20','Dd','un','Dq','D') or dt.vchstatus  is not null or dt.vchstatus <>'' then 1
	  ELSE 0 
	  END AS issubmitted

,CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN isnull(dt.dtdatelodged,dt.dtcreatedate)
	  WHEN dt.vchstatus not in ('20','Dd','un','Dq','D') or dt.vchstatus  is not null or dt.vchstatus <>'' then isnull(dt.dtdatelodged,dt.dtcreatedate)
	  ELSE NULL ---INSERT INTO EXCEPTION REPORT
	  END AS submitteddate

,CASE WHEN a.vchformcode = 'C70' THEN @CIUCRSCC
		WHEN a.vchformcode = 'C21' THEN @CIUNRAS
		WHEN a.vchformcode = 'C22A' THEN @CIUNASC
		WHEN a.vchformcode IN ('C27','C31') THEN @CIUPCRFC
		WHEN a.vchformcode = 'C29' THEN @CIUNSCSDK
		WHEN a.vchformcode = 'C30' THEN @CIUNCRA1
		WHEN a.vchformcode = 'C30A' THEN @CIUNID
		WHEN a.vchformcode = 'CPD2' THEN @CIUNCBANB
		WHEN a.vchformcode = 'C49' and dt.vchformtrx in ('481(48A)','24','44','ROM') THEN @CIUNCRA2
		WHEN a.vchformcode = 'C22' and dt.vchformtrx in ('28','11') THEN @CIUNSCFC
		WHEN a.vchformcode = 'C26' and dt.vchformtrx in ('490','49','45','46', '99','485','481(48A)','50','47','S237(3)') THEN @CIUCRDMS
		ELSE NULL END AS fk_containerprocessid --INSERT INTO EXCEPTION REPORT 

,ROW_NUMBER() OVER (PARTITION BY dt.vchlodgingref, dt.vchformtrx ORDER BY dt.dtupdatedate DESC) AS rn

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby
 
WHERE a.vchformcode in  ('C49','C77','CIU_','C70','C73','C31','C21','C22','C22A','C26','C27','C28','C29','C30','C30A','CPD2') and dt.vchformtrx not in ('99(308)')
AND ((dt.dtupdatedate >= @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate  is null))

--and dt.srllodgingkeycode in ('110527360','110527361','110527362','16577106','16577107')

UNION
		
SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,ISNULL(CB.pk_userid, @SystemUserId) AS submittedby
,dt.srllodgingkeycode AS src_ref_key_col

,CASE 
    WHEN dt.vchstatus IN ('A','R','P','C','O','T','S','D','E','M','Q','V') OR dt.vchstatus IS NOT NULL OR dt.vchstatus <> '' THEN
        CASE 
            WHEN dt.dtupdatedate <= @DVQEndDT THEN ISNULL(dt.dtupdatedate, dt.dtcreatedate)
			WHEN dt.dtupdatedate IS NOT NULL AND dt.vchstatus NOT IN ('D','V','M','Q') THEN ISNULL(dt.dtupdatedate, dt.dtcreatedate)
            WHEN dt.dtupdatedate IS NULL THEN NULL --INSERT INTO EXCEPTION REPORT
            ELSE NULL --INSERT INTO EXCEPTION REPORT
        END
    ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS completeddate

,CASE WHEN dt.vchstatus IN ('A','R','P','C','O','T','S','D','E','M','Q','V') OR dt.vchstatus IS NOT NULL OR dt.vchstatus <> '' THEN 
		CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN 1
        WHEN dt.dtupdatedate IS NOT NULL AND dt.vchstatus NOT IN ('D','V','M','Q') THEN 1
		WHEN dt.dtupdatedate IS NULL THEN NULL --INSERT INTO EXCEPTION REPORT
		 ELSE NULL --INSERT INTO EXCEPTION REPORT
			END
		ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS iscompleted

,CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN 1 
	  WHEN dt.vchstatus not in ('20','Dd','un','Dq','D') or dt.vchstatus  is not null or dt.vchstatus <>'' then 1
	  ELSE 0 
	  END AS issubmitted

,CASE WHEN dt.dtupdatedate <= @DVQEndDT THEN isnull(dt.dtdatelodged,dt.dtcreatedate)
	  WHEN dt.vchstatus not in ('20','Dd','un','Dq','D') or dt.vchstatus  is not null or dt.vchstatus <>'' then isnull(dt.dtdatelodged,dt.dtcreatedate)
	  ELSE NULL --INSERT INTO EXCEPTION ERROR
	  END AS submitteddate
		
,CASE WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('559') THEN @MBRSAR559
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('55') THEN @MBRSAR55
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('555') THEN @MBRSAR555R
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('554') THEN @MBRSFS554
		WHEN a.vchformcode IN ('C24',',C69')  and dt.vchformtrx in ('557') THEN @MBRSFS557
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('558') THEN @MBRSEA558
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('558Q') THEN @MBRSEA558Q
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('559 NoAGM') THEN @MBRSAR559NoAGM
		WHEN a.vchformcode IN ('C24',',C69') and dt.vchformtrx in ('551') THEN @MBRSAR551

		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('801') THEN @MBRSARF801
		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('802') THEN @MBRSARR802
		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('87') THEN @MBRSFS87
		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('554') THEN @MBRSFS554
		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('559') THEN @MBRSAR559
		WHEN a.vchformcode IN ('C25','C69') and dt.vchformtrx in ('557') THEN @MBRSFS557
		ELSE NULL END AS fk_containerprocessid --INSERT INTO EXCEPTION REPORT 

,ROW_NUMBER() OVER (PARTITION BY dt.vchlodgingref, dt.vchformtrx ORDER BY dt.dtupdatedate DESC) AS rn

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby
 
WHERE a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87')
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate  is null))

--and dt.srllodgingkeycode in ('110527360','110527361','110527362','16577106','16577107')

)X
where rn=1;

/*
total time	: 1 hour 05 min 45 Sec
total record: 24,249,180


source table -----------------------------------------------------

SELECT DISTINCT X.vchlodgingref,X.vchcompanyno,X.vchstatus,X.dtupdatedate,X.dtcreatedate,X.srllodgingkeycode,X.dtdatelodged,X.vchformcode,X.vchformtrx from
(SELECT distinct dt.vchlodgingref,dt.vchcompanyno,dt.vchstatus,dt.dtupdatedate,dt.dtcreatedate,dt.srllodgingkeycode,dt.dtdatelodged,a.vchformcode,dt.vchformtrx,
ROW_NUMBER() OVER (PARTITION BY dt.vchlodgingref, dt.vchformtrx ORDER BY dt.dtupdatedate DESC) AS rn
FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
where a.vchformcode in  ('C49','C77','CIU_','C70','C73','C31','C21','C22','C22A','C26','C27','C28','C29','C30','C30A','CPD2') and dt.vchformtrx not in ('99(308)') 
and ((dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
OR (dt.dtupdatedate  is null)) 
and dt.srllodgingkeycode in ('110527360','110527361','110527362','16577106','16577107')
--and dt.srllodgingkeycode in ('110527360','110527361','110527362','110527042','110527043','110527044','110527045','110527046') --'16621734' --'16659506'
GROUP BY dt.vchlodgingref,dt.vchcompanyno,dt.vchstatus,dt.dtupdatedate, dt.vchlodgingref,dt.dtcreatedate,dt.srllodgingkeycode,dt.dtdatelodged,a.vchformcode,dt.vchformtrx -- 

UNION 

SELECT distinct dt.vchlodgingref,dt.vchcompanyno,dt.vchstatus,dt.dtupdatedate,dt.dtcreatedate,dt.srllodgingkeycode,dt.dtdatelodged,a.vchformcode,dt.vchformtrx,
ROW_NUMBER() OVER (PARTITION BY dt.vchlodgingref, dt.vchformtrx ORDER BY dt.dtupdatedate DESC) AS rn
FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87') and ((dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))
OR (dt.dtupdatedate  is null)) 
and dt.srllodgingkeycode in ('110527360','110527361','110527362','16577106','16577107')
--and dt.srllodgingkeycode in ('110527360','110527361','110527362','110527042','110527043','110527044','110527045','110527046') --'16621734' --'16659506'
GROUP BY dt.vchlodgingref,dt.vchcompanyno,dt.vchstatus,dt.dtupdatedate,dt.dtcreatedate,dt.srllodgingkeycode,dt.dtdatelodged,a.vchformcode,dt.vchformtrx

target table -----------------------------------------------------
select * from crsdb2.informix.tbwfr_m_workflowsubmission

*/

