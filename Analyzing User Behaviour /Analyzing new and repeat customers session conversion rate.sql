-- Query to calculate sessions, conversion rate, and revenue based on whether the session is a repeat session or not
SELECT 
    website_sessions.is_repeat_session, -- Indicates if the session is a repeat session
    COUNT(website_sessions.website_session_id) AS sessions, -- Total number of sessions for each repeat session status
    COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) AS conv_rate, -- Conversion rate: orders/session
    SUM(orders.price_usd) / COUNT(website_sessions.website_session_id) AS revenue -- Average revenue per session
FROM 
    website_sessions
LEFT JOIN 
    orders ON website_sessions.website_session_id = orders.website_session_id -- Join to orders table based on website session ID
WHERE 
    website_sessions.created_at < '2014-11-08' -- Filter sessions before November 8, 2014
    AND website_sessions.created_at >= '2014-01-01' -- Filter sessions from January 1, 2014 onwards
GROUP BY 
    website_sessions.is_repeat_session; -- Group results by repeat session status
