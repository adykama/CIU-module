use crs_db;
/*
	base query for
	table: crsdb2.informix.crs_submission(CIU)
*/

DECLARE @SystemUserId INT;
SELECT @SystemUserId = pk_userid FROM crsdb2.informix.tbusr_m_user WHERE username = 'system';

DECLARE @Defaultdate datetime2 = '1900-01-01 00:00:00.00000';

DECLARE @CAM_queried INT;
SELECT @CAM_queried = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'queried'),'');

DECLARE @CAM_Withdrew INT;
SELECT @CAM_Withdrew = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'Withdrew'),'');

DECLARE @CAM_Approved INT;
SELECT @CAM_Approved = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'Approved'),'');

DECLARE @CAM_rejected INT;
SELECT @CAM_rejected = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'rejected'),'');

DECLARE @CAM_new INT;
SELECT @CAM_new = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'new'),'');

DECLARE @CAM_processing INT;
SELECT @CAM_processing = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND codevalue1 = 'processing'),'');

DECLARE @CAM_incomplete INT;
SELECT @CAM_incomplete = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND modulecode='CMN' AND codevalue2 = 'Incomplete'),'');

DECLARE @CAM_submitted INT;
SELECT @CAM_submitted = NULLIF((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
								WHERE codetype = 'WorkflowCamouflageStatusCode' AND modulecode='CMN' AND codevalue2 = 're-submitted'),'');

DECLARE @CAM_Draft INT;
SELECT @CAM_Draft = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and 
codetype='WorkflowCamouflageStatusCode' and codevalue1='Draft'),NULL);

DECLARE @CAM_Withdrawn INT;
SELECT @CAM_Withdrawn = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN' and 
codetype='WorkflowCamouflageStatusCode' and codevalue1='Withdrawn'),NULL);

DECLARE @EXT_pending INT;
SELECT @EXT_pending = NULLIF((Select TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='pending approval'),NULL);

DECLARE @EXT_Draft INT;
SELECT @EXT_Draft = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='Draft'),NULL);

DECLARE @EXT_Queried INT;
SELECT @EXT_Queried = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='Queried'),NULL);

DECLARE @EXT_approved INT;
SELECT @EXT_approved = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='Approved'),NULL);

DECLARE @EXT_Rejected INT;
SELECT @EXT_Rejected = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='Rejected'),NULL);

DECLARE @EXT_Processing INT;
SELECT @EXT_Processing = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' and codevalue1='Processing'),NULL);

DECLARE @EXT_Withdrawn INT;
SELECT @EXT_Withdrawn = NULLIF((SELECT TOP 1 pk_codesetupid from crsdb2.informix.tbsys_m_codesetup where modulecode='CMN'  and 
codetype='WorkflowCamouflageExternalStatusCode' AND modulecode='CMN' and codevalue1='Withdrawn'),NULL);

DECLARE @Ext_new INT;
SELECT @Ext_new = NULLIF ((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
							WHERE modulecode = 'CMN' AND codetype = 'WorkflowCamouflageExternalStatusCode' AND codevalue1 = 'new'),'');

DECLARE @Ext_submitted INT;
SELECT @Ext_submitted = NULLIF ((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
							WHERE modulecode = 'CMN' AND codetype = 'WorkflowCamouflageExternalStatusCode' AND codevalue1 = 're-submitted'),''); --xde value

DECLARE @Ext_Withdrew INT;
SELECT @Ext_Withdrew = NULLIF ((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
							WHERE modulecode = 'CMN' AND codetype = 'WorkflowCamouflageExternalStatusCode' AND codevalue1 = 'Withdrew'),'');

DECLARE @Ext_incomplete INT;
SELECT @Ext_incomplete = NULLIF ((SELECT TOP 1 pk_codesetupid FROM crsdb2.informix.tbsys_m_codesetup 
							WHERE modulecode = 'CMN' AND codetype = 'WorkflowCamouflageExternalStatusCode' AND codevalue2 = 'Incomplete'),'');
							
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
LOWER(CONVERT(VARCHAR(36), NEWID())) AS submission_id
,X.createdby
,X.createddate
,X.modifiedby
,X.modifieddate
,0 AS [version]
,X.draft_refno
,NULL AS expiry_dt
,X.is_approve
,NULL AS last_update_dt
,X.draft_refno AS refno
,1 AS status
,X.cam_ext_sts_id
,X.cam_intl_sts_id
,X.lodger_id
,X.work_flow_sub_id
,'CBS_ROC' AS source_of_data
,NULL AS payment_sts_id
,NULL AS checker_user_id
,'roclodgingdetails' AS src_tablename
,X.src_ref_key_col
,ROW_NUMBER() OVER (ORDER BY X.src_ref_key_col) AS etl_mig_ref_id
,25 AS is_migrated

