-- Q41 
SELECT D_YEAR, C_NATION, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_REGION = 'MIDDLE EAST' -- no fuss over being the same
AND (P_MFGR = 'MFGR#4' OR P_MFGR = 'MFGR#5')
GROUP BY D_YEAR, C_NATION
ORDER BY D_YEAR, C_NATION;

--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=126665.05..126710.26 rows=175 width=26) (actual time=551.321..557.823 rows=35 loops=1)
--    Group Key: date.d_year, customer.c_nation
--    ->  Gather Merge  (cost=126665.05..126705.88 rows=350 width=26) (actual time=551.294..557.780 rows=105 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          ->  Sort  (cost=125665.02..125665.46 rows=175 width=26) (actual time=538.535..538.543 rows=35 loops=3)
--                Sort Key: date.d_year, customer.c_nation
--                Sort Method: quicksort  Memory: 27kB
--                Worker 0:  Sort Method: quicksort  Memory: 27kB
--                Worker 1:  Sort Method: quicksort  Memory: 27kB
--                ->  Partial HashAggregate  (cost=125656.75..125658.50 rows=175 width=26) (actual time=538.469..538.480 rows=35 loops=3)
--                      Group Key: date.d_year, customer.c_nation
--                      Batches: 1  Memory Usage: 40kB
--                      Worker 0:  Batches: 1  Memory Usage: 40kB
--                      Worker 1:  Batches: 1  Memory Usage: 40kB
--                      ->  Hash Join  (cost=6295.67..125285.78 rows=37097 width=26) (actual time=41.406..528.758 rows=32758 loops=3)
--                            Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                            ->  Parallel Hash Join  (cost=6193.16..125085.73 rows=37097 width=28) (actual time=21.033..500.361 rows=32758 loops=3)
--                                  Hash Cond: (lineorder.lo_partkey = part.p_partkey)
--                                  ->  Hash Join  (cost=1024.39..119646.27 rows=103114 width=32) (actual time=4.700..457.148 rows=82215 loops=3)
--                                        Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                        ->  Hash Join  (cost=961.25..118263.20 rows=501770 width=36) (actual time=4.395..414.564 rows=401072 loops=3)
--                                              Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=24) (actual time=0.012..182.137 rows=2000390 loops=3)
--                                              ->  Hash  (cost=886.00..886.00 rows=6020 width=20) (actual time=4.347..4.348 rows=6020 loops=3)
--                                                    Buckets: 8192  Batches: 1  Memory Usage: 370kB
--                                                    ->  Seq Scan on customer  (cost=0.00..886.00 rows=6020 width=20) (actual time=0.010..3.256 rows=6020 loops=3)
--                                                          Filter: (c_region = 'MIDDLE EAST'::bpchar)
--                                                          Rows Removed by Filter: 23980
--                                        ->  Hash  (cost=58.00..58.00 rows=411 width=4) (actual time=0.281..0.281 rows=411 loops=3)
--                                              Buckets: 1024  Batches: 1  Memory Usage: 23kB
--                                              ->  Seq Scan on supplier  (cost=0.00..58.00 rows=411 width=4) (actual time=0.054..0.241 rows=411 loops=3)
--                                                    Filter: (s_region = 'MIDDLE EAST'::bpchar)
--                                                    Rows Removed by Filter: 1589
--                                  ->  Parallel Hash  (cost=4639.71..4639.71 rows=42325 width=4) (actual time=15.768..15.769 rows=26617 loops=3)
--                                        Buckets: 131072  Batches: 1  Memory Usage: 4160kB
--                                        ->  Parallel Seq Scan on part  (cost=0.00..4639.71 rows=42325 width=4) (actual time=0.021..10.254 rows=26617 loops=3)
--                                              Filter: ((p_mfgr = 'MFGR#4'::bpchar) OR (p_mfgr = 'MFGR#5'::bpchar))
--                                              Rows Removed by Filter: 40049
--                            ->  Hash  (cost=70.56..70.56 rows=2556 width=6) (actual time=20.331..20.331 rows=2556 loops=3)
--                                  Buckets: 4096  Batches: 1  Memory Usage: 132kB
--                                  ->  Seq Scan on date  (cost=0.00..70.56 rows=2556 width=6) (actual time=19.835..20.073 rows=2556 loops=3)
--  Planning Time: 2.444 ms
--  JIT:
--    Functions: 132
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 5.435 ms, Inlining 0.000 ms, Optimization 2.692 ms, Emission 57.046 ms, Total 65.173 ms
--  Execution Time: 559.621 ms
-- (48 rows)

-- Q41, FF friendly
SELECT COUNT(*)
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_REGION = 'AMERICA' -- no fuss over being the same
AND (P_MFGR = 'MFGR#4' OR P_MFGR = 'MFGR#5'); 

