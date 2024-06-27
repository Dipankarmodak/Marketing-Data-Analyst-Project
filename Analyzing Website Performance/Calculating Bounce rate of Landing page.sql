-- SELECT * FROM website_sessions;
-- SELECT * FROM website_pageviews;

-- First, find the minimum pageview ID for each web session
CREATE TEMPORARY TABLE first_pageview_id_each_session AS
SELECT 
    p.website_session_id,                   -- Unique session identifier
    MIN(p.website_pageview_id) AS first_pgv_id  -- The ID of the first pageview in each session
FROM 
    website_pageviews p 
    LEFT JOIN website_sessions w ON w.website_session_id = p.website_session_id
WHERE 
    w.created_at < '2012-06-14'             -- Filter for sessions created before the specified date
GROUP BY 
    p.website_session_id;                   -- Group by session ID to find the first pageview per session

-- SELECT * FROM first_pageview_id_each_session;

-- For each web session ID from the previous temporary table, find the landing page URL
CREATE TEMPORARY TABLE landing_page AS
SELECT 
    f.website_session_id,                   -- Unique session identifier
    p.pageview_url AS landing_page          -- URL of the first page viewed in the session (landing page)
FROM 
    first_pageview_id_each_session f
    LEFT JOIN website_pageviews p ON p.website_pageview_id = f.first_pgv_id;

-- SELECT * FROM landing_page;

-- Calculate bounce sessions (sessions with only one pageview)
CREATE TEMPORARY TABLE bounce_sessions AS
SELECT 
    l.website_session_id,                   -- Unique session identifier
    l.landing_page,                         -- URL of the landing page
    COUNT(w.website_pageview_id) AS bounce_sessions_total  -- Total pageviews in the session
FROM 
    landing_page l
    LEFT JOIN website_pageviews w ON l.website_session_id = w.website_session_id
GROUP BY 
    l.website_session_id, l.landing_page
HAVING 
    COUNT(w.website_pageview_id) = 1;       -- Only sessions with exactly one pageview are considered bounces

-- SELECT * FROM bounce_sessions;

-- Calculate the bounce rate, defined as the total number of bounce sessions divided by the total number of sessions for each landing page
SELECT 
    f.landing_page,                         -- URL of the landing page
    COUNT(f.website_session_id) AS total_session,  -- Total number of sessions for the landing page
    COUNT(b.website_session_id) AS bounce_session, -- Total number of bounce sessions for the landing page
    COUNT(b.website_session_id) / COUNT(f.website_session_id) AS bounce_rate  -- Bounce rate for the landing page
FROM 
    landing_page f
    LEFT JOIN bounce_sessions b ON f.website_session_id = b.website_session_id
GROUP BY 
    f.landing_page;                         -- Group by landing page to aggregate session counts and calculate the bounce rate
