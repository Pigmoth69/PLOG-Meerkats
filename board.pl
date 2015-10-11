hexBoard(Board) :- Board =
[	[[' '], [' '],[' '], [' '],
	 [' ']],
 	[[' '], [' '],[' '], [' '],
	 [' '], [' ']],
	[[' '], [' '],[' '], [' '],
	 [' '], [' '],[' ']],
	[[' '], [' '],[' '], [' '],
	 [' '], [' '],[' '], [' ']],
 	[[' '], [' '],[' '], [' '],
	 [' '], [' '],[' '], [' '],
	 [' ']],
 	[[' '], [' '],[' '], [' '],
	 [' '], [' '],[' '], [' ']],
 	[[' '], [' '],[' '], [' '],
	 [' '], [' '],[' ']],
	[[' '], [' '],[' '], [' '],
	 [' '], [' ']],
	[[' '], [' '],[' '], [' '],
	 [' ']]
].

drawBoard(Board) :- secundaryDrawBoard(Board, 0).

secundaryDrawBoard([Line | Board], Number) :- Board \= [], 
											drawIdentation(Number), write_border(Line),
											drawIdentation(Number), write_line(Line),
											NewNumber is Number+1,
											secundaryDrawBoard(Board, NewNumber).

secundaryDrawBoard([Line], Number) :-	drawIdentation(Number), write_border(Line),
										drawIdentation(Number), write_line(Line), 
										drawIdentation(Number), write_border(Line).

write_border([_|Line]) :- write('   *---'), write_border_aux(Line).

write_border_aux([]) :- write('*\n').

write_border_aux([_|Line]) :- write('*---'), write_border_aux(Line).

write_aux_line([]) :- write('|\n').

write_aux_line([Elem|Line]) :- 	write('|'), write_elem(Elem),
								write_aux_line(Line).

write_line(Line) :- write(' '), write(' '), write(' '),
					write_aux_line(Line).

write_elem([Shape]) :- write(' '), write(Shape), write(' '). 

drawIdentation(0) :- write('        ').
drawIdentation(1) :- write('      ').
drawIdentation(2) :- write('    ').
drawIdentation(3) :- write('  ').
drawIdentation(4) :- write('').
drawIdentation(5) :- write('  ').
drawIdentation(6) :- write('    ').
drawIdentation(7) :- write('      ').
drawIdentation(8) :- write('        ').