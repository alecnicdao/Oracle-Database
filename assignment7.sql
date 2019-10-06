/*
Alastair Nicdao
11/1/18
CS: 2550
Assignment 7 Sub-Queries
*/

--Assignment #7
--leave the next lines in your script
set echo on;
set pagesize 3500;
set def off;
--
/*1. List the student ID of the student that has enrolled in the most sections of 200 level courses (200 - 299).
-- 1a. retrieve sections of 200 level courses
-- 1b. by student_id, list how many enrollments
-- 1c. by stuednet_id, list how many enrollments for courses 200 -299
-- 1d. Find the greatest number of those
-- 1e. now combine 1b and 1d, make sure you have correct columns and order by
*/
SELECT student_id
FROM enrollment e
JOIN section s 
ON e.section_id = s.section_id
WHERE Course_no 
BETWEEN 200 AND 299
GROUP BY student_id
HAVING COUNT( *) =
	(
		SELECT MAX(Number_Sections)
		FROM
			(
				SELECT student_id, COUNT(*) AS Number_Sections
				FROM enrollment e
				JOIN section s ON e.section_id = s.section_id
				WHERE Course_no BETWEEN 200 AND 299
				GROUP BY student_id
			)
	);

/*2. Provide the student_id and name of the student that scored highest on the final exam (FI) in section 100.
-- create a list of student_id, name and their FI score for section 100
-- create a query that retrieves the highest score for the final exam in section 100
--link the two 
*/
SELECT grade.student_id, student.first_name || ' ' || student.last_name as STUDENT_NAME,
MAX(grade.numeric_grade) as FINAL_SCORE
FROM grade
JOIN student ON grade.student_id = student.student_id
WHERE grade.grade_type_code = 'FI'
AND grade.section_id = 100
AND (grade.numeric_grade) IN 
(
	SELECT
	MAX(numeric_grade)
    FROM grade
    WHERE section_id = 100
	AND grade_type_code = 'FI'
    GROUP BY grade_type_code
)
GROUP BY grade.student_id, student.first_name || ' ' || student.last_name;
/*3. Provide an alphabetic listing of instructors who have never taught a course section.
--create a listing of instructors
--create a listing of sections and instructors
--check the list of instructors to see that it isn't contained in the list of instructors having taught a section
*/
-- instructors that teach
SELECT s.Instructor_ID
FROM Section s 
JOIN Instructor i
ON s.instructor_id = i.instructor_id;
-- instructors that dont teach
SELECT Instructor_ID
FROM Instructor
WHERE Instructor_ID NOT IN
(
	SELECT s.Instructor_ID
	FROM Section s 
	JOIN Instructor i
	ON s.instructor_id = i.instructor_id
);
-- check the list/solution
SELECT Salutation, First_Name, Last_Name, Zip
FROM Instructor
WHERE Instructor_ID NOT IN
(
	SELECT s.Instructor_ID
	FROM Section s 
	JOIN Instructor i
	ON s.instructor_id = i.instructor_id
);

/*4. Generate an alphabetic listing containing the last names and final exam grade (FI) of students who scored above average on the final exam for section 117.
--like number 1, but......now instead of the largest number of enrollments we are comparing against the average for all final scores for section 117
*/
-- **this should be the avg of all section 117 exams
SELECT AVG(Numeric_Grade) 
AS AVG_GRADE
FROM Section s 
JOIN Enrollment e
ON s.section_id = e.section_id
JOIN Grade g
ON e.section_id = g.section_id 
AND e.student_id = g.student_id
WHERE s.section_id = 117
AND grade_type_code = 'FI';

-- Where the answer should go
SELECT Last_Name, Numeric_Grade
FROM Student s 
JOIN Enrollment e
ON s.student_id = e.student_id
JOIN Grade g
ON e.student_id = g.student_id 
AND e.section_id = g.section_id
WHERE numeric_grade > 
(
	SELECT AVG(Numeric_Grade) 
	AS AVG_GRADE
	FROM Section s 
	JOIN Enrollment e
	ON s.section_id = e.section_id
	JOIN Grade g
	ON e.section_id = g.section_id 
	AND e.student_id = g.student_id
	WHERE s.section_id = 117
	AND grade_type_code = 'FI'
)
AND e.section_id = '117'
AND g.grade_type_code = 'FI'
ORDER BY Last_Name;

/*5. List the course number and course description of the courses with the lowest number of enrolled students. Arrange the list on course number.
--figure out for any course, how many students are enrolled in the course? 
--figure out the minimum number of enrollments
--tie list of courses to the result of minimum enrollments
*/
SELECT section.course_no, course.description,
COUNT(*) AS num_enrollments
FROM enrollment
JOIN section 
ON section.section_id = enrollment.section_id 
JOIN course 
ON course.course_no = section.course_no
GROUP BY course.description ,section.course_no
HAVING COUNT (*) IN
    (
		SELECT
        min(count(*))
		FROM
        enrollment
        INNER JOIN section ON section.section_id = enrollment.section_id
		GROUP BY
        section.course_no
	)
