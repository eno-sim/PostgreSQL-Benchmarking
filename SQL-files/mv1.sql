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


