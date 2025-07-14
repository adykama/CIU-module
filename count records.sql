--[CNS] Name Search - gazette word, control word, Offensive word & Unacceptable Symbols
SELECT 'ns_maint_gw' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.ns_maint_gw WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_cw', '1', COUNT(*), 2 FROM crsdb2.informix.ns_maint_cw WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_ow', '1', COUNT(*), 3 FROM crsdb2.informix.ns_maint_ow WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_as', '1', COUNT(*), 4 FROM crsdb2.informix.ns_maint_as WHERE is_migrated = 1
ORDER BY SortOrder;

--[G.SPT] Supporting Modules - [UAM] User Access Management
SELECT 'tbprf_m_profile' AS TableName, '0' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 0 UNION ALL
SELECT 'tbusr_m_user', '0', COUNT(*), 2 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 0 UNION ALL
SELECT 'crs_usr_addl_info', '0', COUNT(*), 3 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 0 UNION ALL
SELECT 'tbcnt_m_contact', '0', COUNT(*), 4 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 0 UNION ALL
SELECT 'tbprf_t_profilecontact', '0', COUNT(*), 5 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 0 UNION ALL
SELECT 'tbusr_t_userrole', '0', COUNT(*), 6 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 0 UNION ALL
SELECT 'tbprf_m_profile', '1', COUNT(*), 7 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 1 UNION ALL
SELECT 'tbusr_m_user', '1', COUNT(*), 8 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 1 UNION ALL
SELECT 'crs_usr_addl_info', '1', COUNT(*), 9 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 1 UNION ALL
SELECT 'tbcnt_m_contact', '1', COUNT(*), 10 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 1 UNION ALL
SELECT 'tbprf_t_profilecontact', '1', COUNT(*), 11 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 1 UNION ALL
SELECT 'tbusr_t_userrole', '1', COUNT(*), 12 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 1 UNION ALL
SELECT 'tbprf_m_profile', '2', COUNT(*), 13 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 2 UNION ALL
SELECT 'tbusr_m_user', '2', COUNT(*), 14 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 2 UNION ALL
SELECT 'crs_usr_addl_info', '2', COUNT(*), 15 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 2 UNION ALL
SELECT 'tbcnt_m_contact', '2', COUNT(*), 16 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 2 UNION ALL
SELECT 'tbprf_t_profilecontact', '2', COUNT(*), 17 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 2 UNION ALL
SELECT 'tbusr_t_userrole', '2', COUNT(*), 18 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 2 UNION ALL
SELECT 'tbprf_m_profile', '3', COUNT(*), 19 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 3 UNION ALL
SELECT 'tbusr_m_user', '3', COUNT(*), 20 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 3 UNION ALL
SELECT 'crs_usr_addl_info', '3', COUNT(*), 21 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 3 UNION ALL
SELECT 'tbcnt_m_contact', '3', COUNT(*), 22 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 3 UNION ALL
SELECT 'tbprf_t_profilecontact', '3', COUNT(*), 23 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 3 UNION ALL
SELECT 'tbusr_t_userrole', '3', COUNT(*), 24 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 3 UNION ALL
SELECT 'tbprf_m_profile', '4', COUNT(*), 25 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 4 UNION ALL
SELECT 'tbusr_m_user', '4', COUNT(*), 26 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 4 UNION ALL
SELECT 'crs_usr_addl_info', '4', COUNT(*), 27 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 4 UNION ALL
SELECT 'tbcnt_m_contact', '4', COUNT(*), 28 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 4 UNION ALL
SELECT 'tbprf_t_profilecontact', '4', COUNT(*), 29 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 4 UNION ALL
SELECT 'tbusr_t_userrole', '4', COUNT(*), 30 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 4 UNION ALL
SELECT 'tbprf_m_profile', '5', COUNT(*), 31 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 5 UNION ALL
SELECT 'tbusr_m_user', '5', COUNT(*), 32 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 5 UNION ALL
SELECT 'crs_usr_addl_info', '5', COUNT(*), 33 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 5 UNION ALL
SELECT 'tbcnt_m_contact', '5', COUNT(*), 34 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 5 UNION ALL
SELECT 'tbprf_t_profilecontact', '5', COUNT(*), 35 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 5 UNION ALL
SELECT 'tbusr_t_userrole', '5', COUNT(*), 36 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 5 UNION ALL
SELECT 'tbprf_m_profile', '6', COUNT(*), 37 FROM crsdb2.informix.tbprf_m_profile WHERE is_migrated = 6 UNION ALL
SELECT 'tbusr_m_user', '6', COUNT(*), 38 FROM crsdb2.informix.tbusr_m_user WHERE is_migrated = 6 UNION ALL
SELECT 'crs_usr_addl_info', '6', COUNT(*), 39 FROM crsdb2.informix.crs_usr_addl_info WHERE is_migrated = 6 UNION ALL
SELECT 'tbcnt_m_contact', '6', COUNT(*), 40 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated = 6 UNION ALL
SELECT 'tbprf_t_profilecontact', '6', COUNT(*), 41 FROM crsdb2.informix.tbprf_t_profilecontact WHERE is_migrated = 6 UNION ALL
SELECT 'tbusr_t_userrole', '6', COUNT(*), 42 FROM crsdb2.informix.tbusr_t_userrole WHERE is_migrated = 6
ORDER BY SortOrder;


