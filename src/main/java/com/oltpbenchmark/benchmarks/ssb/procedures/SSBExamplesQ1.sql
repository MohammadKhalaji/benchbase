
-- Q11
SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_YEAR = 1993
AND LO_DISCOUNT BETWEEN 2 AND 4
AND LO_QUANTITY < 25;

--                                                                       QUERY PLAN                                                                      
-- -------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize Aggregate  (cost=131685.42..131685.43 rows=1 width=8) (actual time=1016.593..1025.758 rows=1 loops=1)
--    ->  Gather  (cost=131685.21..131685.42 rows=2 width=8) (actual time=1016.376..1025.730 rows=3 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          ->  Partial Aggregate  (cost=130685.21..130685.22 rows=1 width=8) (actual time=1001.940..1001.943 rows=1 loops=3)
--                ->  Hash Join  (cost=81.51..130447.59 rows=47524 width=6) (actual time=20.133..996.210 rows=39563 loops=3)
--                      Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                      ->  Parallel Seq Scan on lineorder  (cost=0.00..129491.04 rows=332795 width=10) (actual time=17.532..954.706 rows=261834 loops=3)
--                            Filter: ((lo_discount >= 2) AND (lo_discount <= 4) AND (lo_quantity < 25))
--                            Rows Removed by Filter: 1738556
--                      ->  Hash  (cost=76.95..76.95 rows=365 width=4) (actual time=2.256..2.257 rows=365 loops=3)
--                            Buckets: 1024  Batches: 1  Memory Usage: 21kB
--                            ->  Seq Scan on date  (cost=0.00..76.95 rows=365 width=4) (actual time=1.041..1.758 rows=365 loops=3)
--                                  Filter: (d_year = 1993)
--                                  Rows Removed by Filter: 2191
--  Planning Time: 15.001 ms
--  JIT:
--    Functions: 50
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 3.345 ms, Inlining 0.000 ms, Optimization 3.783 ms, Emission 47.212 ms, Total 54.340 ms
--  Execution Time: 1164.841 ms

-- Q11, FF friendly 
SELECT COUNT(*)
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_YEAR = 1994
AND LO_DISCOUNT BETWEEN 6 AND 8
AND LO_QUANTITY < 25;

-- Q12
SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_YEARMONTHNUM = 199403
AND LO_DISCOUNT BETWEEN 2 AND 4
AND LO_QUANTITY BETWEEN 25 AND 36;

--                                                                       QUERY PLAN                                                                      
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--  Finalize Aggregate  (cost=137271.72..137271.73 rows=1 width=8) (actual time=259.394..264.659 rows=1 loops=1)
--    ->  Gather  (cost=137271.51..137271.72 rows=2 width=8) (actual time=259.239..264.643 rows=3 loops=1)
--          Workers Planned: 2
--          Workers Launched: 2
--          ->  Partial Aggregate  (cost=136271.51..136271.52 rows=1 width=8) (actual time=247.568..247.570 rows=1 loops=3)
--                ->  Hash Join  (cost=77.34..136261.32 rows=2037 width=6) (actual time=10.440..247.259 rows=1702 loops=3)
--                      Hash Cond: (lineorder.lo_orderdate = date.d_datekey)
--                      ->  Parallel Seq Scan on lineorder  (cost=0.00..135742.33 rows=167969 width=10) (actual time=9.925..235.907 rows=131251 loops=3)
--                            Filter: ((lo_discount >= 2) AND (lo_discount <= 4) AND (lo_quantity >= 25) AND (lo_quantity <= 36))
--                            Rows Removed by Filter: 1869139
--                      ->  Hash  (cost=76.95..76.95 rows=31 width=4) (actual time=0.196..0.197 rows=31 loops=3)
--                            Buckets: 1024  Batches: 1  Memory Usage: 10kB
--                            ->  Seq Scan on date  (cost=0.00..76.95 rows=31 width=4) (actual time=0.073..0.187 rows=31 loops=3)
--                                  Filter: (d_yearmonthnum = 199403)
--                                  Rows Removed by Filter: 2525
--  Planning Time: 0.228 ms
--  JIT:
--    Functions: 50
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 2.765 ms, Inlining 0.000 ms, Optimization 1.608 ms, Emission 28.138 ms, Total 32.512 ms
--  Execution Time: 265.616 ms
-- (21 rows)

-- Q12, FF friendly
SELECT COUNT(*)
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_YEARMONTHNUM = 199403
AND LO_DISCOUNT BETWEEN 2 AND 4
AND LO_QUANTITY BETWEEN 25 AND 36;

-- Q13
SELECT SUM(LO_EXTENDEDPRICE * LO_DISCOUNT) AS REVENUE
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_WEEKNUMINYEAR = 26
AND D_YEAR = 1992
AND LO_DISCOUNT BETWEEN 2 AND 4
AND LO_QUANTITY BETWEEN 25 AND 29;

--                                                            QUERY PLAN                                                           
-- --------------------------------------------------------------------------------------------------------------------------------
--  Aggregate  (cost=56367.31..56367.32 rows=1 width=8) (actual time=43.275..43.278 rows=1 loops=1)
--    ->  Nested Loop  (cost=31.15..56364.99 rows=464 width=6) (actual time=1.523..43.136 rows=486 loops=1)
--          ->  Seq Scan on date  (cost=0.00..83.34 rows=7 width=4) (actual time=0.023..0.251 rows=7 loops=1)
--                Filter: ((d_weeknuminyear = 26) AND (d_year = 1992))
--                Rows Removed by Filter: 2549
--          ->  Bitmap Heap Scan on lineorder  (cost=31.15..8039.54 rows=70 width=10) (actual time=1.516..6.104 rows=69 loops=7)
--                Recheck Cond: (lo_orderdate = date.d_datekey)
--                Filter: ((lo_discount >= 2) AND (lo_discount <= 4) AND (lo_quantity >= 25) AND (lo_quantity <= 29))
--                Rows Removed by Filter: 2477
--                Heap Blocks: exact=4587
--                ->  Bitmap Index Scan on l_od  (cost=0.00..31.14 rows=2494 width=0) (actual time=1.301..1.301 rows=2546 loops=7)
--                      Index Cond: (lo_orderdate = date.d_datekey)
--  Planning Time: 1.794 ms
--  Execution Time: 43.343 ms
-- (14 rows)

-- Q13, FF friendly
SELECT COUNT(*)
FROM LINEORDER, DATE
WHERE LO_ORDERDATE = D_DATEKEY
AND D_WEEKNUMINYEAR = 26
AND D_YEAR = 1992
AND LO_DISCOUNT BETWEEN 2 AND 4
AND LO_QUANTITY BETWEEN 25 AND 29;