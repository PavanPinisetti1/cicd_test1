prompt --application/shared_components/security/authentications/oracle_apex_accounts
begin
--   Manifest
--     AUTHENTICATION: Oracle APEX Accounts
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.6'
,p_default_workspace_id=>118462839105031977
,p_default_application_id=>201
,p_default_id_offset=>0
,p_default_owner=>'WKSP_EBS2CLOUD_MIGRATION'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(9330297334792282)
,p_name=>'Oracle APEX Accounts'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>12213172022034
);
wwv_flow_imp.component_end;
end;
/
