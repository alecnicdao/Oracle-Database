/*
Alastair Nicdao
Usin TO_CHAR to convert #'s
*/

-- getting the salary from employees and make it look like $1,000 rather than 1000.
SELECT TO_CHAR(salary, 'L99G999'), salary
FROM employee