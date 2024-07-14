CREATE TABLE CoronaVirusDataset(
 Province NVARCHAR(255),
    CountryRegion NVARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT,
    Date NVARCHAR(50),
    Confirmed INT,
    Deaths INT,
    Recovered INT
);

BULK INSERT CoronaVirusDataset
FROM 'F:\My Project\Corona Virus Dataset.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2, -- Skip the header row
    TABLOCK
);

select Top 10 * from CoronaVirusDataset;

SELECT * FROM CoronaVirusDataset;

--Q1. Check for Null/Missing values

SELECT * FROM CoronaVirusDataset
where Province is NULL
or CountryRegion is NULL
or Latitude is NULL
or Longitude is NULL
or Date is NULL
or Confirmed is Null
or Deaths is NULL
or Recovered is NULL;


--Q2.If NULL values are present, update them with zeros for all columns.
--There are no NULL values present.

--Q3.check total number of rows

SELECT COUNT(*) as Total_Records FROM CoronaVirusDataset;

--There are 78386 rows

--Q4.Check what is start_date and end_date

SELECT MIN(Date) as Start_date,
MAX(Date) as End_date 
FROM CoronaVirusDataset;

--Dates are not correctly shown
--Check the format
SELECT TOP 10 Date FROM CoronaVirusDataset;

--Alter the date format
ALTER TABLE CoronaVirusDataset ADD DateConverted DATE;

UPDATE CoronaVirusDataset
SET DateConverted = CONVERT(DATE, Date, 105);


Select * from CoronaVirusDataset;

SELECT MIN(DateConverted) as Start_date,
MAX(DateConverted) as End_date 
FROM CoronaVirusDataset;

--Start_date is 22-01-2020
--End_date is 13-06-2021

-- Q5. Number of month present in dataset
SELECT DATEDIFF(MONTH,MIN(DateConverted),MAX(DateConverted)) +1 as NumberofMonths
FROM CoronaVirusDataset;

--18 months


-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT YEAR(DateConverted) as Year,
MONTH(DateConverted) as Month,
AVG(Confirmed) as AvgConfirmed,
AVG(Deaths) as AvgDeaths,
AVG(Recovered) as AvgRecovered
FROM CoronaVirusDataset
GROUP BY YEAR(DateConverted),MONTH(DateConverted)
ORDER BY Year, Month;

--Q7. Find most frequent value for confirmed, deaths, recovered each month
--SELECT YEAR(DateConverted) as Year,
--MONTH(DateConverted) as Month,
--Confirmed, Deaths, Recovered,
--COUNT(*) as Frequency
--FROM CoronaVirusDataset
--GROUP BY YEAR(DateConverted),MONTH(DateConverted),Confirmed, Deaths, Recovered
--ORDER BY Year,Month,Frequency DESC;

SELECT YEAR(DateConverted) as Year,
MONTH(DateConverted) as Month,
Max(Confirmed) as Most_frequent_confirmed, 
Max(Deaths) as Most_frequent_deaths, 
Max(Recovered) as Most_frequent_recovered
FROM CoronaVirusDataset
GROUP BY MONTH(DateConverted),YEAR(DateConverted)
ORDER BY YEAR(DateConverted),MONTH(DateConverted);

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR(DateConverted) as Year,
MIN(Confirmed) as Minconfirmed,
MIN(Deaths) as Mindeaths,
MIN(Recovered) as Minrecovered
FROM CoronaVirusDataset
GROUP BY YEAR(DateConverted)
ORDER BY Year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(DateConverted) as Year,
MAX(Confirmed) as Maxconfirmed,
MAX(Deaths) as Maxdeaths,
MAX(Recovered) as Maxrecovered
FROM CoronaVirusDataset
GROUP BY YEAR(DateConverted)
ORDER BY Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT YEAR(DateConverted) as Year,
MONTH(DateConverted) as Month,
SUM(Confirmed) as TotalConfirmed,
SUM(Deaths) as Totaldeaths,
SUM(Recovered) as Totalrecovered
FROM CoronaVirusDataset
GROUP BY YEAR(DateConverted),MONTH(DateConverted)
ORDER BY Year,Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT SUM(Confirmed) as TotalConfirmed,
AVG(Confirmed) as Avgconfirmed,
ROUND(VAR(Confirmed),0) as Varianceconfirmed,
ROUND(STDEV(Confirmed),0) as Stdevconfirmed
FROM CoronaVirusDataset;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT YEAR(DateConverted) as Year,
MONTH(DateConverted) as Month,
SUM(Deaths) as Totaldeaths,
AVG(Deaths) as Avgdeaths,
ROUND(VAR(Deaths),0) as variancedeaths,
ROUND(STDEV(Deaths),0) as stdevdeaths
FROM CoronaVirusDataset
GROUP BY YEAR(DateConverted),MONTH(DateConverted)
ORDER BY Year, Month;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
SUM(Recovered) as Totalrecovered,
AVG(Recovered) as Avgrecovered,
ROUND(VAR(Recovered),0) as variancerecovered,
ROUND(STDEV(Recovered),0) as stdevrecovered
FROM CoronaVirusDataset;



-- Q14. Find Country having highest number of the Confirmed case
SELECT TOP 1 CountryRegion, SUM(Confirmed) as Totalconfirmed
FROM CoronaVirusDataset
GROUP BY CountryRegion
ORDER BY Totalconfirmed DESC;

-- Q15. Find Country having lowest number of the death case
SELECT TOP 1 CountryRegion, SUM(Deaths) as Totaldeaths
FROM CoronaVirusDataset
GROUP BY CountryRegion
ORDER BY Totaldeaths ASC;

-- Q16. Find top 5 countries having highest recovered case
SELECT TOP 5 CountryRegion,
SUM(Recovered) as Totalrecovered
FROM CoronaVirusDataset
GROUP BY CountryRegion
ORDER BY Totalrecovered DESC;
