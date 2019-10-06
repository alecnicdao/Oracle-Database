/*
Alastair Nicdao
10/6/10
CS: 2550
Assignment #5
*/

---Don't forget to read the standards and assumptions (above).
--Assignment #5
--leave the next lines in your script
set echo on;
set def off;
set pagesize 3500;

/*1. Create a query that returns the average cost for all courses. (Round to two places).
*/
SELECT TO_CHAR(AVG(Cost), '9999.99')
FROM Course;

/*2. Create a query that returns the total number of Students that registered during January 2007. Alias the column as "January_Registrations". 
*/
SELECT SUM(COUNT(Registration_Date))
AS "January_Registrations"
FROM Student
GROUP BY Registration_Date
HAVING TO_CHAR(Registration_Date, 'Mon YYYY') = 'Jan 2007';

/*3. Create a query that returns the average, highest and lowest final exam scores for Section 89.
*/
SELECT TO_CHAR(AVG(Numeric_Grade), '99.99') 
AS Average, MAX(Numeric_Grade)
AS Highest, MIN(Numeric_Grade)
AS Lowet
FROM Grade
WHERE Section_ID = 89;

/*4. List the city, state and number of zipcodes for all cities with more than two zipcodes. Arrange by state and city.
*/
SELECT City, State, COUNT(Zip) 
AS Zipcodes
FROM Zipcode
GROUP BY City, State
HAVING COUNT(*) > 2
ORDER BY State, City;

/*5. Provide a list of Sections and the number of students enrolled in each section for students who enrolled on 2/21/2007. Sort from highest to lowest on the number of students enrolled.
*/
SELECT Section_ID, COUNT(*) 
AS Enrolled
FROM Enrollment
WHERE TO_CHAR(Enroll_Date, 'MM/DD/YYYY') = '02/21/2007'
GROUP BY section_id
ORDER BY Enrolled DESC;

/*6. Create a query listing the student ID, Section ID and Average Grade for all students in Section 86.
Sort your list on the student ID and display all of the average grades rounded to 4 decimal places.
*/
SELECT Student_ID, Section_ID, TO_CHAR(AVG(Numeric_Grade), '99.9999') 
AS AverageGrade
FROM Grade
WHERE Section_ID = 86
GROUP BY Student_ID, Section_ID
ORDER BY Student_ID;

/*7. Create a query to determine the number of sections in which student ID 124 is enrolled.
Your output should contain the student ID and the number of sections enrolled.
*/
SELECT Student_ID, COUNT(*) 
AS Sections
FROM Enrollment
GROUP BY student_id
HAVING Student_ID = 124;

/*8. List the section ID and lowest quiz score for all sections where the low score is at least a B (at least 80).
Arrange by section id.
*/
SELECT Section_ID, MIN(Numeric_Grade)
AS Lowscore
FROM Grade
WHERE grade_type_code = 'QZ'
GROUP BY Section_ID
HAVING MIN(Numeric_Grade) >= 80
ORDER BY Section_ID;

/*9. List the names of Employers having more than 4 student employees.
Your output should contain the employer name and the number of student employees.
Arrange the output on the number of employees from lowest to highest.
*/
SELECT Employer, COUNT(*)
AS student_employee
FROM Student
GROUP BY Employer
HAVING COUNT(*) > 4
ORDER BY COUNT(*);

/*10. List the section ID, number of participation grades and lowest participation grade for all sections with more than 15 participation grades. Arrange by section id.
*/
SELECT Section_ID, Count(Grade_Type_Code) 
AS Participation_Grades, MIN(Numeric_Grade) AS Lowest_Grade
FROM Grade
WHERE Grade_Type_Code = 'PA'
GROUP BY Section_ID
HAVING COUNT(Grade_Type_Code) > 15
ORDER BY Section_ID;