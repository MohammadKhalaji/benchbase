package com.oltpbenchmark.benchmarks.ssb;

import static com.oltpbenchmark.benchmarks.ssb.SSBConstants.*;

import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;
import com.oltpbenchmark.catalog.Table;
import com.oltpbenchmark.util.SQLUtil;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import org.codehaus.commons.nullanalysis.NotNull;

public final class SSBLoader extends Loader<SSBBenchmark> {
  public SSBLoader(SSBBenchmark benchmark) {
    super(benchmark);
  }

  private enum CastTypes {
    LONG,
    INTEGER,
    STRING,
    BIT
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
    CastTypes.BIT, // D_LASTDAYINWEEKFL
    CastTypes.BIT, // D_LASTDAYINMONTHFL
    CastTypes.BIT, // D_HOLIDAYFL
    CastTypes.BIT // D_WEEKDAYFL
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

    if (tableName == TABLENAME_DATE) {
      // Let's break the generality here for the date table
      // Because of the bit fields in that table, and the way jdbc doesn't handle them
      String sql =
          """
                    INSERT INTO date
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::bit, ?::bit, ?::bit, ?::bit);
                    """; // TODO: Format the string instead of hardcoding the tablename
      LOG.info("Insert statement for table {} is {}", tableName, sql);
      return conn.prepareStatement(sql);
    } else {
      Table catalog_tbl = benchmark.getCatalog().getTable(tableName);
      String sql = SQLUtil.getInsertSQL(catalog_tbl, this.getDatabaseType());
      LOG.info("Insert statement for table {} is {}", tableName, sql);
      return conn.prepareStatement(sql);
    }
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
            try (PreparedStatement statement = getInsertStatement(conn, TABLENAME_DATE)) {
              List<Iterable<List<String>>> dateGenerators = new ArrayList<>();
              try {
                dateGenerators.add(
                    new FileIterable(
                        new File(
                            "/home/mohammad/repos/ssb-dbgen/sf"
                                + benchmark.getWorkloadConfiguration().getScaleFactor()
                                + "/date.tbl")));
                genTable(conn, statement, dateGenerators, dateTypes, TABLENAME_DATE);
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            }
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
            try (PreparedStatement statement = getInsertStatement(conn, TABLENAME_PART)) {
              List<Iterable<List<String>>> partGenerators = new ArrayList<>();
              try {
                partGenerators.add(
                    new FileIterable(
                        new File(
                            "/home/mohammad/repos/ssb-dbgen/sf"
                                + benchmark.getWorkloadConfiguration().getScaleFactor()
                                + "/part.tbl")));
                genTable(conn, statement, partGenerators, partTypes, TABLENAME_PART);
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            }
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
            try (PreparedStatement statement = getInsertStatement(conn, TABLENAME_SUPPLIER)) {
              List<Iterable<List<String>>> supplierGenerators = new ArrayList<>();
              try {
                supplierGenerators.add(
                    new FileIterable(
                        new File(
                            "/home/mohammad/repos/ssb-dbgen/sf"
                                + benchmark.getWorkloadConfiguration().getScaleFactor()
                                + "/supplier.tbl")));
                genTable(conn, statement, supplierGenerators, supplierTypes, TABLENAME_SUPPLIER);
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            }
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
            try (PreparedStatement statement = getInsertStatement(conn, TABLENAME_CUSTOMER)) {
              List<Iterable<List<String>>> customerGenerators = new ArrayList<>();
              try {
                customerGenerators.add(
                    new FileIterable(
                        new File(
                            "/home/mohammad/repos/ssb-dbgen/sf"
                                + benchmark.getWorkloadConfiguration().getScaleFactor()
                                + "/customer.tbl")));
                genTable(conn, statement, customerGenerators, customerTypes, TABLENAME_CUSTOMER);
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            }
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
            try (PreparedStatement statement = getInsertStatement(conn, TABLENAME_LINEORDER)) {
              List<Iterable<List<String>>> lineorderGenerators = new ArrayList<>();
              try {
                lineorderGenerators.add(
                    new FileIterable(
                        new File(
                            "/home/mohammad/repos/ssb-dbgen/sf"
                                + benchmark.getWorkloadConfiguration().getScaleFactor()
                                + "/lineorder.tbl")));
                genTable(conn, statement, lineorderGenerators, lineorderTypes, TABLENAME_LINEORDER);
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            }
          }

          @Override
          public void afterLoad() {
            LOG.info("LIENORDER loaded");
          }
        });

    return threads;
  }

  private String fixSsbDbgenBug(String input) {
    // SSB DBGEN bug
    // Brand names can be "MFGR#228" instead of "MFGR#2208", which messes up the lexicographical
    // sorting in Q22, as an example
    // A lot of queries will return 0 results, skewing the benchmark
    // This is here to fix it
    // It's a super quick patch because I didn't have time to spend on making this work cleanly

    if (input.startsWith("MFGR#")
        && input.length() > "MFGR#22".length()
        && input.length() < "MFGR#2211".length()) {
      return input.substring(0, 7) + "0" + input.substring(7, 8);
    }

    return input;
  }

  private void genTable(
      Connection conn,
      PreparedStatement prepStmt,
      List<Iterable<List<String>>> generators,
      CastTypes[] types,
      String tableName) {
    for (Iterable<List<String>> generator : generators) {
      try {
        int recordsRead = 0;
        for (List<String> elems : generator) {
          for (int idx = 0; idx < types.length; idx++) {
            final CastTypes type = types[idx];
            switch (type) {
              case LONG:
                prepStmt.setLong(idx + 1, Long.parseLong(elems.get(idx)));
                break;
              case INTEGER:
                prepStmt.setInt(idx + 1, Integer.parseInt(elems.get(idx)));
                break;
              case STRING:
                prepStmt.setString(idx + 1, fixSsbDbgenBug(elems.get(idx)));
                break;
              case BIT:
                // Casting to bit is done at the query level (see getInsertStatement). Only the
                // date
                // table has bit fields.
                prepStmt.setString(idx + 1, elems.get(idx));
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

  static class FileIterable implements Iterable<List<String>> {

    private final BufferedReader reader;
    private String nextLine;

    public FileIterable(File file) throws FileNotFoundException {
      reader = new BufferedReader(new FileReader(file));
      advance();
    }

    private void advance() {
      try {
        nextLine = reader.readLine();
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
    }

    @Override
    public @NotNull Iterator<List<String>> iterator() {
      return new Iterator<>() {
        @Override
        public boolean hasNext() {
          return (nextLine != null);
        }

        @Override
        public List<String> next() {
          String line = nextLine;
          advance();
          return Arrays.asList(line.split("\\|"));
        }

        @Override
        public void remove() {
          throw new UnsupportedOperationException();
        }
      };
    }
  }
}
