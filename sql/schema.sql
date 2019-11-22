/*
{
  "name": "schema",
  "title": "Schemas",
  "description": "All schemas in the current database",
  "tags": "ui",

  "icon": "pets",
  "icon_class": "blue white--text"
}
*/
select schema_name  /* { "label": "Schema", "description": "Name of the schema" } */
     , schema_owner /* { "label": "Owner", "description": "Name of the owner of the schema" } */
     , case
         when tables_count>0 then json_build_object('label', tables_count, 'link', 'table/'||schema_name) 
       end as tables /* { "label": "Tables", "sortable": false, "description": "The number of tables in the scheme" } */
     , case
         when views_count>0 then json_build_object('label', views_count, 'link', 'view/'||schema_name)
       end as views /* { "label": "Views", "sortable": false, "description": "The number of view in the scheme" } */
  from (select *
             , (select count(1)
                  from information_schema.tables
                 where table_schema = schema_name
                   and table_type = 'BASE TABLE') as tables_count
             , (select count(1)
                  from information_schema.tables
                 where table_schema = schema_name
                   and table_type = 'VIEW') as views_count
          from information_schema.schemata) q

