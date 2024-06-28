-- Create a temporary table to store the first sessions (non-repeat) of each user within the specified date range
CREATE TEMPORARY TABLE first_sessions AS
SELECT 
    user_id,
    website_session_id AS new_sessions
FROM 
    website_sessions
WHERE 
    is_repeat_session = 0 
    AND created_at >= '2014-01-01' 
    AND created_at < '2014-11-01';

-- Create a temporary table to store the repeat sessions of each user within the specified date range
CREATE TEMPORARY TABLE repeat_sessions AS
SELECT 
    user_id,
    website_session_id AS repeat_sessions
FROM 
    website_sessions
WHERE 
    is_repeat_session = 1 
    AND created_at >= '2014-01-01' 
    AND created_at < '2014-11-01';

-- Create a temporary table to join first sessions with repeat sessions of the same user
-- Ensuring that the repeat session happened after the first session
CREATE TEMPORARY TABLE session_w_repeats AS
SELECT 
    f.user_id,
    f.new_sessions,
    r.repeat_sessions
FROM 
    first_sessions f
LEFT JOIN 
    repeat_sessions r
ON 
    f.user_id = r.user_id 
    AND r.repeat_sessions > f.new_sessions;

-- Final query to count the number of users by their total number of repeat sessions
SELECT 
    w.total_repeats,
    COUNT(w.user_id) AS total_users
FROM 
    (
        SELECT 
            user_id, 
            COUNT(repeat_sessions) AS total_repeats
        FROM 
            session_w_repeats 
        GROUP BY 
            user_id
    ) AS w
GROUP BY 
    w.total_repeats
ORDER BY 
    w.total_repeats;
