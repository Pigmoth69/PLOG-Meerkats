availableColors([blue, red, green, yellow]).

playGame(NumberPlayers):- 	availableColors(Colors),
							N is 1,
							assignPlayerColor(NumberPlayers, Info, Colors, N, RInfo).

							



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
	drawBoard(Board, LogicalBoard),
	getEnter,
	validMove(LogicalBoard,RowIdentifier,RowPos),
	write('sai!'),nl,
	abort,
	moveStone(red,LogicalBoard,X,Y,ResultBoard),
	write(ResultBoard),nl,
	getEnter,
	%-------------------------------------------------------
	drawBoard(Board, ResultBoard),
	getEnter.
	
							


getPlayCoord(Message,RowIdentifier):-
					getInteger(X),write(X),nl,nl,
					(
						RowIdentifier is X	,
						X > 10 -> format('Invalid1 ~s !', [Message]),nl,getPlayCoord(Message,_);
						X < 0 -> format('Invalid2 ~s !', [Message]),nl,getPlayCoord(Message,_)
						
					).		
	

getPlayCoord(_,1).
getPlayCoord(_,2).
getPlayCoord(_,3).
getPlayCoord(_,4).
getPlayCoord(_,5).
getPlayCoord(_,6).
getPlayCoord(_,7).
getPlayCoord(_,8).
getPlayCoord(_,9).				
					
	
/*validMove(Board,RowIdentifier,RowPos):-
	write('Insert the row identifier: '),nl,
	getInteger(X),!,
	(
		X < 1 -> write('Invalid Row Identifier!'),nl,validMove(Board,RowIdentifier,RowPos);
		X > 10 -> write('Invalid Row Identifier!'),nl,validMove(Board,RowIdentifier,RowPos);
		write('Insert the row Position: '),nl,
		
		getInteger(Y),
		(
		Y < 1 -> write('Invalid Row Position!'),nl,validMove(Board,RowIdentifier,RowPos);
		Y > 10 -> write('Invalid Row Position!'),nl,validMove(Board,RowIdentifier,RowPos)
		),
		
	),RowIdentifier is X,RowPos is Y.*/
	
	
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


