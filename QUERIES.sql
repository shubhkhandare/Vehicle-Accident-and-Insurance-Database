---
--1.those owners whose owner’s insurance and vehicle insurance expire in the same year.  
--
SELECT O.*
FROM OWNER_INSURANCE OI JOIN OWNERS O
ON OI.OWNER_ID = O.OWNER_ID
JOIN VEHICLE V
ON O.OWNER_ID = V.OWNER_ID
JOIN VINSURANCE VI
ON V.VEHICLE_ID = VI.VEHICLE_ID
WHERE TO_CHAR(OI.END_DATE,'YYYY') = TO_CHAR(VI.END_DATE,'YYYY');


-------------------------
--2.those owners whose more than 3 vehicles were involved in an accident.  
-----

SELECT O.*
FROM OWNERS O JOIN VEHICLE V 
ON O.OWNER_ID = V.OWNER_ID
JOIN ACCIDENTS A
ON V.VEHICLE_ID = A.VEHICLE_ID
GROUP BY O.OWNER_ID, O.NAME, o.Address, o.Phone, o.License_Number
HAVING COUNT(A.VEHICLE_ID) > 3;

---------------------------------------------------
---3.Display details of those vehicles whose owners died during an accident in the year 2020
SELECT O.*
FROM VEHICLE V JOIN ACCIDENTS A
ON V.VEHICLE_ID = A.VEHICLE_ID
JOIN VICTIMS VI
ON A.ACCIDENT_ID = VI.ACCIDENT_ID
JOIN OWNERS O
ON V.OWNER_ID = O.OWNER_ID
WHERE UPPER(VI.STATUS) = 'DIED'
AND TO_CHAR(A.DATE1,'YYYY') = '2024';
-------------------
UPDATE VICTIMS
SET STATUS = 'Died'
WHERE VICTIM_ID IN (6001,6002,6008);


-----------------------------
--Q.4Display the top 3 cities where the number of victims who died is highest.
----------------------------------------------------

SELECT CITY , DETH_COUNT, RANKING
FROM ( SELECT L.CITY, COUNT(V.VICTIM_ID)AS  DETH_COUNT, 
       DENSE_RANK() OVER ( ORDER BY COUNT(V.VICTIM_ID) DESC ) AS RANKING
      FROM ACCIDENTS A JOIN VICTIMS V
      ON A.ACCIDENT_ID = V.ACCIDENT_ID
      JOIN LOCATIONS1 L
      ON A.LOCATION_ID = L.LOCATION_ID
      WHERE V.STATUS ='Died'
      GROUP BY L.CITY)
WHERE RANKING < = 3;


SELECT * FROM VICTIMS;

-----------------------------------
--Q.5Display the yearly average number of vehicles involved in an accident
--
----------------
SELECT TO_CHAR(A.DATE1,'MON'),
ROUND(AVG(VEHICLE_COUNT),2)
FROM (SELECT A.ACCIDENT_ID, A.DATE1, COUNT(V.VEHICLE_ID) AS VEHICLE_COUNT
        FROM ACCIDENTS A JOIN VEHICLE V
        ON A.VEHICLE_ID = V.VEHICLE_ID
        GROUP BY A.ACCIDENT_ID, A.DATE1
       ) ACCIDENT_VEHICLE_COUNT
GROUP BY TO_CHAR(A.DATE1,'MON') ;      


----- -------------------------------------
--Q6-Write a query to display total owners involved in accidents according to the age groups-
--(under 25, 25-34, 35-44, 45-54, above 55).
------
SET SERVEROUTPUT ON
DECLARE 
AGE NUMBER :=&AGE;
OWNERS NUMBER;
BEGIN
SELECT CASE
        WHEN AGE < 25 
            THEN 'UNDER 25'
        WHEN AGE BETWEEN 25 AND 34
            THEN  '25-34'
        WHEN AGE BETWEEN 35 AND 44
            THEN  '35-44'
        WHEN AGE BETWEEN 45 AND 54
            THEN  '45-54'  
        ELSE 'above 55'  
      END AS GROUPOFAGE,
COUNT(OWNER_ID)

INTO AGE, OWNERS

FROM OWNERS O JOIN VEHICLE V
ON O.OWNER_ID = V.OWNER_ID
JOIN ACCIDENTS A
ON V.VEHICLE_ID = A.VEHICLE_ID
GROUP BY CASE
        WHEN AGE < 25 
            THEN 'UNDER 25'
        WHEN AGE BETWEEN 25 AND 34
            THEN  '2
            5-34'
        WHEN AGE BETWEEN 35 AND 44
            THEN  '35-44'
        WHEN AGE BETWEEN 45 AND 54
            THEN  '45-54'  
        ELSE 'above 55'  
      END
ORDER BY GROUPOFAGE   ;

END;
      
--------------------
--q7Write a query to display details of those vehicles where
--the total number of vehicles is greater than the average number of vehicles involved in accidents.
--------

SELECT V.*
FROM VEHICLE V
JOIN (
    
    SELECT V.VEHICLE_ID, COUNT(A.ACCIDENT_ID) AS TOTAL_VEHICLES
    FROM VEHICLE V
    JOIN ACCIDENTS A ON V.VEHICLE_ID = A.VEHICLE_ID
    GROUP BY V.VEHICLE_ID
) VEH_COUNT 
ON V.VEHICLE_ID = VEH_COUNT.VEHICLE_ID
WHERE VEH_COUNT.TOTAL_VEHICLES > (

    SELECT AVG(TOTAL_VEHICLES)
    FROM (
        SELECT COUNT(A.ACCIDENT_ID) AS TOTAL_VEHICLES
        FROM VEHICLE V
        JOIN ACCIDENTS A ON V.VEHICLE_ID = A.VEHICLE_ID
        GROUP BY V.VEHICLE_ID
    ) AVG_VEH
);


----------------
---Q8Write a query to display the bottom 5 owners by age for each accident they were involved in.

----------
ALTER TABLE OWNERS
ADD AGE NUMBER;
--
SELECT *
FROM (SELECT O.* ,V.VEHICLE_ID,A.ACCIDENT_ID,  DENSE_RANK() OVER (PARTITION BY A.ACCIDENT_ID ORDER BY O.AGE) AS RANKING
        FROM OWNERS O JOIN VEHICLE V
        ON O.OWNER_ID = V.OWNER_ID
        JOIN ACCIDENTS A
        ON V.VEHICLE_ID = A.VEHICLE_ID)
WHERE RANKING < = 5 ;

-------
---Q9Write a query to display the top 3 accidents based on the maximum number of vehicles involved in each accident.
--
WITH TEMP
AS( SELECT A.ACCIDENT_ID, COUNT(V.VEHICLE_ID),
  DENSE_RANK() OVER (ORDER BY COUNT(V.VEHICLE_ID)) RANKING
    FROM VEHICLE V JOIN ACCIDENTS A
    ON V.VEHICLE_ID = A.VEHICLE_ID
    GROUP BY A.ACCIDENT_ID
    )
SELECT *
FROM TEMP
WHERE RANKING <= 3;    

---------
----Q10Write a query to display details of owners who own both trucks and cars
-----
SELECT O.*
FROM OWNERS O JOIN VEHICLE V
ON O.OWNER_ID = V.OWNER_ID
WHERE UPPER(V.VEHICLE_TYPE) = 'CAR'
AND UPPER(V.VEHICLE_TYPE) = 'TRUCK';
----------

