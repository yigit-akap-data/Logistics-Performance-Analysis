-- Creating the master view for supply chain intelligence
CREATE VIEW logistics_performance_view AS
SELECT
    date,
    origin_port,
    product_category,
    transport_mode,
    weight_mt,
    lead_time_days,
    geopolitical_risk_score,
    -- Advanced Analytics with Window Functions
    fuel_price_index - ROUND(AVG(fuel_price_index) OVER (PARTITION BY product_category), 2) AS fuel_difference,
    DENSE_RANK() OVER (PARTITION BY origin_port ORDER BY geopolitical_risk_score DESC) AS port_risk_rank,
    SUM(weight_mt) OVER (PARTITION BY product_category ORDER BY date ASC) AS cumulative_weight,
    lead_time_days - ROUND(AVG(lead_time_days) OVER (PARTITION BY transport_mode), 2) AS lead_time_difference,
    ROUND(AVG(weight_mt) OVER (PARTITION BY origin_port), 2) AS avg_port_weight,
    ROUND(AVG(distance_km) OVER (PARTITION BY origin_port), 2) AS avg_port_distance
FROM supply_chain;
