-- Q31 
SELECT C_NATION, S_NATION, D_YEAR, SUM(LO_REVENUE) as REVENUE
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'EUROPE' AND S_REGION = 'EUROPE' -- no fuss over being the same
AND D_YEAR >= 1992 AND D_YEAR <= 1997
GROUP BY C_NATION, S_NATION, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;
--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=123474.57..123485.51 rows=4375 width=42) (actual time=547.619..554.925 rows=150 loops=1)
--    Sort Key: date.d_year, (sum(lineorder.lo_revenue)) DESC
--    Sort Method: quicksort  Memory: 36kB
--    ->  Finalize GroupAggregate  (cost=122057.84..123209.99 rows=4375 width=42) (actual time=547.330..554.826 rows=150 loops=1)
--          Group Key: customer.c_nation, supplier.s_nation, date.d_year
--          ->  Gather Merge  (cost=122057.84..123078.74 rows=8750 width=42) (actual time=547.299..554.716 rows=450 loops=1)
--                Workers Planned: 2
--                Workers Launched: 2
--                ->  Sort  (cost=121057.81..121068.75 rows=4375 width=42) (actual time=533.770..533.782 rows=150 loops=3)
--                      Sort Key: customer.c_nation, supplier.s_nation, date.d_year
--                      Sort Method: quicksort  Memory: 36kB
--                      Worker 0:  Sort Method: quicksort  Memory: 36kB
--                      Worker 1:  Sort Method: quicksort  Memory: 36kB
--                      ->  Partial HashAggregate  (cost=120749.48..120793.23 rows=4375 width=42) (actual time=533.548..533.587 rows=150 loops=3)
--                            Group Key: customer.c_nation, supplier.s_nation, date.d_year
--                            Batches: 1  Memory Usage: 241kB
--                            Worker 0:  Batches: 1  Memory Usage: 241kB
--                            Worker 1:  Batches: 1  Memory Usage: 241kB
--                            ->  Hash Join  (cost=1133.70..119943.16 rows=80632 width=38) (actual time=30.625..510.320 rows=69566 loops=3)
--                                  Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                                  ->  Hash Join  (cost=1022.96..119585.20 rows=94022 width=40) (actual time=9.370..473.258 rows=76381 loops=3)
--                                        Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                        ->  Hash Join  (cost=62.75..117377.68 rows=475098 width=28) (actual time=0.306..417.152 rows=380104 loops=3)
--                                              Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=16) (actual time=0.021..178.283 rows=2000390 loops=3)
--                                              ->  Hash  (cost=58.00..58.00 rows=380 width=20) (actual time=0.268..0.269 rows=380 loops=3)
--                                                    Buckets: 1024  Batches: 1  Memory Usage: 28kB
--                                                    ->  Seq Scan on supplier  (cost=0.00..58.00 rows=380 width=20) (actual time=0.018..0.216 rows=380 loops=3)
--                                                          Filter: (s_region = 'EUROPE'::bpchar)
--                                                          Rows Removed by Filter: 1620
--                                        ->  Hash  (cost=886.00..886.00 rows=5937 width=20) (actual time=9.000..9.001 rows=5937 loops=3)
--                                              Buckets: 8192  Batches: 1  Memory Usage: 366kB
--                                              ->  Seq Scan on customer  (cost=0.00..886.00 rows=5937 width=20) (actual time=0.636..7.356 rows=5937 loops=3)
--                                                    Filter: (c_region = 'EUROPE'::bpchar)
--                                                    Rows Removed by Filter: 24063
--                                  ->  Hash  (cost=83.34..83.34 rows=2192 width=6) (actual time=21.195..21.195 rows=2192 loops=3)
--                                        Buckets: 4096  Batches: 1  Memory Usage: 118kB
--                                        ->  Seq Scan on date  (cost=0.00..83.34 rows=2192 width=6) (actual time=20.707..20.964 rows=2192 loops=3)
--                                              Filter: ((d_year >= 1992) AND (d_year <= 1997))
--                                              Rows Removed by Filter: 364
--  Planning Time: 5.884 ms
--  JIT:
--    Functions: 114
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 4.956 ms, Inlining 0.000 ms, Optimization 2.720 ms, Emission 59.571 ms, Total 67.246 ms
--  Execution Time: 556.631 ms
-- (46 rows)

-- Q31, FF friendly
SELECT COUNT(*)
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_REGION = 'EUROPE' AND S_REGION = 'AFRICA' -- no fuss over being the same
AND D_YEAR >= 1992 AND D_YEAR <= 1997;

