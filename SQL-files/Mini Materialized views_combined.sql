--MW6

--Query complete 00:03:51.463 Spazio: 4.72 GB
CREATE MATERIALIZED VIEW lineitem_orders_customer AS
SELECT
    o_orderkey,
    o_orderdate,
    o_custkey,
    l_extendedprice,
    l_discount,
    l_returnflag,
    l_partkey,
    l_suppkey,
    c_name
 FROM lineitem
    JOIN orders ON l_orderkey=o_orderkey
    JOIN customer ON c_custkey = o_custkey;

--Query complete 00:00:00.308  Space: 12.5 MB 
CREATE MATERIALIZED VIEW supplier_info AS
SELECT
    s_suppkey,
    s_name,
    n_nationkey AS s_nationkey,
    n_name AS s_nationname,
    r_regionkey AS s_regionkey,
    r_name AS s_regionname
    FROM supplier
    JOIN nation ON (s_nationkey = n_nationkey)
    JOIN region ON (n_regionkey = r_regionkey);

--Query complete 00:00:05.142. Space: 167.5 MB
CREATE MATERIALIZED VIEW customer_info AS
SELECT
    c_custkey,
    c_name,
    n_nationkey AS c_nationkey,
    n_name AS c_nationname,
    r_regionkey AS c_regionkey,
    r_name AS c_regionname
    FROM customer
    JOIN nation ON (c_nationkey = n_nationkey)
    JOIN region ON (n_regionkey = r_regionkey);



--Q1 diventa come sotto. Output 20610 righe (stesso output di prima dell'ottimization)
--Query complete 00:00:09.784
--Query complete 00:00:09.506
--Query complete 00:00:09.084
--Query complete 00:00:11.111
--Query complete 00:00:10.036
SELECT
    s_regionname AS export_region,
	c_regionname AS import_region,
	s_nationname AS export_nation,
    c_nationname AS import_nation,
    SUM(l_extendedprice * (1 - l_discount)) AS revenue,
    DATE_PART('month', o_orderdate) AS order_month,
    DATE_PART('quarter', o_orderdate) AS order_quarter,
    DATE_PART('year', o_orderdate) AS order_year,
    p_type AS ptype
FROM
    lineitem_orders_customer
    JOIN PART ON p_partkey = l_partkey
    JOIN supplier_info ON s_suppkey=l_suppkey
    JOIN customer_info ON c_custkey=o_custkey
WHERE
    s_nationname = 'FRANCE'
	AND c_nationname != s_nationname
    AND p_type = 'SMALL POLISHED TIN'
GROUP BY
    ROLLUP(p_type),
    ROLLUP(s_regionname, s_nationname),
    ROLLUP(c_regionname, c_nationname),
    ROLLUP(DATE_PART('year', o_orderdate), DATE_PART('quarter', o_orderdate), DATE_PART('month', o_orderdate));

--Q3 diventa come sotto. Output 10 righe
--Query complete 00:00:08.182
--Query complete 00:00:07.787
--Query complete 00:00:07.565
--Query complete 00:00:08.361
--Query complete 00:00:08.928
--Query complete 00:00:07.886
--Query complete 00:00:08.047

SELECT
  DATE_PART('year', o_orderdate) AS yearOrder,
  DATE_PART('quarter', o_orderdate) AS quarterOrder,
  DATE_PART('month', o_orderdate) AS monthOrder,
  c_name AS custName,
  SUM(l_extendedprice * (1 - l_discount)) AS revenue
FROM
  lineitem_orders_customer
WHERE
  l_returnflag = 'R'
  AND c_name ='Customer#000002000'
GROUP BY
  GROUPING SETS (
    (yearOrder, quarterOrder, monthOrder, custName),
    (yearOrder, quarterOrder, custName),
    (yearOrder, custName),
    (custName),
	()
  )
ORDER BY
 custName,
 COALESCE(DATE_PART('year', o_orderdate)::text, 'All Years'),
 quarterOrder,
 monthOrder;


--Q3 con rollup
--Query complete 00:00:07.860
--Query complete 00:00:08.155
--Query complete 00:00:08.848
 SELECT
  DATE_PART('year', o_orderdate) AS yearOrder,
  DATE_PART('quarter', o_orderdate) AS quarterOrder,
  DATE_PART('month', o_orderdate) AS monthOrder,
  c_name AS custName,
  SUM(l_extendedprice * (1 - l_discount)) AS revenue
FROM
  lineitem_orders_customer
WHERE
  l_returnflag = 'R'
  AND c_name ='Customer#000002000'
GROUP BY
    ROLLUP(custName),
    ROLLUP(DATE_PART('year', o_orderdate), DATE_PART('quarter', o_orderdate), DATE_PART('month', o_orderdate));



--materialized view solo per la terza query
--3 min 27 secs
CREATE MATERIALIZED VIEW MW_for_q3 AS
SELECT
    o_orderdate,
    c_name,
    l_extendedprice,
    l_discount,
    l_returnflag    
 FROM lineitem
    JOIN orders ON l_orderkey=o_orderkey
    JOIN customer ON c_custkey = o_custkey;

--Q3 diventa
--Query complete 00:00:24.093
--Query complete 00:00:06.471
--Query complete 00:00:07.899
--Query complete 00:00:09.662
--Query complete 00:00:09.439

SELECT
  DATE_PART('year', o_orderdate) AS yearOrder,
  DATE_PART('quarter', o_orderdate) AS quarterOrder,
  DATE_PART('month', o_orderdate) AS monthOrder,
  c_name AS custName,
  SUM(l_extendedprice * (1 - l_discount)) AS revenue
FROM
  lineitem_orders_customer
WHERE
  l_returnflag = 'R'
  AND c_name ='Customer#000002000'
GROUP BY
  GROUPING SETS (
    (yearOrder, quarterOrder, monthOrder, custName),
    (yearOrder, quarterOrder, custName),
    (yearOrder, custName),
    (custName),
	()
  )
ORDER BY
 custName,
 COALESCE(DATE_PART('year', o_orderdate)::text, 'All Years'),
 quarterOrder,
 monthOrder;