--[G.SPT] Supporting Modules - [PF] Profiles - Batch 1

--[G.SPT] Supporting Modules - [PF] Profiles - Batch 2

--[G.SPT] Supporting Modules - [PF] Profiles - Batch 3

--MyCOID
SELECT 'crs_submission' AS TableName, '18,19,20,21,33,34,35,36,37,38,40,41,42' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated IN (18,19,20,21,33,34,35,36,37,38,40,41,42) UNION ALL
SELECT 'tbwfr_m_workflowsubmission', '18,19,20,21,33,34,35,36,37,38,40,41,42', COUNT(*), 2 FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated IN (18,19,20,21,33,34,35,36,37,38,40,41,42) UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '18,19,20,21,33,34,35,36,37,38,40,41,42', COUNT(*), 3 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated IN (18,19,20,21,33,34,35,36,37,38,40,41,42) UNION ALL
SELECT 'crs_ent_doc_lod', '18,19,20,21,33,34,35,36,37,38,40,41,42', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated IN (18,19,20,21,33,34,35,36,37,38,40,41,42) UNION ALL
SELECT 'tbadd_m_address', '18,19,20,21,22,23,24,25', COUNT(*), 5 FROM crsdb2.informix.tbadd_m_address WHERE is_migrated IN (18,19,20,21,22,23,24,25) UNION ALL
SELECT 'tbcnt_m_contact', '14,15,16,17', COUNT(*), 6 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated IN (14,15,16,17) UNION ALL
SELECT 'crs_ch', '41,42', COUNT(*), 7 FROM crsdb2.informix.crs_ch WHERE is_migrated IN (41,42) UNION ALL
SELECT 'roc_ch', '3,4', COUNT(*), 8 FROM crsdb2.informix.roc_ch WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_propt_dets', '3,4', COUNT(*), 9 FROM crsdb2.informix.roc_ch_propt_dets WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_party', '3,4', COUNT(*), 10 FROM crsdb2.informix.roc_ch_party WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_chgee_dets', '3,4', COUNT(*), 11 FROM crsdb2.informix.roc_ch_chgee_dets WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_sign_info', '3,4', COUNT(*), 12 FROM crsdb2.informix.roc_ch_sign_info WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_bnf_party', '3,4', COUNT(*), 13 FROM crsdb2.informix.roc_ch_bnf_party WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ch_mort_info', '3,4', COUNT(*), 14 FROM crsdb2.informix.roc_ch_mort_info WHERE is_migrated IN (3,4) UNION ALL
--SELECT 'roc_ch_sup_doc', 'pending', COUNT(*), 15 FROM crsdb2.informix.roc_ch_sup_doc UNION ALL
SELECT 'crs_inc', '2,3', COUNT(*), 16 FROM crsdb2.informix.crs_inc WHERE is_migrated IN (2,3) UNION ALL
SELECT 'roc_inc', '2,3', COUNT(*), 17 FROM crsdb2.informix.roc_inc WHERE is_migrated IN (2,3) UNION ALL
SELECT 'roc_inc_addr', '3,4,5,6', COUNT(*), 18 FROM crsdb2.informix.roc_inc_addr WHERE is_migrated IN (3,4,5,6) UNION ALL
SELECT 'crs_ciu', '1,2,3,4,5,6,7,8,10', COUNT(*), 19 FROM crsdb2.informix.crs_ciu WHERE is_migrated IN (1,2,3,4,5,6,7,8,10) UNION ALL
SELECT 'roc_ciu', '1,2,3,4,5,6,7,8,10', COUNT(*), 20 FROM crsdb2.informix.roc_ciu WHERE is_migrated IN (1,2,3,4,5,6,7,8,10) UNION ALL
SELECT 'roc_ciu_shldr', '1,2', COUNT(*), 21 FROM crsdb2.informix.roc_ciu_shldr WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_ciu_sh_dtls', '1', COUNT(*), 22 FROM crsdb2.informix.roc_ciu_sh_dtls WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_personal', '1,2', COUNT(*), 23 FROM crsdb2.informix.roc_ciu_personal WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_ciu_shldr_bd', '1,2', COUNT(*), 24 FROM crsdb2.informix.roc_ciu_shldr_bd WHERE is_migrated IN (1,2) UNION ALL
--SELECT 'tbdoc_m_document', 'pending', COUNT(*), 25 FROM crsdb2.informix.tbdoc_m_document UNION ALL
SELECT 'crs_payment', '2,3', COUNT(*), 26 FROM crsdb2.informix.crs_payment WHERE is_migrated IN (2,3) UNION ALL
SELECT 'crs_payment_det', '2,3', COUNT(*), 27 FROM crsdb2.informix.crs_payment_det WHERE is_migrated IN (2,3) UNION ALL
SELECT 'roc_ciu_reassign', '1', COUNT(*), 28 FROM crsdb2.informix.roc_ciu_reassign WHERE is_migrated = 1 UNION ALL
SELECT 'crs_lodger_info', '1,2,3,4,5,6,8,9,10', COUNT(*), 29 FROM crsdb2.informix.crs_lodger_info WHERE is_migrated IN (1,2,3,4,5,6,8,9,10) UNION ALL
SELECT 'roc_ciu_com_dets', '1,2', COUNT(*), 30 FROM crsdb2.informix.roc_ciu_com_dets WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_inc_dir', '1,2', COUNT(*), 31 FROM crsdb2.informix.roc_inc_dir WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_inc_mbr', '1,2', COUNT(*), 32 FROM crsdb2.informix.roc_inc_mbr WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_ch_addr', '1,2,3,4', COUNT(*), 33 FROM crsdb2.informix.roc_ch_addr WHERE is_migrated IN (1,2,3,4) UNION ALL
SELECT 'roc_ch_asg_dets', '3,4', COUNT(*), 34 FROM crsdb2.informix.roc_ch_asg_dets WHERE is_migrated IN (3,4) UNION ALL
SELECT 'roc_ciu_ctt', '1,2', COUNT(*), 35 FROM crsdb2.informix.roc_ciu_ctt WHERE is_migrated IN (1,2) UNION ALL
SELECT 'crs_doc_sub', 'pending', COUNT(*), 36 FROM crsdb2.informix.crs_doc_sub UNION ALL
SELECT 'roc_ciu_cosec', '2', COUNT(*), 37 FROM crsdb2.informix.roc_ciu_cosec WHERE is_migrated = 2
ORDER BY SortOrder;