-- Q32
SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_NATION = 'UNITED KINGDOM'
AND S_NATION = 'IRAN'
AND D_YEAR >= 1992 AND D_YEAR <= 1997
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=121500.22..121521.87 rows=8661 width=32) (actual time=396.625..401.436 rows=600 loops=1)
--    Sort Key: date.d_year, (sum(lineorder.lo_revenue)) DESC
--    Sort Method: quicksort  Memory: 71kB
--    ->  Finalize GroupAggregate  (cost=119860.65..120933.78 rows=8661 width=32) (actual time=394.923..401.026 rows=600 loops=1)
--          Group Key: customer.c_city, supplier.s_city, date.d_year
--          ->  Gather Merge  (cost=119860.65..120774.99 rows=7218 width=32) (actual time=394.907..400.727 rows=1777 loops=1)
--                Workers Planned: 2
--                Workers Launched: 2
--                ->  Partial GroupAggregate  (cost=118860.62..118941.83 rows=3609 width=32) (actual time=380.864..381.498 rows=592 loops=3)
--                      Group Key: customer.c_city, supplier.s_city, date.d_year
--                      ->  Sort  (cost=118860.62..118869.65 rows=3609 width=28) (actual time=380.825..380.974 rows=2999 loops=3)
--                            Sort Key: customer.c_city, supplier.s_city, date.d_year
--                            Sort Method: quicksort  Memory: 335kB
--                            Worker 0:  Sort Method: quicksort  Memory: 326kB
--                            Worker 1:  Sort Method: quicksort  Memory: 332kB
--                            ->  Hash Join  (cost=1070.82..118647.38 rows=3609 width=28) (actual time=25.972..377.197 rows=2999 loops=3)
--                                  Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                                  ->  Hash Join  (cost=960.07..118525.57 rows=4208 width=30) (actual time=3.873..353.554 rows=3286 loops=3)
--                                        Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                        ->  Hash Join  (cost=901.02..118202.97 rows=100188 width=23) (actual time=3.558..346.615 rows=79059 loops=3)
--                                              Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=16) (actual time=0.051..174.429 rows=2000390 loops=3)
--                                              ->  Hash  (cost=886.00..886.00 rows=1202 width=15) (actual time=3.447..3.448 rows=1202 loops=3)
--                                                    Buckets: 2048  Batches: 1  Memory Usage: 73kB
--                                                    ->  Seq Scan on customer  (cost=0.00..886.00 rows=1202 width=15) (actual time=0.017..3.173 rows=1202 loops=3)
--                                                          Filter: (c_nation = 'UNITED KINGDOM'::bpchar)
--                                                          Rows Removed by Filter: 28798
--                                        ->  Hash  (cost=58.00..58.00 rows=84 width=15) (actual time=0.225..0.226 rows=84 loops=3)
--                                              Buckets: 1024  Batches: 1  Memory Usage: 12kB
--                                              ->  Seq Scan on supplier  (cost=0.00..58.00 rows=84 width=15) (actual time=0.030..0.210 rows=84 loops=3)
--                                                    Filter: (s_nation = 'IRAN'::bpchar)
--                                                    Rows Removed by Filter: 1916
--                                  ->  Hash  (cost=83.34..83.34 rows=2192 width=6) (actual time=22.070..22.071 rows=2192 loops=3)
--                                        Buckets: 4096  Batches: 1  Memory Usage: 118kB
--                                        ->  Seq Scan on date  (cost=0.00..83.34 rows=2192 width=6) (actual time=21.501..21.821 rows=2192 loops=3)
--                                              Filter: ((d_year >= 1992) AND (d_year <= 1997))
--                                              Rows Removed by Filter: 364
--  Planning Time: 0.557 ms
--  JIT:
--    Functions: 117
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 5.480 ms, Inlining 0.000 ms, Optimization 2.818 ms, Emission 61.854 ms, Total 70.152 ms
--  Execution Time: 403.057 ms
-- (43 rows)

-- Q32, FF friendly
SELECT COUNT(*)
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND C_NATION = 'IRAN'
AND S_NATION = 'IRAN' -- no fuss over being the same
AND D_YEAR >= 1992 AND D_YEAR <= 1997;

