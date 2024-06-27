-- First Query finds out the top traffic sources up until 12 April 2012.
-- From the result of the first query, 'gsearch' and 'nonbrand' are identified as the top source and campaign trackers until 12 April 2012.

SELECT 
    utm_source,                         -- Traffic source
    utm_campaign,                       -- Campaign name
    http_referer,                       -- Referrer URL
    COUNT(DISTINCT website_session_id) AS sessions -- Number of distinct sessions
FROM 
    website_sessions
WHERE 
    created_at < '2012-04-12'           -- Filter for sessions created before 12 April 2012
GROUP BY 
    utm_source,                         -- Group by traffic source
    utm_campaign,                       -- Group by campaign name
    http_referer                        -- Group by referrer URL
ORDER BY 
    sessions DESC;                      -- Order the results by session count in descending order

-- Finding out the conversion rate of 'gsearch' and 'nonbrand' traffic source
-- Conversion rate is given by COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id)

SELECT 
    COUNT(DISTINCT w.website_session_id) AS sessions, -- Total number of distinct sessions
    COUNT(DISTINCT o.order_id) AS orders,             -- Total number of distinct orders
    COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) AS session_to_order_conv_rate -- Session to order conversion rate
FROM 
    website_sessions w
    LEFT JOIN orders o ON w.website_session_id = o.website_session_id
WHERE 
    w.created_at < '2012-04-14'           -- Filter for sessions created before 14 April 2012
    AND w.utm_source = 'gsearch'          -- Filter for sessions from the 'gsearch' source
    AND w.utm_campaign = 'nonbrand';      -- Filter for sessions from the 'nonbrand' campaign
