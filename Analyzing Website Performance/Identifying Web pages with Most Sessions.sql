
--Query to Identify webpages with the most website sessions and ranking them in descending order
SELECT 
 p.pageview_url,
 COUNT(DISTINCT p.website_session_id) as sessions_volume
 FROM website_pageviews p
 WHERE p.created_at<'2012-06-09'
 GROUP BY p.pageview_url
 ORDER BY sessions_volume DESC
