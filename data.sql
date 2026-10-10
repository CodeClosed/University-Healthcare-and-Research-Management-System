-- ============================================================================
-- UNIVERSITY HEALTHCARE AND RESEARCH MANAGEMENT SYSTEM (VIT)
-- DATA INSERTION SCRIPT (DML)
-- ============================================================================

-- 1. Insert Persons
INSERT INTO Person VALUES
('P1001', 'Aarav', 'Kumar', 'Sharma', '2003-05-14', 'Male', 'aarav.sharma@vit.ac.in', 'D-102', 'Kelambakkam Rd', 'Chennai', 'Tamil Nadu', 'India', '600127'),
('P1002', 'Sneha', 'Lata', 'Patel', '2004-02-18', 'Female', 'sneha.patel@vit.ac.in', 'A-304', 'Katpadi Main Rd', 'Vellore', 'Tamil Nadu', 'India', '632014'),
('P1003', 'Rohan', NULL, 'Verma', '2003-11-20', 'Male', 'rohan.verma@vit.ac.in', 'B-12', 'Gandhi Nagar', 'Vellore', 'Tamil Nadu', 'India', '632006'),
('P1004', 'Dr. Ramesh', NULL, 'Sundaram', '1978-08-22', 'Male', 'ramesh.s@vit.ac.in', 'F-401', 'Faculty Quarters', 'Vellore', 'Tamil Nadu', 'India', '632014'),
('P1005', 'Dr. Meenakshi', 'R', 'Iyer', '1972-11-05', 'Female', 'meenakshi.iyer@vit.ac.in', 'H-102', 'Professors Enclave', 'Vellore', 'Tamil Nadu', 'India', '632014'),
('P1006', 'Dr. Suresh', 'K', 'Nair', '1982-04-12', 'Male', 'suresh.nair@vit.ac.in', 'C-205', 'Staff Enclave', 'Vellore', 'Tamil Nadu', 'India', '632014'),
('P1007', 'Karthik', NULL, 'Raman', '1989-09-30', 'Male', 'karthik.r@vit.ac.in', '14/B', 'Green Valley', 'Vellore', 'Tamil Nadu', 'India', '632001'),
('P1008', 'Dr. Hans', NULL, 'Mueller', '1980-01-15', 'Male', 'hans.mueller@tum.de', 'GH-1', 'International Guest House', 'Vellore', 'Tamil Nadu', 'Germany', '632014'),
('P1009', 'Dr. Ananya', 'S', 'Deshmukh', '1985-07-25', 'Female', 'ananya.d@vit.ac.in', 'D-55', 'Medical Colony', 'Vellore', 'Tamil Nadu', 'India', '632014'),
('P1010', 'Murugan', NULL, 'Velu', '1984-03-10', 'Male', 'murugan.v@vit.ac.in', '7/1', 'Bus Depot Colony', 'Vellore', 'Tamil Nadu', 'India', '632009');

-- 2. Insert Departments
INSERT INTO Department VALUES
('DEPT_CSE', 'School of Computer Science & Engineering', 'Technology Tower (TT)', 7500000.00, NULL),
('DEPT_ECE', 'School of Electronics Engineering', 'SJT Tower', 6000000.00, NULL);

-- 3. Insert Faculty
INSERT INTO Faculty VALUES
('FAC_CSE_01', 'P1004', 'Associate Professor', 145000.00, '2015-06-10', 'DEPT_CSE'),
('FAC_CSE_HOD', 'P1005', 'Professor & HoD', 215000.00, '2008-01-15', 'DEPT_CSE'),
('FAC_ECE_01', 'P1006', 'Professor', 180000.00, '2012-08-20', 'DEPT_ECE');

-- Update HoD links in Department
UPDATE Department SET hod_faculty_id = 'FAC_CSE_HOD' WHERE department_id = 'DEPT_CSE';
UPDATE Department SET hod_faculty_id = 'FAC_ECE_01' WHERE department_id = 'DEPT_ECE';

-- Faculty Multivalued Attributes & Recursive Mentoring
INSERT INTO Faculty_Phone VALUES
('FAC_CSE_01', '+91-9876543210'),
('FAC_CSE_01', '+91-9876543211'),
('FAC_CSE_HOD', '+91-9988776655');

