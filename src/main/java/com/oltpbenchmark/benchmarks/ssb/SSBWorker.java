package com.oltpbenchmark.benchmarks.ssb;

import com.oltpbenchmark.api.Procedure.UserAbortException;
import com.oltpbenchmark.api.TransactionType;
import com.oltpbenchmark.api.Worker;
import com.oltpbenchmark.types.TransactionStatus;
import com.oltpbenchmark.util.RandomGenerator;
import java.sql.Connection;
import java.sql.SQLException;

public final class SSBWorker extends Worker<SSBBenchmark> {
  private final RandomGenerator rand;

  public SSBWorker(SSBBenchmark benchmarkModule, int id) {
    super(benchmarkModule, id);
    this.rng().setSeed(15721);
    rand = new RandomGenerator(this.rng().nextInt());
  }

  @Override
  protected TransactionStatus executeWork(Connection conn, TransactionType nextTransaction)
      throws UserAbortException, SQLException {

    return (TransactionStatus.SUCCESS);
  }
}