--[CNS] Name Search
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '1,2' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated IN (1,2) UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '1,2', COUNT(*), 2 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated IN (1,2) UNION ALL
SELECT 'crs_submission', '1,2', COUNT(*), 3 FROM crsdb2.informix.crs_submission WHERE is_migrated IN (1,2) UNION ALL
SELECT 'crs_ent_doc_lod', '18,19', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated IN (18,19) UNION ALL
SELECT 'crs_nr', '1', COUNT(*), 5 FROM crsdb2.informix.crs_nr WHERE is_migrated = 1 UNION ALL
SELECT 'crs_ns_cw', '1', COUNT(*), 6 FROM crsdb2.informix.crs_ns_cw WHERE is_migrated = 1 UNION ALL
SELECT 'tbadd_m_address', '6', COUNT(*), 7 FROM crsdb2.informix.tbadd_m_address WHERE is_migrated = 6 UNION ALL
SELECT 'crs_ns_cw_appl', '1', COUNT(*), 8 FROM crsdb2.informix.crs_ns_cw_appl WHERE is_migrated = 1 UNION ALL
SELECT 'roc_nr', '1', COUNT(*), 9 FROM crsdb2.informix.roc_nr WHERE is_migrated = 1 UNION ALL
SELECT 'roc_nr_clar', '1', COUNT(*), 10 FROM crsdb2.informix.roc_nr_clar WHERE is_migrated = 1 UNION ALL
SELECT 'roc_nr_eot', '1', COUNT(*), 11 FROM crsdb2.informix.roc_nr_eot WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_gw', '1', COUNT(*), 12 FROM crsdb2.informix.ns_maint_gw WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_cw', '1', COUNT(*), 13 FROM crsdb2.informix.ns_maint_cw WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_ow', '1', COUNT(*), 14 FROM crsdb2.informix.ns_maint_ow WHERE is_migrated = 1 UNION ALL
SELECT 'ns_maint_as', '1', COUNT(*), 15 FROM crsdb2.informix.ns_maint_as WHERE is_migrated = 1
ORDER BY SortOrder;

