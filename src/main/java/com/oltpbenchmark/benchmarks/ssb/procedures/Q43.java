package com.oltpbenchmark.benchmarks.ssb.procedures;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.oltpbenchmark.util.RandomGenerator;

public class Q43 extends GenericQuery {
    @Override
    protected PreparedStatement getStatement(
        Connection conn, RandomGenerator rand, double scaleFactor
    ) throws SQLException {
        PreparedStatement stmt = null; 
        return stmt;
    }
}
