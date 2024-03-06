CREATE MATERIALIZED VIEW IF NOT EXISTS mv_q3
TABLESPACE pg_default
AS
 SELECT orders.o_orderdate,
    lineitem.l_extendedprice * (1::numeric - lineitem.l_discount) AS revenue,
    customer.c_name
   FROM lineitem
     JOIN orders ON lineitem.l_orderkey = orders.o_orderkey
     JOIN customer ON customer.c_custkey = orders.o_custkey
  WHERE lineitem.l_returnflag = 'R'::bpchar
WITH DATA;

ALTER TABLE IF EXISTS public.mv_q3
    OWNER TO postgres;