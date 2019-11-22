/*{
  "name": "hypertable",
  "title": "Hypertables",
  "description": "Get information about TimescaleDB hypertables",
  "tags": "ui"
}*/
select table_schema	    /* { "label": "Shema", "description": "Schema name of the hypertable." } */
     , table_name	    /* { "label": "Table", "description": "Table name of the hypertable." } */
     , table_owner	    /* { "label": "Owner", "description": "Owner of the hypertable." } */
     , num_dimensions	    /* { "label": "Dimensions", "description": "Number of dimensions." } */
     , num_chunks	    /* { "label": "Chunks", "description": "Number of chunks." } */
     , table_size	    /* { "label": "Hypertable size", "description": "Disk space used by hypertable" } */
     , index_size	    /* { "label": "Indexes size", "description": "Disk space used by indexes" } */
     , toast_size	    /* { "label": "Toast size", "description": "Disk space of toast tables" } */
     , total_size	    /* { "label": "Total size", "description": "Total disk space used by the specified table, including all indexes and TOAST data" } */
  from timescaledb_information.hypertable
