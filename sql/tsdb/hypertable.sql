/*{
  "name": "hypertable",
  "title": "Hypertables",
  "description": "Get information about TimescaleDB hypertables",
  "tags": "ui"
}*/
select table_schema   /* { "text": "Schema", "description": "Schema name of the hypertable." } */
     , table_name     /* { "text": "Table", "description": "Table name of the hypertable." } */
     , table_owner    /* { "text": "Owner", "description": "Table owner." } */
     , num_dimensions /* { "text": "Dimensions", "description": "Number of dimensions." } */
     , chunks         /* { "text": "Chunks", "type": "json", "sortable": false } */
     , total_size     /* { "text": "Total size", "format": "size", "description": "Total disk space used by the specified table, including all indexes and TOAST data" } */
     , table_size     /* { "text": "Hypertable size", "format": "size", "description": "Disk space used by hypertable" } */
     , index_size     /* { "text": "Indexes size", "format": "size", "description": "Disk space used by indexes" } */
     , toast_size     /* { "text": "Toast size", "format": "size", "description": "Disk space of toast tables" } */
from (select *
           , (s).total_bytes
           , (s).table_bytes
           , (s).index_bytes
           , (s).toast_bytes
      from (select *
                 , case
                       when num_chunks<>0 then json_build_object('label', num_chunks, 'link', 'chunk/'|| table_schema||'.'||table_name)
              end as chunks
                 , hypertable_relation_size(table_schema || '.' || table_name) as s
            from timescaledb_information.hypertable) q) h
