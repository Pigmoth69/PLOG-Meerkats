availableColors([blue, red, green, yellow]).

playGame(NumberPlayers):- 	availableColors(Colors),
							N is 1,
							assignPlayerColor(NumberPlayers, Info, Colors, N, RInfo),
							getEnter,
							write('Number of players: '),
							write(NumberPlayers),nl,
							write('Info: '),
							write(Info),nl,
							write('Colors: '),
							write(Colors),nl,
							write('N: '),
							write(N),nl,
							write('RInfo: '),
							write(RInfo),nl,
							getEnter.
							

							



assignPlayerColor(NumberPlayers, Info, Colors, N, RInfo):-
										N =< NumberPlayers,
										playerReadyForColorAssignment(N),
										sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors),
										N1 is N + 1,
										assignPlayerColor(NumberPlayers, ResultInfo, ResultColors, N1, RInfo).
										
assignPlayerColor(_, Info, _, _, Info).


sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors):-
										length(Colors, Length),
										random(0, Length, Index),
										getColor(Index, Color, Colors, ResultColors),
										storeInfo(Info, Color, N, ResultInfo),
										playerColorScreen(N, Color).

getColor(_, _, [],[]).

getColor(Index, Color, [H|A], [H|NA]):- Index > 0,
									    Nindex is Index-1,
									    getColor(Nindex,Color,A,NA).

getColor(0, Color, [Color|A], A).

storeInfo(Info, Color, N, ResultInfo):- append(Info, [[N | Color]], ResultInfo).






playerReadyForColorAssignment(N):-
	clearScreen,
	write('***************************************************'), nl,
	write('||                                               ||'), nl,
	format('||   Time for player ~d to sort his color.        ||', [N]), nl,	
	write('||                                               ||'), nl,
	write('||    Make sure your are the only one            ||'), nl,
	write('||    watching the result!!!                     ||'), nl,
	write('||                                               ||'), nl,
	write('||    Type Enter when you are ready!             ||'), nl,
	write('||                                               ||'), nl,
	write('***************************************************'), nl,
	getEnter.

playerColorScreen(N, Color):-
	clearScreen,
	write('***************************************************'), nl,
	write('||                                               ||'), nl,
	format('||   Player ~d, the color assigned to you was:    ||', [N]), nl,	
	write('||                                               ||'), nl,
	write('||                 '),
	ansi_format([bold,fg(Color)], ' ~s ', [Color]),
	(
		Color = blue -> write('                        ||');
		Color = green -> write('                       ||');
		Color = yellow -> write('                      ||');
		
		write('                         ||')
	), nl, 
	write('||                                               ||'), nl,
	write('***************************************************'), nl,
	getEnter.

play():-  
	logicalBoard(LogicalBoard),
	displayBoard(Board),
	makePlay(Board,LogicalBoard,Player).
	
makePlay(Board,LogicalBoard,Player):-
	drawBoard(Board, LogicalBoard),
	getValidMove(LogicalBoard,RowIdentifier,RowPos),
	moveStone(red,LogicalBoard,RowIdentifier,RowPos,ResultBoard),
	makePlay(Board,ResultBoard,Player).
	
	
	
getCoords(X,Y):-
		write('Get Coord1: '),nl,
		getInteger(X),
		write('Get Coord2: '),nl,
		getInteger(Y).
	
checkCoords(X,Y,Res):-
				X > 10 -> write('Invalid Coord!'),nl,Res = 'invalid';
				X < 0 -> write('Invalid Coords!'),nl,Res = 'invalid';
				Y > 10 -> write('Invalid Coord!'),nl,Res = 'invalid';
				Y < 0 -> write('Invalid Coords!'),nl,Res = 'invalid';
				Res = valid.
				
/*Esta funcção vê se as coordenadas são inteiros válidos entre 1 e 9*/	
getValidCoords(X1,Y1):-
				getCoords(X,Y),
				checkCoords(X,Y,Res),
				X1 is X, Y1 is Y,
				Res == valid -> true;
				getValidCoords(X1,Y1). 
							


	
