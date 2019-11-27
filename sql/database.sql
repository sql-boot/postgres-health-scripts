/*{
  "name": "database",
  "title": "Databases",
  "description": "The list of databases",
  "tags": "ui"
}*/
select datname         /* { "text": "Database" } */
     , size            /* { "text": "Size", "format": "size" } */
     , size_pct        /* { "text": "Size, %" } */
     , stats_age       /* { "text": "Stats Age" } */
     , cache_hit_ratio /* { "text": "Cache effective, %" } */
     , commited        /* { "text": "Committed, %" } */
     , conflicts       /* { "text": "Conflicts", "description": "Number of queries canceled due to conflicts with recovery in this database" } */
     , deadlocks       /* { "text": "Deadlocks", "description": "Number of deadlocks detected in this database" } */
     , temp_files      /* { "text": "Temporary files", "description": "Number of temporary files created by queries in this database" } */
	 , case
         when current_database() = datname then json_build_object('label', schema_count, 'link', 'schema')
       end as tables /* { "text": "Schemas", "sortable": false, "description": "Schemas" } */
  from (select d.datname
             , case
                 when has_database_privilege(d.datname, 'connect') then pg_database_size(d.datname)
                 else null
               end as size
             , case
                 when has_database_privilege(d.datname, 'connect') then
                   round(100 * pg_database_size(d.datname)::numeric / nullif(sum(pg_database_size(d.datname)) over (partition by (d.oid is null)), 0), 2)
                 else null
               end as size_pct
             , (now() - stats_reset)::interval(0)::text as stats_age
             , case
                 when blks_hit + blks_read > 0 then
                   (round(blks_hit * 100::numeric / (blks_hit + blks_read), 2))
                 else null
               end as cache_hit_ratio
             , case
                 when xact_commit + xact_rollback > 0 then
                   (round(xact_commit * 100::numeric / (xact_commit + xact_rollback), 2))
                 else null
               end as commited
             , conflicts
             , deadlocks
             , temp_files
             , datistemplate
             , (select count(1) from  information_schema.schemata) as schema_count
          from pg_catalog.pg_database d
          join pg_stat_database s on s.datid = d.oid) d
 where datistemplate = false
