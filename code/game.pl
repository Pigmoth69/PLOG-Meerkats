availableColors([blue, red, green, yellow]).
availableStones([[15|blue],[15|red],[15|green],[15|yellow]]).
playerInfo([]).


playGame(NumberPlayers):- 	availableColors(Colors),
							N is 1,
							playerInfo(Info),
							assignPlayerColor(NumberPlayers, Info, Colors, N, RInfo),
							displayPrepareForTheGame(NumberPlayers),
							gameStart(RInfo,Winner).
							/*Esta RInfo é uma lista com os jogadores!*/
							
displayPrepareForTheGame(N):-
	clearScreen,
	write('***************************************************'), nl,
	write('||                                               ||'), nl,
	write('||   Game will start after you press ENTER!      ||'), nl,	
	write('||                                               ||'), nl,
	format('||    There are ~d player in game! Good luck!     ||', [N]), nl,
	write('||                                               ||'), nl,
	write('***************************************************'), nl,
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

	
	

gameStart(Players,Winner):- logicalBoard(LogicalBoard),
							displayBoard(Board),
							availableStones(Stones),
							Winner is -1,
							startPlaying(Board,Stones,LogicalBoard,Players,Winner, 1).

showBoard():-
			logicalBoard(LogicalBoard),
			displayBoard(Board),
			drawBoard(Board,LogicalBoard).

startPlaying(_,_,_,_,1).
startPlaying(_,_,_,_,2).
startPlaying(_,_,_,_,3).
startPlaying(_,_,_,_,4).
		
startPlaying(Board,Stones,LogicalBoard,Players,Winner, Round):-
	/*Ver se todas as peças foram jogadas ou se existe um grupo de 15!*/
	/*---CODE--*/
	/*Joga uma vez completa com todos os jogadores!*/
	playRound(Board,Stones,LogicalBoard,Players,Players,ResultBoard,RemainingStones,Round,Winner),

	startPlaying(Board,RemainingStones,ResultBoard,Players,Winner,2).
	
	
getPlayer([[Id | [Color | []]]], Color, Id).	
getPlayer([Head | Tail],Color,Player):- getPlayer(Tail, Color, Player).


/*Faz uma jogada! Retornando o tabuleiro atual e as pedras restantes*/
playRound(_,Stones,LogicalBoard,[],_,LogicalBoard,Stones, _,Winner). 

playRound(Board,Stones,LogicalBoard,[[H|_]|Tail],Players,ResultBoard,RemainingStones,1,Winner):-	
											drawBoard(Board, LogicalBoard),
											format('It is Player ~d turn!)', [H]), nl,
											write('qwerty'), nl, getEnter,
											withdrawStone(Stones,RemainingStones1,ChoosedStone),
											getEmptyCell(LogicalBoard,RowIdentifier,RowPos),
											setInfo(RowIdentifier,RowPos,ChoosedStone,LogicalBoard,ResultBoard1),
											playRound(Board,RemainingStones1,ResultBoard1,Tail,Players,ResultBoard,RemainingStones, 2,Winner).		

playRound(Board,Stones,LogicalBoard,[[H|_]|Tail],Players,ResultBoard,RemainingStones,2,Winner):-	
											drawBoard(Board, LogicalBoard),
											format('It is Player ~d turn!)', [H]), nl,
											dropStone(LogicalBoard,Stones,RemainingStones1,RowIdentifier,RowPos,ResultBoard1),
											getWinning(Board,RemainingStones1,ResultBoard1,Tail,Players,ResultBoard,RemainingStones,N,Winner,RowIdentifier,RowPos).
											%playRound(Board,RemainingStones1,FinalBoard,Tail,Players,ResultBoard,RemainingStones,N,Winner).	


dropStone(LogicalBoard,Stones,RemainingStones1,RowIdentifier,RowPos,ResultBoard1):-
			withdrawStone(Stones,RemainingStones1,ChoosedStone),
			getEmptyCell(LogicalBoard,RowIdentifier,RowPos),
			setInfo(RowIdentifier,RowPos,ChoosedStone,LogicalBoard,ResultBoard1).



