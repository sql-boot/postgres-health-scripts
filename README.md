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


6. Or run against demo database:
```
docker-compose up -d
```
