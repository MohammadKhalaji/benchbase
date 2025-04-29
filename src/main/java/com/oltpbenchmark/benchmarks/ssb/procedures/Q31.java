package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q31 extends GenericQuery {

    // FF from the paper: (1/1000) * (1/5) = 1/5000
    // The 1/1000 factor corresponds to the P_BRAND predicate 
    // P_BRAND values according to DDL: P_CATEGORY||1-40 => 25 * 40 = 1000 values 
    // The example in the paper is P_BRAND = 'MFGR#2221' 

    // The 1/5 factor corresponds to the S_REGION predicate (5 values)

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT C_NATION, S_NATION, D_YEAR, SUM(LO_REVENUE) as REVENUE 
        FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_ORDERDATE = D_DATEKEY 
        AND C_REGION = ? AND S_REGION = ?
        AND D_YEAR >= ? AND D_YEAR <= ?
        GROUP BY C_NATION, S_NATION, D_YEAR
        ORDER BY D_YEAR ASC, REVENUE DESC;
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        String category = SSBUtil.generateRandomCategory(rand);
        String brand = SSBUtil.genrateRandomBrandForCategory(category, rand);

        String region = SSBUtil.choice(SSBConstants.REGIONS, rand);

        stmt.setString(1, brand);
        stmt.setString(2, region);


        return stmt;
    }
}
