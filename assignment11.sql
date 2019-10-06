/*
Alastair Nicdao
11/29/18
Assignment #11 Insert, updates, and deletes
*/

--leave this next line in your script
set echo on;

--1. Insert a new instructor: Mr. Hugo Reyes with an ID of 815. His address is 2342 Oceanic Way, Bayonne, NJ, 07002. He doesn't have a phone number .
--2. Create a new section ID of 48 for Mr. Reyes. He'll be teaching section 4 of the Project Management Course (142) beginning on September 22, 2011 at 8:15am in Room L211. The capacity is 15 students. 
--3. Enroll students 375, 137, 266 and 382 in the course. Their enrollment date should be the current date. (Use ONE INSERT statement)
--4. Remove the enrollment for student 147 from section 120.
--Note the error. You cannot delete the enrollment record because there are foreign keys in the Grade table that depend on the Enrollment table records, thus creating an integrity constraint violation.
--First remove all grades for student 147, section 120 and then remove the enrollment for student 147, section 120. (Use two DELETE statements)
DELETE 
FROM grade
WHERE student_id = 147
AND section_id = 120;

DELETE 
FROM enrollment
WHERE student_id = 147
AND section_id = 120;
--5. Use the same procedure to remove the enrollment record for student 180 in section 119.
DELETE 
FROM grade
WHERE student_id = 180 
AND section_id = 119;

DELETE 
FROM enrollment
WHERE student_id = 180
AND section_id = 119;
--6. Change Mr. Reyes’ (ID 815) phone number to be 4815162342.
UPDATE instructor -- reyes
SET phone = '4815162342' -- number
WHERE instructor_id = '815'; -- id
--7. Change the grade on the first homework (HM) assignment for each student in section 119 to 100.
UPDATE grade
SET numeric_grade = '100'
WHERE grade_type_code = 'HM'
AND grade_code_occurrence = '1'
AND section_id = '119';
--8. Increase the final exam (FI) score for each student in section 119 by 10 percent.
UPDATE grade
SET numeric_grade = TO_CHAR
(
	numeric_grade + (numeric_grade * 0.1)
)
WHERE section_id = '119'
AND grade_type_code = 'FI';
--9. For each section of the Project Management course, list the section ID, location and number of students enrolled. Sort by section ID
SELECT s.section_id, s.location, 
COUNT (e.student_id) 
AS num_students 
FROM section s 
JOIN enrollment e 
ON e.section_id = s.section_id 
JOIN course c 
ON c.course_no = s.course_no 
WHERE c.description = 'Project Management' 
GROUP BY s.section_id, s.location 
ORDER BY s.section_id;
--10. Provide an alphabetic list of instructor names and addresses for instructors that teach the Project Managment course.
SELECT i.instructor_id, i.first_name, i.last_name, i.street_address, z.city, z.state -- street address (city and state)
FROM instructor i 
JOIN zipcode z 
ON z.zip = i.zip 
WHERE instructor_id 
IN
	( 
		SELECT s.instructor_id 
		FROM section s 
		JOIN course c 
		ON c.course_no = s.course_no 
		WHERE c.description = 'Project Management'
	) 	
ORDER BY i.last_name, i.first_name;

 rollback;