-- Q21 
SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_CATEGORY = 'MFGR#12'
AND S_REGION = 'AMERICA'
GROUP BY D_YEAR, P_BRAND
ORDER BY D_YEAR, P_BRAND;

--                                                                                 QUERY PLAN                                                                                
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=123843.33..125651.78 rows=7000 width=20) (actual time=539.199..545.192 rows=280 loops=1)
--    Group Key: date.d_year, part.p_brand
--    ->  Gather Merge  (cost=123843.33..125476.78 rows=14000 width=20) (actual time=539.169..545.052 rows=840 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          ->  Sort  (cost=122843.31..122860.81 rows=7000 width=20) (actual time=523.857..523.877 rows=280 loops=3)
--                Sort Key: date.d_year, part.p_brand
--                Sort Method: quicksort  Memory: 46kB
--                Worker 0:  Sort Method: quicksort  Memory: 46kB
--                Worker 1:  Sort Method: quicksort  Memory: 46kB
--                ->  Partial HashAggregate  (cost=122326.25..122396.25 rows=7000 width=20) (actual time=523.578..523.633 rows=280 loops=3)
--                      Group Key: date.d_year, part.p_brand
--                      Batches: 1  Memory Usage: 241kB
--                      Worker 0:  Batches: 1  Memory Usage: 241kB
--                      Worker 1:  Batches: 1  Memory Usage: 241kB
--                      ->  Hash Join  (cost=4569.75..122184.24 rows=18935 width=16) (actual time=85.153..517.703 rows=14858 loops=3)
--                            Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                            ->  Hash Join  (cost=4467.24..122031.94 rows=18935 width=18) (actual time=66.433..493.605 rows=14858 loops=3)
--                                  Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                  ->  Parallel Hash Join  (cost=4404.51..121705.68 rows=100183 width=22) (actual time=64.941..481.507 rows=78939 loops=3)
--                                        Hash Cond: (lineorder.lo_partkey = part.p_partkey)
--                                        ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=16) (actual time=0.023..177.268 rows=2000390 loops=3)
--                                        ->  Parallel Hash  (cost=4345.59..4345.59 rows=4714 width=14) (actual time=64.729..64.730 rows=2628 loops=3)
--                                              Buckets: 8192  Batches: 1  Memory Usage: 512kB
--                                              ->  Parallel Seq Scan on part  (cost=0.00..4345.59 rows=4714 width=14) (actual time=0.186..63.426 rows=2628 loops=3)
--                                                    Filter: (p_category = 'MFGR#12'::bpchar)
--                                                    Rows Removed by Filter: 64039
--                                  ->  Hash  (cost=58.00..58.00 rows=378 width=4) (actual time=1.400..1.400 rows=378 loops=3)
--                                        Buckets: 1024  Batches: 1  Memory Usage: 22kB
--                                        ->  Seq Scan on supplier  (cost=0.00..58.00 rows=378 width=4) (actual time=0.509..1.344 rows=378 loops=3)
--                                              Filter: (s_region = 'AMERICA'::bpchar)
--                                              Rows Removed by Filter: 1622
--                            ->  Hash  (cost=70.56..70.56 rows=2556 width=6) (actual time=18.683..18.684 rows=2556 loops=3)
--                                  Buckets: 4096  Batches: 1  Memory Usage: 132kB
--                                  ->  Seq Scan on date  (cost=0.00..70.56 rows=2556 width=6) (actual time=18.127..18.378 rows=2556 loops=3)
--  Planning Time: 5.249 ms
--  JIT:
--    Functions: 105
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 5.458 ms, Inlining 0.000 ms, Optimization 2.864 ms, Emission 51.743 ms, Total 60.065 ms
--  Execution Time: 546.766 ms
-- (41 rows)

-- Q21, FF friendly
SELECT COUNT(*)
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_CATEGORY = 'MFGR#12'
AND S_REGION = 'AMERICA';

-- Q22
SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_BRAND BETWEEN 'MFGR#2208' AND 'MFGR#2215'
AND S_REGION = 'MIDDLE EAST'
GROUP BY D_YEAR, P_BRAND
ORDER BY D_YEAR, P_BRAND;

