package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;

public class Q34 extends GenericQuery {

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
        AND (C_CITY = ? OR C_CITY = ?)
        AND (S_CITY = ? OR S_CITY = ?)
        AND D_YEARMONTH = ?
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
        String city1 = SSBUtil.generateRandomCityInNation(nation, rand);
        String city2 = SSBUtil.generateRandomCityInNation(nation, rand);
        while (city1.equals(city2)) {
            city2 = SSBUtil.generateRandomCityInNation(nation, rand);
        }

        int year = SSBUtil.generateRandomYear(rand);
        int month = SSBUtil.generateRandomMonth(rand);
        String yearMonth = SSBUtil.getYearMonth(year, month);

        stmt.setString(1, city1);
        stmt.setString(2, city2);
        stmt.setString(3, city1);
        stmt.setString(4, city2);
        stmt.setString(5, yearMonth);

        return stmt;
    }
}
