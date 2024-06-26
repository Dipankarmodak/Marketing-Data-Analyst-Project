 -- First find the landing page id  for each website session 
 
 -- SELECT * FROM website_sessions;
 -- SELECT * FROM website_pageviews;

--Finding out the creation date of the new homepage and the first web pageview of the new homepage.
-- The name of the new homepage is lander-1
 SELECT MIN(w.created_at),MIN(w.website_pageview_id) FROM website_pageviews w
 WHERE w.pageview_url='/lander-1' AND w.website_pageview_id is not null;

-- Changing the creation date in the WHERE statement for the gsearch non brand marketing campaign.
 CREATE TEMPORARY TABLE first_pageview_id_each_session
 SELECT p.website_session_id,MIN(p.website_pageview_id) as first_pgv_id
 FROM website_pageviews p LEFT JOIN website_sessions w  
 ON w.website_session_id=p.website_session_id
 WHERE w.created_at BETWEEN '2012-06-19' AND '2012-07-28' AND p.website_pageview_id =23504 AND w.utm_source='gsearch' AND w.utm_campaign='nonbrand'
 GROUP BY p.website_session_id;
 
 
 -- Rest of the steps is same as before when calculating the bounce rates
 
-- SELECT * FROM first_pageview_id_each_session;
 
 CREATE TEMPORARY TABLE landing_page
 SELECT f.website_session_id ,p.pageview_url as landing_page
 FROM first_pageview_id_each_session f LEFT JOIN website_pageviews p 
 ON p.website_pageview_id=f.first_pgv_id;
 

 -- SELECT * FROM landing_page
 
 CREATE TEMPORARY TABLE bounce_sessions
 SELECT l.website_session_id,l.landing_page,COUNT(w.website_pageview_id) bounce_sessions_total FROM landing_page l LEFT JOIN website_pageviews w
 ON l.website_session_id = w.website_session_id
 GROUP BY l.website_session_id,l.landing_page
 HAVING COUNT(w.website_pageview_id)=1
 

 --SELECT * FROM bounce_sessions
 
SELECT f.landing_page, COUNT( f.website_session_id) total_session,COUNT( b.website_session_id) bounce_session ,
COUNT(b.website_session_id)/COUNT(f.website_session_id) bounce_rate
FROM landing_page f LEFT JOIN bounce_sessions b 
ON f.website_session_id=b.website_session_id
GROUP BY f.landing_page


 
