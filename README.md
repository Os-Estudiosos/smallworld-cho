# smallworld-cho
Informational Modeling Subject small world project

# Configuring your workspace
```bash
git clone https://github.com/Os-Estudiosos/smallworld-cho.git
or
git clone git@github.com:Os-Estudiosos/smallworld-cho.git
```
```bash
cd smallword-cho
python -m venv venv
source ./venv/Scripts/activate
python.exe -m pip install --upgrade pip
pip install -r requirements.txt
```

Create your database and a user with all priveliges to this database:
```sql
CREATE USER <user> WITH PASSWORD <password>;
CREATE DATABASE cho OWNER <user>;
GRANT ALL PRIVILEGES ON DATABASE cho TO <user>;
CREATE SCHEMA cho AUTHORIZATION <user>;
SET search_path TO cho;
```

After, create a file named **.env** with this content:
```bash
DB_USER = <user>
DB_HOST = <host>
DB_PASSWORD = <password>
```

# Execution order
- sql/DDL_CHO.sql
- sql/DDL_DW_CHO.sql
- main.py (DML)
- sql/ETL_CHO_carga_inicial.sql
- sql/ETL_CHO_incremental.sql
- sql/GENERATE_CSV.sql
- sql/DROP_TABLES_DW_CHO.sql (optional)
- sql/DROP_TABLES_CHO.sql (optional)