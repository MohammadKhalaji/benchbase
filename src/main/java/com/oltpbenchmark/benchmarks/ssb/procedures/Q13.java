package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class Q13 extends GenericQuery {

    // FF from the paper: (1/364) * (3/11) * (1/10) = 0.000075
    // The 1/364 factor corresponds to the D_WEEKNUMINYEAR and D_YEAR field (7 years, 53 weeknum values = 365) 
    // The 3/11 factor corresponds to the LO_DISCOUNT field
    // the 1/10 factor corresponds to the LO_QUANTITY field, so the bounds need to cover 5 consecutive quantity values 

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
        FROM LINEORDER, DATE
        WHERE LO_ORDERDATE = D_DATEKEY
        AND D_WEEKNUMINYEAR = ?
        AND D_YEAR = ?
        AND LO_DISCOUNT BETWEEN ? AND ?
        AND LO_QUANTITY BETWEEN ? AND ?       
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        int weekNum = rand.number(1, 53);
        int year = rand.number(1992, 1998);

        int discount = rand.number(1, 9); // TODO: 1,9 or 0,10?

        int quantityStart = rand.number(1, 46); 
        int quantityEnd = quantityStart + 4; // LO_QUANTITY BETWEEN x AND x + 4 => 5 values

        stmt.setInt(1, weekNum); 
        stmt.setInt(2, year);
        stmt.setInt(3, discount - 1); // discount is between x - 1 and x + 1
        stmt.setInt(4, discount + 1); // discount is between x - 1 and x + 1
        stmt.setInt(5, quantityStart); // LO_QUANTITY BETWEEN x AND x + 4
        stmt.setInt(6, quantityEnd); // LO_QUANTITY BETWEEN x AND x + 4


        return stmt;
    }
}
