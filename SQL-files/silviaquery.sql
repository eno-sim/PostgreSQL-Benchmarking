--updated query 1
SELECT
	DATE_PART('year', orderdate) AS order_year,
    DATE_PART('quarter', orderdate) AS order_quarter,
    DATE_PART('month', orderdate) AS order_month,
    Exp.n_name AS exp_nation,
	Imp.n_name AS imp_nation,
	Exp.r_name AS exp_region,
	Imp.r_name AS imp_region,
    SUM(revenue) AS total_revenue,
    ptype
FROM
    mv_q1
JOIN MV_nations_regions AS Exp ON Exp.n_nationkey=mv_q1.export_nation
JOIN MV_nations_regions AS Imp ON Imp.n_nationkey=mv_q1.import_nation

WHERE
    Exp.n_name = 'FRANCE'
    AND ptype = 'SMALL POLISHED TIN'
GROUP BY
    ROLLUP(ptype),
    ROLLUP(exp_region, exp_nation),
    ROLLUP(imp_region, imp_nation),
    ROLLUP(order_year, order_quarter, order_month)
