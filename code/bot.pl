chooseStoneBOT(ChoosedStone):-
							write('Write the stone you want to play!'),nl,
							write('1 -> red | 2 -> green | 3 -> blue | 4 -> yellow'),nl,
							random(1,5,StoneID),(
							StoneID == 1 ->  ChoosedStone = red;
							StoneID == 2 ->  ChoosedStone = green;
							StoneID == 3 ->  ChoosedStone = blue;
							StoneID == 4 ->  ChoosedStone = yellow;
							write('Invalid stone name!'),nl,
							chooseStone(ChoosedStone)).
							
withdrawStoneBOT(Stones,RemainingStones,StoneColor):-	
									displayRemainingStones(Stones),
									chooseStoneBOT(ChoosedStone),
									getStoneNumber(Stones,ChoosedStone,Number),
									Number > 0 ->write('Stone withdraw!'),nl, NewNum is Number -1,setStoneNumber(Stones,ChoosedStone,NewNum,RemainingStones),StoneColor = ChoosedStone;
									write('There are no more of those stones! Choose another one!'),nl,
									withdrawStoneBOT(Stones,RemainingStones,StoneColor).

getWinningOnDropBOT(Board,RemainingStones1,FinalBoard,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos,FinalWinner):-
											drawBoard(Board, FinalBoard),
											dragStoneBOT(FinalBoard,RowIdentifier,RowPos,FinalBoard1),
											getWinningOnDrag(Board,RemainingStones1,FinalBoard1,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos,FinalWinner).


dragStoneBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard):-
										write('What stone do you want to move?'),nl,
										getStoneCellBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,Initial1,Initial2),
										displayDirectionsListBOT(Direction, NumberCells),
										checkDrag(LogicalBoard,Initial1,Initial2,Direction,NumberCells,Message,Final1,Final2),
										Message == valid -> getInfo(Initial1,Initial2,Stone,LogicalBoard),setInfo(Initial1,Initial2,empty,LogicalBoard,Res),setInfo(Final1,Final2,Stone,Res,ResultBoard);
										dragStoneBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard).	

										
displayDirectionsListBOT(Direction, NumberCells):- 	write('1 -> Up-Left     2 -> Up-Right     3 -> Right'),  nl,
													write('4 -> Down-Right  5 -> Down-Left    6 -> Left'), nl,
													write('Direction: '),
													random(1,7,Direction), 
													Direction < 7,
													Direction > 0,
													displayGetNumberCellsBOT(NumberCells)
													;
													nl, write('Invalid Input. Try again'),
													displayDirectionsListBOT(Direction, NumberCells).

displayGetNumberCellsBOT(NumberCells):-	write('Insert the number of cells you want to drag your stone: '), random(1,10,NumberCells).					
										
getStoneCellBOT(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos):-
	getNotEqualCoordsBOT(PlayedStoneCoord1,PlayedStoneCoord2,Coord1,Coord2),
	getInfo(Coord1,Coord2,Info,Board),
	(
		Info == empty -> getStoneCellBOT(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos);
		RowIdentifier is Coord1, RowPos is Coord2
		
	).
	
getStoneCellBOT(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos):-	
	getStoneCellBOT(Board,PlayedStoneCoord1,PlayedStoneCoord2,RowIdentifier,RowPos).
				
getNotEqualCoordsBOT(Initial1,Initial2,ResCoord1,ResCoord2):-
											getValidCoordsBOT(C1,C2),
											compCoords(Initial1,Initial2,C1,C2,M),
											M == notEqual,
											ResCoord1 is C1,ResCoord2 is C2,!.
											
getNotEqualCoordsBOT(Initial1,Initial2,ResCoord1,ResCoord2):-											
											getNotEqualCoordsBOT(Initial1,Initial2,ResCoord1,ResCoord2).
																		
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

getEmptyCellBOT(Board,RowIdentifier,RowPos):-
											getValidCoordsBOT(Coord1,Coord2),
											getInfo(Coord1,Coord2,Info,Board),
											Info == empty,
											write('Valid move!'),nl, RowIdentifier is Coord1,RowPos is Coord2,!.

getEmptyCellBOT(Board,RowIdentifier,RowPos):-
											getEmptyCellBOT(Board,RowIdentifier,RowPos).
	
	
getValidCoordsBOT(X,Y):-
				random(1,10,X),
				random(1,10,Y),
				validCell(X,Y),!.
				
getValidCoordsBOT(X,Y):-
				getValidCoordsBOT(X,Y).
	


dropStoneBOT(LogicalBoard,Stones,RemainingStones1,RowIdentifier,RowPos,ResultBoard1):-
			withdrawStoneBOT(Stones,RemainingStones1,ChoosedStone),
			getEmptyCellBOT(LogicalBoard,RowIdentifier,RowPos),
			setInfo(RowIdentifier,RowPos,ChoosedStone,LogicalBoard,ResultBoard1).
