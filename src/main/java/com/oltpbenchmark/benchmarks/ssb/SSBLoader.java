package com.oltpbenchmark.benchmarks.ssb;

import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;
import com.oltpbenchmark.catalog.Table;
import com.oltpbenchmark.util.SQLUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public final class SSBLoader extends Loader<SSBBenchmark> {
    public SSBLoader(SSBBenchmark benchmark) {
        super(benchmark);
    }

    private enum CastTypes {
        LONG,
        INTEGER,
        STRING
    };

    private static final CastTypes[] dateTypes = {
            CastTypes.LONG, // D_DATEKEY
            CastTypes.STRING, // D_DATE
            CastTypes.STRING, // D_DAYOFWEEK
            CastTypes.STRING, // D_MONTH
            CastTypes.INTEGER, // D_YEAR
            CastTypes.INTEGER, // D_YEARMONTHNUM
            CastTypes.STRING, // D_YEARMONTH
            CastTypes.INTEGER, // D_DAYNUMINWEEK
            CastTypes.INTEGER, // D_DAYNUMINMONTH
            CastTypes.INTEGER, // D_DAYNUMINYEAR
            CastTypes.INTEGER, // D_MONTHNUMINYEAR
            CastTypes.INTEGER, // D_WEEKNUMINYEAR
            CastTypes.STRING, // D_SELLINGSEASON
            CastTypes.INTEGER, // D_LASTDAYINWEEKFL
            CastTypes.INTEGER, // D_LASTDAYINMONTHFL
    };

    private static final CastTypes[] partTypes = {
            CastTypes.LONG, // P_PARTKEY
            CastTypes.STRING, // P_NAME
            CastTypes.STRING, // P_MFGR
            CastTypes.STRING, // P_CATEGORY
            CastTypes.STRING, // P_BRAND
            CastTypes.STRING, // P_COLOR
            CastTypes.STRING, // P_TYPE
            CastTypes.INTEGER, // P_SIZE
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
            CastTypes.INTEGER, // LO_QUANTITY
            CastTypes.LONG, // LO_EXTENDEDPRICE
            CastTypes.LONG, // LO_ORDTOTALPRICE
            CastTypes.INTEGER, // LO_DISCOUNT
            CastTypes.LONG, // LO_REVENUE
            CastTypes.LONG, // LO_SUPPLYCOST
            CastTypes.INTEGER, // LO_TAX
            CastTypes.LONG, // LO_COMMITDATE
            CastTypes.STRING, // LO_SHIPMODE
    };

    private PreparedStatement getInsertStatement(Connection conn, String tableName)
            throws SQLException {
        Table catalog_tbl = benchmark.getCatalog().getTable(tableName);
        String sql = SQLUtil.getInsertSQL(catalog_tbl, this.getDatabaseType());
        return conn.prepareStatement(sql);
    }

    @Override
    public List<LoaderThread> createLoaderThreads() {
        List<LoaderThread> threads = new ArrayList<>();

        final CountDownLatch latch = new CountDownLatch(4); // 4 tables to create before lineorder

        final double scaleFactor = this.workConf.getScaleFactor();

        // Date
        threads.add(
                new LoaderThread(this.benchmark) {
                    @Override
                    public void beforeLoad() {
                        LOG.info("Loading DATE...");
                    }

                    @Override
                    public void load(Connection conn) throws SQLException {
                        // TODO
                    }

                    @Override
                    public void afterLoad() {
                        LOG.info("DATE loaded.");
                        latch.countDown();
                    }
                });

        // part
        threads.add(
                new LoaderThread(this.benchmark) {
                    @Override
                    public void beforeLoad() {
                        LOG.info("Loading PART...");
                    }

                    @Override
                    public void load(Connection conn) throws SQLException {
                        // TODO
                    }

                    @Override
                    public void afterLoad() {
                        latch.countDown();
                        LOG.info("PART loaded.");
                    }
                });

        // supplier
        threads.add(
                new LoaderThread(this.benchmark) {
                    @Override
                    public void beforeLoad() {
                        LOG.info("Loading SUPPLIER...");
                    }

                    @Override
                    public void load(Connection conn) throws SQLException {
                        // TODO
                    }

                    @Override
                    public void afterLoad() {
                        latch.countDown();
                        LOG.info("SUPPLIER loaded.");
                    }
                });

        // customer
        threads.add(
                new LoaderThread(this.benchmark) {
                    @Override
                    public void beforeLoad() {
                        LOG.info("Loading CUSTOMER...");
                    }

                    @Override
                    public void load(Connection conn) throws SQLException {
                        // TODO
                    }

                    @Override
                    public void afterLoad() {
                        latch.countDown();
                        LOG.info("CUSTOMER loaded.");
                    }
                });

        // lineorder
        threads.add(
                new LoaderThread(this.benchmark) {
                    @Override
                    public void beforeLoad() {
                        try {
                            latch.await();
                            LOG.info("Finished waiting for other tables, loading LINEORDER....");
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }

                    @Override
                    public void load(Connection conn) throws SQLException {
                        // TODO
                    }

                    @Override
                    public void afterLoad() {
                        LOG.info("LIENORDER loaded");
                    }
                });

        return threads;
    }

    private void genTable(
            Connection conn,
            PreparedStatement prepStmt,
            List<Iterable<List<Object>>> generators,
            CastTypes[] types,
            String tableName) {
        for (Iterable<List<Object>> generator : generators) {
            try {
                int recordsRead = 0;
                for (List<Object> elems : generator) {
                    for (int idx = 0; idx < types.length; idx++) {
                        final CastTypes type = types[idx];
                        switch (type) {
                            case LONG:
                                prepStmt.setLong(idx + 1, (Long) elems.get(idx));
                                break;
                            case INTEGER:
                                prepStmt.setInt(idx + 1, (int) elems.get(idx));
                                break;
                            case STRING:
                                prepStmt.setString(idx + 1, (String) elems.get(idx));
                                break;
                            default:
                                throw new RuntimeException("Unrecognized type for prepared statement");
                        }
                    }

                    ++recordsRead;
                    prepStmt.addBatch();
                    if ((recordsRead % workConf.getBatchSize()) == 0) {

                        LOG.debug("writing batch {} for table {}", recordsRead, tableName);

                        prepStmt.executeBatch();
                        prepStmt.clearBatch();
                    }
                }

                prepStmt.executeBatch();
            } catch (Exception e) {
                LOG.error(e.getMessage(), e);
            }
        }
    }

}
