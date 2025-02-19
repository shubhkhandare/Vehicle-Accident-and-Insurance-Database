--- OWNERS TABLE--
CREATE TABLE OWNERS(
OWNER_ID NUMBER PRIMARY KEY,
NAME VARCHAR2(50) NOT NULL,
ADDRESS VARCHAR2(100),
PHONE NUMBER(10) UNIQUE,
LICENSE_NUMBER VARCHAR2(30) UNIQUE);


SELECT * FROM owners;


------OWNER INSURANCE

CREATE TABLE OWNER_INSURANCE(
OWNER_INSURANCE_ID NUMBER PRIMARY KEY,
OWNER_ID NUMBER,
START_DATE DATE,
END_DATE DATE,
TYPE VARCHAR(20),

FOREIGN KEY (OWNER_ID) REFERENCES OWNERS(OWNER_ID)
ON DELETE SET NULL
);




-------------------------------

CREATE TABLE VEHICLE(
VEHICLE_ID NUMBER PRIMARY KEY,
VEHICLE_TYPE VARCHAR2(30) ,
LICENSE_PLATE NUMBER NOT NULL UNIQUE,
OWNER_ID NUMBER,
VEHICLE_AGE NUMBER(4,2),
VEHICLE_CONDITION VARCHAR(30),
FOREIGN KEY (OWNER_ID) REFERENCES OWNERS(OWNER_ID)
ON DELETE SET NULL
);



-----------------------------------------------------------------------

CREATE TABLE LOCATIONS1(
LOCATION_ID NUMBER PRIMARY KEY,
CITY VARCHAR2(20),
STATE VARCHAR2(20),
ZIP_CODE  NUMBER(6),
ROAD_TYPE VARCHAR2(30)
);




-------------------------------
CREATE TABLE ACCIDENTS(
ACCIDENT_ID NUMBER PRIMARY KEY,
DATE1 DATE,
TIME TIMESTAMP,
VEHICLE_ID NUMBER,
LOCATION_ID NUMBER,
DESCRIPTIONS VARCHAR(200),
FOREIGN KEY (VEHICLE_ID) REFERENCES VEHICLE(VEHICLE_ID)
ON DELETE SET NULL,
FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS1(LOCATION_ID)
ON DELETE SET NULL
);





--------------------------------
--------------------


CREATE TABLE INJURY(
INJURY_ID NUMBER PRIMARY KEY,
INJURY_TYPE VARCHAR2(30),
SEVERITY VARCHAR2(25),
DESCRIPTIONS VARCHAR2(200));






---------------------------------------

CREATE TABLE VICTIMS(
VICTIM_ID NUMBER PRIMARY KEY,
ACCIDENT_ID NUMBER,
NAME VARCHAR2(30),
AGE NUMBER,
INJURY_ID NUMBER,
STATUS VARCHAR2(30),

FOREIGN KEY (ACCIDENT_ID) REFERENCES ACCIDENTS(ACCIDENT_ID),
FOREIGN KEY (INJURY_ID) REFERENCES INJURY(INJURY_ID)
);


-----------------VEHICLE INSURANCE

CREATE TABLE VINSURANCE(
VI_ID NUMBER PRIMARY KEY,
VEHICLE_ID NUMBER,
TYPE VARCHAR2(30),
START_DATE DATE,
END_DATE DATE
);




-------------------------------------- CF--------
--------
SELECT * FROM VICTIMS;
SELECT * FROM OWNERS;
SELECT * FROM OWNER_INSURANCE;
SELECT * FROM ACCIDENTS;
SELECT * FROM LOCATIONS1;
SELECT * FROM VINSURANCE;
SELECT * FROM VEHICLE;











