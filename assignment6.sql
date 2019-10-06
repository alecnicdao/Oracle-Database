/*
Alastair Nicdao
10/17/18
CS: 2550
Assignment 6 Joins, and aggregations
*/

--Assignment #6
--leave the next lines in your script
set echo on;
set pagesize 3500;
set def off;

/*1. List the full name (first and last name) and phone number for students that live in Newark, NJ.
Sort on last name and first name.*/
SELECT First_Name ||' '|| Last_Name, S.phone
AS "FULL NAME"
FROM Student s 
JOIN Zipcode zip
ON s.zip = zip.zip
WHERE zip.city = 'Newark'
AND zip.state = 'NJ'
ORDER BY Last_Name, First_Name;

/*2. For all 200 level courses (200-299), list the course number, prerequisite course number and prerequisite course description. Sort by course number.
*/
SELECT c.course_NO, c.prerequisite,(SELECT DESCRIPTION
FROM Course
WHERE Course_no = c.prerequisite)
AS DESCRIPTION FROM Course C
WHERE C.Course_NO >= 200 
AND C.Course_NO <= 299
ORDER BY C.Course_NO;

/*3. List the course number and description for all 100-level courses taught by Charles Lowry. 
Arrange the list in order of course number.
*/
SELECT s.COURSE_NO, c.Description
FROM Course c 
JOIN Section s
ON c.course_no = s.course_no
JOIN Instructor i
ON s.instructor_id = i.instructor_id
WHERE i.first_name = 'Charles'
	AND i.last_name = 'Lowry'
	AND c.course_no >= 100
	AND c.course_no < 200
ORDER BY c.course_no;

/*4. List the grade type code, description and number per section (a column in the grade_type_weight table) of all grades in course 144. Arrange by description.
*/
SELECT gtw.grade_type_code,
	CASE gtw.grade_type_code
		WHEN 'FI' THEN 'FINAL'
		WHEN 'HW' THEN 'HOMEWORK'
		WHEN 'MT' THEN 'MIDTERM'
		WHEN 'PA' THEN 'PARTICIPATION'
		WHEN 'QZ' THEN 'QUIZ'
	END Description, number_per_section
FROM Section s 
JOIN Grade_type_weight gtw
ON s.section_id = gtw.section_id
WHERE course_no = 144;

/*5. Provide an alphabetic list of students (student last name followed by first name) who have an overall grade average of 93 or higher. The name should be one column, last name first and sorted on last name then first name.
*/
SELECT Last_Name ||', ' || First_Name
AS "Student Name"
FROM Student s 
JOIN Enrollment e
ON s.student_id = e.student_id
JOIN Grade g
ON e.student_id = g.student_id
GROUP BY Last_Name, First_Name
HAVING AVG(numeric_grade) >= 93
ORDER BY Last_Name;

/*6. List the names (first name and last name) and address (including city and state) for all faculty who have taught less than 10 course sections.
*/
SELECT i.First_Name, i.Last_Name, i.street_address, zip.city, zip.state, zip.zip
FROM Instructor i
JOIN Zipcode zip
ON i.zip = zip.zip
JOIN Section s
ON i.instructor_id = s.instructor_id
GROUP BY i.First_name, i.Last_name, i.Street_address, zip.city, zip.state, zip.zip
HAVING count(*) < 10;

/*7. List the course number and number of students enrolled in courses that don’t have a prerequisite. Sort the list by number of students enrolled from highest to lowest.
*/
SELECT c.course_no, count(*) 
AS Enrolled
FROM Course c 
JOIN Section s
ON c.course_no = s.course_no
JOIN Enrollment e
ON s.section_id = e.section_id
WHERE c.prerequisite IS NULL
GROUP BY c.course_no
ORDER BY Enrolled DESC;

/*8. Provide a distinct alphabetic list of students (first and last name and phone number) from Flushing, NY who enrolled prior to 10:20am on February 2, 2007.
*/
SELECT s.First_Name, s.Last_Name, s.Phone, e.enroll_date, TO_CHAR(e.enroll_date, 'HH:MI AM')
FROM Student s 
JOIN Zipcode zip
ON s.zip = zip.zip
JOIN Enrollment e
ON s.student_id = e.student_id
WHERE zip.city = 'Flushing'
	AND zip.state = 'NY'
	AND e.enroll_date <= TO_DATE ('02-02-2007 10:20 AM', 'MM-DD-YYYY HH:MI AM');
	
/*9. Provide a listing of courses (course number and course name) that include projects as a part of their grading criteria. 
*/
SELECT course_no
FROM Section s 
JOIN Grade_Type_Weight gtw
ON s.section_id = gtw.section_id
WHERE gtw.grade_type_code = 'PJ'
ORDER BY course_no;

/*10. List the highest grade on the final exam that was given to a student in course 145.
*/
SELECT MAX(Numeric_grade)
AS Highest_Final_Grade
FROM Section s
JOIN Enrollment e
ON s.section_id = e.section_id
JOIN Grade g
ON e.student_id = g.student_id
AND e.section_id = g.section_id
WHERE s.course_no = 145
	AND g.grade_type_code = 'FI';