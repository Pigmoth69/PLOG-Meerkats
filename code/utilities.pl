
clearScreen :- write('\33\[2J').

getChar(Input) :- 	get_char(Input),
					get_char(_).

getEnter :-	get_char(_).