INSERT INTO Faculty_Research_Interest VALUES
('FAC_CSE_01', 'Machine Learning & Healthcare Analytics'),
('FAC_CSE_01', 'High-Performance Graph Databases'),
('FAC_CSE_HOD', 'Cloud Security & Distributed Systems');

INSERT INTO Faculty_Mentoring VALUES
('FAC_CSE_01', 'FAC_CSE_HOD', '2015-07-01');

-- 4. Insert Students
INSERT INTO Student VALUES
('21BCE1001', 'P1001', 'B.Tech Computer Science and Engineering', 7, 9.88),
('21BCE1002', 'P1002', 'B.Tech Computer Science and Engineering', 7, 8.95),
('21BEC1001', 'P1003', 'B.Tech Electronics and Communication', 7, 9.40);

INSERT INTO Student_Skill VALUES
('21BCE1001', 'PostgreSQL Query Optimization'),
('21BCE1001', 'PyTorch Neural Networks'),
('21BCE1002', 'React.js Frontend Architecture');

INSERT INTO Student_Certification VALUES
('21BCE1001', 'AWS Certified Solutions Architect'),
('21BCE1001', 'Oracle Certified Database Professional');

INSERT INTO Research_Supervision VALUES
('FAC_CSE_01', '21BCE1001', 'Deep Clinical Graph Embeddings', '2024-01-10');

-- 5. Insert Staff & Visiting Scholar
INSERT INTO Staff VALUES
('STF_01', 'P1007', 'DEPT_CSE', 'General Day Shift (8:30 AM - 5:30 PM)');

INSERT INTO Visiting_Scholar VALUES
('SCH_01', 'P1008', 'Technical University of Munich', 'Germany', 180);

-- 6. Insert Courses & Sections
INSERT INTO Course VALUES
('CSE3001', 'Database Management Systems', 4, 'DEPT_CSE'),
('CSE4001', 'Artificial Intelligence in Medicine', 3, 'DEPT_CSE'),
('ECE2002', 'Digital Signal Processing', 4, 'DEPT_ECE');

INSERT INTO Course_Section VALUES
('CSE3001', 'L01', 'Fall Semester', '2025-2026', 'FAC_CSE_01'),
('CSE3001', 'L02', 'Fall Semester', '2025-2026', 'FAC_CSE_HOD'),
('CSE4001', 'L01', 'Fall Semester', '2025-2026', 'FAC_CSE_01');

-- 7. Insert Enrollments
INSERT INTO Enrollment VALUES
('21BCE1001', 'CSE3001', 'L01', 'Fall Semester', '2025-2026', '2025-07-15', 'S', 98.00),
('21BCE1002', 'CSE3001', 'L01', 'Fall Semester', '2025-2026', '2025-07-15', 'A', 91.50),
('21BEC1001', 'CSE3001', 'L01', 'Fall Semester', '2025-2026', '2025-07-16', 'B', 84.00);

-- 8. LMS Data
INSERT INTO Learning_Module VALUES
('MOD_DBMS_01', 'CSE3001', 'Relational Algebra & Normalization', 'https://vit.ac.in/lms/videos/mod1.mp4');

INSERT INTO Assignment VALUES
('ASN_01', 'MOD_DBMS_01', 'Complex SQL & Transaction Isolation', '2025-09-15 23:59:59', 50);

INSERT INTO Assignment_Submission VALUES
('ASN_01', '21BCE1001', '2025-09-14 18:22:10', 49.50, 'Exemplary indexing strategy and execution plans.'),
('ASN_01', '21BCE1002', '2025-09-15 21:10:00', 43.00, 'Good schema design; minor foreign key omission.');

INSERT INTO Quiz VALUES
('QZ_01', 'MOD_DBMS_01', 'Mid-Term Relational Theory Quiz', 20);

INSERT INTO Quiz_Question VALUES
('QZ_01', 1, 'Prove whether BCNF decomposition guarantees dependency preservation.', 10.00),
('QZ_01', 2, 'Explain phantom read anomaly under Repeatable Read isolation.', 10.00);

