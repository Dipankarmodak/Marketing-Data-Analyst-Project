 -- gsearch and nonbrand campaign session volume trend after reduced bidding
 -- we see that the session volume reduced after reducing bid for gsearch and nonbrand campaign

 SELECT 
 MIN(DATE(w.created_at)) as week_start,
 COUNT(DISTINCT w.website_session_id) as sessions
 FROM website_sessions w 
 WHERE w.created_at < '2012-05-10' AND  w.utm_source='gsearch'
 AND w.utm_campaign='nonbrand'
 GROUP BY YEAR(w.created_at),WEEK(w.created_at)
  ;
