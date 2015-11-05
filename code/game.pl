availableColors([blue, red, green, yellow]).

playGame(NumberPlayers):- 	availableColors(Colors),
							N is 1,
							assignPlayerColor(NumberPlayers, Info, Colors, N,ResultInfo),nl,
							format('NumberPlayers: ~d', [NumberPlayers]), nl,
							write('List: '), write(ResultInfo),nl,
							write('Colors: '),
							write(Colors),nl,
							write(N),nl,
							write('sair assign'), nl,
							length(Info, Length),
							format('length of Info: ~d ', [Length]),
							abort.



assignPlayerColor(NumberPlayers, Info, Colors, N,R):-
										N =< NumberPlayers,
										%printPlayerWaitForEnterScreen(N),
										sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors),
										N1 is N + 1,
										assignPlayerColor(NumberPlayers, ResultInfo, ResultColors, N1,R).
										
assignPlayerColor(NumberPlayers, Info, _, N,Info):-
	N > NumberPlayers.


sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors):-
										length(Colors, Length),
										random(0, Length, Index),
										getColor(Index, Color, Colors, ResultColors),
										storeInfo(Info, Color, N, ResultInfo).

getColor(_, _, [],[]).

getColor(Index, Color, [H|A], [H|NA]):- Index > 0,
									    Nindex is Index-1,
									    getColor(Nindex,Color,A,NA).

getColor(0, Color, [Color|A], A).

storeInfo(Info, Color, N, ResultInfo):- append(Info, [[N | Color]], ResultInfo).






printPlayerWaitForEnterScreen(N):-
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

play:- 
	logicalBoard(LogicalBoard),
	displayBoard(Board),
	drawBoard(Board, LogicalBoard),
	getEnter.
























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

rowIdentifiers([' a         |', ' b       |', ' c     |', ' d   |', ' e |', ' f   |', ' g     |', ' h       |', ' i         |']).

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