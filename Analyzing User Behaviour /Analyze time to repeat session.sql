-- Create a temporary table to store the first sessions (non-repeat) of each user within the specified date range
CREATE TEMPORARY TABLE first_sessions AS
SELECT 
    user_id,
    website_session_id AS new_sessions,
    created_at
FROM 
    website_sessions
WHERE 
    is_repeat_session = 0 
    AND created_at >= '2014-01-01' 
    AND created_at < '2014-11-03';

-- Create a temporary table to store the repeat sessions of each user within the specified date range
CREATE TEMPORARY TABLE repeat_sessions AS
SELECT 
    user_id,
    website_session_id AS repeat_sessions,
    created_at
FROM 
    website_sessions
WHERE 
    is_repeat_session = 1 
    AND created_at >= '2014-01-01' 
    AND created_at < '2014-11-03';

-- Create a temporary table to join first sessions with repeat sessions of the same user
-- Ensuring that the repeat session happened after the first session
CREATE TEMPORARY TABLE session_w_repeats AS
SELECT 
    f.user_id,
    f.new_sessions,
    r.repeat_sessions,
    f.created_at AS first_time,
    r.created_at AS repeated_times
FROM 
    first_sessions f
LEFT JOIN 
    repeat_sessions r
ON 
    f.user_id = r.user_id 
    AND r.repeat_sessions > f.new_sessions;

-- Final query to calculate the average, minimum, and maximum days between the first and second sessions
SELECT 
    AVG(m.diff_btn_first_to_second) AS avg_days_first_to_second,
    MIN(m.diff_btn_first_to_second) AS min_days_first_to_second, 
    MAX(m.diff_btn_first_to_second) AS max_days_first_to_second
FROM 
    (
        SELECT 
            user_id, 
            DATEDIFF(MIN(repeated_times), first_time) AS diff_btn_first_to_second 
        FROM 
            session_w_repeats
        WHERE 
            repeated_times IS NOT NULL
        GROUP BY 
            user_id, first_time
    ) AS m;
