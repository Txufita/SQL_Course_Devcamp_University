CREATE DATABASE universidad;
USE universidad;

-- ====================
-- Create Tables
-- ====================
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE Professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ====================
-- Insert Sample Data
-- ====================
INSERT INTO Students (first_name, last_name) VALUES
('Ana', 'Johnson'),
('Dennis', 'Smith'),
('Carlos', 'Brown'),
('Diana', 'Miller'),
('Ethan', 'Davis');

INSERT INTO Professors (first_name, last_name) VALUES
('Dr.', 'Anderson'),
('Dr.', 'Baker'),
('Dr.', 'Clark');

INSERT INTO Courses (course_name, professor_id) VALUES
('Mathematics', 1),
('Computer Science', 2),
('Physics', 1),
('History', 3),
('Biology', 2);

INSERT INTO Grades (student_id, course_id, grade) VALUES
(1, 1, 88.5),
(1, 2, 92.0),
(1, 3, 76.0),
(2, 1, 90.0),
(2, 4, 85.5),
(3, 2, 70.0),
(3, 5, 95.0),
(4, 3, 82.0),
(4, 4, 89.5),
(5, 1, 67.0),
(5, 5, 73.5),
(5, 2, 80.0);

-- ====================
-- Queries
-- ====================

-- 1. Average grade given by each professor
SELECT p.first_name, p.last_name, AVG(g.grade) AS avg_grade
FROM Professors p
JOIN Courses c ON p.professor_id = c.professor_id
JOIN Grades g ON c.course_id = g.course_id
GROUP BY p.professor_id;

-- 2. Top grade for each student
SELECT s.first_name, s.last_name, MAX(g.grade) AS top_grade
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
GROUP BY s.student_id;

-- 3. Sort students by the courses they are enrolled in
SELECT s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
JOIN Courses c ON g.course_id = c.course_id
ORDER BY c.course_name, s.last_name;

-- 4. Summary report of courses and their average grades
-- (sorted from most challenging to easiest)
SELECT c.course_name, AVG(g.grade) AS avg_grade
FROM Courses c
JOIN Grades g ON c.course_id = g.course_id
GROUP BY c.course_id
ORDER BY avg_grade ASC;

-- 5. Finding which student and professor have the most courses in common

SELECT s.first_name, s.last_name, p.first_name AS prof_first, p.last_name AS prof_last,
       COUNT(*) AS common_courses
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
JOIN Courses c ON g.course_id = c.course_id
JOIN Professors p ON c.professor_id = p.professor_id
GROUP BY s.student_id, p.professor_id
ORDER BY common_courses DESC
LIMIT 1;

