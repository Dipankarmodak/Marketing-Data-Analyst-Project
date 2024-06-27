-- The inner query calculates the number of repeat sessions for each user

SELECT 
    user_id,
    SUM(CASE WHEN is_repeat_session = 1 THEN 1 ELSE 0 END) AS repeats -- Sum up the repeat sessions for each user
FROM 
    website_sessions
GROUP BY 
    user_id -- Group by user_id to get the repeat sessions count for each user

-- The outer query counts the number of users for each repeat session count

SELECT 
    m.repeats,                            -- Number of repeat sessions
    COUNT(DISTINCT m.user_id) AS user_count -- Count the number of distinct users for each repeat session count
FROM 
    (SELECT 
        user_id,
        SUM(CASE WHEN is_repeat_session = 1 THEN 1 ELSE 0 END) AS repeats -- Subquery to calculate repeat sessions for each user
     FROM 
        website_sessions
     GROUP BY 
        user_id) AS m                     -- Alias the subquery result as m
GROUP BY 
    m.repeats;                            -- Group by the number of repeat sessions
