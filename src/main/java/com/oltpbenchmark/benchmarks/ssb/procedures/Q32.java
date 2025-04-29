package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q32 extends GenericQuery {

    // FF from the paper: (1/25) * (1/25) * (6/7) = 6/4375
    // The first (1/25) factor corresponds to the C_NATION predicate
    // The second (1/25) factor corresponds to the S_NATION predicate
    // Although the nation variable should be the same, it will still filter out a lot of rows in the supplier table
    // The (6/7) factor corresponds to the 6 years out of 7 possible that we choose 

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
        FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND LO_ORDERDATE = D_DATEKEY
        AND C_NATION = ?
        AND S_NATION = ?
        AND D_YEAR >= ? AND D_YEAR <= ?
        GROUP BY C_CITY, S_CITY, D_YEAR
        ORDER BY D_YEAR ASC, REVENUE DESC;
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        String nation = SSBUtil.choice(SSBConstants.NATIONS, rand);
        // TODO: is there only one nation?

        int startYear = SSBUtil.generateRandomYearRangeStart(5, rand);
        int endYear = startYear + 5;

        stmt.setString(1, nation);
        stmt.setString(2, nation);
        stmt.setInt(3, startYear);
        stmt.setInt(4, endYear);

        return stmt;
    }
}
