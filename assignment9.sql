/*
Alastair Nicdao
11/20/18
Assignment #9
CS: 2550
*/
--Assignment #9
--leave the next lines in your script
set echo on;
set pagesize 3500;
set def off;
--1.Write a statement that displays the first and last name of the student(s) that were the first to register for school (earliest registration date)
SELECt DISTINCT st.first_name || ' ' || st.last_name
AS student_name
FROM enrollment e
JOIN student st 
ON st.student_id = e.student_id
WHERE TO_CHAR(enroll_date, 'MM/DD/YYYY HH:MI') =
(
	SELECT MIN(TO_CHAR(enroll_date, 'MM/DD/YYYY HH:MI'))
	FROM enrollment
);
--2. Show the course description, section number capacity and cost of the sections with the lowest course cost and a capacity equal to or lower than the average capacity.
SELECT Description, Section_no, Cost, Capacity
FROM Course c 
JOIN Section sec
ON c.course_no = sec.course_no
WHERE Cost =
(
	SELECT MIN(Cost)
	FROM Course
)
	AND sec.capacity <=
	(
		SELECT AVG(capacity)
		FROM Section
	);
--3. Select the course number and total capacity for each course. Show only those courses with a total capacity less than the average capacity of all sections
SELECT c.course_no, s.capacity
FROM course c
JOIN section s ON s.course_no = c.course_no
WHERE s.capacity <
(
	SELECT AVG(capacity)
	FROM section
)
ORDER BY c.course_no;
--4. Choose  most ambitious students by showing the student ID for those students enrolled in the most sections
SELECT s.student_id, COUNT(*) 
AS most_classes
FROM student s 
JOIN enrollment e
ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(*) = 
(
	SELECT MAX(COUNT(*))
	FROM Student s 
	JOIN Enrollment e
	ON s.student_id = e.student_id
	GROUP BY s.student_id
);
--5. Select the Student ID and section ID of enrolled students living is Zip Code 11365
SELECT s.student_id, e.section_id
FROM student s 
JOIN enrollment e
ON s.student_id = e.student_id
WHERE zip = 11365;
--6. Display the course number and the course description of courses taught by Nina Schorin
SELECT c.course_no, c.description
FROM course c
JOIN section s 
ON s.course_no = c.course_no
JOIN instructor i 
ON i.instructor_id = s.instructor_id
-- first name
WHERE i.first_name =  'Nina'
-- last name
AND i.last_name = 'Schorin'
ORDER BY course_no;
--7. Show the first and last names of students who are not enrolled in any class
SELECT first_name, last_name
FROM student s
MINUS
SELECT first_name, last_name
FROM student s 
JOIN enrollment e
ON s.student_id = e.section_id
ORDER BY last_name, first_name;
--8. Determine the student name, course description, and section ID of the students who had the lowest Participation (PA) grade from all courses.
SELECT DISTINCT first_name, last_name, description, e.section_id
FROM student s 
JOIN enrollment e
ON s.student_id = e.student_id
JOIN Grade g
ON e.student_id = g.student_id
AND e.section_id = g.section_id
JOIN section sec
ON e.section_id = sec.section_id
JOIN course c
ON sec.course_no = c.course_no
WHERE grade_type_code = 'PA'
AND g.numeric_grade =
(
	SELECT MIN(numeric_grade)
	FROM grade
	WHERE grade_type_code = 'PA'
);
--9. Select the sections that are full by comparing capacity to the number enrolled. Show the capacity and the section ID
SELECT section_id, capacity
FROM section
WHERE capacity IN
(
	SELECT count(student_id)
	FROM enrollment
	GROUP BY section_id
);
--10.Show the course number, description and cost of the cheapest courses
SELECT course_no, description, cost
FROM course c
WHERE cost =
(
	-- cheapest courses
	SELECT MIN(cost)
	FROM course
);