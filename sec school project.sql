CREATE SCHEMA schoolproj;
USE schoolproj;


-- IMPORT DATA
DESC student_activity_participation;
DESC Students_data;
DESC Parent_data;
DESC Teachers_data;
DESC attendance_data;
Desc Grades_data;

-- students repeating classes
SELECT count(student_id) from Students_data
where is_repeating = 'true'; 

-- 1. Analyze Attendance Impact on Grades
SELECT 
    g.student_id,
    AVG(g.total_score) AS average_score,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage
FROM 
    grades_data g
JOIN 
    attendance_data a ON g.student_id = a.student_id
GROUP BY 
    g.student_id;

-- Insights: Higher attendance correlates with better grades.

-- 2. Analyze Extracurricular Activities Impact on Grades
SELECT 
    g.student_id,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 
    g.student_id;

-- student performance with activity hours greater than 5 hours sitting below average score
SELECT 
    t.student_id,
   t.total_activity_hours,
t.average_score, AVG(t.Avg_tot_activity_hrs) avg_tot_actvty_hrs
FROM
 (SELECT g.student_id student_id,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score, SUM(ap.hours_spent) Avg_tot_activity_hrs 
	FROM 
    grades_data g
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 
    g.student_id) t
where t.average_score < 50 and t.total_activity_hours > 5
    group by 1;

-- student performance with  activity hours less than 2 hours sitting below average score
SELECT 
    t.student_id,
   t.total_activity_hours,
t.average_score, AVG(t.Avg_tot_activity_hrs) avg_tot_actvty_hrs
FROM
 (SELECT g.student_id student_id,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score, SUM(ap.hours_spent) Avg_tot_activity_hrs 
	FROM 
    grades_data g
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 
    g.student_id) t
where t.average_score < 50 and t.total_activity_hours < 2
    group by 1;
    
-- Insights: Moderate activity participation improves grades; overcommitment might harm performance.

-- 3. Analyze Parental Support and Grades
SELECT 
    s.parental_support,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
JOIN 
    students_data s ON g.student_id = s.student_id
GROUP BY 
    s.parental_support
ORDER BY
	average_score DESC;

-- Insights: Higher parental support is associated with better academic outcomes.

-- 4. Analyze Stress and Motivation Levels
SELECT 
    s.stress_level,
    s.motivation_level,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
JOIN 
    students_data s ON g.student_id = s.student_id
GROUP BY 
    s.stress_level, s.motivation_level
ORDER BY
	average_score DESC;

-- Insights: Low stress and high motivation lead to better performance.

-- 5. Teacher Engagement and Grades
SELECT 
    s.teacher_engagement,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
JOIN 
    students_data s ON g.student_id = s.student_id
GROUP BY 
    s.teacher_engagement;

-- Insights: Teacher engagement positively impacts grades.

-- 6. Combined Analysis: Attendance, Activities, and Grades
SELECT 
    g.student_id,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    attendance_data a ON g.student_id = a.student_id
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 
    g.student_id;
    
-- students below average score
SELECT 
    g.student_id,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    attendance_data a ON g.student_id = a.student_id
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 1
HAVING average_score < 50
 order by average_score;
  -- Number(count) of students below average score
 SELECT COUNT(*)
FROM (SELECT 
    g.student_id,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    attendance_data a ON g.student_id = a.student_id
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 1
HAVING average_score < 50
 order by average_score) C ;

    
-- students above average score
SELECT 
    g.student_id,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    attendance_data a ON g.student_id = a.student_id
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 1
HAVING average_score >= 50
 order by average_score ;
 -- Number(count) of students above average score
 SELECT COUNT(*)
FROM (SELECT 
    g.student_id,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(*) AS attendance_percentage,
    SUM(ap.hours_spent) AS total_activity_hours,
    AVG(g.total_score) AS average_score
FROM 
    grades_data g
LEFT JOIN 
    attendance_data a ON g.student_id = a.student_id
LEFT JOIN 
    student_activity_participation ap ON g.student_id = ap.student_id
GROUP BY 1
HAVING average_score >= 50
 order by average_score) C ;