--[INC] Incorporation
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 1 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 1 UNION ALL
SELECT 'crs_submission' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 1 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 1 UNION ALL
SELECT 'crs_inc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_inc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_inc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_inc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_inc_biz_code' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_inc_biz_code WHERE is_migrated = 1 UNION ALL
SELECT 'roc_inc_cap_str' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_inc_cap_str WHERE is_migrated = 1 UNION ALL
SELECT 'tbadd_m_address' AS TableName, '1,7,8' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.tbadd_m_address WHERE is_migrated IN (1,7,8) UNION ALL
SELECT 'roc_inc_addr' AS TableName, '1,2' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.roc_inc_addr WHERE is_migrated IN (1,2)
ORDER BY SortOrder;

--[BL] Blacklist
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 12 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 12 UNION ALL
SELECT 'crs_submission' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 12 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 12 UNION ALL
SELECT 'enf_blst' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.enf_blst WHERE is_migrated = 1
ORDER BY SortOrder;

--[G.BZT] BizTrust
SELECT 'crs_ent_urladdr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.crs_ent_urladdr WHERE is_migrated = 1 ORDER BY SortOrder;

--[G.FN] Finance
--[PAYMENT] Payment Data Migration
SELECT 'crs_payment' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.crs_payment WHERE is_migrated = 1 UNION ALL
SELECT 'crs_payment_det' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.crs_payment_det WHERE is_migrated = 1
ORDER BY SortOrder;

--[CH] Charges

--[CIR] Corporate Intermediaries Registration
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '4,5,6,7,8,9,10' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated IN (4,5,6,7,8,9,10) UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '4,5,6,7,8,9,10', COUNT(*), 2 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated IN (4,5,6,7,8,9,10) UNION ALL
SELECT 'tbcnt_m_contact', '5,6,7,8,9,10,11,12,13', COUNT(*), 3 FROM crsdb2.informix.tbcnt_m_contact WHERE is_migrated IN (5,6,7,8,9,10,11,12,13) UNION ALL
SELECT 'tbadd_m_address', '9,10,11,12,13,14,15,16,17', COUNT(*), 4 FROM crsdb2.informix.tbadd_m_address WHERE is_migrated IN (9,10,11,12,13,14,15,16,17) UNION ALL
SELECT 'roc_cir_addr', '1,2,3,4,5,6,7', COUNT(*), 5 FROM crsdb2.informix.roc_cir_addr WHERE is_migrated IN (1,2,3,4,5,6,7) UNION ALL
SELECT 'crs_submission', '4,5,6,7,8,9,10', COUNT(*), 6 FROM crsdb2.informix.crs_submission WHERE is_migrated IN (4,5,6,7,8,9,10) UNION ALL
SELECT 'crs_cir', '1,2,3,4,5,6,7', COUNT(*), 7 FROM crsdb2.informix.crs_cir WHERE is_migrated IN (1,2,3,4,5,6,7) UNION ALL
SELECT 'roc_cir', '1,2,3,4,5,6,7', COUNT(*), 8 FROM crsdb2.informix.roc_cir WHERE is_migrated IN (1,2,3,4,5,6,7) UNION ALL
SELECT 'crs_cosec_cir_prf', '1', COUNT(*), 9 FROM crsdb2.informix.crs_cosec_cir_prf WHERE is_migrated = 1 UNION ALL
SELECT 'crs_cpe_trn_cir_prf', '1', COUNT(*), 10 FROM crsdb2.informix.crs_cpe_trn_cir_prf WHERE is_migrated = 1 UNION ALL
SELECT 'crs_liq_prf', '1', COUNT(*), 11 FROM crsdb2.informix.crs_liq_prf WHERE is_migrated = 1 UNION ALL
SELECT 'crs_ent_doc_lod', '2,3,4', COUNT(*), 12 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated IN (2,3,4) UNION ALL
SELECT 'crs_cpst_cir_prf', '1', COUNT(*), 13 FROM crsdb2.informix.crs_cpst_cir_prf WHERE is_migrated = 1 UNION ALL
SELECT 'crs_cpex_cir_prf', '1', COUNT(*), 14 FROM crsdb2.informix.crs_cpex_cir_prf WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_upc', '1', COUNT(*), 15 FROM crsdb2.informix.roc_cir_upc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_upc_cptr', '1', COUNT(*), 16 FROM crsdb2.informix.roc_cir_upc_cptr WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_upc_cpst', '1', COUNT(*), 17 FROM crsdb2.informix.roc_cir_upc_cpst WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_upc_cpex', '1', COUNT(*), 18 FROM crsdb2.informix.roc_cir_upc_cpex WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_reg_aufi', '1', COUNT(*), 19 FROM crsdb2.informix.roc_cir_reg_aufi WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_aufi_brnc', '1', COUNT(*), 20 FROM crsdb2.informix.roc_cir_aufi_brnc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noap', '1', COUNT(*), 21 FROM crsdb2.informix.roc_cir_noap WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noap_jap', '1', COUNT(*), 22 FROM crsdb2.informix.roc_cir_noap_jap WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noap_sps', '1', COUNT(*), 23 FROM crsdb2.informix.roc_cir_noap_sps WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noap_qlf', '1', COUNT(*), 24 FROM crsdb2.informix.roc_cir_noap_qlf WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noal', '1', COUNT(*), 25 FROM crsdb2.informix.roc_cir_noal WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_noal_jap', '1', COUNT(*), 26 FROM crsdb2.informix.roc_cir_noal_jap WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_cpc_app', '1', COUNT(*), 27 FROM crsdb2.informix.roc_cir_cpc_app WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_cpc_ren', '1', COUNT(*), 28 FROM crsdb2.informix.roc_cir_cpc_ren WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_cpc_ren_cpe', '1', COUNT(*), 29 FROM crsdb2.informix.roc_cir_cpc_ren_cpe WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_clc_app', '1', COUNT(*), 30 FROM crsdb2.informix.roc_cir_clc_app WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_clc_app_det', '1', COUNT(*), 31 FROM crsdb2.informix.roc_cir_clc_app_det WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_clc_ren', '1', COUNT(*), 32 FROM crsdb2.informix.roc_cir_clc_ren WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_clc_ren_cpe', '1', COUNT(*), 33 FROM crsdb2.informix.roc_cir_clc_ren_cpe WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cir_mas_cs', '1', COUNT(*), 34 FROM crsdb2.informix.roc_cir_mas_cs WHERE is_migrated = 1 UNION ALL
SELECT 'crs_auditor_prf', '1', COUNT(*), 35 FROM crsdb2.informix.crs_auditor_prf WHERE is_migrated = 1
ORDER BY SortOrder;


