CREATE INDEX idx_l_partkey ON lineitem_orders_customer(l_partkey);
CREATE INDEX idx_c_name ON lineitem_orders_customer(c_name);
CREATE INDEX idx_s_nationname ON supplier_info(s_nationname);
CREATE INDEX idx_c_custkey ON customer_info(c_custkey);
CREATE INDEX idx_p_type ON part(p_type);