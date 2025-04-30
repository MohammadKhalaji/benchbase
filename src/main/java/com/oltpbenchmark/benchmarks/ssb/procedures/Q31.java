package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Q31 extends GenericQuery {

  // FF from the paper: (1/5) * (1/5) * (6/7) = 6/175
  // (1/5): C_REGION
  // (1/5): S_REGION
  // (6/7): D_YEAR

  public final SQLStmt query_stmt =
      new SQLStmt(
          """
        SELECT C_NATION, S_NATION, D_YEAR, SUM(LO_REVENUE) as REVENUE
        FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND LO_ORDERDATE = D_DATEKEY
        AND C_REGION = ? AND S_REGION = ?
        AND D_YEAR >= ? AND D_YEAR <= ?
        GROUP BY C_NATION, S_NATION, D_YEAR
        ORDER BY D_YEAR ASC, REVENUE DESC;
        """);

  @Override
  protected PreparedStatement getStatement(
      Connection conn, RandomGenerator rand, double scaleFactor) throws SQLException {
    PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

    String region = SSBUtil.choice(SSBConstants.REGIONS, rand);
    // TODO: is there only one region?
    // Can be two...

    int startYear = SSBUtil.generateRandomYearRangeStart(5, rand);
    int endYear = startYear + 5;

    stmt.setString(1, region);
    stmt.setString(2, region);
    stmt.setInt(3, startYear);
    stmt.setInt(4, endYear);
    return stmt;
  }
}
