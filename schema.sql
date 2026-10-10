-- ============================================================================
-- UNIVERSITY HEALTHCARE AND RESEARCH MANAGEMENT SYSTEM (VIT)
-- SCHEMA CREATION SCRIPT (DDL)
-- Compatible with PostgreSQL 12+ and MySQL 8.0+
-- ============================================================================

DROP TABLE IF EXISTS Club_Membership CASCADE;
DROP TABLE IF EXISTS Club CASCADE;
DROP TABLE IF EXISTS Bus_Subscription CASCADE;
DROP TABLE IF EXISTS Bus_Assignment CASCADE;
DROP TABLE IF EXISTS Driver CASCADE;
DROP TABLE IF EXISTS Bus CASCADE;
DROP TABLE IF EXISTS Prescribed_Medicine CASCADE;
DROP TABLE IF EXISTS Medicine CASCADE;
DROP TABLE IF EXISTS Medical_Consultation CASCADE;
DROP TABLE IF EXISTS Doctor CASCADE;
DROP TABLE IF EXISTS Room_Allocation CASCADE;
DROP TABLE IF EXISTS Hostel_Room CASCADE;
DROP TABLE IF EXISTS Hostel CASCADE;
DROP TABLE IF EXISTS Borrow_Record CASCADE;
DROP TABLE IF EXISTS Book_Copy CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Publication_Author CASCADE;
DROP TABLE IF EXISTS Publication CASCADE;
DROP TABLE IF EXISTS Project_Participant CASCADE;
DROP TABLE IF EXISTS Research_Project CASCADE;
DROP TABLE IF EXISTS Quiz_Question CASCADE;
DROP TABLE IF EXISTS Quiz CASCADE;
DROP TABLE IF EXISTS Assignment_Submission CASCADE;
DROP TABLE IF EXISTS Assignment CASCADE;
DROP TABLE IF EXISTS Learning_Module CASCADE;
DROP TABLE IF EXISTS Enrollment CASCADE;
DROP TABLE IF EXISTS Course_Section CASCADE;
DROP TABLE IF EXISTS Course CASCADE;
DROP TABLE IF EXISTS Visiting_Scholar CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Research_Supervision CASCADE;
DROP TABLE IF EXISTS Faculty_Mentoring CASCADE;
DROP TABLE IF EXISTS Faculty_Research_Interest CASCADE;
DROP TABLE IF EXISTS Faculty_Phone CASCADE;
DROP TABLE IF EXISTS Faculty CASCADE;
DROP TABLE IF EXISTS Student_Certification CASCADE;
DROP TABLE IF EXISTS Student_Skill CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Department CASCADE;
DROP TABLE IF EXISTS Person CASCADE;

-- 1. Master Person Table (Composite attributes decomposed)
CREATE TABLE Person (
    person_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    primary_email VARCHAR(100) UNIQUE NOT NULL,
    door_no VARCHAR(20),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    postal_code VARCHAR(20)
);

-- 2. Department Table
CREATE TABLE Department (
    department_id VARCHAR(20) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50) NOT NULL,
    budget NUMERIC(15, 2) CHECK (budget >= 0),
    hod_faculty_id VARCHAR(20)
);

-- 3. Student Subclass Table
CREATE TABLE Student (
    roll_number VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) NOT NULL REFERENCES Person(person_id) ON DELETE CASCADE,
    program VARCHAR(100) NOT NULL,
    semester INT CHECK (semester BETWEEN 1 AND 10),
    cgpa NUMERIC(4, 2) CHECK (cgpa BETWEEN 0.00 AND 10.00)
);

CREATE TABLE Student_Skill (
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    skill_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (roll_number, skill_name)
);

CREATE TABLE Student_Certification (
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    certification_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (roll_number, certification_name)
);

