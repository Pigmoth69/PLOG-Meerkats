/*BOARD INICICIALMENTE VAZIA*/
hexBoard0(Board) :- Board =
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
/*BOARD COM UM JOGO A DECORRER*/
hexBoard1(Board) :- Board =
[	[['B'], [' '],[' '], [' '],[' ']],
 	[[' '], [' '],['R'], [' '],[' '], [' ']],
	[['R'], ['Y'],['Y'], [' '],['B'], ['B'],[' ']],
	[['G'], ['R'],['R'], ['Y'],['Y'], ['Y'],['B'], [' ']],
 	[['R'], ['R'],['R'], ['Y'],['G'], ['G'],['G'], ['B'], [' ']],
 	[['B'], ['G'],['Y'], ['G'],['G'], ['B'],['B'], [' ']],
 	[['B'], ['B'],['B'], ['B'],['B'], [' '],['B']],
	[[' '], [' '],[' '], [' '],[' '], [' ']],
	[[' '], [' '],[' '], ['G'],[' ']]
].

/*BOARD COM APENAS A PEÇA INICIAL*/
hexBoard2(Board) :- Board =
[	[[' '], [' '],[' '], [' '],[' ']],
 	[[' '], [' '],[' '], [' '],[' '], [' ']],
	[[' '], [' '],[' '], [' '],[' '], [' '],[' ']],
	[[' '], [' '],[' '], [' '],[' '], [' '],[' '], [' ']],
 	[[' '], [' '],[' '], [' '],[' '], [' '],[' '], [' '], [' ']],
 	[[' '], [' '],[' '], [' '],[' '], [' '],[' '], [' ']],
 	[[' '], [' '],['B'], [' '],[' '], [' '],[' ']],
	[[' '], [' '],[' '], [' '],[' '], [' ']],
	[[' '], [' '],[' '], [' '],[' ']]
].

/*BOARD COM O FIM DE JOGO 1- 15 PEÇAS DA MESMA COR NO TABULEIRO*/
hexBoard3(Board) :- Board =
[	[['B'], ['R'],['R'], ['R'],['R']],
 	[['R'], ['R'],['R'], ['R'],[' '], [' ']],
	[['R'], ['Y'],['Y'], ['R'],['B'], ['B'],[' ']],
	[['G'], ['R'],['R'], ['Y'],['Y'], ['Y'],['B'], [' ']],
 	[['R'], ['R'],['R'], ['Y'],['G'], ['G'],['G'], ['B'], [' ']],
 	[['B'], ['G'],['Y'], ['G'],['G'], ['B'],['B'], [' ']],
 	[['B'], ['B'],['B'], ['B'],['B'], [' '],['B']],
	[[' '], [' '],[' '], [' '],[' '], [' ']],
	[[' '], [' '],[' '], ['G'],[' ']]
].

/*BOARD COM O FIM DE JOGO 2- EMPATE COM O MAIOR GRUPO*/

hexBoard4(Board) :- Board =
[	[['B'], ['G'],['G'], ['Y'],['G']],
 	[['G'], ['G'],['R'], ['Y'],['Y'], ['Y']],
	[['R'], ['Y'],['Y'], ['Y'],['B'], ['B'],['Y']],
	[['G'], ['R'],['R'], ['Y'],['Y'], ['Y'],['B'], ['Y']],
 	[['R'], ['R'],['R'], ['Y'],['G'], ['G'],['G'], ['B'], [' ']],
 	[['B'], ['G'],['Y'], ['G'],['G'], ['B'],['B'], [' ']],
 	[['B'], ['B'],['B'], ['B'],['B'], ['R'],['B']],
	[['G'], ['R'],['R'], ['R'],['R'], [' ']],
	[[' '], [' '],['R'], ['G'],['R']]
].

drawBoard(Board) :- secundaryDrawBoard(Board, 0).

secundaryDrawBoard([Line | Board], Number) :- Board \= [], 
											drawIdentation(Number), displayBoarder(Line),
											drawIdentation(Number), displayLine(Line),
											NewNumber is Number+1,
											secundaryDrawBoard(Board, NewNumber).

secundaryDrawBoard([Line], Number) :-	drawIdentation(Number), displayBoarder(Line),
										drawIdentation(Number), displayLine(Line), 
										drawIdentation(Number), displayBoarder(Line).

displayBoarder([_|Line]) :- write('   *---'), displayAuxBorder(Line).


displayAuxBorder([]) :- write('*\n').

displayAuxBorder([_|Line]) :- write('*---'), displayAuxBorder(Line).

writeAuxLine([]) :- write('|\n').

writeAuxLine([Elem|Line]) :- 	write('|'), writeSymbol(Elem),
								writeAuxLine(Line).

displayLine(Line) :- write(' '), write(' '), write(' '),
					writeAuxLine(Line).

					
writeSymbol([Color]) :- write(' '), write(Color), write(' '). 

drawIdentation(0) :- write('        ').
drawIdentation(1) :- write('      ').
drawIdentation(2) :- write('    ').
drawIdentation(3) :- write('  ').
drawIdentation(4) :- write('').
drawIdentation(5) :- write('  ').
drawIdentation(6) :- write('    ').
drawIdentation(7) :- write('      ').
drawIdentation(8) :- write('        ').