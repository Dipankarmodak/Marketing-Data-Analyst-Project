 
--To find the top landing pages of website, First a temporary table is created 
CREATE TEMPORARY TABLE first_pgv_per_session 
SELECT p.website_session_id,MIN(p.website_pageview_id) as first_pv
FROM website_pageviews p
WHERE p.created_at<'2012-06-12'
group by p.website_session_id
 ;

 -- inner join with the original table and the temporary table , 
SELECT COUNT(p.website_session_id),p.pageview_url 
FROM first_pgv_per_session f JOIN website_pageviews p
ON f.website_session_id=p.website_session_id
GROUP BY p.pageview_url;
 
