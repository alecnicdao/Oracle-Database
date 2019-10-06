/*
Alastair Nicdao
9/13/18
CS: 2550
*/
--Assignment #2 extra credit

--leave this next line in your script
set echo on;
--

--1. List the salutation and names (first and last name) of all instructors in alphabetical order (last name then first name).
SELECT Salutation, First_name, Last_name
FROM Instructor
ORDER BY Last_name, first_name;

--2. Provide a list of distinct locations that have been used to teach sections of courses. Arrange the list in order of location.
SELECT DISTINCT Location
FROM Section
ORDER BY Location;

--3. List the first and last names of Instructors with a last name starting with “W”. Sort them in alphabetical order (last name, then first name).
SELECT First_Name, Last_Name 
FROM Instructor
WHERE Last_Name LIKE 'W%'
ORDER BY Last_Name, First_Name;

--4. List the phone number, full name (as one column) and employer for all students with a last name of “Valentine”. Sort by Employer
SELECT Phone, First_Name || ' ' || Last_Name
FROM Student
WHERE Last_Name LIKE 'Valentine'
ORDER BY Employer;

--5. List the course number and course description of all courses that have a prerequisite of course 80.
SELECT Course_No, Description
FROM Course
WHERE course_no = 80;

--6. List the course number, description and cost for all 200 level courses (200-299) costing less than $1100. Arrange by course number.
SELECT Course_No, description, cost
FROM course
WHERE course_no >= 200 AND course_no <= 299 AND cost < 1100
ORDER BY course_no;

--7. List the course number, section id and location for all 100 level courses (100 through 199) that are taught in room L214 or L509. Order by location and course number.
SELECT course_no, section_id, LOCATION
FROM Section
WHERE course_no >= 100 AND course_no <= 199 AND (location = 'L214' OR location = 'L509')
ORDER BY course_no, LOCATION;

--8. List the course number and section id for classes with a capacity of 12 or 15 (use the IN clause). Order the list by course number and section id.
SELECT course_no, section_id
FROM Section
WHERE capacity IN (12,15)
ORDER BY course_no, section_id;

--9. List the student id and grade for all of the midterm exam scores (MT) in section 141. Arrange the list by student id and grade.
SELECT DISTINCT student_id, numeric_grade
FROM Grade
WHERE SUBSTR (section_id, 1,3) = 141 AND Grade_Type_Code = 'MT'
ORDER BY student_id, numeric_grade;

--10. List the course number and description for all 300 level courses that have a prerequisite, arranged on course description.
SELECT course_no, description
FROM Course
WHERE course_no between 300 AND 399 AND prerequisite is not NULL
ORDER BY description;