-- 9. Research Projects & Publications
INSERT INTO Research_Project VALUES
('RP_VIT_2024_01', 'AI-Driven Multimodal Healthcare Intelligence', 3500000.00, '2024-01-01', '2026-12-31');

INSERT INTO Project_Participant VALUES
('RP_VIT_2024_01', 'P1001', 'Lead Student Researcher', '2024-02-01', 40.00),
('RP_VIT_2024_01', 'P1004', 'Principal Investigator', '2024-01-01', 60.00);

INSERT INTO Publication VALUES
('10.1109/JBHI.2025.32109', 'Scalable Deep Graph Learning on Clinical Patient Databases', '2025-05-12', 'IEEE Journal of Biomedical and Health Informatics', 'RP_VIT_2024_01');

INSERT INTO Publication_Author VALUES
('10.1109/JBHI.2025.32109', 'P1001', 1),
('10.1109/JBHI.2025.32109', 'P1004', 2);

-- 10. Library Data
INSERT INTO Book VALUES
('978-0133970777', 'Database System Concepts', '7th Edition', 'McGraw-Hill'),
('978-0136086208', 'Fundamentals of Database Systems', '7th Edition', 'Pearson');

INSERT INTO Book_Copy VALUES
('978-0133970777', 1, 'RACK-CS-04-A', 'Issued'),
('978-0133970777', 2, 'RACK-CS-04-A', 'Available'),
('978-0136086208', 1, 'RACK-CS-04-B', 'Available');

INSERT INTO Borrow_Record (transaction_id, isbn, copy_number, person_id, issue_date, due_date, return_date, fine_amount)
VALUES (1, '978-0133970777', 1, 'P1001', '2025-08-01', '2025-08-15', '2025-08-18', 15.00);

-- 11. Hostel Data
INSERT INTO Hostel VALUES
('HST_MH_Q', 'Q-Block Men Hostel', 'Men'),
('HST_LH_E', 'E-Block Ladies Hostel', 'Women');

INSERT INTO Hostel_Room VALUES
('HST_MH_Q', '604', 2),
('HST_LH_E', '312', 2);

INSERT INTO Room_Allocation (allocation_id, hostel_id, room_number, roll_number, check_in_date, check_out_date)
VALUES (1, 'HST_MH_Q', '604', '21BCE1001', '2024-07-20', NULL);

-- 12. Healthcare Data
INSERT INTO Doctor VALUES
('DOC_01', 'P1009', 'General Medicine & Infectious Diseases', 'TMC-88492-MD');

INSERT INTO Medical_Consultation (visit_id, person_id, doctor_id, visit_date, diagnosis, prescription_notes)
VALUES (1, 'P1001', 'DOC_01', '2025-09-02 10:30:00', 'Seasonal Acute Rhinitis', 'Hydration and 3-day antihistamine course');

INSERT INTO Medicine VALUES
('MED_01', 'Cetirizine 10mg', 'Dr. Reddy Laboratories'),
('MED_02', 'Paracetamol 650mg', 'Cipla Pharmaceuticals');

INSERT INTO Prescribed_Medicine VALUES
('1', 'MED_01', '1 tablet OD', 'Take post dinner for 3 days');

-- 13. Transportation Data
INSERT INTO Bus VALUES
('BUS_24', 'Route-24 Katpadi to Campus', 54);

INSERT INTO Driver VALUES
('DRV_01', 'P1010', 'DL-TN23-20110098231');

INSERT INTO Bus_Assignment VALUES
('BUS_24', 'DRV_01', '2025-09-10', 'Morning');

INSERT INTO Bus_Subscription (subscription_id, roll_number, route_number, subscription_date, fee_paid)
VALUES (1, '21BCE1002', 'Route-24 Katpadi to Campus', '2025-07-10', 14500.00);

-- 14. Club Data
INSERT INTO Club VALUES
('CLUB_AI', 'Artificial Intelligence & Robotics Club', 'FAC_CSE_01');

INSERT INTO Club_Membership VALUES
('CLUB_AI', '21BCE1001', '2023-08-01', 'President', 24);
