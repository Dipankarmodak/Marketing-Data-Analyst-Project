-- Query to identify the session to order conversion rate based on device type (desktop or mobile) for gsearch and nonbrand campaign

SELECT 
    w.device_type,                                -- Type of device (e.g., desktop, mobile)
    COUNT(DISTINCT w.website_session_id) AS sessions, -- Total number of distinct sessions for each device type
    COUNT(DISTINCT o.order_id) AS orders,         -- Total number of distinct orders for each device type
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS session_to_order_conv_rate -- Session to order conversion rate
FROM 
    website_sessions w
    LEFT JOIN orders o ON w.website_session_id = o.website_session_id
WHERE 
    w.created_at < '2012-05-11'                   -- Filter for sessions created before the specified date
    AND w.utm_source = 'gsearch'                  -- Filter for sessions from the 'gsearch' source
    AND w.utm_campaign = 'nonbrand'               -- Filter for sessions from the 'nonbrand' campaign
GROUP BY 
    w.device_type;                                -- Group by device type to calculate the metrics for each group
