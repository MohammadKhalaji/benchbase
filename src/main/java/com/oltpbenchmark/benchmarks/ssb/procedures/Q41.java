package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Q41 extends GenericQuery {

  // FF from the paper: (1/5) * (1/5) * (2/5) = 2/125
  // The first (1/5) factor corresponds to the C_REGION predicate
  // The second (1/5) factor corresponds to the S_REGION predicate
  // Although the REGION variable should be the same, it will still filter out a lot of rows in the
  // supplier table
  // The (2/5) factor corresponds to the P_MFGR predicate

  public final SQLStmt query_stmt =
      new SQLStmt(
          """
        SELECT D_YEAR, C_NATION, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
        FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND LO_PARTKEY = P_PARTKEY
        AND LO_ORDERDATE = D_DATEKEY
        AND C_REGION = ?
        AND S_REGION = ?
        AND (P_MFGR = ? OR P_MFGR = ?)
        GROUP BY D_YEAR, C_NATION
        ORDER BY D_YEAR, C_NATION;
        """);

  @Override
  protected PreparedStatement getStatement(
      Connection conn, RandomGenerator rand, double scaleFactor) throws SQLException {
    PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

    String region = SSBUtil.choice(SSBConstants.REGIONS, rand);
    String mfgr1 = SSBUtil.generateRandomMfgr(rand);
    String mfgr2 = SSBUtil.generateRandomMfgr(rand);
    while (mfgr1.equals(mfgr2)) {
      mfgr2 = SSBUtil.generateRandomMfgr(rand);
    }

    stmt.setString(1, region);
    stmt.setString(2, region);
    stmt.setString(3, mfgr1);
    stmt.setString(4, mfgr2);

    return stmt;
  }
}