-- Q42
SELECT D_YEAR, S_NATION, P_CATEGORY, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_REGION = 'MIDDLE EAST' -- no fuss over being the same
AND (D_YEAR = 1992 OR D_YEAR = 1993)
AND (P_MFGR = 'MFGR#2' OR P_MFGR = 'MFGR#5')
GROUP BY D_YEAR, S_NATION, P_CATEGORY
ORDER BY D_YEAR, S_NATION, P_CATEGORY;

--                                                                                       QUERY PLAN                                                                                      
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=127172.24..128005.46 rows=4375 width=34) (actual time=770.928..778.865 rows=100 loops=1)
--    Group Key: date.d_year, supplier.s_nation, part.p_category
--    ->  Gather Merge  (cost=127172.24..127917.96 rows=4375 width=34) (actual time=770.883..778.799 rows=200 loops=1)
--          Workers Planned: 1
--          Workers Launched: 1
--          ->  Partial GroupAggregate  (cost=126172.23..126425.77 rows=4375 width=34) (actual time=761.337..764.180 rows=100 loops=2)
--                Group Key: date.d_year, supplier.s_nation, part.p_category
--                ->  Sort  (cost=126172.23..126207.19 rows=13986 width=34) (actual time=761.268..762.143 rows=14976 loops=2)
--                      Sort Key: date.d_year, supplier.s_nation, part.p_category
--                      Sort Method: quicksort  Memory: 1563kB
--                      Worker 0:  Sort Method: quicksort  Memory: 1546kB
--                      ->  Parallel Hash Join  (cost=120351.62..125209.17 rows=13986 width=34) (actual time=722.466..747.971 rows=14976 loops=2)
--                            Hash Cond: (part.p_partkey = lineorder.lo_partkey)
--                            ->  Parallel Seq Scan on part  (cost=0.00..4639.71 rows=42551 width=12) (actual time=0.029..15.299 rows=39970 loops=2)
--                                  Filter: ((p_mfgr = 'MFGR#2'::bpchar) OR (p_mfgr = 'MFGR#5'::bpchar))
--                                  Rows Removed by Filter: 60030
--                            ->  Parallel Hash  (cost=120009.22..120009.22 rows=27392 width=30) (actual time=722.010..722.015 rows=37356 loops=2)
--                                  Buckets: 131072  Batches: 1  Memory Usage: 5728kB
--                                  ->  Hash Join  (cost=1116.21..120009.22 rows=27392 width=30) (actual time=29.069..707.487 rows=37356 loops=2)
--                                        Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                                        ->  Hash Join  (cost=1024.39..119646.27 rows=103114 width=32) (actual time=4.194..665.134 rows=123322 loops=2)
--                                              Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                              ->  Hash Join  (cost=961.25..118263.20 rows=501770 width=20) (actual time=3.878..601.149 rows=601608 loops=2)
--                                                    Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                                    ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=24) (actual time=0.039..259.450 rows=3000586 loops=2)
--                                                    ->  Hash  (cost=886.00..886.00 rows=6020 width=4) (actual time=3.805..3.806 rows=6020 loops=2)
--                                                          Buckets: 8192  Batches: 1  Memory Usage: 276kB
--                                                          ->  Seq Scan on customer  (cost=0.00..886.00 rows=6020 width=4) (actual time=0.024..3.233 rows=6020 loops=2)
--                                                                Filter: (c_region = 'MIDDLE EAST'::bpchar)
--                                                                Rows Removed by Filter: 23980
--                                              ->  Hash  (cost=58.00..58.00 rows=411 width=20) (actual time=0.297..0.298 rows=411 loops=2)
--                                                    Buckets: 1024  Batches: 1  Memory Usage: 29kB
--                                                    ->  Seq Scan on supplier  (cost=0.00..58.00 rows=411 width=20) (actual time=0.020..0.240 rows=411 loops=2)
--                                                          Filter: (s_region = 'MIDDLE EAST'::bpchar)
--                                                          Rows Removed by Filter: 1589
--                                        ->  Hash  (cost=83.34..83.34 rows=679 width=6) (actual time=24.800..24.801 rows=731 loops=2)
--                                              Buckets: 1024  Batches: 1  Memory Usage: 37kB
--                                              ->  Seq Scan on date  (cost=0.00..83.34 rows=679 width=6) (actual time=24.516..24.720 rows=731 loops=2)
--                                                    Filter: ((d_year = 1992) OR (d_year = 1993))
--                                                    Rows Removed by Filter: 1825
--  Planning Time: 0.930 ms
--  JIT:
--    Functions: 99
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 3.743 ms, Inlining 0.000 ms, Optimization 2.084 ms, Emission 47.100 ms, Total 52.928 ms
--  Execution Time: 780.816 ms
-- (46 rows)

