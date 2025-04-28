package com.oltpbenchmark.benchmarks.ssb.procedures;

import com.oltpbenchmark.api.SQLStmt;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Q11 extends GenericQuery {
    
    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = null; 
        return stmt;
    }
}