-- 4. Faculty Subclass Table
CREATE TABLE Faculty (
    employee_id VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) NOT NULL REFERENCES Person(person_id) ON DELETE CASCADE,
    designation VARCHAR(50) NOT NULL,
    salary NUMERIC(12, 2) CHECK (salary > 0),
    joining_date DATE NOT NULL,
    department_id VARCHAR(20) NOT NULL REFERENCES Department(department_id) ON DELETE RESTRICT
);

-- Add HoD Foreign Key to Department
ALTER TABLE Department 
    ADD CONSTRAINT fk_department_hod 
    FOREIGN KEY (hod_faculty_id) REFERENCES Faculty(employee_id) ON DELETE SET NULL;

CREATE TABLE Faculty_Phone (
    employee_id VARCHAR(20) REFERENCES Faculty(employee_id) ON DELETE CASCADE,
    phone_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (employee_id, phone_number)
);

CREATE TABLE Faculty_Research_Interest (
    employee_id VARCHAR(20) REFERENCES Faculty(employee_id) ON DELETE CASCADE,
    interest_area VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee_id, interest_area)
);

-- Recursive Faculty Mentoring
CREATE TABLE Faculty_Mentoring (
    mentee_faculty_id VARCHAR(20) PRIMARY KEY REFERENCES Faculty(employee_id) ON DELETE CASCADE,
    mentor_faculty_id VARCHAR(20) NOT NULL REFERENCES Faculty(employee_id) ON DELETE RESTRICT,
    mentoring_start_date DATE NOT NULL,
    CHECK (mentee_faculty_id <> mentor_faculty_id)
);

-- Faculty Research Supervision
CREATE TABLE Research_Supervision (
    faculty_id VARCHAR(20) REFERENCES Faculty(employee_id) ON DELETE CASCADE,
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    research_area VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    PRIMARY KEY (faculty_id, roll_number)
);

-- 5. Staff Subclass Table
CREATE TABLE Staff (
    staff_id VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) NOT NULL REFERENCES Person(person_id) ON DELETE CASCADE,
    department_id VARCHAR(20) NOT NULL REFERENCES Department(department_id),
    shift_details VARCHAR(50) NOT NULL
);

-- 6. Visiting Scholar Subclass Table
CREATE TABLE Visiting_Scholar (
    scholar_id VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) NOT NULL REFERENCES Person(person_id) ON DELETE CASCADE,
    home_university VARCHAR(150) NOT NULL,
    country VARCHAR(50) NOT NULL,
    visit_duration_days INT CHECK (visit_duration_days > 0)
);

-- 7. Course & Weak Entity Course_Section
CREATE TABLE Course (
    course_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    credit_value INT CHECK (credit_value BETWEEN 1 AND 8),
    department_id VARCHAR(20) REFERENCES Department(department_id)
);

CREATE TABLE Course_Section (
    course_id VARCHAR(20) REFERENCES Course(course_id) ON DELETE CASCADE,
    section_id VARCHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    faculty_id VARCHAR(20) NOT NULL REFERENCES Faculty(employee_id),
    PRIMARY KEY (course_id, section_id, semester, academic_year)
);

CREATE TABLE Enrollment (
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    course_id VARCHAR(20) NOT NULL,
    section_id VARCHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2) CHECK (grade IN ('S', 'A', 'B', 'C', 'D', 'E', 'F', 'N')),
    attendance_percentage NUMERIC(5, 2) CHECK (attendance_percentage BETWEEN 0.00 AND 100.00),
    PRIMARY KEY (roll_number, course_id, section_id, semester, academic_year),
    FOREIGN KEY (course_id, section_id, semester, academic_year) 
        REFERENCES Course_Section(course_id, section_id, semester, academic_year) ON DELETE CASCADE
);

-- 8. Online Learning Management System (LMS)
CREATE TABLE Learning_Module (
    module_id VARCHAR(20) PRIMARY KEY,
    course_id VARCHAR(20) REFERENCES Course(course_id) ON DELETE CASCADE,
    module_title VARCHAR(150) NOT NULL,
    video_url VARCHAR(255)
);

