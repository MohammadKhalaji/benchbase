package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q43 extends GenericQuery {

    // FF from the paper: (1/5) * (1/25) * (2/7) * (1/25)
    // (1/5): C_REGION
    // (1/25): S_NATION
    // TODO: Are nations and regions not correlated? Is the dataset generated purely randomly?
    // (2/7): two years
    // (1/25): P_CATEGORY

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT D_YEAR, S_CITY, P_BRAND, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
        FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
        WHERE LO_CUSTKEY = C_CUSTKEY
        AND LO_SUPPKEY = S_SUPPKEY
        AND LO_PARTKEY = P_PARTKEY
        AND LO_ORDERDATE = D_DATEKEY
        AND C_REGION = ?
        AND S_NATION = ?
        AND (D_YEAR = ? OR D_YEAR = ?)
        AND P_CATEGORY = ?
        GROUP BY D_YEAR, S_CITY, P_BRAND 
        ORDER BY D_YEAR, S_CITY, P_BRAND;
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        String region = SSBUtil.choice(SSBConstants.REGIONS, rand);
        String nation = SSBUtil.choice(SSBConstants.NATIONS, rand);
        int year1 = SSBUtil.generateRandomYear(rand);
        int year2 = SSBUtil.generateRandomYear(rand);
        while (year1 == year2) {
            year2 = SSBUtil.generateRandomYear(rand);
        }
        String category = SSBUtil.generateRandomCategory(rand);

        stmt.setString(1, region);
        stmt.setString(2, nation);
        stmt.setInt(3, year1);
        stmt.setInt(4, year2);
        stmt.setString(5, category);
        
        return stmt;
    }
}
