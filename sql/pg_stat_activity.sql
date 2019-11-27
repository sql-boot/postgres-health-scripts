/*{
  "name": "pg_stat_activity",
  "title": "Database processes",
  "description": "The pg_stat_activity view will have one row per server process, showing information related to the current activity of that process",
  "tags": "ui"
}*/
select datname           /* { "text": "Database", "description": "Name of the database this backend is connected to" } */
     , pid               /* { "text": "Process ID", "description": "Process ID of this backend" } */
     , usename           /* { "text": "User", "description": "Name of the user logged into this backend" } */
     , application_name  /* { "text": "Application", "description": "Name of the application that is connected to this backend" } */
     , client_addr       /* { "text": "Client IP", "description": "IP address of the client connected to this backend. If this field is null, it indicates either that the client is connected via a Unix socket on the server machine or that this is an internal process such as autovacuum." } */
     , client_hostname   /* { "text": "Client hostname", "description": "Host name of the connected client, as reported by a reverse DNS lookup of client_addr. This field will only be non-null for IP connections, and only when log_hostname is enabled." } */
     , client_port       /* { "text": "Client port", "description": "TCP port number that the client is using for communication with this backend, or -1 if a Unix socket is used" } */
     , backend_start     /* { "text": "Process started", "description": "Time when this process was started. For client backends, this is the time the client connected to the server." } */
     , xact_start        /* { "text": "Transaction started", "description": "Time when this process' current transaction was started, or null if no transaction is active. If the current query is the first of its transaction, this column is equal to the query_start column." } */
     , query_start       /* { "text": "Query started", "description": "Time when the currently active query was started, or if state is not active, when the last query was started" } */
     , state_change      /* { "text": "State changed", "description": "Time when the state was last changed" } */
     , wait_event_type   /* { "text": "Event type", "description": "The type of event for which the backend is waiting, if any; otherwise NULL." } */
     , wait_event        /* { "text": "Wait event", "description": "Wait event name if backend is currently waiting, otherwise NULL." } */
     , state             /* { "text": "State", "description": "Current overall state of this backend." } */
     , backend_xid       /* { "text": "Top-level transaction", "description": "Top-level transaction identifier of this backend, if any." } */
     , backend_xmin      /* { "text": "Oldest transaction", "description": "The current backend's xmin horizon." } */
     , query             /* { "text": "Query", "visible": false, "description": "Text of this backend's most recent query." } */
     , backend_type      /* { "text": "Backend type", "description": "Type of current backend." } */
  from pg_stat_activity
