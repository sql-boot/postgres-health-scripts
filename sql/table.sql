/*
{
  "name": "table",
  "title": "Tables",
  "description": "The list of tables",
  "tags": "ui",

  "icon": "table_chart",
  "icon_class": "blue white--text"
}
*/
select schema_name      /* { "text": "Schema", "description": "" } */
     , table_name       /* { "text": "Table", "description": "" } */
     , columns          /* { "text": "Columns", "sortable": false } */
     , indexes          /* { "text": "Indexes", "sortable": false } */
     , row_estimate     /* { "text": "Rows", "description": "Estimate rows count" } */
     , total_bytes      /* { "text": "Total size", "format": "size", "description": "Total size, include index and TOAST" } */
     , total_percent    /* { "text": "Total size, %", "description": "Total size %, include index and TOAST" } */
     , table_bytes      /* { "text": "Table size", "format": "size", "visible": false, "description": "" } */
     , table_percent    /* { "text": "Table size, %", "visible": false, "description": "" } */
     , index_bytes      /* { "text": "Index size", "format": "size", "visible": false, "description": "" } */
     , index_percent    /* { "text": "Index size, %", "visible": false, "description": "" } */
     , toast_bytes      /* { "text": "TOAST size", "format": "size", "visible": false, "description": "" } */
     , toast_percent    /* { "text": "TOAST size, %", "visible": false, "description": "" } */
     , heap_blks_read	  /* { "text": "Blocks read", "description": "Number of disk blocks read from this table" } */
     , heap_blks_hit	  /* { "text": "Buffer hits", "description": "Number of buffer hits in this table" } */
  from (select schema_name
             , table_name
             , case when indexes_count<>0 then json_build_object('label', indexes_count, 'link', 'index/'||schema_name||'.'||table_name) end as indexes
             , case when columns_count<>0 then json_build_object('label', columns_count, 'link', 'column/'||schema_name||'.'||table_name) end as columns
             , row_estimate
             , total_bytes as total_bytes
             , round(100 * total_bytes::numeric / nullif(sum(total_bytes) over (), 0), 2) as total_percent
             , table_bytes as table_bytes
             , round(100 * table_bytes::numeric / nullif(sum(table_bytes) over (), 0), 2) as table_percent
             , index_bytes as index_bytes
             , round(100 * index_bytes::numeric / nullif(sum(index_bytes) over (), 0), 2) as index_percent
             , toast_bytes as toast_bytes
             , round(100 * toast_bytes::numeric / nullif(sum(toast_bytes) over (), 0), 2) as toast_percent
             , heap_blks_read
             , heap_blks_hit
          from (select c.oid
                     , (select spcname from pg_tablespace where oid = reltablespace) as tblspace
                     , n.nspname as schema_name
                     , c.relname as table_name
                     , c.reltuples as row_estimate
                     , pg_total_relation_size(c.oid) as total_bytes
                     , pg_total_relation_size(c.oid) - pg_indexes_size(c.oid) - coalesce(pg_total_relation_size(reltoastrelid), 0) as table_bytes
                     , pg_indexes_size(c.oid) as index_bytes
                     , pg_total_relation_size(reltoastrelid) as toast_bytes
                     , (select count(1) from pg_indexes i where i.schemaname=nspname and i.tablename=c.relname) as indexes_count
                     , (select count(1) from information_schema.columns col where col.table_schema=n.nspname and col.table_name=c.relname) as columns_count
                     , io.heap_blks_read
                     , io.heap_blks_hit
                  from pg_class c
                  left join pg_namespace n on n.oid = c.relnamespace
                  left join pg_statio_all_tables io on io.schemaname = n.nspname and io.relname = c.relname
                 where relkind = 'r') q) q
