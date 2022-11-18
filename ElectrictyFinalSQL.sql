USE [ElectrityProjectSql] ;
Select * from nuclear_sources_clean;
Select * from trans_dist_loss;
Select * from urban;
Select * from rural_clean;
Select * from total_clean;
Select * from oil_sources;
Select * from renewable_clean;

---STARTING___

---Removing unwanted rows
DELETE FROM nuclear_sources_clean WHERE country_name = 'not classified';
DELETE FROM trans_dist_loss WHERE country_name = 'not classified';
DELETE FROM urban WHERE country_name = 'not classified';
DELETE FROM rural_clean WHERE country_name = 'not classified';
DELETE FROM total_clean WHERE country_name = 'not classified';
DELETE FROM oil_sources WHERE country_name = 'not classified';
DELETE FROM renewable_clean WHERE country_name = 'not classified';

---Importing the matadata
SELECT * FROM PROJECT_METADATA;

---DELETING THE LAST COLUMN 
ALTER TABLE PROJECT_METADATA 
DROP COLUMN COLUMN6;

--- Joining the metadata
SELECT * FROM nuclear_sources_clean 
INNER JOIN 
project_metadata
ON nuclear_sources_clean.COUNTRY_CODE = PROJECT_METADATA.COUNTRY_CODE;

---(Q1 Comparison of access to electricity post 2000s in different countries)

SELECT COUNTRY_NAME, AVG(_2001 + _2002+ _2003 + _2004 + _2005 + _2006 + _2007 
+ _2008 + _2009 + _2010 + _2011 + _2012 + _2013 + _2014 + _2015 + _2016 + _2017 +
_2018 + _2019 + _2020 + _2021) AS AVG_OF_ELECTRICITY_BY_YEARS FROM total_clean
GROUP BY 
COUNTRY_NAME;

---(Q2 Find one interesting insight present in the data (across all the tables))
create view JOINED_TABLE as
select * from total_clean union
select * from renewable_clean union
select * from rural_clean union
select * from nuclear_sources_clean union
select * from urban union
select * from trans_dist_loss union
select * from oil_sources;

SELECT * FROM JOINED_TABLE;
CREATE VIEW VIEW_NEW AS 
SELECT INDICATOR_NAME, AVG(_2001 + _2002+ _2003 + _2004 + _2005 + _2006 + _2007 
+ _2008 + _2009 + _2010 + _2011 + _2012 + _2013 + _2014 + _2015 + _2016 + _2017 +
_2018 + _2019 + _2020 + _2021) AS INDICATORWISE, COUNT(COUNTRY_NAME) as name_of_country
FROM JOINED_TABLE
GROUP BY 
INDICATOR_NAME;
select * from VIEW_NEW;

select * from view_new 
where INDICATORWISE >=max(indicatorwise)
group by
Indicator_Name;

SELECT INDICATOR_NAME, RANK() OVER (PARTITION BY AVG(INDICATORWISE) 
ORDER BY 
INDICATOR_NAME) FROM VIEW_NEW;

Indicator_Name;
RANK() OVER (
   [PARTITION BY expression, ]
   ORDER BY expression (ASC | DESC) );

SELECT INDICATOR_NAME, COUNT(COUNTRY_NAME) AS NO_OF_COUNTRIES FROM JOINED_TABLE
WHERE AVG(_2001 + _2002+ _2003 + _2004 + _2005 + _2006 + _2007 
+ _2008 + _2009 + _2010 + _2011 + _2012 + _2013 + _2014 + _2015 + _2016 + _2017 +
_2018 + _2019 + _2020 + _2021) >= AVG(JOINED_TABLE)
GROUP BY 
INDICATOR_NAME;

SELECT INDICATOR_NAME, COUNT(COUNTRY_NAME) AS NO_OF_COUNTRIES FROM JOINED_TABLE
GROUP BY 
INDICATOR_NAME
HAVING AVG(_2001 + _2002+ _2003 + _2004 + _2005 + _2006 + _2007 
+ _2008 + _2009 + _2010 + _2011 + _2012 + _2013 + _2014 + _2015 + _2016 + _2017 +
_2018 + _2019 + _2020 + _2021) >= AVG(JOINED_TABLE);

---(Q3 Present a way to compare every country’s performance with respect to 
---world average for every year. As in, if someone wants to check how is the 
---accessibility of electricity in India in 2006 
---as compared to average access of the world to electricity)
select country_name, _2001, avg(_2001) over (partition by indicator_name) as avg_2001, _2002, 
avg(_2002) over (partition by indicator_name) as avg_2002, _2003, 
avg(_2003) over (partition by indicator_name) as avg_2003,_2004, 
avg(_2004) over (partition by indicator_name) as avg_2004,_2005, 
avg(_2005) over (partition by indicator_name) as avg_2005, _2006, 
avg(_2006) over (partition by indicator_name) as avg_2006, _2007, 
avg(_2007) over (partition by indicator_name) as avg_2007, _2008, 
avg(_2008) over (partition by indicator_name) as avg_2008, _2009, 
avg(_2009) over (partition by indicator_name) as avg_2009, _2010, 
avg(_2010) over (partition by indicator_name) as avg_2010, _2011, 
avg(_2011) over (partition by indicator_name) as avg_2011, _2012, 
avg(_2012) over (partition by indicator_name) as avg_2012, _2013, 
avg(_2013) over (partition by indicator_name) as avg_2013, _2014, 
avg(_2014) over (partition by indicator_name) as avg_2014, _2015, 
avg(_2015) over (partition by indicator_name) as avg_2015, _2016, 
avg(_2016) over (partition by indicator_name) as avg_2016, _2017, 
avg(_2017) over (partition by indicator_name) as avg_2017, _2018, 
avg(_2018) over (partition by indicator_name) as avg_2018, _2019, 
avg(_2019) over (partition by indicator_name) as avg_2019, _2020, 
avg(_2020) over (partition by indicator_name) as avg_2020, _2021, 
avg(_2021) over (partition by indicator_name) as avg_2021
from total_CLEAN;



