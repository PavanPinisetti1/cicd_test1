prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 201
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.6'
,p_default_workspace_id=>118462839105031977
,p_default_application_id=>201
,p_default_id_offset=>0
,p_default_owner=>'WKSP_EBS2CLOUD_MIGRATION'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(9335957305792436)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
