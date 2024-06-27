-- Creating a Pivot Table to analyze sessions based on device type after increasing the bid on gsearch
-- and non-brand marketing campaign for desktop device type

SELECT 
    MIN(DATE(w.created_at)) AS week_start_date,  -- The start date of each week
    SUM(CASE WHEN w.device_type = 'desktop' THEN 1 ELSE 0 END) AS dtop_sessions, -- Total sessions from desktop devices
    SUM(CASE WHEN w.device_type = 'mobile' THEN 1 ELSE 0 END) AS mobile_sessions -- Total sessions from mobile devices
FROM 
    website_sessions w
WHERE 
    w.created_at > '2012-04-15'               -- Filter for sessions created after the specified date
    AND w.created_at < '2012-06-09'           -- Filter for sessions created before the specified date
    AND w.utm_source = 'gsearch'              -- Filter for sessions from the 'gsearch' source
    AND w.utm_campaign = 'nonbrand'           -- Filter for sessions from the 'nonbrand' campaign
GROUP BY 
    WEEK(w.created_at);                       -- Group the results by week to aggregate the session counts
