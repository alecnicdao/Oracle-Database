/*
Alastair Nicdao
Using INSTR
*/

-- Showing where the number 5 is located in the empphone
	-- remember that it counts everything as characters 
select empfirstname, emplastname, empphone, instr(empphone,'5')
	-- it'll show the number of postion of where the number 5 is location (for example: position number 13)
from employee;

-- Showing where a letter is located
select empfirstname, instr(empfirstname, 'a')
	-- Landi, for example the letter a is at postion number 2
from employee;
