SELECT
  COALESCE(DATE_PART('year', O.o_orderdate)::text, 'Total') AS yearOrder,
  DATE_PART('quarter', O.o_orderdate) AS quarterOrder,
  DATE_PART('month', O.o_orderdate) AS monthOrder,
  CU.c_name AS custName,
  SUM(L.l_extendedprice * (1 - L.l_discount)) AS revenue
FROM
  lineitem AS L
JOIN
  orders AS O ON L.l_orderkey = O.o_orderkey
JOIN
  customer AS CU ON CU.c_custkey = O.o_custkey
WHERE
  L.l_returnflag = 'R'
  AND CU.c_name ='Customer#000002000'
  AND DATE_PART('quarter', O.o_orderdate)='1'
GROUP BY
  GROUPING SETS (
    (DATE_PART('year', O.o_orderdate), quarterOrder, monthOrder, custName),
    (DATE_PART('year', O.o_orderdate), quarterOrder, custName),
    (DATE_PART('year', O.o_orderdate), custName),
    (custName),
	()
  )
ORDER BY
  custName,
  COALESCE(DATE_PART('year', O.o_orderdate)::text, 'All Years'),
  quarterOrder,
  monthOrder;
