CREATE INDEX idx_customer_cname ON customer(c_name);
CREATE INDEX idx_lineitem_lorderkey ON lineitem(l_orderkey);
CREATE INDEX idx_lineitem_lpartkey ON lineitem(l_partkey);
CREATE INDEX idx_orders_ccustkey ON orders(o_custkey);
CREATE INDEX idx_part_ptype ON part(p_type);
CREATE INDEX idx_supplier_snationkey ON supplier(s_nationkey);
