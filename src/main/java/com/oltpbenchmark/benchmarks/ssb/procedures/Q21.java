package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class Q21 extends GenericQuery {

    // FF from the paper: (1/25) * (1/5) = 1/125
    // The 1/25 factor corresponds to the P_CATEGORY predicate (25 values)
    // The 1/5 factor corresponds to the S_REGION predicate (5 values)

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
        FROM LINEORDER, DATE, PART, SUPPLIER 
        WHERE LO_ORDERDATE = D_DATEKEY
        AND LO_PARTKEY = P_PARTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND P_CATEGORY = ?
        AND S_REGION = ?
        GROUP BY D_YEAR, P_BRAND
        ORDER BY D_YEAR, P_BRAND;
        """
    ); 

    public final String[] regions = {
        "AFRICA",
        "AMERICA",
        "ASIA",
        "EUROPE",
        "MIDDLE EAST"
    };

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        int firstCatDigit = rand.number(1, 5);
        int secondCatDigit = rand.number(1, 5);
        String category = String.format("MFGR#%d%d", firstCatDigit, secondCatDigit);

        int regionIndex = rand.number(1, 5) - 1; // 0-4
        String region = regions[regionIndex];

        stmt.setString(1, category);
        stmt.setString(2, region);


        return stmt;
    }
}
