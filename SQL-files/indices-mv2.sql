--Q1 NONE IS USEFUL--
CREATE INDEX idx_n_name ON nation(n_name);
CREATE INDEX idx_ptype ON mv_q1(ptype);
CREATE INDEX idx_exp_nation ON mv_q1(export_nation);
CREATE INDEX idx_imp_nation ON mv_q1(import_nation);
CREATE INDEX idx_exp_region ON mv_q1(export_region);
CREATE INDEX idx_imp_region ON mv_q1(import_region);

DROP INDEX if exists idx_n_name;
--DROP INDEX if exists idx_ptype;
--DROP INDEX if exists idx_exp_nation;
DROP INDEX if exists idx_imp_nation;
DROP INDEX if exists idx_exp_region;
DROP INDEX if exists idx_imp_region;





--Q3--
CREATE INDEX idx_c_name ON mv_q3(c_name);