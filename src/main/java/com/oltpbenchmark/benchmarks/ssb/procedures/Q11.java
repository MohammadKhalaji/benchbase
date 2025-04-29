package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.benchmarks.ssb.SSBConstants;
import com.oltpbenchmark.benchmarks.ssb.SSBUtil;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Q11 extends GenericQuery {

    // From the paper: 
    // Q1 is based on Q6 of TPC-H 
    // In the example, LO_DISCOUNT is between 1 and 3, D_YEAR is 1993, and LO_QUANTITY < 25
    // FF is told to be 0.0194, fetching 116K rows with SF=1
    // See the ddl-postgres.sql file for information about the possible values for the relevant fields
    // D_YEAR: 1992 -> 1998
    // LO_DISCOUNT: 0 -> 10
    // LO_QUANTITY: 1 -> 50
    // Discount is between x - 1 and x + 1
    // FF in the paper = (1/7) * (1/2) * (3/11)
    // 1/7 is for the year predicate
    // 3/11 is for the discount predicate (11 values, 3 selected in the query)
    // 1/2 is for the quantity predicate => LO_QUANTITY predicate needs to be hardcoded to 25

    public final SQLStmt query_stmt = 
        new SQLStmt(
            """
            SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
            FROM LINEORDER, DATE 
            WHERE LO_ORDERDATE = D_DATEKEY
            AND D_YEAR = ?
            AND LO_DISCOUNT BETWEEN ? AND ?
            AND LO_QUANTITY < 25;       
            """
        );
    
    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = this.getPreparedStatement(conn, query_stmt); 
        
        int year = SSBUtil.generateRandomYear(rand);
        // int quantity = rand.number(2, 50); // min is 2 because the predicate is not inclusive
        
        int discountRangeCenter = SSBUtil.generateRandomDiscountRangeCenter(1, rand);

        stmt.setInt(1, year);
        stmt.setInt(2, discountRangeCenter - 1); // discount is between x - 1 and x + 1
        stmt.setInt(3, discountRangeCenter + 1); // discount is between x - 1 and x + 1
        // stmt.setInt(4, quantity); // LO_QUANTITY < 25


        return stmt;
    }
}
