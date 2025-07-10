use crs_db;
/*
	base query for
	table: crsdb2.informix.tbwfr_t_workflowsubmissionstatus (CIU)
*/

DECLARE @SystemUserId INT;
SELECT @SystemUserId = pk_userid FROM crsdb2.informix.tbusr_m_user  WHERE username = 'system';

DECLARE @Defaultdate datetime2 = '1900-01-01 00:00:00.00000';

DECLARE @Draft INT;
SELECT @Draft = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='Draft'),NULL);

DECLARE @submitted INT;
SELECT @submitted = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='WFR' and codetype='WorkflowStatusCode' and codevalue1='re-submitted'),NULL);

DECLARE @Queried INT;
SELECT @Queried = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='Queried'),NULL);

DECLARE @Approved INT;
SELECT @Approved = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='Approved'),NULL);

DECLARE @Rejected INT;
SELECT @Rejected = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='Rejected'),NULL);

DECLARE @Processing INT;
SELECT @Processing = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='processing'),NULL);

DECLARE @auto INT;
SELECT @auto = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='WFR' and codetype='WorkflowStatusCode' and codevalue1='auto-rejected'),NULL);

DECLARE @Withdrawn INT;
SELECT @Withdrawn = NULLIF((select pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode = 'WFR' and codetype='WorkflowStatusCode' and codevalue1='Withdrawn'),NULL);

DECLARE @Incomplete INT ;
SELECT @Incomplete = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup WHERE modulecode = 'CMN' AND codetype = 'WorkflowStatusCode' AND codevalue1 = 'I'),NULL);

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
LOWER(CONVERT(VARCHAR(36), NEWID())) AS pk_workflowsubmissionstatusid
,@SystemUserId AS createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,1 AS [status]
,X.fk_workflowsubmissionid
,X.fk_workflowstatusid
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
,FORMAT(ISNULL(dt.dtupdatedate,@Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,dt.srllodgingkeycode AS src_ref_key_col
,ISNULL(ws.pk_workflowsubmissionid,NULL) AS fk_workflowsubmissionid 

,CASE 
    WHEN dt.vchstatus NOT IN ('AA','20','Dd','un','Dq') 
         OR dt.vchstatus IS NOT NULL 
         OR dt.vchstatus <> '' 
    THEN
        CASE 
            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDt <> @DVQEndDT
            THEN
                CASE 
                    WHEN dt.dtupdatedate <= @DVQEndDT THEN
                        CASE 
                            WHEN dt.vchstatus IN ('D','V','M') THEN @Incomplete
                            WHEN dt.vchstatus IN ('O','C','P') THEN @Withdrawn
                            WHEN dt.vchstatus = 'A' THEN @Approved
                            WHEN dt.vchstatus IN ('T','Q') THEN @auto
                            WHEN dt.vchstatus = 'R' THEN @Rejected
                            ELSE @submitted
                        END
                    ELSE --2025
                        CASE 
                            WHEN dt.vchstatus IN ('O','C','P') THEN @Withdrawn
                            WHEN dt.vchstatus = 'A' THEN @Approved
                            WHEN dt.vchstatus = 'T' THEN @auto
                            WHEN dt.vchstatus = 'R' THEN @Rejected
                            WHEN dt.vchstatus = 'S' THEN @submitted
                            ELSE NULL  --INSERT INTO EXCEPTION REPORT
                        END
                END
				
            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NULL 
                 AND @DVQEndDT IS NULL
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('O','C','P') THEN @Withdrawn
                    WHEN dt.vchstatus = 'A' THEN @Approved
                    WHEN dt.vchstatus = 'T' THEN @auto
                    WHEN dt.vchstatus = 'R' THEN @Rejected
                    WHEN dt.vchstatus = 'S' THEN @submitted
                    ELSE NULL  --INSERT INTO EXCEPTION REPORT
                END
				
            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDT = @DVQEndDT
            THEN
                CASE 
                    WHEN dt.vchstatus = 'D' THEN @Draft
                    WHEN dt.vchstatus = 'Q' THEN @Queried
                    WHEN dt.vchstatus = 'A' THEN @Approved
                    WHEN dt.vchstatus = 'T' THEN @auto
                    WHEN dt.vchstatus = 'R' THEN @Rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @Processing
                    ELSE @Withdrawn 
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT = 1 
            THEN
                CASE 
                    WHEN dt.vchstatus = 'D' THEN @Draft
                    WHEN dt.vchstatus = 'Q' THEN @Queried
                    WHEN dt.vchstatus = 'A' THEN @Approved
                    WHEN dt.vchstatus = 'T' THEN @auto
                    WHEN dt.vchstatus = 'R' THEN @Rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @Processing
                    WHEN dt.vchstatus = 'S' THEN @submitted
                    ELSE @Withdrawn 
                END
            ELSE NULL  --INSERT INTO EXCEPTION REPORT
        END
    ELSE NULL  --INSERT INTO EXCEPTION REPORT
END AS fk_workflowstatusid 

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt 
ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby

INNER JOIN crsdb2.informix.tbwfr_m_workflowsubmission ws
ON ws.src_ref_key_col = dt.srllodgingkeycode
AND is_migrated = '25'

WHERE (a.vchformcode in  ('C49','C77','CIU_','C70','C73','C31','C21','C22','C22A','C26','C27','C28','C29','C30','C30A','CPD2') and dt.vchformtrx not in ('99(308)') and dt.vchformtrx not in ('99(308)')) 
OR (a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

)X										

/*
total time	: 4 min 57 Sec
total record: 21,624,699


source table -----------------------------------------------------

SELECT trim(dt.vchstatus) vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid
FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.vchformtrx not in ('99(308)') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate is null)

UNION 

SELECT trim(dt.vchstatus) vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid FROM crs_db.dbo.roclodgingmaster a
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar)
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('559','55','555','557','554','801','802','87', '559 NoAGM','551','558Q','558')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate is null)

union 

SELECT trim(dt.vchstatus) vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid
FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in  ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.vchformtrx not in ('99(308)') and dt.dtupdatedate is null

UNION 

SELECT trim(dt.vchstatus) vchstatus, dt.dtupdatedate,ws.pk_workflowsubmissionid FROM crs_db.dbo.roclodgingmaster a
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.CIU_tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar)
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('559','55','555','557','554','801','802','87', '559 NoAGM','551','558Q','558')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select count(1) from crsdb2.informix.tbwfr_t_workflowsubmissionstatus where is_migrated = 25

*/