/*Esta função só termina quando existe um movimento válido*/	
getValidMove(Board,RowIdentifier,RowPos):-
	getValidCoords(Coord1,Coord2),
	getInfo(Coord1,Coord2,Info,Board),
	Info == empty ->write('Valid move!'),nl, RowIdentifier is Coord1,RowPos is Coord2;
	getValidMove(Board,_,_).
	
	
	
	
moveStone(Color,LogicalBoard,RowIdentifier,RowPos,ResultBoard):-
																getBoardRow(LogicalBoard,RowIdentifier,Row),
																changeBoardRow(Row,RowPos,Color,ResRow),
																changeBoard(LogicalBoard,RowIdentifier,ResRow,ResultBoard).
changeBoard([],_,_,[]).
changeBoard([H|A],NewRow,Elem,[H|NA]):- 
	NewRow > 1,
	Npos is NewRow-1,
	changeBoard(A,Npos,Elem,NA).
changeBoard([_|A],1,Elem,[Elem|A]). 													
																
changeBoardRow([],_,_,[]).
changeBoardRow([H|A],RowPos,Elem,[H|NA]):- 
	RowPos > 1,
	Npos is RowPos-1,
	changeBoardRow(A,Npos,Elem,NA).
changeBoardRow([_|A],1,Elem,[Elem|A]). 	

																
getBoardRow([_|T],RowIdentifier,Row):-
											RowIdentifier > 1,
											N is RowIdentifier - 1,
											getBoardRow(T,N,Row).
getBoardRow([H|_],1,H).
														
	
	

/*
moveStone(Color,[[H|T]|Tail],1,RowPos,ResultBoard):-moveStone(Color,[H|T],1,RowPos,ResultBoard).  

moveStone(Color,[[H|T]|Tail],RowIdentifier,RowPos,ResultBoard):-
											RowIdentifier > 1,
											N is RowIdentifier - 1,
											moveStone(Color,Tail,N,RowPos,ResultBoard).
											

moveStone(Color,[H|T],1,RowPos,[H|T]):-
									N is RowPos - 1,
									moveStone(Color,[H|T],0,N,T).

moveStone(Color,[H|T],1,1,[Color|T]).
										

*/









%-------------------------------------------%
%--------------BOARD FUNCTIONS--------------$
%-------------------------------------------%



logicalBoard([
	            [empty, empty, empty, empty, empty],
	         [empty, empty, empty, empty, empty, empty],
	      [empty, empty, empty, empty, empty, empty, empty],
	   [empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty, empty],
	   [empty, empty, empty, empty, empty, empty, empty, empty],
	      [empty, empty, empty, empty, empty, empty, empty],
	         [empty, empty, empty, empty, empty, empty],
	            [empty, empty, empty, empty, empty]
	]).

displayBoard([
	            ['1', '2', '3', '4', '5'],
	          ['1', '2', '3', '4', '5', '6'],
	        ['1', '2', '3', '4', '5', '6', '7'],
	      ['1', '2', '3', '4', '5', '6', '7', '8'],
	   ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
	      ['1', '2', '3', '4', '5', '6', '7', '8'],
	        ['1', '2', '3', '4', '5', '6', '7'],
	          ['1', '2', '3', '4', '5', '6'],
	            ['1', '2', '3', '4', '5']
	]).

horizontalBottomBorders([
		'         -------------------------',
		'       -----------------------------',
		'     ---------------------------------',
		'   -------------------------------------',
		'   -------------------------------------',
		'     ---------------------------------',
		'       -----------------------------',
		'         -------------------------',
		'           ---------------------'
	]).

rowIdentifiers([' 1         |', ' 2       |', ' 3     |', ' 4   |', ' 5 |', ' 6   |', ' 7     |', ' 8       |', ' 9         |']).



drawBoard(Board, LogicalBoard):- 
			printTopBorder, nl,
			rowIdentifiers(RowsIndexes),
			horizontalBottomBorders(BottomBorders),
			printBoardRows(Board, LogicalBoard, RowsIndexes, BottomBorders).

