package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q22 extends GenericQuery {

    // FF from the paper: (1/125) * (1/5) = 1/625
    // The 1/125 factor corresponds to the P_BRAND predicate
    // P_BRAND values according to DDL: P_CATEGORY||1-40 => 25 * 40 = 1000 values
    // The example in the paper is P_BRAND between 'MFGR#2221' and 'MFGR#2228'
    // So the P_CATEGORY is fixed, but there's 8 P_CATEGORY's chosen
    // 8 / 1000 = 1 / 125

    // The 1/5 factor corresponds to the S_REGION predicate (5 values)

    public final SQLStmt query_stmt = new SQLStmt(
            """
                    SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
                    FROM LINEORDER, DATE, PART, SUPPLIER
                    WHERE LO_ORDERDATE = D_DATEKEY
                    AND LO_PARTKEY = P_PARTKEY
                    AND LO_SUPPKEY = S_SUPPKEY
                    AND P_BRAND BETWEEN ? AND ?
                    AND S_REGION = ?
                    GROUP BY D_YEAR, P_BRAND
                    ORDER BY D_YEAR, P_BRAND;
                    """);

    @Override
    protected PreparedStatement getStatement(
            Connection conn, RandomGenerator rand, double scaleFactor) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        String category = SSBUtil.generateRandomCategory(rand);

        int firstOfForty = rand.number(1, 33);
        int lastOfForty = firstOfForty + 7; // 8 values
        String lowBound = String.format("%s%02d", category, firstOfForty);
        String highBound = String.format("%s%02d", category, lastOfForty);

        String region = SSBUtil.choice(SSBConstants.REGIONS, rand);

        stmt.setString(1, lowBound);
        stmt.setString(2, highBound);
        stmt.setString(3, region);

        return stmt;
    }
}
