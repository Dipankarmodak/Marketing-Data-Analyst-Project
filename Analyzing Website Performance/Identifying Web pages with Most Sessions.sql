-- Query to identify webpages with the most website sessions and rank them in descending order
SELECT 
    p.pageview_url,                                  -- URL of the page viewed
    COUNT(DISTINCT p.website_session_id) AS sessions_volume  -- Count of distinct website sessions per page
FROM 
    website_pageviews p
WHERE 
    p.created_at < '2012-06-09'                      -- Filter for pageviews before the specified date
GROUP BY 
    p.pageview_url                                   -- Group by page URL to aggregate session counts
ORDER BY 
    sessions_volume DESC;                            -- Order the results by session volume in descending order
