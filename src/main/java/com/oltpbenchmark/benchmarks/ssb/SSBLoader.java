package com.oltpbenchmark.benchmarks.ssb;


import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;
import com.oltpbenchmark.benchmarks.ssb.SSBBenchmark;
import com.oltpbenchmark.catalog.Table;
import com.oltpbenchmark.util.SQLUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;

public final class SSBLoader extends Loader<SSBBenchmark> {
    public SSBLoader(SSBBenchmark benchmark) {
        super(benchmark);
    }


    private enum CastTypes {
        LONG, 
        DOUBLE, 
        STRING, 
        DATE
    }; 

    private static final CastTypes[] dateTypes = {
        CastTypes.LONG, // D_DATEKEY
        CastTypes.STRING, // D_DATE
        CastTypes.STRING, // D_DAYOFWEEK
        CastTypes.STRING, // D_MONTH
        CastTypes.LONG, // D_YEAR
        CastTypes.LONG, // D_YEARMONTHNUM
        CastTypes.STRING, // D_YEARMONTH
        CastTypes.LONG, // D_DAYNUMINWEEK
        CastTypes.LONG, // D_DAYNUMINMONTH
        CastTypes.LONG, // D_DAYNUMINYEAR
        CastTypes.LONG, // D_MONTHNUMINYEAR
        CastTypes.LONG, // D_WEEKNUMINYEAR
        CastTypes.STRING, // D_SELLINGSEASON
        CastTypes.LONG, // D_LASTDAYINWEEKFL
        CastTypes.LONG, // D_LASTDAYINMONTHFL
    };

    private static final CastTypes[] partTypes = {
        CastTypes.LONG, // P_PARTKEY
        CastTypes.STRING, // P_NAME
        CastTypes.STRING, // P_MFGR
        CastTypes.STRING, // P_CATEGORY
        CastTypes.STRING, // P_BRAND
        CastTypes.STRING, // P_COLOR
        CastTypes.STRING, // P_TYPE
        CastTypes.LONG, // P_SIZE
        CastTypes.STRING, // P_CONTAINER
    };

    private static final CastTypes[] supplierTypes = {
        CastTypes.LONG, // S_SUPPKEY
        CastTypes.STRING, // S_NAME
        CastTypes.STRING, // S_ADDRESS
        CastTypes.STRING, // S_CITY
        CastTypes.STRING, // S_NATION
        CastTypes.STRING, // S_REGION
        CastTypes.STRING, // S_PHONE
    };


    private static final CastTypes[] customerTypes = {
        CastTypes.LONG, // C_CUSTKEY
        CastTypes.STRING, // C_NAME
        CastTypes.STRING, // C_ADDRESS
        CastTypes.STRING, // C_CITY
        CastTypes.STRING, // C_NATION
        CastTypes.STRING, // C_REGION
        CastTypes.STRING, // C_PHONE
        CastTypes.STRING, // C_MKTSEGMENT
    };
    

    private static final CastTypes[] lineorderTypes = {
        CastTypes.LONG, // LO_ORDERKEY
        CastTypes.LONG, // LO_LINENUMBER
        CastTypes.LONG, // LO_CUSTKEY
        CastTypes.LONG, // LO_PARTKEY
        CastTypes.LONG, // LO_SUPPKEY
        CastTypes.LONG, // LO_ORDERDATE
        CastTypes.STRING, // LO_ORDERPRIORITY
        CastTypes.STRING, // LO_SHIPPRIORITY
        CastTypes.LONG, // LO_QUANTITY
        CastTypes.LONG, // LO_EXTENDEDPRICE
        CastTypes.LONG, // LO_ORDTOTALPRICE
        CastTypes.LONG, // LO_DISCOUNT
        CastTypes.LONG, // LO_REVENUE
        CastTypes.LONG, // LO_SUPPLYCOST
        CastTypes.LONG, // LO_TAX
        CastTypes.LONG, // LO_COMMITDATE
        CastTypes.STRING, // LO_SHIPMODE
    };



    private PreparedStatement getInsertStatement(Connection conn, String tableName) {
        // TODO: complete implementation
        return null;
    }

    @Override 
    public List<LoaderThread> createLoaderThreads() {
        // TODO: complete implementation
        return null;
    }
}
