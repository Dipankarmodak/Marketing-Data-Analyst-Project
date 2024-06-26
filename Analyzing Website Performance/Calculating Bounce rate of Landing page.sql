 
 -- SELECT * FROM website_sessions;
 -- SELECT * FROM website_pageviews;

-- First we find out  the minimum pageview id for each web session
 CREATE TEMPORARY TABLE first_pageview_id_each_session
 SELECT p.website_session_id,MIN(p.website_pageview_id) as first_pgv_id
 FROM website_pageviews p LEFT JOIN website_sessions w  
 ON w.website_session_id=p.website_session_id
 WHERE w.created_at <'2012-06-14'
 GROUP BY p.website_session_id;
 
 -- SELECT * FROM first_pageview_id_each_session;


 --Then for each web session id from the previous temporary table we find the landing page url i.e we find where the users click
-- the home page
 CREATE TEMPORARY TABLE landing_page
 SELECT f.website_session_id ,p.pageview_url as landing_page
 FROM first_pageview_id_each_session f LEFT JOIN website_pageviews p 
 ON p.website_pageview_id=f.first_pgv_id;
 
 -- SELECT * FROM landing_page

-- Then we calculate the bounce session. Bounce sessions are those whose total count of pageviews=1. i.e they just scroll through the
-- home page and then they exited from the webpage.
 
 CREATE TEMPORARY TABLE bounce_sessions
 SELECT l.website_session_id,l.landing_page,COUNT(w.website_pageview_id) bounce_sessions_total FROM landing_page l LEFT JOIN website_pageviews w
 ON l.website_session_id = w.website_session_id
 GROUP BY l.website_session_id,l.landing_page
 HAVING COUNT(w.website_pageview_id)=1
 
 -- SELECT * FROM bounce_sessions

 -- Then we calculate the bounce rate which is defined by total number of web sessions which are bounces divided by total number of 
 -- web session on a landing page
SELECT COUNT(f.website_session_id) total_session,COUNT(b.website_session_id) bounce_session ,
COUNT(b.website_session_id)/COUNT(f.website_session_id) bounce_rate
FROM landing_page f LEFT JOIN bounce_sessions b 
ON f.website_session_id=b.website_session_id
GROUP BY f.landing_page


 
