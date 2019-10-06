/*
Alastair Nicdao
9/20/18
Assignment #3 
FUNCTIONS
*/
--Assignment #3
--leave this next line in your script
set echo on;
set define off;

--1. Provide an alphabetical list of the full name and phone number of all students that work for 'Alex. & Alexander' (the full name should be displayed as one column with an alias of 'Student Name')
SELECT  first_name||' '|| last_name AS "Student Name", phone
FROM Student
WHERE Employer = 'Alex & Alexander'
ORDER BY last_name, phone;

--2. Provide a list of student employers that are corporations (have "Co." in their name). List each employer only once and arrange the list alphabetical order.
SELECT DISTINCT Employer
FROM Student
WHERE Employer LIKE '%Co.'
ORDER BY lower (Employer);

--3. Provide an alphabetical list of students in area code 212. List student name in the format <last name (all upper case)>, <first initial>. ( Example, SMITH, J. ) followed by the phone number.
SELECT last_name||', '|| SUBSTR (first_name, 1, 1)||'.' AS "Student Name", phone
FROM student
WHERE phone LIKE '212%'
ORDER BY Last_name;

--4. List the first name, last name and address of all instructors without a zip code.
SELECT upper (first_name || ' ' || last_name) "Instructor", Street_Address
FROM Instructor
WHERE Zip IS NULL;

--5. Provide a list of zip codes for Jackson Heights, NY. Sort on zip.
SELECT Zip
FROM Zipcode
WHERE city LIKE 'Jackson Heights'
AND state = 'NY'
ORDER BY zip;

--6. List the course number and location for all courses taught in a classroom that ends in the number 10. Arrange the list on course number.
SELECT Course_No, Location
FROM Section
WHERE Location LIKE '%10'
ORDER BY course_no;

--7. Provide a list containing full state name, state abbreviation and city from the zip code table for FL, OH, PR and WV. (Please use CASE for this). FL is Florida, OH is Ohio, PR is Puerto Rico and WV is West Virginia.Sort by state.
SELECT
	CASE State
		WHEN 'FL' THEN upper('Florida')
		WHEN 'OH' THEN 'Ohio'
		WHEN 'PR' THEN 'Puerto Rico'
		WHEN 'WV' THEN lower('West Virginia')
	END "State Name", State, City
FROM zipcode
WHERE state IN ('FL', 'OH', 'PR', 'WV')
ORDER BY State;
	
--8. Create a listing containing single column address (salutation, first name, last name, address, zip) as 'Instructor Address' for each instructor in zip code 10025. Sort the list in alphabetical order.
SELECT Salutation||'. '|| upper (first_name)||' '||last_name||' '||Street_address AS "Instructor Address"
FROM instructor
WHERE zip LIKE lower ('10025')
ORDER BY first_name, last_name DESC;

--9. List the student id and quiz scores for each student in section 125. List the scores from highest to lowest.
SELECT student_id, numeric_grade
FROM grade
WHERE section_id = 125
AND grade_type_code LIKE upper ('QZ')
ORDER BY numeric_grade DESC;

--10. List the student ID, final exam (FI) score and exam result ('PASS' or 'FAIL') for all students in section 86. A final score of 85 or higher is required to pass. Arrange the list by student ID.
SELECT student_ID, numeric_grade,
	CASE
		WHEN Numeric_Grade >= 85 THEN upper ('Pass')
		ELSE lower ('Fail')
	END "Result"
FROM Grade
WHERE section_ID = 156 AND Grade_type_code = 'FI'
ORDER BY student_ID;
