-- First Query finds out the top traffic sources up untill 12 April 2012.
-- From the result of first query, gsearch and nonbrand are the top source and campaign trackers until 12 April 2012.

SELECT utm_source,utm_campaign,http_referer,COUNT(DISTINCT
website_session_id) as sessions
 FROM website_sessions
 WHERE created_at <'2012-04-12'
 GROUP BY utm_source,utm_campaign,http_referer
 ORDER BY sessions desc;

--Finding out the conversion rate of gsearch and nonbrand traffic source i.e Number of Website sessions that has lead to actual orders from the  orders page
-- Conversion rate is given by -- COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) 
 
 SELECT COUNT(DISTINCT w.website_session_id) as sessions,
 COUNT(DISTINCT o.order_id) as orders,
 COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) 
 session_to_order_conv_rate
 FROM website_sessions w LEFT JOIN
 orders o ON w.website_session_id=o.website_session_id
 WHERE w.created_at<'2012-04-14' AND w.utm_source='gsearch'
 AND w.utm_campaign='nonbrand'
  ;
