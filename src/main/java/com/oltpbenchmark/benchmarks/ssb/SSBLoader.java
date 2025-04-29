package com.oltpbenchmark.benchmarks.ssb;


import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;
import com.oltpbenchmark.benchmarks.ssb.SSBBenchmark;
import com.oltpbenchmark.catalog.Table;
import com.oltpbenchmark.util.SQLUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.LoaderThread;

public final class SSBLoader extends Loader<SSBBenchmark> {
    public SSBLoader(SSBBenchmark benchmark) {
        super(benchmark);
    }


    private PreparedStatement getInsertStatement(Connection conn, String tableName) {
        // TODO: complete implementation
        return null;
    }

    @Override 
    public List<LoaderThread> createLoaderThreads() {
        // TODO: complete implementation
        return null;
    }
}