-- Q33
SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND (C_CITY = 'IRAN     1' OR C_CITY = 'IRAN     2') -- DO fuss over being from the same country. DO fuss over not being the same city
AND (S_CITY = 'IRAN     1' OR S_CITY = 'IRAN     2') -- DO NOT fuss over being the same cities as above
AND D_YEAR >= 1992 AND D_YEAR <= 1995
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;
--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=119459.94..119460.46 rows=206 width=32) (actual time=360.133..365.765 rows=16 loops=1)
--    Sort Key: date.d_year, (sum(lineorder.lo_revenue)) DESC
--    Sort Method: quicksort  Memory: 26kB
--    ->  Finalize GroupAggregate  (cost=119426.46..119452.02 rows=206 width=32) (actual time=360.083..365.754 rows=16 loops=1)
--          Group Key: customer.c_city, supplier.s_city, date.d_year
--          ->  Gather Merge  (cost=119426.46..119448.24 rows=172 width=32) (actual time=360.067..365.733 rows=48 loops=1)
--                Workers Planned: 2
--                Workers Launched: 2
--                ->  Partial GroupAggregate  (cost=118426.43..118428.37 rows=86 width=32) (actual time=346.959..346.981 rows=16 loops=3)
--                      Group Key: customer.c_city, supplier.s_city, date.d_year
--                      ->  Sort  (cost=118426.43..118426.65 rows=86 width=28) (actual time=346.919..346.927 rows=91 loops=3)
--                            Sort Key: customer.c_city, supplier.s_city, date.d_year
--                            Sort Method: quicksort  Memory: 33kB
--                            Worker 0:  Sort Method: quicksort  Memory: 31kB
--                            Worker 1:  Sort Method: quicksort  Memory: 31kB
--                            ->  Nested Loop  (cost=1027.29..118423.67 rows=86 width=28) (actual time=27.332..346.767 rows=91 loops=3)
--                                  ->  Hash Join  (cost=1027.01..118378.29 rows=150 width=30) (actual time=24.211..345.341 rows=157 loops=3)
--                                        Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                        ->  Hash Join  (cost=963.81..118265.76 rows=18754 width=23) (actual time=3.044..324.199 rows=16403 loops=3)
--                                              Hash Cond: (lineorder.lo_custkey = customer.c_custkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=16) (actual time=0.042..171.198 rows=2000390 loops=3)
--                                              ->  Hash  (cost=961.00..961.00 rows=225 width=15) (actual time=2.894..2.895 rows=234 loops=3)
--                                                    Buckets: 1024  Batches: 1  Memory Usage: 19kB
--                                                    ->  Seq Scan on customer  (cost=0.00..961.00 rows=225 width=15) (actual time=0.026..2.849 rows=234 loops=3)
--                                                          Filter: ((c_city = 'IRAN     1'::bpchar) OR (c_city = 'IRAN     2'::bpchar))
--                                                          Rows Removed by Filter: 29766
--                                        ->  Hash  (cost=63.00..63.00 rows=16 width=15) (actual time=19.573..19.573 rows=18 loops=3)
--                                              Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                              ->  Seq Scan on supplier  (cost=0.00..63.00 rows=16 width=15) (actual time=19.398..19.558 rows=18 loops=3)
--                                                    Filter: ((s_city = 'IRAN     1'::bpchar) OR (s_city = 'IRAN     2'::bpchar))
--                                                    Rows Removed by Filter: 1982
--                                  ->  Index Scan using date_pkey on date  (cost=0.28..0.30 rows=1 width=6) (actual time=0.007..0.007 rows=1 loops=470)
--                                        Index Cond: (d_datekey = lineorder.lo_orderdate)
--                                        Filter: ((d_year >= 1992) AND (d_year <= 1995))
--                                        Rows Removed by Filter: 0
--  Planning Time: 0.557 ms
--  JIT:
--    Functions: 108
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 4.583 ms, Inlining 0.000 ms, Optimization 2.351 ms, Emission 55.933 ms, Total 62.867 ms
--  Execution Time: 367.322 ms
-- (41 rows)

-- Q33, FF friendly
SELECT COUNT(*)
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND (C_CITY = 'IRAN     1' OR C_CITY = 'IRAN     2') -- DO fuss over being from the same country. DO fuss over not being the same city
AND (S_CITY = 'MOZAMBIQU4' OR S_CITY = 'MOZAMBIQU1') -- DO NOT fuss over being the same cities as above
AND D_YEAR >= 1992 AND D_YEAR <= 1995;


-- Q34 
SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND (C_CITY = 'IRAN     1' OR C_CITY = 'IRAN     2') -- DO fuss over being from the same country. DO fuss over not being the same city
AND (S_CITY = 'MOZAMBIQU4' OR S_CITY = 'MOZAMBIQU1') -- DO NOT fuss over being the same cities as above
AND D_YEARMONTH = 'Dec1994'
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

