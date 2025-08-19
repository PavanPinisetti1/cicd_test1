prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.6'
,p_default_workspace_id=>118462839105031977
,p_default_application_id=>201
,p_default_id_offset=>0
,p_default_owner=>'WKSP_EBS2CLOUD_MIGRATION'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(9330404222792287)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(9330661355792291)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp.component_end;
end;
/
