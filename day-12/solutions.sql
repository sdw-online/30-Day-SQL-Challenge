-- ============================================
-- DAY 12 SOLUTIONS: Subqueries & Temp Tables
-- ============================================

-- Task 1: Above-average students
SELECT student_name, school_name, subject, score
FROM school_results
WHERE score > (SELECT AVG(score) FROM school_results)
ORDER BY score DESC;

-- Task 2: School average vs student score
SELECT
    student_name,
    school_name,
    subject,
    score,
    (SELECT ROUND(AVG(score), 1)
     FROM school_results sr2
     WHERE sr2.school_name = sr.school_name) AS school_avg,
    score - (SELECT ROUND(AVG(score), 1)
             FROM school_results sr2
             WHERE sr2.school_name = sr.school_name) AS diff_from_avg
FROM school_results sr
ORDER BY school_name, score DESC;

-- Task 3: Underperforming schools
SELECT school_name, ROUND(avg_score, 1) AS avg_score
FROM (
    SELECT school_name, AVG(score) AS avg_score
    FROM school_results
    GROUP BY school_name
) school_avgs
WHERE avg_score < (SELECT AVG(score) FROM school_results);

-- Task 4: Temp table report
CREATE TEMP TABLE school_summary AS
SELECT
    school_name,
    ROUND(AVG(score), 1) AS avg_score,
    COUNT(*)             AS student_count,
    MAX(score)           AS highest_score
FROM school_results
GROUP BY school_name;

SELECT
    school_name,
    avg_score,
    student_count,
    highest_score,
    CASE
        WHEN avg_score >= 80 THEN 'Strong'
        WHEN avg_score >= 60 THEN 'Average'
        ELSE 'Needs Support'
    END AS performance_rating
FROM school_summary
ORDER BY avg_score DESC;
