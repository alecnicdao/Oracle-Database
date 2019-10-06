/*
Alastair Nicdao
Using LPAD and RPAD
*/

-- Using the LPAD function to put the character * on the left side to the point where there are a total number of 10 characters.
	-- you can put other characters as well not just *. For example &, (, &, $, #, even words.. For example, your name.
SELECT lpad(empfirstname, 10,'%')
FROM employee;

-- Using the RPAD function to put the character * on the right side to the point where there are a total number of 50 characters.
	-- you can put other characters as well not just *. For example &, (, &, $, #, even words.. For example, your name.
SELECT lpad(empfirstname, 50,'$')
FROM employee;

-- Using both the LPAD and RPAD function and putting a character to reach a total number of 20.
	-- For this one I am going to use the first name for the left side and then last name for the right side
SELECT lpad(empfirstname, 20, '('), rpad(emplastname, 20, ')')
FROM employee;

