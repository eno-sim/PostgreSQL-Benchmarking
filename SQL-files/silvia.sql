--additional materialized view

CREATE MATERIALIZED VIEW MV_nations_regions AS
SELECT
    n_nationkey,
    n_name,
    r_name,
    r_regionkey
FROM NATION
    JOIN REGION ON n_regionkey=r_regionkey

