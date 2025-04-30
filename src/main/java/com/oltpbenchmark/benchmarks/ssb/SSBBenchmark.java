package com.oltpbenchmark.benchmarks.ssb;

import com.oltpbenchmark.WorkloadConfiguration;
import com.oltpbenchmark.api.BenchmarkModule;
import com.oltpbenchmark.api.Loader;
import com.oltpbenchmark.api.Worker;
import com.oltpbenchmark.benchmarks.ssb.procedures.Q11;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SSBBenchmark extends BenchmarkModule {
  private static final Logger LOG = LoggerFactory.getLogger(SSBBenchmark.class);

  public SSBBenchmark(WorkloadConfiguration workConf) {
    super(workConf);
  }

  @Override
  protected Package getProcedurePackageImpl() {
    return (Q11.class.getPackage());
  }

  @Override
  protected List<Worker<? extends BenchmarkModule>> makeWorkersImpl() {
    List<Worker<? extends BenchmarkModule>> workers = new ArrayList<>();

    int numTerminals = workConf.getTerminals();
    LOG.info(String.format("Creating %d workers for SSB", numTerminals));
    for (int i = 0; i < numTerminals; i++) {
      workers.add(new SSBWorker(this, i));
    }
    return workers;
  }

  @Override
  protected Loader<SSBBenchmark> makeLoaderImpl() {
    return new SSBLoader(this);
  }
}
