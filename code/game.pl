availableColors([blue, red, green, yellow]).
playersInfo([]).

playGame(NumberPlayers, NumberBots):- 	availableColors(Colors),
										playersInfo(Info),
										assignPlayerColor(NumberPlayers, Info, Colors, 1).

assignPlayerColor(X, _, _, Y):- X = Y-1.

assignPlayerColor(NumberPlayers, Info, Colors, N):-
										printPlayerWaitForEnterScreen(N1),
										sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors),
										N1 is N + 1,
										AssignPlayerColor(NumberPlayers, ResultInfo, ResultColors, N1).

sortPlayerColor(N, Info, Colors, ResultInfo, ResultColors):-
										length(Colors, Length),
										Rand is random(0, Length, Index),

getIndexColor(], Index, Color):-



printPlayerWaitForEnterScreen(N):-
	clearScreen,
	write('***************************************************'), nl,
	write('||                                               ||'), nl,
	format('||   Time for player ~d to sort his color.       ||', [N]), nl,	
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