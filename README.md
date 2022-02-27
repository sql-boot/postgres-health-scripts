[![Build Status](https://travis-ci.org/sql-boot/postgres-health-scripts.svg?branch=master)](https://travis-ci.org/sql-boot/postgres-health-scripts)

Simple [sql-boot](https://github.com/CrocInc/sql-boot) template for PostgreSQL scripts.

## How to use

1. Clone this repo (or click "Use this template" and clone new repo):
```
git clone https://github.com/sql-boot/postgres-health-scripts.git
cd postgres-health-scripts
```

2. Add or edit SQL scripts in `sql` folder (if necessary)

3. Edit properties in application.yml for your database(s)

4. Run with Docker Compose:
```
docker-compose up -d sql-boot
```

5. Or run with Docker:
```
docker build . -t sql-boot-postgres
docker run -v $PWD/sql:/sql-boot/sql \
           -v $PWD/application.yml:/sql-boot/application.yml \
           -t -p 8007:8007 \
           mgramin/sql-boot
```



## How to run Demo

1. Clone this repo:
```
git clone https://github.com/sql-boot/postgres-health-scripts.git
cd postgres-health-scripts
```

2. Run against demo database:
```
docker-compose up -d
```

3. Go to the main page `http://localhost:8007/index.html#/` in your web browser.
Or directly show db tables `http://localhost:8007/index.html#/demodb/table` or database processes `http://localhost:8007/index.html#/demodb/pg_stat_activity` or somthing else.
