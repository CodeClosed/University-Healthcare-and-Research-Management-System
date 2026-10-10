-- ============================================================================
-- UNIVERSITY HEALTHCARE AND RESEARCH MANAGEMENT SYSTEM (VIT)
-- QUESTION 4: APJ ABDUL KALAM AWARD RECOGNITION QUERY
-- ============================================================================
-- Business Logic:
-- Retrieves students who:
-- 1. Are actively engaged in university research projects (Project_Participant)
-- 2. Have authored scholarly research publications (Publication_Author)
-- 3. Scored an outstanding 'S' grade in course evaluations (Enrollment)
-- ============================================================================

SELECT 
    TRIM(p_stu.first_name || ' ' || COALESCE(p_stu.middle_name || ' ', '') || p_stu.last_name) 
        AS "Student Name",
    s.roll_number 
        AS "RegNo",
    c.title 
        AS "Course Name",
    c.course_id 
        AS "Course Code",
    f.employee_id 
        AS "Course Faculty ID",
    TRIM(p_fac.first_name || ' ' || COALESCE(p_fac.middle_name || ' ', '') || p_fac.last_name) 
        AS "Course Faculty Name",
    TRIM(p_hod.first_name || ' ' || COALESCE(p_hod.middle_name || ' ', '') || p_hod.last_name) 
        AS "HoD Name",
    e.grade 
        AS "Course grade",
    rp.title 
        AS "Research Work",
    pub.title || ' (DOI: ' || pub.doi || ')' 
        AS "Research work publication"
FROM Student s
JOIN Person p_stu 
    ON s.person_id = p_stu.person_id
JOIN Enrollment e 
    ON s.roll_number = e.roll_number
JOIN Course_Section cs 
    ON  e.course_id = cs.course_id 
    AND e.section_id = cs.section_id 
    AND e.semester = cs.semester 
    AND e.academic_year = cs.academic_year
JOIN Course c 
    ON cs.course_id = c.course_id
JOIN Faculty f 
    ON cs.faculty_id = f.employee_id
JOIN Person p_fac 
    ON f.person_id = p_fac.person_id
JOIN Department d 
    ON f.department_id = d.department_id
JOIN Faculty hod_f 
    ON d.hod_faculty_id = hod_f.employee_id
JOIN Person p_hod 
    ON hod_f.person_id = p_hod.person_id
JOIN Project_Participant pp 
    ON p_stu.person_id = pp.person_id
JOIN Research_Project rp 
    ON pp.project_id = rp.project_id
JOIN Publication_Author pa 
    ON p_stu.person_id = pa.person_id
JOIN Publication pub 
    ON pa.doi = pub.doi
WHERE e.grade = 'S'
ORDER BY s.roll_number, c.course_id;
