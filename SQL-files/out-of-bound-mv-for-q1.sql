
CREATE MATERIALIZED VIEW mv_q1 AS
SELECT
    ExpReg.r_name AS export_region,
    ImpReg.r_name AS import_region,
    ExpNat.n_name AS export_nation,
    ImpNat.n_name AS import_nation,
    DATE_PART('year', O.o_orderdate) AS order_year,
    DATE_PART('quarter', O.o_orderdate) AS order_quarter,
    DATE_PART('month', O.o_orderdate) AS order_month,
    P.p_type AS ptype,
    L.l_extendedprice * (1 - L.l_discount) AS revenue
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
    ImpNat.n_name != ExpNat.n_name


