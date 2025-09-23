# smallworld-cho
Informational Modeling Subject small world project

# Execution order
Create your database and a user with all priveliges to this database:
```sql
CREATE USER <user> WITH PASSWORD <password>;
CREATE DATABASE cho OWNER <user>;
GRANT ALL PRIVILEGES ON DATABASE cho TO <user>;
CREATE SCHEMA cho AUTHORIZATION <user>;
SET search_path TO cho;
```

After, fill the blanks with your user's information in the file config/database.py.

Finally, execute this files in the folowing order:
- sql/DDL_CHO.sql
- sql/DDL_DW_CHO.sql
- main.py (DML)
- sql/ETL_CHO_carga_inicial.sql
- sql/ETL_CHO_incremental.sql
- sql/GENERATE_CSV.sql
- sql/DROP_TABLES_DW_CHO.sql (optional)
- sql/DROP_TABLES_CHO.sql (optional)