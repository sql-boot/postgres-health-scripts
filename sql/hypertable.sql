/*{
  "name": "hypertable",
  "title": "Hypertables",
  "description": "Get information about TimescaleDB hypertables",
  "tags": "ui"
}*/
select table_schema	    /* { "text": "Shema", "description": "Schema name of the hypertable." } */
     , table_name	    /* { "text": "Table", "description": "Table name of the hypertable." } */
     , table_owner	    /* { "text": "Owner", "description": "Owner of the hypertable." } */
     , num_dimensions	    /* { "text": "Dimensions", "description": "Number of dimensions." } */
     , num_chunks	    /* { "text": "Chunks", "description": "Number of chunks." } */
     , table_size	    /* { "text": "Hypertable size", "description": "Disk space used by hypertable" } */
     , index_size	    /* { "text": "Indexes size", "description": "Disk space used by indexes" } */
     , toast_size	    /* { "text": "Toast size", "description": "Disk space of toast tables" } */
     , total_size	    /* { "text": "Total size", "description": "Total disk space used by the specified table, including all indexes and TOAST data" } */
  from timescaledb_information.hypertable
