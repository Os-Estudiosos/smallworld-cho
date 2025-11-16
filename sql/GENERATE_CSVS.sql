\a
\pset fieldsep ','
\o receitafato.csv
select * from dw_cho.ReceitaFato;

\a
\pset fieldsep ','
\o clientedimension.csv
select * from dw_cho.ClienteDimension;

\a
\pset fieldsep ','
\o filialdimension.csv
select * from dw_cho.FilialDimension;

\a
\pset fieldsep ','
\o itemdimension.csv
select * from dw_cho.ItemMenuDimension;

\a
\pset fieldsep ','
\o calendardimension.csv
select * from dw_cho.CalendarDimension;
