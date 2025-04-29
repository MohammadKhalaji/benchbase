-- DDL from the SSB paper:
-- https://www.cs.umb.edu/~poneil/StarSchemaB.PDF

DROP TABLE IF EXISTS DATE CASCADE;

DROP TABLE IF EXISTS CUSTOMER CASCADE;

DROP TABLE IF EXISTS SUPPLIER CASCADE;

DROP TABLE IF EXISTS PART CASCADE;

DROP TABLE IF EXISTS LINEORDER CASCADE;

-- DATE TABLE
CREATE TABLE DATE (
    D_DATEKEY integer NOT NULL, -- eg: 19980101
    D_DATE char(18) NOT NULL, -- eg: December 31, 1997
    D_DAYOFWEEK char(8) NOT NULL, -- values: 7 values: SUNDAY to SATURDAY
    D_MONTH char(9) NOT NULL, -- values: 12 values: JANUARY to DECEMBER
    D_YEAR smallint NOT NULL, -- values: 1992-1998 (7 values)
    D_YEARMONTHNUM smallint NOT NULL, -- format: YYYYMM (eg: 199801) (12 * 7 = 84 values)
    D_YEARMONTH char(7) NOT NULL, -- format Mar1998
    D_DAYNUMINWEEK smallint NOT NULL, -- values: 1-7
    D_DAYNUMINMONTH smallint NOT NULL, -- values: 1-31
    D_DAYNUMINYEAR smallint NOT NULL, -- values: 1-366
    D_MONTHNUMINYEAR smallint NOT NULL, -- values: 1-12
    D_WEEKNUMINYEAR smallint NOT NULL, -- values: 1-53
    D_SELLINGSEASON char(12) NOT NULL, -- eg: Christmas
    D_LASTDAYINWEEKFL bit(1) NOT NULL,
    D_LASTDAYINMONTHFL bit(1) NOT NULL,
    D_HOLIDAYFL bit(1) NOT NULL,
    D_WEEKDAYFL bit(1) NOT NULL,
    PRIMARY KEY (D_DATEKEY)
); 

 -- PART TABLE 
CREATE TABLE PART (
    P_PARTKEY integer NOT NULL,
    P_NAME varchar(22) NOT NULL,
    P_MFGR char(6) NOT NULL, -- values: MFGR#1 to MFGR#5 (5 values)
    P_CATEGORY char(7) NOT NULL, -- values: MFGR#||1-5||1-5|| (25 values)
    P_BRAND char(9) NOT NULL, -- values: P_CATEGORY||1-40 (1000 values)
    P_COLOR varchar(11) NOT NULL, -- values: 94 values
    P_TYPE varchar(25) NOT NULL, -- values: 150 values
    P_SIZE smallint NOT NULL, -- values: 1-50
    P_CONTAINER char(10) NOT NULL, -- values: 40 values
    PRIMARY KEY (P_PARTKEY)
); 


-- SUPPLIER TABLE
CREATE TABLE SUPPLIER (
    S_SUPPKEY integer NOT NULL,
    S_NAME char(25) NOT NULL, -- values: Supplier||SUPPKEY
    S_ADDRESS varchar(25) NOT NULL,
    S_CITY char(10) NOT NULL, -- 10 cities per nation: S_NATION_PREFIX||(0-9) => 250 values
    S_NATION char(15) NOT NULL, -- values: 25 values (longest: UNITED KINGDOM)
    S_REGION char(12) NOT NULL, -- values: 5 values (longest: MIDDLE EAST)
    S_PHONE char(15) NOT NULL, -- values: many (format: 43-617-354-1222)
    PRIMARY KEY (S_SUPPKEY)
); 


-- CUSTOMER TABLE 
CREATE TABLE CUSTOMER (
    C_CUSTKEY integer NOT NULL,
    C_NAME varchar(25) NOT NULL, -- values: Customer||CUSTKEY
    C_ADDRESS varchar(25) NOT NULL, 
    C_CITY char(10) NOT NULL, -- values: 10 cities per nation: C_NATION_PREFIX||(0-9) => 250 values
    C_NATION char(15) NOT NULL, -- values: 25 values (longest: UNITED KINGDOM)
    C_REGION char(12) NOT NULL, -- values: 5 values (longest: MIDDLE EAST)
    C_PHONE char(15) NOT NULL, -- values: many (format: 43-617-354-1222)
    C_MKTSEGMENT char(10) NOT NULL, -- values: 10 values (longest: AUTOMOBILE)
    PRIMARY KEY (C_CUSTKEY)
); 


-- LINEORDER TABLE
CREATE TABLE LINEORDER (
    LO_ORDERKEY integer NOT NULL,
    LO_LINENUMBER smallint NOT NULL, -- values: 1-7
    LO_CUSTKEY integer NOT NULL,
    LO_PARTKEY integer NOT NULL,
    LO_SUPPKEY integer NOT NULL,
    LO_ORDERDATE integer NOT NULL,
    LO_ORDERPRIORITY char(15) NOT NULL, -- values: 1-URGENT to 5-SOMETHING
    LO_SHIPPRIORITY char(1) NOT NULL, 
    LO_  smallint NOT NULL, -- values: 1-50
    LO_EXTENDEDPRICE INTEGER NOT NULL, -- values <= 55,450
    LO_ORDTOTALPRICE INTEGER NOT NULL, -- values <= 388,000
    LO_DISCOUNT smallint NOT NULL, -- values: 0-10
    LO_REVENUE INTEGER NOT NULL, -- (lo_extendedprice*(100-lo_discount)/100)
    LO_SUPPLYCOST INTEGER NOT NULL, 
    LO_TAX smallint NOT NULL, -- values: 0-8
    LO_COMMITDATE integer NOT NULL,
    LO_SHIPMODE char(10) NOT NULL, -- values: 7 modes: REG AIR, AIR etc

    FOREIGN KEY (LO_CUSTKEY) REFERENCES CUSTOMER (C_CUSTKEY) ON DELETE CASCADE,
    FOREIGN KEY (LO_PARTKEY) REFERENCES PART (P_PARTKEY) ON DELETE CASCADE,
    FOREIGN KEY (LO_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY) ON DELETE CASCADE,
    FOREIGN KEY (LO_ORDERDATE) REFERENCES DATE (D_DATEKEY) ON DELETE CASCADE,
    FOREIGN KEY (LO_COMMITDATE) REFERENCES DATE (D_DATEKEY) ON DELETE CASCADE,
    PRIMARY KEY (LO_ORDERKEY, LO_LINENUMBER)
);

CREATE INDEX l_od ON LINEORDER (LO_ORDERDATE ASC);
CREATE INDEX l_pk ON LINEORDER (LO_PARTKEY ASC);
CREATE INDEX l_sk ON LINEORDER (LO_SUPPKEY ASC);
CREATE INDEX l_ck ON LINEORDER (LO_CUSTKEY ASC);