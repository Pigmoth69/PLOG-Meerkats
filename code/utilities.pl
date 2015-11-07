
clearScreen :- write('\33\[2J').

getChar(Input) :- 
				get_char(Input),
				get_char(_).
					

getInteger(Input) :-	get_code(Code),
						Input is Code - 48,
						get_char(_).

getEnter :-	write('antes do enter'), get_char(_), write('depois do enter').

startSeed:-
	now(Usec), Seed is Usec mod 30269,
	getrand(random(X, Y, Z, _)),
	setrand(random(Seed, X, Y, Z)), !.
	
	