--                                                                            QUERY PLAN                                                                            
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=118675.04..119604.97 rows=6111 width=20) (actual time=349.835..357.108 rows=56 loops=1)
--    Group Key: date.d_year, part.p_brand
--    ->  Gather Merge  (cost=118675.04..119498.03 rows=6111 width=20) (actual time=349.808..357.074 rows=112 loops=1)
--          Workers Planned: 1
--          Workers Launched: 1
--          ->  Partial GroupAggregate  (cost=117675.03..117810.53 rows=6111 width=20) (actual time=340.347..341.044 rows=56 loops=2)
--                Group Key: date.d_year, part.p_brand
--                ->  Sort  (cost=117675.03..117693.63 rows=7439 width=16) (actual time=340.299..340.536 rows=4948 loops=2)
--                      Sort Key: date.d_year, part.p_brand
--                      Sort Method: quicksort  Memory: 433kB
--                      Worker 0:  Sort Method: quicksort  Memory: 416kB
--                      ->  Hash Join  (cost=166.08..117196.67 rows=7439 width=16) (actual time=17.358..336.540 rows=4948 loops=2)
--                            Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                            ->  Hash Join  (cost=63.57..117074.60 rows=7439 width=18) (actual time=16.827..333.185 rows=4948 loops=2)
--                                  Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                  ->  Nested Loop  (cost=0.43..116916.23 rows=36202 width=22) (actual time=16.506..326.322 rows=23938 loops=2)
--                                        ->  Parallel Seq Scan on part  (cost=0.00..4639.71 rows=1206 width=14) (actual time=15.553..34.079 rows=798 loops=2)
--                                              Filter: ((p_brand >= 'MFGR#2208'::bpchar) AND (p_brand <= 'MFGR#2215'::bpchar))
--                                              Rows Removed by Filter: 99202
--                                        ->  Index Scan using l_pk on lineorder  (cost=0.43..92.80 rows=30 width=16) (actual time=0.217..0.356 rows=30 loops=1595)
--                                              Index Cond: (lo_partkey = part.p_partkey)
--                                  ->  Hash  (cost=58.00..58.00 rows=411 width=4) (actual time=0.252..0.253 rows=411 loops=2)
--                                        Buckets: 1024  Batches: 1  Memory Usage: 23kB
--                                        ->  Seq Scan on supplier  (cost=0.00..58.00 rows=411 width=4) (actual time=0.016..0.211 rows=411 loops=2)
--                                              Filter: (s_region = 'MIDDLE EAST'::bpchar)
--                                              Rows Removed by Filter: 1589
--                            ->  Hash  (cost=70.56..70.56 rows=2556 width=6) (actual time=0.519..0.520 rows=2556 loops=2)
--                                  Buckets: 4096  Batches: 1  Memory Usage: 132kB
--                                  ->  Seq Scan on date  (cost=0.00..70.56 rows=2556 width=6) (actual time=0.009..0.251 rows=2556 loops=2)
--  Planning Time: 0.540 ms
--  JIT:
--    Functions: 63
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 2.402 ms, Inlining 0.000 ms, Optimization 1.405 ms, Emission 29.781 ms, Total 33.587 ms
--  Execution Time: 358.511 ms
-- (35 rows)

-- Q22, FF friendly
SELECT COUNT(*)
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_BRAND BETWEEN 'MFGR#2208' AND 'MFGR#2215'
AND S_REGION = 'MIDDLE EAST';

-- Q23
SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_BRAND = 'MFGR#2221'
AND S_REGION = 'EUROPE'
GROUP BY D_YEAR, P_BRAND
ORDER BY D_YEAR, P_BRAND;
--                                                                          QUERY PLAN                                                                         
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize GroupAggregate  (cost=19558.00..19662.72 rows=1134 width=20) (actual time=56.597..62.260 rows=7 loops=1)
--    Group Key: date.d_year, part.p_brand
--    ->  Gather Merge  (cost=19558.00..19646.38 rows=667 width=20) (actual time=56.575..62.250 rows=14 loops=1)
--          Workers Planned: 1
--          Workers Launched: 1
--          ->  Partial GroupAggregate  (cost=18557.99..18571.33 rows=667 width=20) (actual time=46.969..47.040 rows=7 loops=2)
--                Group Key: date.d_year, part.p_brand
--                ->  Sort  (cost=18557.99..18559.66 rows=667 width=16) (actual time=46.947..46.977 rows=547 loops=2)
--                      Sort Key: date.d_year
--                      Sort Method: quicksort  Memory: 57kB
--                      Worker 0:  Sort Method: quicksort  Memory: 43kB
--                      ->  Hash Join  (cost=169.88..18526.71 rows=667 width=16) (actual time=2.144..46.720 rows=547 loops=2)
--                            Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                            ->  Hash Join  (cost=67.37..18422.44 rows=667 width=18) (actual time=1.479..45.730 rows=547 loops=2)
--                                  Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                  ->  Nested Loop  (cost=4.62..18350.45 rows=3512 width=22) (actual time=1.011..44.656 rows=2924 loops=2)
--                                        ->  Parallel Seq Scan on part  (cost=0.00..4345.59 rows=117 width=14) (actual time=0.117..12.232 rows=102 loops=2)
--                                              Filter: (p_brand = 'MFGR#2221'::bpchar)
--                                              Rows Removed by Filter: 99898
--                                        ->  Bitmap Heap Scan on lineorder  (cost=4.62..119.40 rows=30 width=16) (actual time=0.185..0.310 rows=29 loops=203)
--                                              Recheck Cond: (lo_partkey = part.p_partkey)
--                                              Heap Blocks: exact=3691
--                                              ->  Bitmap Index Scan on l_pk  (cost=0.00..4.62 rows=30 width=0) (actual time=0.175..0.175 rows=29 loops=203)
--                                                    Index Cond: (lo_partkey = part.p_partkey)
--                                  ->  Hash  (cost=58.00..58.00 rows=380 width=4) (actual time=0.325..0.325 rows=380 loops=2)
--                                        Buckets: 1024  Batches: 1  Memory Usage: 22kB
--                                        ->  Seq Scan on supplier  (cost=0.00..58.00 rows=380 width=4) (actual time=0.017..0.282 rows=380 loops=2)
--                                              Filter: (s_region = 'EUROPE'::bpchar)
--                                              Rows Removed by Filter: 1620
--                            ->  Hash  (cost=70.56..70.56 rows=2556 width=6) (actual time=0.645..0.646 rows=2556 loops=2)
--                                  Buckets: 4096  Batches: 1  Memory Usage: 132kB
--                                  ->  Seq Scan on date  (cost=0.00..70.56 rows=2556 width=6) (actual time=0.009..0.320 rows=2556 loops=2)
--  Planning Time: 0.699 ms
--  Execution Time: 62.337 ms
-- (34 rows)

-- Q23, FF friendly
SELECT COUNT(*)
FROM LINEORDER, DATE, PART, SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
AND LO_PARTKEY = P_PARTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND P_BRAND = 'MFGR#2221'
AND S_REGION = 'EUROPE';