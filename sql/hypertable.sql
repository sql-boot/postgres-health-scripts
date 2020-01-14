/*{
  "name": "hypertable",
  "title": "Hypertables",
  "description": "Get information about TimescaleDB hypertables",
  "tags": "ui"
}*/
with
    ht_size as (
        select ht.id
             , ht.schema_name as table_schema
             , ht.table_name
             , t.tableowner as table_owner
             , ht.num_dimensions
             , (select count(1) as count
                from _timescaledb_catalog.chunk ch
                where ch.hypertable_id = ht.id) as num_chunks
             , bsize.table_bytes
             , bsize.index_bytes
             , bsize.toast_bytes
             , bsize.total_bytes
        from _timescaledb_catalog.hypertable ht
                 left join pg_tables t on ht.table_name = t.tablename and ht.schema_name = t.schemaname
                 left join lateral hypertable_relation_size(
                case
                    when has_schema_privilege(ht.schema_name::text, 'USAGE'::text) then format('%I.%I'::text, ht.schema_name, ht.table_name)
                    else null::text
                    end::regclass) bsize(table_bytes, index_bytes, toast_bytes, total_bytes) on true),
    compht_size as (
        select srcht.id
             ,sum(map.compressed_heap_size) as heap_bytes
             , sum(map.compressed_index_size) as index_bytes
             , sum(map.compressed_toast_size) as toast_bytes
             , sum(map.compressed_heap_size) + sum(map.compressed_toast_size) + sum(map.compressed_index_size) as total_bytes
        from _timescaledb_catalog.chunk srcch
           , _timescaledb_catalog.compression_chunk_size map
           , _timescaledb_catalog.hypertable srcht
        where map.chunk_id = srcch.id and srcht.id = srcch.hypertable_id
        group by srcht.id)
select hts.table_schema   /* { "text": "Schema", "description": "Schema name of the hypertable." } */
     , hts.table_name     /* { "text": "Table", "description": "Table name of the hypertable." } */
     , hts.table_owner    /* { "text": "Owner", "description": "Table owner." } */
     , hts.num_dimensions /* { "text": "Dimensions", "description": "Number of dimensions." } */
     , case when hts.num_chunks<>0 then json_build_object('label', hts.num_chunks, 'link', 'chunk/'||hts.table_schema||'.'||table_name) end as chunks /* { "text": "Chunks", "type": "json", "sortable": false } */
     , coalesce(hts.total_bytes::numeric + compht_size.total_bytes, hts.total_bytes::numeric) as total_size /* { "text": "Total size", "format": "size", "description": "Total disk space used by the specified table, including all indexes and TOAST data" } */
     , coalesce(hts.table_bytes::numeric + compht_size.heap_bytes, hts.table_bytes::numeric) as table_size  /* { "text": "Hypertable size", "format": "size", "description": "Disk space used by hypertable" } */
     , coalesce(hts.index_bytes::numeric + compht_size.index_bytes, hts.index_bytes::numeric, compht_size.index_bytes) as index_size /* { "text": "Indexes size", "format": "size", "description": "Disk space used by indexes" } */
     , coalesce(hts.toast_bytes::numeric + compht_size.toast_bytes, hts.toast_bytes::numeric, compht_size.toast_bytes) as toast_size /* { "text": "Toast size", "format": "size", "description": "Disk space of toast tables" } */
  from ht_size hts
  left join compht_size on hts.id = compht_size.id
