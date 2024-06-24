 
 -- Creating Pivot Table based on device type sessions after increasing the bid on gsearch
 -- and non brand marketing campaign on the desktop device type after the last analysis on bid optimization.
 SELECT 
 MIN(DATE(w.created_at)) as week_start_date,
  SUM(CASE WHEN w.device_type='desktop' THEN 1 ELSE 0 END) as dtop_sessions,
SUM(CASE WHEN w.device_type='mobile' THEN 1 ELSE 0 END) as mobile_sessions
 FROM website_sessions w 
 WHERE w.created_at >'2012-04-15' AND w.created_at <'2012-06-09' AND  w.utm_source='gsearch'
 AND w.utm_campaign='nonbrand'
 GROUP BY WEEK(w.created_at)
  ;