--[CIU] Corporate Information Update
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '25' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 25 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '25' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 25 UNION ALL
SELECT 'crs_submission' AS TableName, '25' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 25 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '25' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 25 UNION ALL
SELECT 'crs_ciu' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_ciu WHERE is_migrated = 12 UNION ALL
SELECT 'roc_ciu' AS TableName, '12' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_ciu WHERE is_migrated = 12 UNION ALL
SELECT 'roc_ciu_com_dets' AS TableName, '5' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_ciu_com_dets WHERE is_migrated = 5 UNION ALL
SELECT 'roc_ciu_bizcode' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_ciu_bizcode WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_naofbiz' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.roc_ciu_naofbiz WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_addr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.roc_ciu_addr WHERE is_migrated = 1 UNION ALL
SELECT 'tbadd_m_address' AS TableName, '31,32,33,34,35' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.tbadd_m_address WHERE is_migrated IN (31,32,33,34,35) UNION ALL
SELECT 'roc_ciu_addr_typ' AS TableName, '1,2' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.roc_ciu_addr_typ WHERE is_migrated IN (1,2) UNION ALL
SELECT 'roc_ciu_branch' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 13 AS SortOrder FROM crsdb2.informix.roc_ciu_branch WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_personal' AS TableName, '5' AS IsMigrated, COUNT(*) AS TotalRows, 14 AS SortOrder FROM crsdb2.informix.roc_ciu_personal WHERE is_migrated = 5 UNION ALL
SELECT 'roc_ciu_dr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 15 AS SortOrder FROM crsdb2.informix.roc_ciu_dr WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_mgr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 16 AS SortOrder FROM crsdb2.informix.roc_ciu_mgr WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_sec' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 17 AS SortOrder FROM crsdb2.informix.roc_ciu_sec WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_dr_alt' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 18 AS SortOrder FROM crsdb2.informix.roc_ciu_dr_alt WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_shldr' AS TableName, '5' AS IsMigrated, COUNT(*) AS TotalRows, 19 AS SortOrder FROM crsdb2.informix.roc_ciu_shldr WHERE is_migrated = 5 UNION ALL
SELECT 'roc_ciu_sh_dtls' AS TableName, '5' AS IsMigrated, COUNT(*) AS TotalRows, 20 AS SortOrder FROM crsdb2.informix.roc_ciu_sh_dtls WHERE is_migrated = 5 UNION ALL
SELECT 'roc_ciu_shc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 21 AS SortOrder FROM crsdb2.informix.roc_ciu_shc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_type' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 22 AS SortOrder FROM crsdb2.informix.roc_ciu_type WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_mas_trsc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 23 AS SortOrder FROM crsdb2.informix.roc_ciu_mas_trsc WHERE is_migrated = 1
ORDER BY SortOrder;