FROM (

SELECT DISTINCT 
ISNULL(CB.pk_userid, @SystemUserId) AS createdby
,ISNULL(MB.pk_userid, @SystemUserId) AS modifiedby
,FORMAT(ISNULL(dt.dtcreatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS createddate
,FORMAT(ISNULL(dt.dtupdatedate, @Defaultdate), 'yyyy-MM-dd HH:mm:ss') AS modifieddate
,dt.srllodgingkeycode AS src_ref_key_col
,ISNULL(ws.pk_workflowsubmissionid,NULL) AS work_flow_sub_id 
,ISNULL(CB.pk_userid, @SystemUserId) AS lodger_id
,ISNULL(a.vchlodgingref,NULL) AS draft_refno
		
,CASE 
    WHEN dt.vchstatus NOT IN ('AA','20','Dd','un','Dq','D') 
         OR dt.vchstatus IS NOT NULL 
         OR dt.vchstatus <> '' 
    THEN
        CASE 
            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDT <> @DVQEndDT 
            THEN
                CASE 
                    WHEN dt.dtupdatedate <= @DVQEndDT THEN
                        CASE 
                            WHEN dt.vchstatus IN ('D','V','M') THEN @CAM_incomplete
							WHEN dt.vchstatus IN ('O','C','P') THEN @CAM_Withdrawn
							WHEN dt.vchstatus = 'A' THEN @CAM_approved
							WHEN dt.vchstatus IN ('T','R','Q') THEN @CAM_rejected
							ELSE @CAM_submitted
                        END
                    ELSE --2025
                        CASE 
                            WHEN dt.vchstatus IN ('O','C','P') THEN @CAM_Withdrawn
							WHEN dt.vchstatus = 'A' THEN @CAM_approved
							WHEN dt.vchstatus IN ('T','R') THEN @CAM_rejected
							WHEN dt.vchstatus = 'S' THEN @CAM_submitted
                            ELSE NULL --INSERT INTO EXCEPTION REPORT
                        END
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL  
                 AND @DVQStartDT IS NULL 
                 AND @DVQEndDT IS NULL 
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('O','C','P') THEN @CAM_Withdrawn
                    WHEN dt.vchstatus = 'A' THEN @CAM_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @CAM_rejected
					WHEN dt.vchstatus = 'S' THEN @CAM_submitted
                    ELSE NULL --INSERT INTO EXCEPTION REPORT
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDT = @DVQEndDT 
            THEN
                CASE 
                    WHEN dt.vchstatus = ('D') THEN @CAM_draft
                    WHEN dt.vchstatus = 'Q' THEN @CAM_queried
                    WHEN dt.vchstatus = 'A' THEN @CAM_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @CAM_rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @CAM_processing
                    ELSE @CAM_Withdrew
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT = 1 
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('D') THEN @CAM_draft 
                    WHEN dt.vchstatus = 'Q' THEN @CAM_queried
                    WHEN dt.vchstatus = 'A' THEN @CAM_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @CAM_rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @CAM_processing
					WHEN dt.vchstatus = 'S' THEN @CAM_submitted
                    ELSE @CAM_Withdrew
                END

            ELSE NULL --INSERT INTO EXCEPTION REPORT
        END
    ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS cam_intl_sts_id 

,CASE 
    WHEN dt.vchstatus NOT IN ('AA','20','Dd','un','Dq','D') 
         OR dt.vchstatus IS NOT NULL 
         OR dt.vchstatus <> '' 
    THEN
        CASE 
            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDT <> @DVQEndDT 
            THEN
                CASE 
                    WHEN dt.dtupdatedate <= @DVQEndDT THEN
                        CASE 
                            WHEN dt.vchstatus IN ('D','V','M') THEN @Ext_incomplete
                            WHEN dt.vchstatus IN ('O','C','P') THEN @Ext_withdrawn
                            WHEN dt.vchstatus = 'A' THEN @EXT_approved
                            WHEN dt.vchstatus IN ('T','R','Q') THEN @EXT_rejected
                            ELSE @EXT_pending
                        END
                    ELSE --2025
                        CASE 
                            WHEN dt.vchstatus IN ('O','C','P') THEN @EXT_withdrawn
                            WHEN dt.vchstatus = 'A' THEN @EXT_approved
                            WHEN dt.vchstatus IN ('T','R') THEN @EXT_rejected
                            WHEN dt.vchstatus = 'S' THEN @EXT_pending
                            ELSE NULL --INSERT INTO EXCEPTION REPORT
                        END
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NULL 
                 AND @DVQEndDT IS NULL 
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('O','C','P') THEN @EXT_withdrawn
                    WHEN dt.vchstatus = 'A' THEN @EXT_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @EXT_rejected
                    WHEN dt.vchstatus = 'S' THEN @EXT_pending
                    ELSE NULL --INSERT INTO EXCEPTION REPORT
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT IS NULL 
                 AND @DVQStartDT IS NOT NULL 
                 AND @DVQEndDT IS NOT NULL 
                 AND @StatusEndDT = @DVQEndDT 
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('D') THEN @EXT_draft 
                    WHEN dt.vchstatus = 'Q' THEN @EXT_queried
                    WHEN dt.vchstatus = 'A' THEN @EXT_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @EXT_rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @EXT_Processing
					WHEN dt.vchstatus = 'S' THEN @EXT_pending
                    ELSE @EXT_Withdrew
                END

            WHEN @DataLoadStatus IS NULL 
                 AND @NullDT = 1 
            THEN
                CASE 
                    WHEN dt.vchstatus IN ('D') THEN @EXT_draft 
                    WHEN dt.vchstatus = 'Q' THEN @EXT_queried
                    WHEN dt.vchstatus = 'A' THEN @EXT_approved
                    WHEN dt.vchstatus IN ('T','R') THEN @EXT_rejected
                    WHEN dt.vchstatus IN ('V','M') THEN @EXT_Processing
					WHEN dt.vchstatus = 'S' THEN @EXT_pending
                    ELSE @EXT_Withdrew
                END

            ELSE NULL --INSERT INTO EXCEPTION REPORT
        END
    ELSE NULL --INSERT INTO EXCEPTION REPORT
END AS cam_ext_sts_id 

,CASE WHEN dt.vchstatus = 'A' THEN '1'
		ELSE '0' END AS is_approve

,ROW_NUMBER() OVER (PARTITION BY ws.pk_workflowsubmissionid ORDER BY ws.src_ref_key_col DESC) AS row_num

FROM crs_db.dbo.roclodgingmaster a

INNER JOIN crs_db.dbo.roclodgingdetails dt ON a.vchlodgingref = dt.vchlodgingref AND a.vchcompanyno = dt.vchcompanyno

LEFT JOIN CTE_CREATED CB
ON CB.vchuserid = dt.vchcreateby
 
LEFT JOIN CTE_CREATED MB
ON MB.vchuserid = dt.vchupdateby

INNER JOIN crsdb2.informix.tbwfr_m_workflowsubmission ws
ON ws.src_ref_key_col = dt.srllodgingkeycode
AND ws.is_migrated = '25'

WHERE (a.vchformcode in ('C49','C77','CIU_', 'C70','C73','C31','C21','C22','C22A','C26','C27','C28','C29','C30','C30A','CPD2') and dt.vchformtrx not in ('99(308)') ) 
OR (a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('99','551','555','559','55','56','52','558','559 NoAGM','801','802','554','557','87'))
AND ((dt.dtupdatedate > @StatusStartDT AND dt.dtupdatedate < @StatusEndDT AND @DataLoadStatus IS NULL)
OR (dt.dtupdatedate IS NULL))

--and dt.srllodgingkeycode in ('136894555','136894703','136898350','136898526')

)X
WHERE X.row_num = 1

/*
total time	: 16 min 9 Sec
total record: 24,249,180


source table -----------------------------------------------------

SELECT dt.vchlodgingref,dt.vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid  FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in   ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

UNION 

SELECT dt.vchlodgingref,dt.vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in  ('C24','C25','C69') and dt.vchformtrx  in ('559','55','555','557','554','801','802','87', '559 NoAGM','551','558Q','558')
and (dt.dtupdatedate  > (select StatusStartDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null) and dt.dtupdatedate < (select StatusEndDT from crs_db.dbo.tbSSIS_m_IncrementalSnapShot
where Module = 'CIU' and DataLoadStatus is null))

UNION 

SELECT dt.vchlodgingref,dt.vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in   ('C49', 'C77', 'CIU_', 'C70', 'C73','C31', 'C21', 'C22','C22A', 'C26', 'C27', 'C28', 'C29', 'C30', 'C30A', 'CPD2') and dt.vchformtrx not in ('99(308)') 
and dt.dtupdatedate  is null

UNION 

SELECT dt.vchlodgingref,dt.vchstatus, dt.dtupdatedate, ws.pk_workflowsubmissionid FROM crs_db.dbo.roclodgingmaster a 
inner join crs_db.dbo.roclodgingdetails dt on dt.vchlodgingref=a.vchlodgingref and dt.vchcompanyno =a.vchcompanyno 
inner join crsdb2.informix.tbwfr_m_workflowsubmission ws on ws.src_ref_key_col=cast(dt.srllodgingkeycode as varchar) 
where a.vchformcode in ('C24','C25','C69') and dt.vchformtrx  in ('559','55','555','557','554','801','802','87', '559 NoAGM','551','558Q','558')
and dt.dtupdatedate is null

target table -----------------------------------------------------
select * from crsdb2.informix.crs_submission

*/