printBoardRows([], [], [], []).

printBoardRows([Head | Tail], [LHead | LTail], [RHead | RTail], [BHead | BTail]):- 
						write(RHead), printBoardRow(Head, LHead),
						nl, write(BHead), 
						nl,	printBoardRows(Tail, LTail, RTail, BTail).

printBoardRow([], []).

printBoardRow([Head | Tail], [LHead | LTail]):- 
			printCell(Head, LHead),
			write('|'),
			printBoardRow(Tail, LTail).
			
printCell(Element, LogicalElement):- 
			LogicalElement = empty   -> format(' ~w ', [Element]);
			LogicalElement = blue    -> ansi_format([bold,fg(blue)], ' ~w ', [Element]);
			LogicalElement = yellow  -> ansi_format([bold,fg(yellow)], ' ~w ', [Element]);
			LogicalElement = red     -> ansi_format([bold,fg(red)], ' ~w ', [Element]);
			LogicalElement = green   -> ansi_format([bold,fg(green)], ' ~w ', [Element]).


printTopBorder:- write('           ---------------------').












%------------------------------------%
%-------------FloodFill--------------%
%------------------------------------%

registBoard([
	            [0, 0, 0, 0, 0],
	         [0, 0, 0, 0, 0, 0],
	      [0, 0, 0, 0, 0, 0, 0],
	   [0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	   [0, 0, 0, 0, 0, 0, 0, 0],
	      [0, 0, 0, 0, 0, 0, 0],
	         [0, 0, 0, 0, 0, 0],
	            [0, 0, 0, 0, 0]
	]).


floodFill:-		logicalBoard(LogicalBoard),
				flood(blue, Rb, LogicalBoard),
				flood(red, Rr, LogicalBoard),
				flood(green, Rg, LogicalBoard),
				flood(yellow, Ry, LogicalBoard),
				append([Rb], [Rr], R1), append([Rg], [Ry], R2), append(R1, R2, R), write(R), !.

flood(Color, Result, LogicalBoard):- 	registBoard(RegistBoard),
										searchNextColorOcurrence(1, 1, LogicalBoard, RegistBoard, Color, [Row | [Col | _]]),
										searchColorGroups(Row, Col, Color, LogicalBoard, RegistBoard, R),
										append([Color], [R], Result), !.

searchColorGroups(9, 6, _, _, _, []).

searchColorGroups(Row, Col, Color, LogicalBoard, RegistBoard, [FinalArea | Result]):- 	calculateArea(Row, Col, Color, RegistBoard, LogicalBoard, FinalArea, LastRegistBoard),
																						searchNextColorOcurrence(Row, Col, LogicalBoard, LastRegistBoard, Color, [R | [C | _]]),
																						searchColorGroups(R, C, Color, LogicalBoard, LastRegistBoard, Result).

calculateArea(Row, Col, Color, RegistBoard, LogicalBoard, FinalArea, FinalRegistBoard):-validCell(Row, Col),
																						visitedCell(Row, Col, RegistBoard, Visited),
																						Visited = 0,
																						checkForColor(Row, Col, NewColor, LogicalBoard),
																						NewColor = Color,
																						setVisitedCell(Row, Col, RegistBoard, NewRegistBoard),	
																						MinorRow is Row - 1,
																						MajorRow is Row + 1,
																						MinorCol is Col - 1,
																						MajorCol is Col + 1,
																						calculateArea(MinorRow, MinorCol, Color, NewRegistBoard, LogicalBoard, A1, FR1),
																						calculateArea(MinorRow, Col, Color, FR1, LogicalBoard, A2, FR2),
																						calculateArea(MinorRow, MajorCol, Color, FR2, LogicalBoard, A3, FR3),
																						calculateArea(Row, MinorCol, Color, FR3, LogicalBoard, A4, FR4),
																						calculateArea(Row, MajorCol, Color, FR4, LogicalBoard, A5, FR5),
																						calculateArea(MajorRow, MinorCol, Color, FR5, LogicalBoard, A6, FR6),
																						calculateArea(MajorRow, Col, Color, FR6, LogicalBoard, A7, FR7),
																						calculateArea(MajorRow, MajorCol, Color, FR7, LogicalBoard, A8, FinalRegistBoard),
																						FinalArea is 1+A1+A2+A3+A4+A5+A6+A7+A8, !.


calculateArea(_, _, _, RegistBoard, _, 0, RegistBoard).


searchNextColorOcurrence(9, 6, _, _, _, [9, 6]).

searchNextColorOcurrence(Row, Col, LogicalBoard, RegistBoard, Color, Result):-	not(validCell(Row, Col)),
																				NewRow is Row+1,
																				searchNextColorOcurrence(NewRow, 1, LogicalBoard, RegistBoard, Color, Result).
																				

searchNextColorOcurrence(Row, Col, LogicalBoard, RegistBoard, Color, Result):- 	search(Row, Col, LogicalBoard, Color, [R | [C | _]]),
																				visitedCell(R, C, RegistBoard, 0),
																				append([R], [C], Result).


searchNextColorOcurrence(Row, Col, LogicalBoard, RegistBoard, Color, Result):- 	search(Row, Col, LogicalBoard, Color, [_]), 
																				NextCol is Col + 1,
																				searchNextColorOcurrence(Row, NextCol, LogicalBoard, RegistBoard, Color, Result).



visitedCell(Row, Col, RegistBoard, Visited):-	getInfo(Row, Col, Visited, RegistBoard).
visitedCell(9, 6, _, 0).

setVisitedCell(Row, Col, RegistBoard, FinalRegistBoard):- setInfo(Row, Col, 1, RegistBoard, FinalRegistBoard).
					
checkForColor(Row, Col, Color, Board):- getInfo(Row, Col, Color, Board).



%----------------------------------------------------------------------------%
%-----Functions to get any info from a certain position of any matrix--------%
%----------------------------------------------------------------------------%

getInfo(0, 1, Head, [Head | _]).

getInfo(0, Col, Info, [_ | Tail]):-	NewCol is Col - 1,
									getInfo(0, NewCol, Info, Tail).

getInfo(1, Col, Info, [Head | _]):- getInfo(0, Col, Info, Head).

getInfo(Row, Col, Info, [_ | Tail]):- 	NextRow is Row - 1,
										getInfo(NextRow, Col, Info, Tail).

%----------------------------------------------------------------------------%
%-----Functions to set any info into a certain position of any matrix--------%
%----------------------------------------------------------------------------%

setInfo(0, 1, Info, [_ | Tail],  [Info | Tail]).

setInfo(0, Col, Info, [Head | Tail], [Head | RTail]):-	NewCol is Col - 1,
											setInfo(0, NewCol, Info, Tail, RTail).

setInfo(1, Col, Info, [Head | Tail], [RHead | Tail]):- setInfo(0, Col, Info, Head, RHead).

setInfo(Row, Col, Info, [Head | Tail], [Head | RTail]):-	NewRow is Row - 1,
															setInfo(NewRow, Col, Info, Tail, RTail), !.							

%----------------------------------------------------------------------------%
%-----Functions to search for a certain Element on a matrix------------------%
%----------------------------------------------------------------------------%

search(9, 6, _, _, [9, 6]).

search(Row, Col, LogicalBoard, Element, [Row, Col]):-	validCell(Row, Col),
														getInfo(Row, Col, NewElement, LogicalBoard),
														Element = NewElement, !.

search(Row, Col, LogicalBoard, Element, Result):- 	not(validCell(Row, Col)),
													NewRow is Row + 1,
													search(NewRow, 1, LogicalBoard, Element, Result).

search(Row, Col, LogicalBoard, Element, Result):-	validCell(Row, Col),
													NewCol is Col + 1,
													search(Row, NewCol, LogicalBoard, Element, Result).
