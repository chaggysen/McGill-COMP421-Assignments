--popcsv = LOAD '/data/pop.csv' USING PigStorage(',') AS (country:CHARARRAY, population:INT);

--vdatacsv = LOAD '/data/vaccination-data.csv' USING PigStorage(',') AS (country:CHARARRAY, iso3:CHARARRAY, who_region:CHARARRAY, persons_fully_vaccinated:INT);

vmetacsv = LOAD '/data/vaccination-metadata.csv' USING PigStorage(',') AS (iso3:CHARARRAY, vaccine_name:CHARARRAY, product_name:CHARARRAY, company_name:CHARARRAY);

vaccine_group = GROUP vmetacsv BY company_name;

datas = FOREACH vaccine_group GENERATE ($0), COUNT($1) AS country_count;

order_by_data = ORDER datas BY country_count DESC;

top10 = LIMIT order_by_data 10;
  
DUMP top10;