--[CRC] Receivership of Company
SELECT 'crs_submission' AS TableName, '31' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 31 UNION ALL
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '31' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 31 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '31' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 31 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '31' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 31 UNION ALL
SELECT 'crs_crc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_crc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_crc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_comp_det' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_crc_comp_det WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_sig' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_crc_sig WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_app_prtc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.roc_crc_app_prtc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_soa' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.roc_crc_soa WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_account' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.roc_crc_account WHERE is_migrated = 1 UNION ALL
SELECT 'roc_crc_rcvr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.roc_crc_rcvr WHERE is_migrated = 1
ORDER BY SortOrder;


--[CA] Corporate Administration
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '16' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 16 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '16', COUNT(*), 2 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 16 UNION ALL
SELECT 'crs_submission', '16', COUNT(*), 3 FROM crsdb2.informix.crs_submission WHERE is_migrated = 16 UNION ALL
SELECT 'crs_ent_doc_lod', '16', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 16 UNION ALL
SELECT 'crs_ca', '1', COUNT(*), 5 FROM crsdb2.informix.crs_ca WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ca', '1', COUNT(*), 6 FROM crsdb2.informix.roc_ca WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ca_comp_dets', '1', COUNT(*), 7 FROM crsdb2.informix.roc_ca_comp_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ca_comp_addr', '1', COUNT(*), 8 FROM crsdb2.informix.roc_ca_comp_addr WHERE is_migrated = 1
ORDER BY SortOrder;


--[EOT] Extension of Time
SELECT 'tbwfr_m_workflowsubmission', '14', COUNT(*), 1 FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 14 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '14', COUNT(*), 2 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 14 UNION ALL
SELECT 'crs_submission', '14', COUNT(*), 3 FROM crsdb2.informix.crs_submission WHERE is_migrated = 14 UNION ALL
SELECT 'crs_ent_doc_lod', '14', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 14 UNION ALL
SELECT 'crs_eot', '1', COUNT(*), 5 FROM crsdb2.informix.crs_eot WHERE is_migrated = 1 UNION ALL
SELECT 'crs_eot_ent_det', '1', COUNT(*), 6 FROM crsdb2.informix.crs_eot_ent_det WHERE is_migrated = 1 UNION ALL
SELECT 'crs_eot_app_det', '1', COUNT(*), 7 FROM crsdb2.informix.crs_eot_app_det WHERE is_migrated = 1 UNION ALL
SELECT 'crs_eot_cor_info', '1', COUNT(*), 8 FROM crsdb2.informix.crs_eot_cor_info WHERE is_migrated = 1 UNION ALL
SELECT 'crs_eot_supp_doc', '1', COUNT(*), 9 FROM crsdb2.informix.crs_eot_supp_doc WHERE is_migrated = 1 UNION ALL
SELECT 'crs_eot_decl', '1', COUNT(*), 10 FROM crsdb2.informix.crs_eot_decl WHERE is_migrated = 1
ORDER BY SortOrder;


--[AMC] Insolvency - Asset Management
SELECT 'crs_submission', '15', COUNT(*), 1 FROM crsdb2.informix.crs_submission WHERE is_migrated = 15 UNION ALL
SELECT 'tbwfr_m_workflowsubmission', '15', COUNT(*), 2 FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 15 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '15', COUNT(*), 3 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 15 UNION ALL
SELECT 'crs_ent_doc_lod', '15', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 15 UNION ALL
SELECT 'crs_amc', '1', COUNT(*), 5 FROM crsdb2.informix.crs_amc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_amc', '1', COUNT(*), 6 FROM crsdb2.informix.roc_amc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_amc_aplct_indv', '1', COUNT(*), 7 FROM crsdb2.informix.roc_amc_aplct_indv WHERE is_migrated = 1 UNION ALL
SELECT 'roc_amc_aplct_comp', '1', COUNT(*), 8 FROM crsdb2.informix.roc_amc_aplct_comp WHERE is_migrated = 1 UNION ALL
SELECT 'roc_amc_aplct_asst', '1', COUNT(*), 9 FROM crsdb2.informix.roc_amc_aplct_asst WHERE is_migrated = 1 UNION ALL
SELECT 'roc_amc_comp_dets', '1', COUNT(*), 10 FROM crsdb2.informix.roc_amc_comp_dets WHERE is_migrated = 1
ORDER BY SortOrder;