-- Q42, FF friendly
SELECT COUNT(*)
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_REGION = 'EUROPE' -- no fuss over being the same
AND (D_YEAR = 1992 OR D_YEAR = 1993)
AND (P_MFGR = 'MFGR#2' OR P_MFGR = 'MFGR#5');

-- Q43
SELECT D_YEAR, S_CITY, P_BRAND, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_NATION = 'UNITED KINGDOM' -- no fuss over nation having to be in the region
AND (D_YEAR = 1992 OR D_YEAR = 1993)
AND P_CATEGORY = 'MFGR#25'
GROUP BY D_YEAR, S_CITY, P_BRAND
ORDER BY D_YEAR, S_CITY, P_BRAND;

--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=122041.17..122101.43 rows=482 width=31) (actual time=458.500..464.170 rows=379 loops=1)
--    Group Key: date.d_year, supplier.s_city, part.p_brand
--    ->  Gather Merge  (cost=122041.17..122092.59 rows=402 width=31) (actual time=458.489..464.027 rows=487 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          ->  Partial GroupAggregate  (cost=121041.14..121046.17 rows=201 width=31) (actual time=445.203..445.279 rows=162 loops=3)
--                Group Key: date.d_year, supplier.s_city, part.p_brand
--                ->  Sort  (cost=121041.14..121041.65 rows=201 width=31) (actual time=445.168..445.181 rows=188 loops=3)
--                      Sort Key: date.d_year, supplier.s_city, part.p_brand
--                      Sort Method: quicksort  Memory: 39kB
--                      Worker 0:  Sort Method: quicksort  Memory: 40kB
--                      Worker 1:  Sort Method: quicksort  Memory: 38kB
--                      ->  Nested Loop  (cost=1112.47..121033.45 rows=201 width=31) (actual time=37.348..444.807 rows=188 loops=3)
--                            ->  Hash Join  (cost=1112.05..118734.46 rows=5198 width=25) (actual time=28.131..398.009 rows=4735 loops=3)
--                                  Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                                  ->  Hash Join  (cost=1020.23..118591.18 rows=19569 width=27) (actual time=4.250..370.665 rows=15610 loops=3)
--                                        Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                        ->  Hash Join  (cost=58.98..117373.91 rows=97520 width=31) (actual time=0.274..352.422 rows=77979 loops=3)
--                                              Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=24) (actual time=0.038..172.886 rows=2000390 loops=3)
--                                              ->  Hash  (cost=58.00..58.00 rows=78 width=15) (actual time=0.217..0.218 rows=78 loops=3)
--                                                    Buckets: 1024  Batches: 1  Memory Usage: 12kB
--                                                    ->  Seq Scan on supplier  (cost=0.00..58.00 rows=78 width=15) (actual time=0.018..0.203 rows=78 loops=3)
--                                                          Filter: (s_nation = 'UNITED KINGDOM'::bpchar)
--                                                          Rows Removed by Filter: 1922
--                                        ->  Hash  (cost=886.00..886.00 rows=6020 width=4) (actual time=3.914..3.914 rows=6020 loops=3)
--                                              Buckets: 8192  Batches: 1  Memory Usage: 276kB
--                                              ->  Seq Scan on customer  (cost=0.00..886.00 rows=6020 width=4) (actual time=0.011..3.313 rows=6020 loops=3)
--                                                    Filter: (c_region = 'MIDDLE EAST'::bpchar)
--                                                    Rows Removed by Filter: 23980
--                                  ->  Hash  (cost=83.34..83.34 rows=679 width=6) (actual time=23.825..23.825 rows=731 loops=3)
--                                        Buckets: 1024  Batches: 1  Memory Usage: 37kB
--                                        ->  Seq Scan on date  (cost=0.00..83.34 rows=679 width=6) (actual time=23.533..23.743 rows=731 loops=3)
--                                              Filter: ((d_year = 1992) OR (d_year = 1993))
--                                              Rows Removed by Filter: 1825
--                            ->  Index Scan using part_pkey on part  (cost=0.42..0.44 rows=1 width=14) (actual time=0.010..0.010 rows=0 loops=14204)
--                                  Index Cond: (p_partkey = lineorder.lo_partkey)
--                                  Filter: (p_category = 'MFGR#25'::bpchar)
--                                  Rows Removed by Filter: 1
--  Planning Time: 1.146 ms
--  JIT:
--    Functions: 135
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 6.333 ms, Inlining 0.000 ms, Optimization 3.000 ms, Emission 67.809 ms, Total 77.142 ms
--  Execution Time: 465.951 ms
-- (45 rows)

-- Q43, FF friendly
SELECT COUNT(*)
FROM DATE, CUSTOMER, SUPPLIER, PART, LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'MIDDLE EAST'
AND S_NATION = 'UNITED KINGDOM' -- no fuss over nation having to be in the region
AND (D_YEAR = 1992 OR D_YEAR = 1993)
AND P_CATEGORY = 'MFGR#25';