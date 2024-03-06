
SELECT
	DATE_PART('year', orderdate) AS order_year,
    DATE_PART('quarter', orderdate) AS order_quarter,
    DATE_PART('month', orderdate) AS order_month,
    ExpNat.n_name AS exp_nation,
	ImpNat.n_name AS imp_nation,
	ExpReg.r_name AS exp_region,
	ImpReg.r_name AS imp_region,
    SUM(revenue) AS total_revenue,
    ptype
FROM
    mv_q1
JOIN nation AS ExpNat ON ExpNat.n_nationkey=export_nation
JOIN nation AS ImpNat ON ImpNat.n_nationkey=import_nation
JOIN region AS ExpReg ON ExpReg.r_regionkey=export_region
JOIN region AS ImpReg ON ImpReg.r_regionkey=import_region
WHERE
    ExpNat.n_name = 'FRANCE'
    AND ptype = 'SMALL POLISHED TIN'
GROUP BY
    ROLLUP(ptype),
    ROLLUP(exp_region, exp_nation),
    ROLLUP(imp_region, imp_nation),
    ROLLUP(order_year, order_quarter, order_month);