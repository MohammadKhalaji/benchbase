package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q23 extends GenericQuery {

    // FF from the paper: (1/1000) * (1/5) = 1/5000
    // The 1/1000 factor corresponds to the P_BRAND predicate 
    // P_BRAND values according to DDL: P_CATEGORY||1-40 => 25 * 40 = 1000 values 
    // The example in the paper is P_BRAND = 'MFGR#2221' 

    // The 1/5 factor corresponds to the S_REGION predicate (5 values)

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
        FROM LINEORDER, DATE, PART, SUPPLIER 
        WHERE LO_ORDERDATE = D_DATEKEY
        AND LO_PARTKEY = P_PARTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND P_BRAND = ?
        AND S_REGION = ?
        GROUP BY D_YEAR, P_BRAND
        ORDER BY D_YEAR, P_BRAND;
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        int firstCatDigit = rand.number(1, 5);
        int secondCatDigit = rand.number(1, 5);
        String cateogry = String.format("%d%d", firstCatDigit, secondCatDigit);

        int forty = rand.number(1, 40);
        
        String brand = String.format("MFGR#%s%02d", cateogry, forty);


        String region = SSBUtil.choice(SSBConstants.REGIONS, rand);

        stmt.setString(1, brand);
        stmt.setString(2, region);


        return stmt;
    }
}