--[CCVA] Corporate Voluntary Arrangement
SELECT 'tbwfr_m_workflowsubmission', '17', COUNT(*), 1 FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 17 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus', '17', COUNT(*), 2 FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 17 UNION ALL
SELECT 'crs_submission', '17', COUNT(*), 3 FROM crsdb2.informix.crs_submission WHERE is_migrated = 17 UNION ALL
SELECT 'crs_ent_doc_lod', '17', COUNT(*), 4 FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 17 UNION ALL
SELECT 'crs_ccva', '1', COUNT(*), 5 FROM crsdb2.informix.crs_ccva WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_info', '1', COUNT(*), 6 FROM crsdb2.informix.roc_ccva_info WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva', '1', COUNT(*), 7 FROM crsdb2.informix.roc_ccva WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_comp_dets', '1', COUNT(*), 8 FROM crsdb2.informix.roc_ccva_comp_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_comp_ofc', '1', COUNT(*), 9 FROM crsdb2.informix.roc_ccva_comp_ofc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_mt', '1', COUNT(*), 10 FROM crsdb2.informix.roc_ccva_mt WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_lod_dets', '1', COUNT(*), 11 FROM crsdb2.informix.roc_ccva_lod_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ccva_nominee', '1', COUNT(*), 12 FROM crsdb2.informix.roc_ccva_nominee WHERE is_migrated = 1
ORDER BY SortOrder;


--[CJM] Insolvency - Judicial Management
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '24' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 24 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '24' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 24 UNION ALL
SELECT 'crs_submission' AS TableName, '24' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 24 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '24' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 24 UNION ALL
SELECT 'crs_cjm' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_cjm WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_app_info' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_cjm_app_info WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_cjm WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_comp_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_cjm_comp_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_comp_ofc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.roc_cjm_comp_ofc WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_lod_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.roc_cjm_lod_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_aplct_typ' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.roc_cjm_aplct_typ WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cjm_jmmd' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.roc_cjm_jmmd WHERE is_migrated = 1
ORDER BY SortOrder;


--Beneficial Ownership (eBOS)
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 28 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 28 UNION ALL
SELECT 'crs_submission' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 28 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 28 UNION ALL
SELECT 'crs_ciu' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_ciu WHERE is_migrated = 28 UNION ALL
SELECT 'roc_ciu' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_ciu WHERE is_migrated = 28 UNION ALL
SELECT 'roc_ciu_bnf_ows' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_ciu_bnf_ows WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_personal' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_ciu_personal WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_bnf_joint' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.roc_ciu_bnf_joint WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_bnf_typ' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.roc_ciu_bnf_typ WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciu_bnf_crta' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.roc_ciu_bnf_crta WHERE is_migrated = 1 UNION ALL
SELECT 'crs_ent_bo_typ_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.crs_ent_bo_typ_dets WHERE is_migrated = 1 UNION ALL
SELECT 'crs_doc_sub' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 13 AS SortOrder FROM crsdb2.informix.crs_doc_sub WHERE is_migrated = 28 UNION ALL
SELECT 'tbdoc_m_document' AS TableName, '28' AS IsMigrated, COUNT(*) AS TotalRows, 14 AS SortOrder FROM crsdb2.informix.tbdoc_m_document WHERE is_migrated = 28
ORDER BY SortOrder;


--[CSO] Compliance Strike Off
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '26' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 26 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '26' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 26 UNION ALL
SELECT 'crs_submission' AS TableName, '26' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 26 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '26' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 26 UNION ALL
SELECT 'crs_cso' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_cso WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cso' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_cso WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cso_app_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_cso_app_dets WHERE is_migrated = 1 UNION ALL
SELECT 'roc_cso_comp_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_cso_comp_dets WHERE is_migrated = 1
ORDER BY SortOrder;


