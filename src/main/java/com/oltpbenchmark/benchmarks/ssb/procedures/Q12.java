package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


public class Q12 extends GenericQuery {

    // FF from the paper: (1/84) * (3/11) * (2/10) = 0.00064935
    // The 1/84 factor corresponds to the D_YEARMONTHNUM field (7 years, 12 months each = 84 values) (e.g. 199801)
    // The 3/11 factor corresponds to the LO_DISCOUNT field
    // the 2/10 factor corresponds to the LO_QUANTITY field, so the bounds need to cover 10 consecutive quantity values 

    public final SQLStmt query_stmt = new SQLStmt(
        """
        SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
        FROM LINEORDER, DATE
        WHERE LO_ORDERDATE = D_DATEKEY
        AND D_YEARMONTHNUM = ?
        AND LO_DISCOUNT BETWEEN ? AND ?
        AND LO_QUANTITY BETWEEN ? AND ?       
        """
    ); 

    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt);

        int year = rand.number(1992, 1998);
        int month = rand.number(1, 12);
        int yearMonth = year * 100 + month; // D_YEARMONTHNUM is YYYYMM
        
        int discount = rand.number(1, 9); // TODO: 1,9 or 0,10?

        int quantityStart = rand.number(1, 41); 
        int quantityEnd = quantityStart + 9; // LO_QUANTITY BETWEEN x AND x + 9 => 10 values

        stmt.setInt(1, yearMonth);
        stmt.setInt(2, discount - 1); // discount is between x - 1 and x + 1
        stmt.setInt(3, discount + 1); // discount is between x - 1 and x + 1
        stmt.setInt(4, quantityStart); // LO_QUANTITY BETWEEN x AND x + 9
        stmt.setInt(5, quantityEnd); // LO_QUANTITY BETWEEN x AND x + 9


        return stmt;
    }
}
