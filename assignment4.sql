/*
Alastair Nicdao
10/1/18
CS: 2550
*/
--Assignment #4
--leave the next lines in your script
set echo on;
set def off;

/*1-- List the first name, last name and registration_date (formatted like "January 2, 1901") for all students that have no phone number. Arrange the list in order of last name and first name. */
SELECT first_name, last_name, Phone, registration_date
FROM Student
WHERE registration_date LIKE '02-JAN-1901'
ORDER BY last_name, first_name;

/*2-- List course number, section ID and start date for all sections located in L509. 
Arrange by start date. */
SELECT course_no, section_ID, start_date_time
FROM Section
WHERE Location = 'L509'
ORDER BY start_date_time;

/*3-- List the course number, section ID, start date, instructor ID and capacity for all courses with a start date in April 2007. Arrange the list by start date and course number. */
SELECT course_no, section_ID, start_date_time, instructor_ID, capacity
FROM section
WHERE start_date_time >= to_date ('April 2007', 'Month YYYY') 
AND start_date_time < to_date ('August 2007', 'Month YYYY')
ORDER BY start_date_time, course_no;

/*4-- List Student ID, Section ID and final grade for all students who have a final grade and enrolled in January 2007. */
SELECT student_ID, section_ID, final_grade
FROM enrollment
WHERE final_grade IS NOT NULL 
AND to_char (enroll_date, 'Mon YYYY') = 'Jan 2007';

/*5-- Create a query using the Oracle Dual Table that returns the end date of the semester assuming the beginning date is January 17, 2017 and the semester is 109 days long.*/
SELECT (TO_DATE('January 17, 2017', 'Month DD, YYYY') + 109) 
AS "End of Semester"
FROM dual;

/*6-- Provide a list of course numbers and locations for sections being taught in the even numbered rooms located in building L (location starts with 'L'). */
SELECT course_no, location
FROM section
WHERE INSTR (location, 'L', 1) > 0
AND mod(TO_NUMBER(SUBSTR(location,2,3)), 2) = 0
ORDER BY course_no;

/*7-- Provide a list of Students in zip code 11368 that registered 3 or more days after their student record was created. */
SELECT first_name || ' ' || last_name AS student_name, zip, registration_date, created_date
FROM student
WHERE TO_NUMBER(zip) = 11368
AND created_date+3 <= registration_date;

/*8-- Create a list of student names (first name, last name) along with the number of years since they registered (round to 2 decimal places) for those students from area code 212. Sort the list on the number of years from highest to lowest. */
SELECT first_name, last_name, TO_CHAR(months_between(SYSDATE, registration_date) / 12, '999.99') AS "Years Enrolled"
FROM student
WHERE SUBSTR(phone, 1, 3) LIKE '212'
ORDER BY months_between(SYSDATE, registration_date) DESC;

/*9-- Create a list of starting times (don't include date component -- just the time) for all course sections. Eliminate duplicates . */
SELECT DISTINCT to_char(start_date_time, 'HH:MI')
FROM section;

/*10-- List the Student ID, Section ID and time enrolled for all students who enrolled at 10:20am. Arrange the list by student ID */
SELECT student_ID, section_ID, TO_CHAR(enroll_date, 'HH:MI AM') AS EnrollTime
FROM enrollment
WHERE to_char(enroll_date, 'HH:MI AM') = '10:20 AM'
ORDER BY student_ID;
