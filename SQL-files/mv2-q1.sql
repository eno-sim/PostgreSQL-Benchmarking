
CREATE MATERIALIZED VIEW mv_q1 AS
SELECT
    ExpReg.r_regionkey AS export_region,
    ImpReg.r_regionkey AS import_region,
    ExpNat.n_nationkey AS export_nation,
    ImpNat.n_nationkey AS import_nation,
    O.o_orderdate AS orderdate,
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
    ImpNat.n_nationkey != ExpNat.n_nationkey


