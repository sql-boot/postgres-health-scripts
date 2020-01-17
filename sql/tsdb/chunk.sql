/*{
  "name": "chunk",
  "title": "Chunks",
  "description": "Get information about TimescaleDB chunks",
  "tags": "ui"
}*/
select schema_name             /* { "text": "Schema", "description": "Schema name of the hypertable." } */
     , table_name              /* { "text": "Table", "description": "Table name of the hypertable." } */
     , chunk_table_schema_name /* { "text": "Chunk schema", "description": "Schema name of the current chunk." } */
     , chunk_table_name        /* { "text": "Chunk table", "description": "Table name of the current chunk." } */
     , total_bytes             /* { "text": "Total size", "format": "size", "description": "Total disk space used by the specified table, including all indexes and TOAST data" } */
     , index_bytes             /* { "text": "Indexes size", "format": "size", "description": "Disk space used by indexes" } */
     , toast_bytes             /* { "text": "Toast size", "format": "size", "description": "Disk space of toast tables" } */
     , range_start             /* { "text": "Range start", "type": "timestamptz", "description": "Range start" } */
     , range_end               /* { "text": "Range end", "type": "timestamptz", "description": "Range end" } */
  from (select h.schema_name
             , h.table_name
             , c.schema_name as chunk_table_schema_name
             , c.table_name as chunk_table_name
             , pg_total_relation_size(format('%I.%I', c.schema_name, c.table_name)) as total_bytes
             , pg_indexes_size(format('%I.%I', c.schema_name, c.table_name)) as index_bytes
             , pg_total_relation_size(reltoastrelid) as toast_bytes
             , _timescaledb_internal.to_timestamp(ds.range_start) as range_start
             , _timescaledb_internal.to_timestamp(ds.range_end) as range_end
          from _timescaledb_catalog.hypertable h
          join _timescaledb_catalog.chunk c on c.hypertable_id = h.id
          join _timescaledb_catalog.chunk_constraint cc on cc.chunk_id = c.id
          join _timescaledb_catalog.dimension_slice ds on ds.id = cc.dimension_slice_id
          join _timescaledb_catalog.dimension d on d.id = ds.dimension_id
          join pg_class pgc on pgc.relname = c.table_name and pgc.relkind = 'r'
          join pg_namespace pns on pns.oid = pgc.relnamespace and pns.nspname = c.schema_name) c