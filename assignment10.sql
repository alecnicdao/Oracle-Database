/*
Alastair Nicdao
11/24/18
CS: 2550
Assignment #10 Joins, sub-queries and unions too
*/

--leave this next line in your script
set echo on;
/*1. List the student ID, name and employer of the student that has enrolled the most times. 
Arrange the list in alphabetical order of last name then first name.
*/
SELECT s.student_id, last_name, first_name, employer
FROM student s
JOIN enrollment e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name, s.employer
HAVING COUNT(*) >=
(
	SELECT MAX(COUNT(*))
	FROM student s
	JOIN enrollment e
	ON s.student_id = e.student_id
	GROUP BY s.student_id
)
ORDER BY s.last_name, s.first_name;
/*2. List the first and last name of instructors, their zip code, city and state. Show all instructors -- even if they don't have a zip code. Arrange the list by zip code.
*/
SELECT i.first_name, i.last_name, i.zip, z.city, z.state
FROM instructor i
LEFT
OUTER
JOIN zipcode z
ON z.zip = i.zip
ORDER BY i.zip;
/*3. Provide a list of names and cities of students and instructors that live in zipcode 10025. Identify each person's role as either "Student" or "Instructor". Sort the list by role, last name and first name.
*/
SELECT first_name, last_name, City, 'Student' 
AS ROLE
FROM student s 
JOIN ZIPCODE zip
ON s.zip = zip.zip
WHERE s.zip = 10025
UNION
SELECT first_name, last_name, city, 'Instructor'
AS ROLE
FROM Instructor i
JOIN Zipcode zip
ON i.zip = zip.zip
WHERE i.zip = 10025
ORDER BY ROLE, last_name, first_name;
/*4. Create a query that lists location, number of sections taught in that location and number of students enrolled in sections at that location. Sort by location.
*/
SELECT s.location, COUNT(s.section_id)
AS num_sections,
SUM
((
	SELECT COUNT(distinct e.student_id)
	FROM enrollment e
	WHERE e.section_id = s.section_id)) enrolled_student_count
	FROM section s
	GROUP BY s.location;
/*5. Create a query that shows all of the individual grades for student ID 112 in section 95 and also the average of those grades. The individual grades should come first with the average at the bottom. List the grade type code and numeric grade. The average row should have a caption of, "Average for student 112 is".
*/
SELECT grade_type_code, numeric_grade
AS Grade
FROM section sec 
JOIN enrollment e
ON sec.section_id = e.section_id
JOIN grade g
ON e.student_id = g.student_id
AND e.section_id = g.section_id
WHERE e.section_id = 95
AND e.student_id = 112
	UNION ALL
SELECT 'Average', ROUND(AVG(Grade), 2)
FROM
(
	SELECT grade_type_code, numeric_grade 
	AS GRADE
	FROM section sec
	JOIN enrollment e
	ON sec.section_id = e.section_id
	JOIN grade g
	ON e.student_id = g.student_id
	AND e.section_id = g.section_id
	WHERE e.section_id = 95
	AND e.student_id = 112
);
/*6. Create an alphabetic listing of all instructors and the number of sections that they have taught. 
*/
SELECT first_name, last_name, NVL(COUNT(sec.section_id), 0) 
AS sections
FROM instructor i 
LEFT
JOIN section sec
ON i.instructor_id = sec.instructor_id
GROUP BY first_name, last_name;
/*7. List the course number and description of courses wherein students have received grades for all possible grade types. Order by Course Number.
*/
SELECT s.course_no, c.description
FROM grade g
JOIN section s 
ON s.section_id = g.section_id
JOIN course c 
ON c.course_no = s.course_no
GROUP BY s.course_no, c.description
HAVING
COUNT(distinct g.grade_type_code) 
IN
	(
		SELECT
		COUNT(grade_type_code)
        FROM grade_type
	)
ORDER BY s.course_no;
/*8. List all of the zip codes in Stamford, CT and the number of students from each of the zip codes. Sort by zip code. Show zero (0) for zip codes with no students enrolled.
*/
SELECT z.zip, COUNT(s.student_id) 
AS no_of_students 
FROM zipcode z 
LEFT 
OUTER 
JOIN student s 
ON s.zip = z.zip
WHERE z.city = 'Stamford' 
AND z.state = 'CT' 
GROUP BY z.zip 
ORDER BY z.zip;
/*9. List course number and description all of the Programming courses and the total number of enrollments for each course. Arrange by highest number of enrollments.
*/
SELECT 
DISTINCT c.course_no,
c.description, COUNT(e.student_id)
AS students_enrolled
FROM course c
JOIN section s
ON s.course_no = c.course_no
JOIN enrollment e
ON e.section_id = s.section_id
WHERE c.description
LIKE '%Programming%'
GROUP BY c.course_no, c.description
ORDER BY students_enrolled DESC;
/*10. List student ID and Name of all of the students in area code 617 along with the number of enrollments each has. Alphabetize the list on last name and first name.
*/
SELECT 
DISTINCT st.student_id, st.first_name, st.last_name, COUNT(e.student_id)
AS num_enrollments
FROM student st
JOIN enrollment e
ON e.student_id = st.student_id
WHERE INSTR(st.phone, '617') > 0
GROUP BY st.student_id, st.first_name, st.last_name
ORDER BY st.last_name, st.first_name;