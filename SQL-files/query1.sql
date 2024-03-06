--runna in 22 secondi e output di 20,610 righe
SELECT
    COALESCE(ExpReg.r_name, 'Total') AS export_region,
	COALESCE(ImpReg.r_name, 'Total') AS import_region,
	COALESCE(ExpNat.n_name, 'Total') AS export_nation,
    COALESCE(ImpNat.n_name, 'Total') AS import_nation,
    SUM(L.l_extendedprice * (1 - L.l_discount)) AS revenue,
    DATE_PART('month', O.o_orderdate) AS order_month,
    DATE_PART('quarter', O.o_orderdate) AS order_quarter,
    DATE_PART('year', O.o_orderdate) AS order_year,
    P.p_type AS ptype
FROM
    LINEITEM AS L
    JOIN ORDERS AS O ON L.l_orderkey = O.o_orderkey
    JOIN PART AS P ON P.p_partkey = L.l_partkey
    JOIN SUPPLIER AS Ex ON Ex.s_suppkey = L.l_suppkey
    JOIN CUSTOMER AS Im ON Im.c_custkey = O.o_custkey
    JOIN NATION AS ExpNat ON ExpNat.n_nationkey = Ex.s_nationkey
    JOIN NATION AS ImpNat ON ImpNat.n_nationkey = Im.c_nationkey
    JOIN REGION AS ExpReg ON ExpReg.r_regionkey = ExpNat.n_regionkey
    JOIN REGION AS ImpReg ON ImpReg.r_regionkey = ImpNat.n_regionkey
WHERE
    ExpNat.n_name = 'FRANCE'
	AND ImpNat.n_name != ExpNat.n_name
    AND P.p_type = 'SMALL POLISHED TIN'
GROUP BY
    ROLLUP(P.p_type),
    ROLLUP(ExpReg.r_name, ExpNat.n_name),
    ROLLUP(ImpReg.r_name, ImpNat.n_name),
    ROLLUP(DATE_PART('year', O.o_orderdate), DATE_PART('quarter', O.o_orderdate), DATE_PART('month', O.o_orderdate));
