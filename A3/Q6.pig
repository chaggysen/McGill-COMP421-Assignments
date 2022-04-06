popcsv = LOAD '/data/pop.csv' USING PigStorage(',') AS (country:CHARARRAY, population:INT);

highpop = FILTER popcsv BY  population > 100000;

vdatacsv = LOAD '/data/vaccination-data.csv' USING PigStorage(',') AS (country:CHARARRAY, iso3:CHARARRAY, who_region:CHARARRAY, persons_fully_vaccinated:INT);

vmetacsv = LOAD '/data/vaccination-metadata.csv' USING PigStorage(',') AS (iso3:CHARARRAY, vaccine_name:CHARARRAY, product_name:CHARARRAY, company_name:CHARARRAY);

highpop_vdatacsv_join = JOIN highpop BY country, vdatacsv BY country;

int_data = FOREACH highpop_vdatacsv_join GENERATE ($0),($1),((float)($5)/((float)($1)*1000))*100, ($3) AS iso3;

vmeta_grouped = GROUP vmetacsv BY iso3;

DESCRIBE vmeta_grouped;

vaccine_count_by_country = FOREACH vmeta_grouped GENERATE ($0) AS iso3, COUNT($1);

int_output = JOIN int_data by iso3, vaccine_count_by_country by iso3;
 
uo_output = FOREACH int_output GENERATE ($0), ($1) AS population, ($2) AS vpercentage, ($5) AS nbvbrand;

ordered_output = ORDER uo_output BY population DESC;

DUMP ordered_output;
