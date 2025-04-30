package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Q42 extends GenericQuery {

  // FF from the paper: (2/7) * (2/125) = 4/875
  // The (2/7) factor corresponds to the two years
  // The (2/125) factor is the Q41 factor, because this query is very similar to Q41

  public final SQLStmt query_stmt =
      new SQLStmt(
          """
        SELECT D_YEAR, S_NATION, P_CATEGORY, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
        FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND LO_PARTKEY = P_PARTKEY
        AND LO_ORDERDATE = D_DATEKEY
        AND C_REGION = ?
        AND S_REGION = ?
        AND (D_YEAR = ? OR D_YEAR = ?)
        AND (P_MFGR = ? OR P_MFGR = ?)
        GROUP BY D_YEAR, S_NATION, P_CATEGORY
        ORDER BY D_YEAR, S_NATION, P_CATEGORY;
        """);

  @Override
  protected PreparedStatement getStatement(
      Connection conn, RandomGenerator rand, double scaleFactor) throws SQLException {
    PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

    String region = SSBUtil.choice(SSBConstants.REGIONS, rand);
    // TODO: one region only?
    // Can be two
    
    int year1 = SSBUtil.generateRandomYear(rand);
    int year2 = SSBUtil.generateRandomYear(rand);
    while (year1 == year2) {
      year2 = SSBUtil.generateRandomYear(rand);
    }
    String mfgr1 = SSBUtil.generateRandomMfgr(rand);
    String mfgr2 = SSBUtil.generateRandomMfgr(rand);
    while (mfgr1.equals(mfgr2)) {
      mfgr2 = SSBUtil.generateRandomMfgr(rand);
    }

    stmt.setString(1, region);
    stmt.setString(2, region);
    stmt.setInt(3, year1);
    stmt.setInt(4, year2);
    stmt.setString(5, mfgr1);
    stmt.setString(6, mfgr2);

    return stmt;
  }
}