--                                                                                    QUERY PLAN                                                                                   
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=118600.10..118600.11 rows=5 width=32) (actual time=378.122..383.661 rows=4 loops=1)
--    Sort Key: date.d_year, (sum(lineorder.lo_revenue)) DESC
--    Sort Method: quicksort  Memory: 25kB
--    ->  Finalize GroupAggregate  (cost=118599.44..118600.04 rows=5 width=32) (actual time=378.113..383.655 rows=4 loops=1)
--          Group Key: customer.c_city, supplier.s_city, date.d_year
--          ->  Gather Merge  (cost=118599.44..118599.95 rows=4 width=32) (actual time=378.096..383.639 rows=9 loops=1)
--                Workers Planned: 2
--                Workers Launched: 2
--                ->  Partial GroupAggregate  (cost=117599.42..117599.46 rows=2 width=32) (actual time=365.871..365.876 rows=3 loops=3)
--                      Group Key: customer.c_city, supplier.s_city, date.d_year
--                      ->  Sort  (cost=117599.42..117599.42 rows=2 width=28) (actual time=365.835..365.839 rows=4 loops=3)
--                            Sort Key: customer.c_city, supplier.s_city, date.d_year
--                            Sort Method: quicksort  Memory: 25kB
--                            Worker 0:  Sort Method: quicksort  Memory: 25kB
--                            Worker 1:  Sort Method: quicksort  Memory: 25kB
--                            ->  Nested Loop  (cost=140.85..117599.41 rows=2 width=28) (actual time=63.759..365.799 rows=4 loops=3)
--                                  ->  Hash Join  (cost=140.56..117514.67 rows=273 width=21) (actual time=21.324..359.737 rows=229 loops=3)
--                                        Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                                        ->  Hash Join  (cost=63.23..117378.16 rows=22505 width=23) (actual time=20.093..357.358 rows=17982 loops=3)
--                                              Hash Cond: (lineorder.lo_suppkey = supplier.s_suppkey)
--                                              ->  Parallel Seq Scan on lineorder  (cost=0.00..110737.17 rows=2500517 width=16) (actual time=0.017..172.785 rows=2000390 loops=3)
--                                              ->  Hash  (cost=63.00..63.00 rows=18 width=15) (actual time=20.026..20.027 rows=18 loops=3)
--                                                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                                    ->  Seq Scan on supplier  (cost=0.00..63.00 rows=18 width=15) (actual time=19.844..20.013 rows=18 loops=3)
--                                                          Filter: ((s_city = 'MOZAMBIQU4'::bpchar) OR (s_city = 'MOZAMBIQU1'::bpchar))
--                                                          Rows Removed by Filter: 1982
--                                        ->  Hash  (cost=76.95..76.95 rows=31 width=6) (actual time=0.225..0.226 rows=31 loops=3)
--                                              Buckets: 1024  Batches: 1  Memory Usage: 10kB
--                                              ->  Seq Scan on date  (cost=0.00..76.95 rows=31 width=6) (actual time=0.095..0.219 rows=31 loops=3)
--                                                    Filter: (d_yearmonth = 'Dec1994'::bpchar)
--                                                    Rows Removed by Filter: 2525
--                                  ->  Index Scan using customer_pkey on customer  (cost=0.29..0.31 rows=1 width=15) (actual time=0.025..0.025 rows=0 loops=687)
--                                        Index Cond: (c_custkey = lineorder.lo_custkey)
--                                        Filter: ((c_city = 'IRAN     1'::bpchar) OR (c_city = 'IRAN     2'::bpchar))
--                                        Rows Removed by Filter: 1
--  Planning Time: 0.692 ms
--  JIT:
--    Functions: 108
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 4.335 ms, Inlining 0.000 ms, Optimization 2.581 ms, Emission 57.059 ms, Total 63.976 ms
--  Execution Time: 385.192 ms
-- (41 rows)

-- Q34, FF friendly
SELECT COUNT(*)
FROM CUSTOMER, LINEORDER, SUPPLIER, DATE
WHERE LO_CUSTKEY = C_CUSTKEY
AND LO_SUPPKEY = S_SUPPKEY
AND LO_ORDERDATE = D_DATEKEY
AND (C_CITY = 'IRAN     1' OR C_CITY = 'IRAN     2') -- DO fuss over being from the same country. DO fuss over not being the same city
AND (S_CITY = 'MOZAMBIQU4' OR S_CITY = 'MOZAMBIQU1') -- DO NOT fuss over being the same cities as above
AND D_YEARMONTH = 'Dec1994';