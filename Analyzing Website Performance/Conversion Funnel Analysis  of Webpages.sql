-- Create a temporary table to flag the last page reached in each session
CREATE TEMPORARY TABLE flag_the_last_page_each_session AS
SELECT 
    w.created_at,                   -- Session creation timestamp
    p.pageview_url,                 -- URL of the page viewed
    w.website_session_id,           -- Unique session identifier
    -- Flag indicating if the session reached the products page
    CASE WHEN p.pageview_url = '/products' THEN 1 ELSE 0 END AS till_products,
    -- Flag indicating if the session reached the cart page
    CASE WHEN p.pageview_url = '/cart' THEN 1 ELSE 0 END AS till_cart,
    -- Flag indicating if the session reached the billing page
    CASE WHEN p.pageview_url = '/billing' THEN 1 ELSE 0 END AS till_billing,
    -- Flag indicating if the session reached the Mr. Fuzzy page
    CASE WHEN p.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS till_mr_fuzzy,
    -- Flag indicating if the session reached the shipping page
    CASE WHEN p.pageview_url = '/shipping' THEN 1 ELSE 0 END AS till_shipping,
    -- Flag indicating if the session reached the thank you page
    CASE WHEN p.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS till_thanks
FROM 
    website_sessions w 
    LEFT JOIN website_pageviews p ON w.website_session_id = p.website_session_id
WHERE  
    w.created_at > '2012-08-05' 
    AND w.created_at < '2012-09-05' 
    AND w.utm_source = 'gsearch' 
    AND w.utm_campaign = 'nonbrand'
ORDER BY 
    w.website_session_id;

-- Create a temporary table to calculate session-level click-through rates
CREATE TEMPORARY TABLE session_level_clickthorough_rate AS
SELECT 
    -- Calculate the click-through rate for landing on the products page
    SUM(CASE WHEN m.session_to_products = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT m.website_session_id) AS landerpage_clk_rate,
    -- Calculate the click-through rate for landing on the Mr. Fuzzy page
    SUM(CASE WHEN m.to_mr_fuzzy = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN m.session_to_products = 1 THEN 1 ELSE 0 END) AS mrfuzzypage_clk_rate,
    -- Calculate the click-through rate for landing on the cart page
    SUM(CASE WHEN m.to_cart = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN m.to_mr_fuzzy = 1 THEN 1 ELSE 0 END) AS cartpage_clk_rate,
    -- Calculate the click-through rate for landing on the shipping page
    SUM(CASE WHEN m.to_shipping = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN m.to_cart = 1 THEN 1 ELSE 0 END) AS shippingpage_clk_rate,
    -- Calculate the click-through rate for landing on the billing page
    SUM(CASE WHEN m.to_billing = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN m.to_shipping = 1 THEN 1 ELSE 0 END) AS billingpage_clk_rate,
    -- Calculate the click-through rate for landing on the thank you page
    SUM(CASE WHEN m.to_thanks = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN m.to_billing = 1 THEN 1 ELSE 0 END) AS thankspage_clk_rate
FROM (
    -- Subquery to get the maximum flag values for each session
    SELECT 
        website_session_id,
        MAX(till_products) AS session_to_products,
        MAX(till_cart) AS to_cart,
        MAX(till_billing) AS to_billing,
        MAX(till_mr_fuzzy) AS to_mr_fuzzy,
        MAX(till_shipping) AS to_shipping,
        MAX(till_thanks) AS to_thanks
    FROM 
        flag_the_last_page_each_session
    GROUP BY 
        website_session_id
) AS m;

--Display the clickthrough rate output per page
SELECT * FROM session_level_clickthorough_rate;
