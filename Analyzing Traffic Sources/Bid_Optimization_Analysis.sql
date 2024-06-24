 -- Narrowing down the analysis of sessions to order conversion rate based on device type i.e desktop for mobile for gsearch and nonbrand campaign
 -- Based on analysis we see that desktop has more session to order conversion rate
 -- Bidding more on desktop type for gsearch and nonbrand campaign is the optimal bid technqiue
-- Query to identify the sessions to order conversion based on device type i.e desktop or mobile.
 SELECT 
 w.device_type,
 COUNT(DISTINCT w.website_session_id) as sessions,
  COUNT(DISTINCT o.order_id) as orders,
COUNT(DISTINCT o.order_id)/ COUNT(DISTINCT w.website_session_id)
as session_to_order_conv_rate
 FROM website_sessions w LEFT JOIN orders o
 ON w.website_session_id=o.website_session_id
 WHERE w.created_at < '2012-05-11' AND  w.utm_source='gsearch'
 AND w.utm_campaign='nonbrand'
 GROUP BY w.device_type
  ;