getWinning(Board,RemainingStones1,FinalBoard,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos):-
			winner(FinalBoard, Winner, Area),
			Area == 15-> write('getwininig'), nl,playRound(_,_,_,[],_,_,_,_,1).


getWinning(Board,RemainingStones1,FinalBoard,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos):-
											drawBoard(Board, FinalBoard),
											dragStone(FinalBoard,RowIdentifier,RowPos,FinalBoard1),
											playRound(Board,RemainingStones1,FinalBoard1,Tail,Players,ResultBoard,RemainingStones,2,Winner).






/**********************************************************************************************************************************/
		



checkDrag(LogicalBoard,InitialCoord1,InitialCoord2,Direction,NumberCells,Message,FinalRow,FinalCol):-	write('cheackDrag'), nl,( 
																					Direction == 1 -> checkDragDiagonalUpLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid;
																					Direction == 2 -> checkDragDiagonalUpRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid;
																					Direction == 3 -> checkDragRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid;
																					Direction == 4 -> write('inseriu 4'), nl,checkDragDiagonalDownRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid;
																					Direction == 5 -> checkDragDiagonalDownLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid;
																					Direction == 6 -> checkDragLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol), Message=valid
																					).
checkDrag(_,_,_,_,_,invalid,_,_).
																		


checkDragDiagonalUpLeft(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragDiagonalUpLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 - 1,
																									InitialCoord1 < 6,
																									NewCol is InitialCoord2 - 1,
																									validCell(NewRow,NewCol), !,
																									getInfo(NewRow, NewCol, Info, LogicalBoard),
																									Info == empty, !,
																									NewNumberCells is NumberCells - 1,
																									checkDragDiagonalUpLeft(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).

checkDragDiagonalUpLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 - 1,
																									InitialCoord1 > 5,
																									NewCol is InitialCoord2,
																									validCell(NewRow,NewCol), !,
																									getInfo(NewRow, NewCol, Info, LogicalBoard),
																									Info == empty, !,
																									NewNumberCells is NumberCells - 1,
																									checkDragDiagonalUpLeft(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).


checkDragDiagonalUpRight(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragDiagonalUpRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 - 1,
																									InitialCoord1 > 5,
																									NewCol is InitialCoord2 + 1,
																								 	validCell(NewRow,NewCol), !,
																								 	getInfo(NewRow,NewCol,Info,LogicalBoard),
																								 	Info == empty, !,
																								 	NewNumberCells is NumberCells - 1,
																								 	checkDragDiagonalUpRight(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).

checkDragDiagonalUpRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 - 1,
																									InitialCoord1 < 6,
																									NewCol is InitialCoord2,
																								 	validCell(NewRow,NewCol), !,
																								 	getInfo(NewRow,NewCol,Info,LogicalBoard),
																								 	Info == empty, !,
																								 	NewNumberCells is NumberCells - 1,
																								 	checkDragDiagonalUpRight(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).


checkDragRight(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):-	NewCol is InitialCoord2 + 1,
																				validCell(InitialCoord1,NewCol), !,
																				getInfo(InitialCoord1,NewCol,Info,LogicalBoard),
																				Info == empty, !,
																				NewNumberCells is NumberCells - 1,
																				checkDragRight(LogicalBoard,InitialCoord1,NewCol,NewNumberCells,FinalRow,FinalCol).


checkDragDiagonalDownRight(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragDiagonalDownRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 + 1,
																										InitialCoord1 < 5, 
																										NewCol is InitialCoord2+1,
																										write(NewCol),nl,
																				 						validCell(NewRow,InitialCoord2), !,
																					 					getInfo(NewRow,NewCol,Info,LogicalBoard),
																					 					Info == empty, !,
																				 						NewNumberCells is NumberCells - 1,
																				 						checkDragDiagonalDownRight(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).


checkDragDiagonalDownRight(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- 	NewRow is InitialCoord1 + 1,
																										InitialCoord1 > 4,
																										NewCol is InitialCoord2,
																										write(NewCol),nl,
																				 						validCell(NewRow,InitialCoord2), !,
																					 					getInfo(NewRow,NewCol,Info,LogicalBoard),
																					 					Info == empty, !,
																				 						NewNumberCells is NumberCells - 1,
																				 						checkDragDiagonalDownRight(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).

checkDragDiagonalDownLeft(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragDiagonalDownLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- NewRow is InitialCoord1 + 1,
																									InitialCoord1 > 4,
																									NewCol is InitialCoord2 - 1,
																									validCell(NewRow,NewCol), !,
																									getInfo(NewRow, NewCol, Info, LogicalBoard),
																									Info == empty, !,
																									NewNumberCells is NumberCells - 1,
																									checkDragDiagonalDownLeft(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).

checkDragDiagonalDownLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):- NewRow is InitialCoord1 + 1,
																									InitialCoord1 < 5,
																									NewCol is InitialCoord2,
																									validCell(NewRow,NewCol), !,
																									getInfo(NewRow, NewCol, Info, LogicalBoard),
																									Info == empty, !,
																									NewNumberCells is NumberCells - 1,
																									checkDragDiagonalDownLeft(LogicalBoard,NewRow,NewCol,NewNumberCells,FinalRow,FinalCol).


checkDragLeft(_,InitialCoord1,InitialCoord2,0,InitialCoord1,InitialCoord2).
checkDragLeft(LogicalBoard,InitialCoord1,InitialCoord2,NumberCells,FinalRow,FinalCol):-	NewCol is InitialCoord2 - 1,
																				validCell(InitialCoord1,NewCol), !,
																				getInfo(InitialCoord1,NewCol,Info,LogicalBoard),
																				Info == empty, !,
																				NewNumberCells is NumberCells - 1,
																				checkDragLeft(LogicalBoard,InitialCoord1,NewCol,NewNumberCells,FinalRow,FinalCol).

																				
																				
/*Message = valid ou invalid*/	

displayDirectionsList(Direction, NumberCells):- 	write('1 -> Up-Left     2 -> Up-Right     3 -> Right'),  nl,
													write('4 -> Down-Right  5 -> Down-Left    6 -> Left'), nl,
													write('Direction: '), getInteger(Direction), 
													Direction < 7,
													Direction > 0,
													displayGetNumberCells(NumberCells)
													;
													nl, write('Invalid Input. Try again'),
													displayDirectionsList(Direction, NumberCells).

displayGetNumberCells(NumberCells):-	write('Insert the number of cells you want to drag your stone: '), getInteger(NumberCells).
										


dragStone(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard):-
										write('What stone do you want to move?'),nl,
										getStoneCell(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,Initial1,Initial2),
										displayDirectionsList(Direction, NumberCells),
										checkDrag(LogicalBoard,Initial1,Initial2,Direction,NumberCells,Message,Final1,Final2),
										Message == valid -> getInfo(Initial1,Initial2,Stone,LogicalBoard),setInfo(Initial1,Initial2,empty,LogicalBoard,Res),setInfo(Final1,Final2,Stone,Res,ResultBoard);
										dragStone(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard).
	
/********************************************************/
	
	
	
chooseStone(ChoosedStone):-
							write('Write the stone you want to play!'),nl,
							write('1 -> red | 2 -> green | 3 -> blue | 4 -> yellow'),nl,
							getInteger(StoneID),(
							StoneID == 1 ->  ChoosedStone = red;
							StoneID == 2 ->  ChoosedStone = green;
							StoneID == 3 ->  ChoosedStone = blue;
							StoneID == 4 ->  ChoosedStone = yellow;
							write('Invalid stone name!'),nl,
							chooseStone(ChoosedStone)).
	
displayRemainingStones([[Blue | _] | [[Red | _] | [[Green | _] | [[Yellow| _]]]]]):- format('Remaing stones: ~d Blues, ~d Reds, ~d Greens and ~d Yellows.', [Blue, Red, Green, Yellow]), nl.

								
/*Faz a jogava correspondente a retirar uma peça das Stones que ainda restam e "retorna" as Stones que restam*/
withdrawStone(Stones,RemainingStones,StoneColor):-	
									displayRemainingStones(Stones),
									chooseStone(ChoosedStone),
									getStoneNumber(Stones,ChoosedStone,Number),
									Number > 0 ->write('Stone withdraw!'),nl, NewNum is Number -1,setStoneNumber(Stones,ChoosedStone,NewNum,RemainingStones),StoneColor = ChoosedStone;
									write('There are no more of those stones! Choose another one!'),nl,
									withdrawStone(Stones,RemainingStones).
									

/*Vê o numero de peças correspondentes a uma cor*/
/*getStoneNumber(Stones,ChoosedStone,Number)*/
getStoneNumber([[_|T]|Tail],ChoosedStone,Number):- 
												T \= ChoosedStone,
												getStoneNumber(Tail,ChoosedStone,Number).

												
getStoneNumber([[H|T]|_],ChoosedStone,Number):-  
												T == ChoosedStone,
												Number = H.
												
												
												
			
/*Faz set ao numero de peças da cor*/
/*setStoneNumber(Stones,ChoosedStone,Number,RemainingStones)*/	

setStoneNumber([],_,_,[]).
setStoneNumber([[H|A]|Tail],ChoosedStone,Number,[[H|A]|NA]):- 
	ChoosedStone \= A,
	setStoneNumber(Tail,ChoosedStone,Number,NA).
	
setStoneNumber([[_|A]|Tail],_,Number,[[Number|A]|Tail]).


		
/*-------------------------------------------------------------------------------------------*/											


	
getCoords(X,Y):-
		write('Get Coord1: '),nl,
		getInteger(X),
		write('Get Coord2: '),nl,
		getInteger(Y).
					
/*Esta funcção vê se as coordenadas são inteiros válidos entre 1 e 9*/	
getValidCoords(X,Y):-
				getCoords(X,Y),
				validCell(X,Y);
				write('Coordinates inserted are not valid!!! Please try again.'), nl,
				getValidCoords(X,Y). 
							



/*Esta função só termina quando existe um movimento válido*/	
getEmptyCell(Board,RowIdentifier,RowPos):-
	getValidCoords(Coord1,Coord2),
	write('Valid RowIdentifier: '),write(Coord1),nl,
	write('Valid RowPosPos: '),write(Coord2),nl,
	getInfo(Coord1,Coord2,Info,Board),
	Info == empty ->write('Valid move!'),nl, RowIdentifier is Coord1,RowPos is Coord2;
	getEmptyCell(Board,RowIdentifier,RowPos).
	
	
/*Ve se o que está selecionado é uma peça*/	
getStoneCell(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos):-
	getNotEqualCoords(PlayedStoneCoord1,PlayedStoneCoord2,Coord1,Coord2),
	write('Valid RowIdentifier: '),write(Coord1),nl,
	write('Valid RowPosPos: '),write(Coord2),nl,
	getInfo(Coord1,Coord2,Info,Board),
	
	Info \= empty ->write('Valid move!'),nl, RowIdentifier is Coord1,RowPos is Coord2;
	write('Not a stone!'),nl,
	getStoneCell(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos).	
/*-------------------------------------------------------------------------------------------*/											

getNotEqualCoords(Initial1,Initial2,ResCoord1,ResCoord2):-
											getValidCoords(C1,C2),
											compCoords(Initial1,Initial2,C1,C2,M),
											M == notEqual ->ResCoord1 is C1,ResCoord2 is C2;
											write('Cant move the stone you just played!'),nl,
											getNotEqualCoords(Initial1,Initial2,ResCoord1,ResCoord2).
											

											
compCoords(X1,_,X2,_,M):-
						X1 \= X2,
						M = notEqual.		
compCoords(_,Y1,_,Y2,M):-
						Y1 \= Y2,
						M = notEqual.						
											
compCoords(X1,Y1,X2,Y2,M):-
						X1 == X2,
						Y1 == Y2,
						M = equal.
							


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
														
	
	






%-------------------------------------------%
%--------------BOARD FUNCTIONS--------------$
%-------------------------------------------%



logicalBoard([
	            [blue, empty, empty, empty, red],
	         [empty, empty, empty, empty, empty, empty],
	      [empty, empty, empty, empty, empty, empty, empty],
	   [empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty, empty],
	   [empty, empty, empty, empty, empty, empty, empty, empty],
	      [empty, empty, empty, empty, empty, empty, empty],
	         [empty, empty, empty, empty, empty, empty],
	            [yellow, empty, empty, empty, green]
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
%-----------Winner Calculator--------%
%------------------------------------%


winner(L, W, A):- 	floodFill(L, R), nl,
				calculateWinner(R, W, A).

calculateWinner(Result, Winner, AreaResult):-	getMainGroups(Result, 16, Winner, AreaResult), !.




getMainGroups(Result, MaxValue, ColorResult, AreaResult):- 	findMaxAreaValue(Result, MaxValue, AreaResult),	%retorna o valor da maior area ate MaxValue unidades
												getCorrespondentTeam(Result, FinalResult, AreaResult, X), %retorna lista com as cores com areas da dimensao de AreaResult
												length(X, Length),
												(
													Length > 1 -> NewMax is AreaResult, getMainGroups(FinalResult, NewMax, ColorResult, AreaResult);
													Length = 1 -> append([], X, ColorResult);
													Length = 0 -> append([], [], ColorResult)
												). 
												

findMaxAreaValue([[_ | [Blue | _]] | [[_ | [Red | _]] | [[_ | [Green| _]] | [[_ | [Yellow |_]]]]]], MaxValue, AreaResult):-	findMax(Blue, MaxValue, 0, RB),
																															findMax(Red, MaxValue, 0, RR),
																															findMax(Green, MaxValue, 0, RG),
																															findMax(Yellow, MaxValue, 0, RY),
																															findMax([RB, RR, RG, RY], 16, 0, AreaResult).

findMax([], _, Result, Result).

findMax([Head | Tail], MaxValue, Min, Result):- Head > Min,
												Head < MaxValue,
												findMax(Tail, MaxValue, Head, Result), !.


findMax([_ | Tail], MaxValue, Min, Result):- findMax(Tail, MaxValue, Min, Result), !.

getCorrespondentTeam([], [], _, []).


getCorrespondentTeam([Head | Tail] , [Head | FinalResult], AreaResult, [Color | ColorResult]):- checkMember(AreaResult, Head, Color), !, 
																								getCorrespondentTeam(Tail, FinalResult, AreaResult, ColorResult), !.

getCorrespondentTeam([[Color | [_]] | Tail] , [[Color | [[]]] | FinalResult], AreaResult, ColorResult):- 	getCorrespondentTeam(Tail, FinalResult, AreaResult, ColorResult), !.

checkMember(Value, [Result | [Tail | _]], Result):- member(Value, Tail).





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


floodFill(L,R):-
				flood(blue, Rb, L),
				flood(red, Rr, L),
				flood(green, Rg, L),
				flood(yellow, Ry, L),
				append([Rb], [Rr], R1), append([Rg], [Ry], R2), append(R1, R2, R).

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


searchNextColorOcurrence(Row, Col, LogicalBoard, RegistBoard, Color, Result):- 	search(Row, Col, LogicalBoard, Color, _), 
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