CREATE TABLE Assignment (
    assignment_id VARCHAR(20) PRIMARY KEY,
    module_id VARCHAR(20) REFERENCES Learning_Module(module_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    due_date TIMESTAMP NOT NULL,
    max_marks INT CHECK (max_marks > 0)
);

CREATE TABLE Assignment_Submission (
    assignment_id VARCHAR(20) REFERENCES Assignment(assignment_id) ON DELETE CASCADE,
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    submission_time TIMESTAMP NOT NULL,
    marks_obtained NUMERIC(5, 2),
    instructor_feedback TEXT,
    PRIMARY KEY (assignment_id, roll_number)
);

CREATE TABLE Quiz (
    quiz_id VARCHAR(20) PRIMARY KEY,
    module_id VARCHAR(20) REFERENCES Learning_Module(module_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    total_marks INT CHECK (total_marks > 0)
);

CREATE TABLE Quiz_Question (
    quiz_id VARCHAR(20) REFERENCES Quiz(quiz_id) ON DELETE CASCADE,
    question_number INT NOT NULL,
    question_text TEXT NOT NULL,
    max_marks NUMERIC(4, 2) NOT NULL,
    PRIMARY KEY (quiz_id, question_number)
);

-- 9. Research Projects & Publications
CREATE TABLE Research_Project (
    project_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    budget NUMERIC(15, 2) CHECK (budget >= 0),
    start_date DATE NOT NULL,
    end_date DATE,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE Project_Participant (
    project_id VARCHAR(20) REFERENCES Research_Project(project_id) ON DELETE CASCADE,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    joining_date DATE NOT NULL,
    percentage_contribution NUMERIC(5, 2) CHECK (percentage_contribution BETWEEN 0.00 AND 100.00),
    PRIMARY KEY (project_id, person_id)
);

CREATE TABLE Publication (
    doi VARCHAR(100) PRIMARY KEY,
    title VARCHAR(250) NOT NULL,
    publication_date DATE NOT NULL,
    venue_details TEXT NOT NULL,
    project_id VARCHAR(20) REFERENCES Research_Project(project_id) ON DELETE SET NULL
);

CREATE TABLE Publication_Author (
    doi VARCHAR(100) REFERENCES Publication(doi) ON DELETE CASCADE,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE CASCADE,
    authorship_order INT NOT NULL CHECK (authorship_order > 0),
    PRIMARY KEY (doi, person_id)
);

-- 10. Library Circulation System
CREATE TABLE Book (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    edition VARCHAR(20),
    publisher VARCHAR(100) NOT NULL
);

CREATE TABLE Book_Copy (
    isbn VARCHAR(20) REFERENCES Book(isbn) ON DELETE CASCADE,
    copy_number INT NOT NULL,
    rack_location VARCHAR(50) NOT NULL,
    current_status VARCHAR(20) CHECK (current_status IN ('Available', 'Issued', 'Under Maintenance')),
    PRIMARY KEY (isbn, copy_number)
);

CREATE TABLE Borrow_Record (
    transaction_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL,
    copy_number INT NOT NULL,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE RESTRICT,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount NUMERIC(8, 2) DEFAULT 0.00,
    FOREIGN KEY (isbn, copy_number) REFERENCES Book_Copy(isbn, copy_number) ON DELETE RESTRICT
);

-- 11. Hostel Management System
CREATE TABLE Hostel (
    hostel_id VARCHAR(20) PRIMARY KEY,
    hostel_name VARCHAR(100) NOT NULL,
    hostel_type VARCHAR(20) CHECK (hostel_type IN ('Men', 'Women', 'Co-ed'))
);

CREATE TABLE Hostel_Room (
    hostel_id VARCHAR(20) REFERENCES Hostel(hostel_id) ON DELETE CASCADE,
    room_number VARCHAR(20) NOT NULL,
    capacity INT CHECK (capacity > 0),
    PRIMARY KEY (hostel_id, room_number)
);

CREATE TABLE Room_Allocation (
    allocation_id SERIAL PRIMARY KEY,
    hostel_id VARCHAR(20) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_out_date DATE,
    FOREIGN KEY (hostel_id, room_number) REFERENCES Hostel_Room(hostel_id, room_number) ON DELETE CASCADE
);

-- 12. University Healthcare Center
CREATE TABLE Doctor (
    doctor_id VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE CASCADE,
    specialization VARCHAR(100) NOT NULL,
    medical_license_no VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Medical_Consultation (
    visit_id SERIAL PRIMARY KEY,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE CASCADE,
    doctor_id VARCHAR(20) REFERENCES Doctor(doctor_id) ON DELETE RESTRICT,
    visit_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnosis TEXT NOT NULL,
    prescription_notes TEXT
);

CREATE TABLE Medicine (
    medicine_id VARCHAR(20) PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL
);

CREATE TABLE Prescribed_Medicine (
    visit_id INT REFERENCES Medical_Consultation(visit_id) ON DELETE CASCADE,
    medicine_id VARCHAR(20) REFERENCES Medicine(medicine_id) ON DELETE RESTRICT,
    dosage VARCHAR(50) NOT NULL,
    instructions VARCHAR(100),
    PRIMARY KEY (visit_id, medicine_id)
);

-- 13. Transportation Management
CREATE TABLE Bus (
    bus_id VARCHAR(20) PRIMARY KEY,
    route_number VARCHAR(30) NOT NULL,
    seating_capacity INT CHECK (seating_capacity > 0)
);

CREATE TABLE Driver (
    driver_id VARCHAR(20) PRIMARY KEY,
    person_id VARCHAR(20) REFERENCES Person(person_id) ON DELETE CASCADE,
    driving_license_no VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Bus_Assignment (
    bus_id VARCHAR(20) REFERENCES Bus(bus_id) ON DELETE CASCADE,
    driver_id VARCHAR(20) REFERENCES Driver(driver_id) ON DELETE RESTRICT,
    assignment_date DATE NOT NULL,
    shift VARCHAR(20) CHECK (shift IN ('Morning', 'Evening', 'Night')),
    PRIMARY KEY (bus_id, driver_id, assignment_date, shift)
);

CREATE TABLE Bus_Subscription (
    subscription_id SERIAL PRIMARY KEY,
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    route_number VARCHAR(30) NOT NULL,
    subscription_date DATE NOT NULL,
    fee_paid NUMERIC(10, 2) CHECK (fee_paid >= 0)
);

-- 14. Extracurricular Clubs
CREATE TABLE Club (
    club_id VARCHAR(20) PRIMARY KEY,
    club_name VARCHAR(100) NOT NULL,
    faculty_advisor_id VARCHAR(20) REFERENCES Faculty(employee_id) ON DELETE RESTRICT
);

CREATE TABLE Club_Membership (
    club_id VARCHAR(20) REFERENCES Club(club_id) ON DELETE CASCADE,
    roll_number VARCHAR(20) REFERENCES Student(roll_number) ON DELETE CASCADE,
    join_date DATE NOT NULL,
    leadership_position VARCHAR(50) CHECK (leadership_position IN ('President', 'Secretary', 'Treasurer', 'Member', 'Vice-President')),
    duration_months INT DEFAULT 12,
    PRIMARY KEY (club_id, roll_number)
);

-- Views for Derived Attributes
CREATE OR REPLACE VIEW V_Person_Demographics AS
SELECT 
    p.person_id,
    p.first_name || ' ' || COALESCE(p.middle_name || ' ', '') || p.last_name AS full_name,
    p.dob,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM p.dob) - 
        CASE WHEN TO_CHAR(CURRENT_DATE, 'MMDD') < TO_CHAR(p.dob, 'MMDD') THEN 1 ELSE 0 END AS derived_age
FROM Person p;

CREATE OR REPLACE VIEW V_Faculty_Experience AS
SELECT 
    f.employee_id,
    f.joining_date,
    ROUND((CURRENT_DATE - f.joining_date) / 365.25, 1) AS derived_experience_years
FROM Faculty f;