ORDER BY section.course_no;
/*6. List course number and course description for all courses that have at least one 10:30AM section. Sort by course number.
--show all of the section records where the time component of start_date_time is '10:30am' 
--list course number, description
-- list course_no and start time 
-- list course_no and start time where start time is 10:30am
-- link course numer and description -- is the course_no 
*/
SELECT c.course_no, c.description
FROM course c, section s
WHERE c.course_no = s.course_no
AND to_char(s.start_date_time, 'HH:MIAM') IN '10:30AM'
GROUP BY c.course_no, c.description
HAVING Count(*) >= 1
ORDER BY c.course_no;

/*7. List the student_id and last_name of students who received a below average grade on the third quiz in section 120.
--find average grade on third quiz in section 120
-- list student_id's scoring below average
--build another query showing student_id and last name
--link queries for student name and student_id below average
*/
SELECT s.student_id, s.last_name
FROM grade g, enrollment e, student s
WHERE g.student_id = e.student_id
AND e.student_id = s.student_id
AND g.grade_type_code = 'QZ'
AND g.grade_code_occurrence = 3
AND e.section_id = 120
AND g.numeric_grade <
(
	SELECT avg (average)
	FROM
	(
		SELECT g.student_id, g.numeric_grade
		AS Average
		FROM Grade g, enrollment e, student s
		WHERE g.student_id = e.student_id
		AND e.student_id = s.student_id
		AND g.grade_type_code = 'QZ'
		AND g.grade_code_occurrence = 3
		AND e.section_id = 120
	)
)
ORDER BY s.last_name;
/*8. Provide an alphabetic list containing the full names and phone numbers of students who have taken both the Systems Analysis and the Project Management courses. You must use the title of the course in your query, not the course number.
--query to show course_no, description for Systems Analysis 
--query to show course_no, description for and Project Management
--query to show student_ids who have taken Systems Analysis
--query to show student_ids who have taken Project Management
--query to show student_id, course_no, student full name, phone numbers for enrollments for the hard-coded courses from prior query 
--drop in sub-queries where the course_no was hard-coded
*/
SELECT student.student_id, student.first_name || ' ' || student.last_name 
AS student_name, student.phone
FROM student
JOIN enrollment ON student.student_id = enrollment.student_id
JOIN section ON section.section_id = enrollment.section_id
JOIN course ON course.course_no = section.course_no
WHERE (course.course_no, course.description) IN 
    (
		SELECT course_no, description
		FROM course
		WHERE
        description = 'Systems Analysis'
        OR description = 'Project Management'
	)
ORDER BY student.last_name, student.first_name;
/*9. List the instructor name and course description of the Java courses that have been taught by the Instructor that has taught the most Java courses. Sort on instructor name and course description.
--list course numbers of courses with Java in description (go ahead and use LIKE on this one)
--create a query to show instructor id, course, course description
--create a query to instructor_id, course_no, count(*) -- a count, by course no and instructor id of courses taught
--show the max count
-- combine queries together intructor_id, count, and max
-- combine that with the list of course numbers & descripttions with Java in description 
*/
SELECT DISTINCT i.first_name, i.last_name, description
FROM instructor i, section s, course c
WHERE i.instructor_id = s.instructor_id
AND s.course_no = c.course_no
AND description like '%Java%'
AND i.instructor_id IN
(
	SELECT i.instructor_id
	FROM instructor i, section s, course c
	WHERE i.instructor_id = s.instructor_id
	AND s.course_no = c.course_no
	AND description LIKE '%Java%'
	GROUP BY i.instructor_id
	HAVING COUNT(*) =
	(
		SELECT MAX(courses)
		FROM
		(
			SELECT COUNT(*) 
			AS courses
			FROM instructor i, section s, course c
			WHERE i.instructor_id = s.instructor_id
			AND s.course_no = c.course_no
			AND description LIKE '%Java%'
			GROUP BY i.last_name
		) --from
	) --having
); --and
/*10. List the student_id and last_name of students who received an above average grade on the Final Exam in section 147.
-- similar to number 2
*/
SELECT s.student_id ,s.last_name
FROM grade g
JOIN student s 
ON s.student_id = g.student_id
WHERE g.section_id = 147
AND g.grade_type_code = 'FI'
AND numeric_grade > 
        (
			SELECT
			AVG(numeric_grade)
			FROM grade
			WHERE section_id = 147
			AND grade_type_code = 'FI'
		)
ORDER BY last_name;