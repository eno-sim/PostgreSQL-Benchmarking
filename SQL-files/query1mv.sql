SELECT
    s_regionname AS export_region,
	c_regionname AS import_region,
	s_nationname AS export_nation,
    c_nationname AS import_nation,
    SUM(revenue) AS total_revenue,
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
