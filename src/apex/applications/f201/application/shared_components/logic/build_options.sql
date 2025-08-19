prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 201
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.6'
,p_default_workspace_id=>118462839105031977
,p_default_application_id=>201
,p_default_id_offset=>0
,p_default_owner=>'WKSP_EBS2CLOUD_MIGRATION'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(9329993734792271)
,p_build_option_name=>'Commented Out'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>12213172022034
);
wwv_flow_imp.component_end;
end;
/
