-- Query to analyze website sessions by campaign type and traffic source by year and month

SELECT 
    YEAR(w.created_at) AS year,                -- Extracts the year from the created_at column
    MONTH(w.created_at) AS month,              -- Extracts the month from the created_at column
    COUNT(CASE WHEN w.utm_campaign = 'brand' THEN w.website_session_id ELSE NULL END) AS brand, -- Counts sessions from 'brand' campaign
    COUNT(CASE WHEN w.utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END) AS nonbrand, -- Counts sessions from 'nonbrand' campaign
    COUNT(CASE WHEN w.utm_campaign = 'brand' THEN w.website_session_id ELSE NULL END) /
    COUNT(CASE WHEN w.utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END) AS brand_pct_of_nonbrand, -- Ratio of brand to nonbrand sessions
    COUNT(CASE WHEN w.utm_campaign IS NULL AND w.http_referer IS NULL THEN w.website_session_id ELSE NULL END) AS direct, -- Counts direct sessions
    COUNT(CASE WHEN w.utm_campaign IS NULL AND w.http_referer IS NULL THEN w.website_session_id ELSE NULL END) /
    COUNT(CASE WHEN w.utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END) AS direct_pct_of_nonbrand, -- Ratio of direct to nonbrand sessions
    COUNT(CASE WHEN w.utm_campaign IS NULL AND w.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN w.website_session_id ELSE NULL END) AS organic, -- Counts organic sessions
    COUNT(CASE WHEN w.utm_campaign IS NULL AND w.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN w.website_session_id ELSE NULL END) /
    COUNT(CASE WHEN w.utm_campaign = 'nonbrand' THEN w.website_session_id ELSE NULL END) AS organic_pct_of_nonbrand -- Ratio of organic to nonbrand sessions
FROM 
    website_sessions w
WHERE 
    w.created_at < '2012-12-23'                -- Filter for sessions created before 23 December 2012
GROUP BY 
    YEAR(w.created_at),                        -- Group by year
    MONTH(w.created_at);                       -- Group by month