--[CISO] Compliance Initiate Striking Off
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '27' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 27 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '27' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 27 UNION ALL
SELECT 'crs_submission' AS TableName, '27' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 27 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '27' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 27 UNION ALL
SELECT 'crs_ciso' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_ciso WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciso' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.roc_ciso WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciso_app_so' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.roc_ciso_app_so WHERE is_migrated = 1 UNION ALL
SELECT 'roc_ciso_comp_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.roc_ciso_comp_dets WHERE is_migrated = 1
ORDER BY SortOrder;


--[CWU] Winding Up
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '32' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 32 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '32' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 32 UNION ALL
SELECT 'crs_submission' AS TableName, '32' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 32 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '32' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 32 UNION ALL
SELECT 'crs_cwu' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.crs_cwu WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_ent_info' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.cwu_ent_info WHERE is_migrated = 1 UNION ALL
SELECT 'tbadd_m_address' AS TableName, '37' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.tbadd_m_address WHERE is_migrated = 37 UNION ALL
SELECT 'tbadd_m_address' AS TableName, '39' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.tbadd_m_address WHERE is_migrated = 39 UNION ALL
SELECT 'crs_ent_ofc_add' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.crs_ent_ofc_add WHERE is_migrated = 1 UNION ALL
SELECT 'crs_ent_ofc_add' AS TableName, '2' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.crs_ent_ofc_add WHERE is_migrated = 2 UNION ALL
SELECT 'cwu_ent_ofc_info' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.cwu_ent_ofc_info WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_trans' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.cwu_trans WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_app_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 13 AS SortOrder FROM crsdb2.informix.cwu_app_dets WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_cord' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 14 AS SortOrder FROM crsdb2.informix.cwu_cord WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_cord_det' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 15 AS SortOrder FROM crsdb2.informix.cwu_cord_det WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_not_chg' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 16 AS SortOrder FROM crsdb2.informix.cwu_not_chg WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_ptn_lod' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 17 AS SortOrder FROM crsdb2.informix.cwu_ptn_lod WHERE is_migrated = 1 UNION ALL
SELECT 'cwu_ptn_dets' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 18 AS SortOrder FROM crsdb2.informix.cwu_ptn_dets WHERE is_migrated = 1
ORDER BY SortOrder;


--[CM] Compound
SELECT 'tbwfr_m_workflowsubmission' AS TableName, '11' AS IsMigrated, COUNT(*) AS TotalRows, 1 AS SortOrder FROM crsdb2.informix.tbwfr_m_workflowsubmission WHERE is_migrated = 11 UNION ALL
SELECT 'tbwfr_t_workflowsubmissionstatus' AS TableName, '11' AS IsMigrated, COUNT(*) AS TotalRows, 2 AS SortOrder FROM crsdb2.informix.tbwfr_t_workflowsubmissionstatus WHERE is_migrated = 11 UNION ALL
SELECT 'crs_submission' AS TableName, '11' AS IsMigrated, COUNT(*) AS TotalRows, 3 AS SortOrder FROM crsdb2.informix.crs_submission WHERE is_migrated = 11 UNION ALL
SELECT 'crs_ent_doc_lod' AS TableName, '11' AS IsMigrated, COUNT(*) AS TotalRows, 4 AS SortOrder FROM crsdb2.informix.crs_ent_doc_lod WHERE is_migrated = 11 UNION ALL
SELECT 'enf_cm_cfg_act_nm' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 5 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_act_nm WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_cfg_div' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 6 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_div WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_cfg_sect' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 7 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_sect WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_cfg_dsc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 8 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_dsc WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_cfg_sect_doc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 9 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_sect_doc WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_cfg_compd' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 10 AS SortOrder FROM crsdb2.informix.enf_cm_cfg_compd WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_compd' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 11 AS SortOrder FROM crsdb2.informix.enf_cm_compd WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_appl' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 12 AS SortOrder FROM crsdb2.informix.enf_cm_appl WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_dsc_sect' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 13 AS SortOrder FROM crsdb2.informix.enf_cm_dsc_sect WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_monr' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 14 AS SortOrder FROM crsdb2.informix.enf_cm_monr WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_compd_ofn' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 15 AS SortOrder FROM crsdb2.informix.enf_cm_compd_ofn WHERE is_migrated = 1 UNION ALL
SELECT 'enf_cm_compd_ctc' AS TableName, '1' AS IsMigrated, COUNT(*) AS TotalRows, 16 AS SortOrder FROM crsdb2.informix.enf_cm_compd_ctc WHERE is_migrated = 1
ORDER BY SortOrder;



