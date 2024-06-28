-- Select the session type and count the number of new and repeat sessions for each type
SELECT 
    session_type_repeat_customers.session_type,  -- The type of session
    COUNT(CASE 
        WHEN session_type_repeat_customers.is_repeat_session = 0 THEN session_type_repeat_customers.user_id 
        ELSE NULL 
    END) AS new_sessions,  -- Count of new sessions
    COUNT(CASE 
        WHEN session_type_repeat_customers.is_repeat_session = 1 THEN session_type_repeat_customers.user_id 
        ELSE NULL 
    END) AS repeat_sessions  -- Count of repeat sessions
FROM (
    -- Subquery to classify sessions based on utm_campaign, http_referer, and utm_source
    SELECT 
        user_id,
        is_repeat_session,
        CASE
            WHEN utm_campaign IS NULL AND http_referer IS NULL THEN 'direct_type_in'  -- Direct type-in sessions
            WHEN utm_campaign IS NULL AND http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') THEN 'organic_search'  -- Organic search sessions
            WHEN utm_campaign = 'brand' AND utm_source IN ('gsearch', 'bsearch') THEN 'paid_brand'  -- Paid brand sessions
            WHEN utm_campaign = 'nonbrand' AND utm_source IN ('gsearch', 'bsearch') THEN 'paid_nonbrand'  -- Paid non-brand sessions
            WHEN utm_source = 'socialbook' THEN 'paid_social'  -- Paid social sessions
            ELSE 'other'  -- Other types of sessions
        END AS session_type
    FROM 
        website_sessions
    WHERE 
        created_at < '2014-11-05'  -- Only include sessions created before November 5, 2014
        AND created_at >= '2014-01-01'  -- Only include sessions created on or after January 1, 2014
) AS session_type_repeat_customers  -- Alias for the subquery
GROUP BY 
    session_type_repeat_customers.session_type;  -- Group by session type
