-- Create a temporary table to find the first pageview of each session
CREATE TEMPORARY TABLE first_pgv_per_session AS
SELECT 
    p.website_session_id,                        -- Unique session identifier
    MIN(p.website_pageview_id) AS first_pv       -- The ID of the first pageview in each session
FROM 
    website_pageviews p
WHERE 
    p.created_at < '2012-06-12'                  -- Filter for pageviews before the specified date
GROUP BY 
    p.website_session_id;                        -- Group by session ID to find the first pageview per session

-- Inner join the temporary table with the original table to find the top landing pages
SELECT 
    COUNT(f.website_session_id) AS session_count, -- Count of sessions that landed on each page
    p.pageview_url                                -- URL of the first page viewed in the session
FROM 
    first_pgv_per_session f
    LEFT JOIN website_pageviews p ON f.first_pv = p.website_pageview_id -- Join to get the URL of the first pageview
GROUP BY 
    p.pageview_url;                               -- Group by page URL to aggregate session counts