---(Q4 A chart to depict the increase in count of country with greater
---than 75% electricity access in rural areas across different year.
---For example, what was the count of countries having ≥75% rural electricity 
---access in 2000 as compared to 2010.)
SELECT COUNTRY_NAME,_2001 as sum_2001, _2002 as sum_2002,
_2003 as sum_2003,_2004 as sum_2004,_2005 as sum_2005,
_2006 as sum_2006,_2007 as sum_2007,_2008 as sum_2008,
_2009 as sum_2009,_2010 as sum_2010,_2011 as sum_2011,
_2012 as sum_2012, _2013 as sum_2013,_2014 as sum_2014,
_2015 as sum_2015,_2016 as sum_2016,_2017 as sum_2017,
_2018 as sum_2018,_2019 as sum_2019,_2020 as sum_2020,
_2021 as sum_2021  FROM rural_clean;

SELECT COUNTRY_NAME, COUNT(COUNTRY_NAME) FROM rural_clean
WHERE 2000 <= 2010*(75/100)
GROUP BY 
Country_Name;


---(Q5 Define a way/KPI to present the evolution of nuclear power presence 
---grouped by Region and
---IncomeGroup. How was the nuclear power generation
---in the region of Europe & Central Asia as compared
---to Sub-Saharan Africa.)
create view kpi as
select a.*,b.incomegroup,b.region from nuclear_sources_clean as a inner join
PROJECT_metadata as b on a.country_code = b.country_code;
select * from kpi
select Region,incomegroup,sum(_2001) as sum_2001 ,sum(_2002) as sum_2002,
sum(_2003) as sum_2003,sum(_2004) as sum_2004,sum(_2005) as sum_2005,
sum(_2006) as sum_2006, sum(_2007) as sum_2007,sum(_2008) as sum_2008,
sum(_2009) as sum_2009,sum(_2010) as sum_2010,sum(_2011) as sum_2011,
sum(_2012) as sum_2012,sum(_2013) as sum_2013,sum(_2014) as sum_2014,
sum(_2015) as sum_2015,sum(_2016) as sum_2016,sum(_2017) as sum_2017,
sum(_2018) as sum_2018,sum(_2019) as sum_2019,sum(_2020) as sum_2020,
sum(_2021) as sum_2021 from kpi 
group by region , incomegroup;

---(Q6 A chart to present the production of electricity across
---different sources (nuclear, oil, etc.) as a function of time)
create view sources as 
select * from nuclear_sources_clean union
select * from oil_sources union
select * from renewable_clean; 

select * from sources;

select Indicator_Name,sum(_2001) as sum_2001 ,sum(_2002) as sum_2002,
sum(_2003) as sum_2003,sum(_2004) as sum_2004,sum(_2005) as sum_2005,
sum(_2006) as sum_2006,sum(_2007) as sum_2007,sum(_2008) as sum_2008,
sum(_2009) as sum_2009,sum(_2010) as sum_2010,sum(_2011) as sum_2011,
sum(_2012) as sum_2012,sum(_2013) as sum_2013,sum(_2014) as sum_2014,
sum(_2015) as sum_2015,sum(_2016) as sum_2016,sum(_2017) as sum_2017,
sum(_2018) as sum_2018,sum(_2019) as sum_2019,sum(_2020) as sum_2020,
sum(_2021) as sum_2021
from sources group by Indicator_Name;



SELECT        A.Country_Name AS Country, A.Country_Code, A.Indicator_Name, A.Indicator_Code, B.region, B.incomegroup, A._2000 AS [2000], A._2001 AS [2001], A._2002 AS [2002], A._2003 AS [2003], A._2004 AS [2004], A._2005 AS [2005], 
                         A._2006 AS [2006], A._2007 AS [2007], A._2008 AS [2008], A._2009 AS [2009], A._2010 AS [2010], A._2011 AS [2011], A._2012 AS [2012], A._2013 AS [2013], A._2014 AS [2014], A._2015 AS [2015], A._2016 AS [2016], 
                         A._2017 AS [2017], A._2018 AS [2018], A._2019 AS [2019], A._2020 AS [2020], A._2021 AS [2021]
FROM            dbo.JOINED_TABLE AS A INNER JOIN
                         dbo.kpi AS B ON A.Country_Code = B.Country_Code










