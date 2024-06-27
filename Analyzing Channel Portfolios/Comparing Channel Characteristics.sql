SELECT w.utm_source AS start_week_date,COUNT(CASE WHEN w.utm_source='gsearch' THEN w.website_session_id ELSE NULL END) AS gsearch_sessions,
COUNT(CASE WHEN w.utm_source='bsearch' THEN w.website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions w
WHERE w.created_at >'2012-08-22' AND w.created_at <'2012-11-29' AND w.utm_campaign='nonbrand'
GROUP BY WEEK(w.created_at);



SELECT w.utm_source ,COUNT(DISTINCT w.website_session_id) AS total_sessions,
COUNT(CASE WHEN w.device_type='mobile' THEN w.website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(CASE WHEN w.device_type='mobile' THEN w.website_session_id ELSE NULL END)/COUNT(DISTINCT w.website_session_id)AS pct_mobile_sessions
FROM website_sessions w
WHERE w.created_at >'2012-08-22' AND w.created_at <'2012-11-30' AND w.utm_campaign='nonbrand'
GROUP BY w.utm_source;


SELECT MIN(DATE(w.created_at)) AS start_week_date ,
COUNT(CASE WHEN w.device_type='desktop' AND w.utm_source='gsearch' THEN w.website_session_id ELSE NULL END) AS g_dtop_sessions,
COUNT(CASE WHEN w.device_type='desktop' AND w.utm_source='bsearch' THEN w.website_session_id ELSE NULL END) AS b_dtop_sessions,
COUNT(CASE WHEN w.device_type='desktop' AND w.utm_source='bsearch' THEN w.website_session_id ELSE NULL END)/
COUNT(CASE WHEN w.device_type='desktop' AND w.utm_source='gsearch' THEN w.website_session_id ELSE NULL END) AS b_pct_of_g_dtop,
COUNT(CASE WHEN w.device_type='mobile' AND w.utm_source='gsearch' THEN w.website_session_id ELSE NULL END) AS g_mob_sessions,
COUNT(CASE WHEN w.device_type='mobile' AND w.utm_source='bsearch' THEN w.website_session_id ELSE NULL END) AS b_mob_sessions,
COUNT(CASE WHEN w.device_type='mobile' AND w.utm_source='bsearch' THEN w.website_session_id ELSE NULL END)/
COUNT(CASE WHEN w.device_type='mobile' AND w.utm_source='gsearch' THEN w.website_session_id ELSE NULL END) AS b_pct_of_g_mob
FROM website_sessions w 
WHERE w.created_at >'2012-11-04' AND w.created_at <'2012-12-22' AND w.utm_campaign='nonbrand'
GROUP BY WEEK(w.created_at);
