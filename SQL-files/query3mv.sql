
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
