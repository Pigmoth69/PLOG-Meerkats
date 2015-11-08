chooseStoneBOT(ChoosedStone):-
							random(1,5,StoneID),(
							StoneID == 1 ->  ChoosedStone = red;
							StoneID == 2 ->  ChoosedStone = green;
							StoneID == 3 ->  ChoosedStone = blue;
							StoneID == 4 ->  ChoosedStone = yellow;
							chooseStone(ChoosedStone)).
							
withdrawStoneBOT(Stones,RemainingStones,StoneColor):-
									chooseStoneBOT(ChoosedStone),
									getStoneNumber(Stones,ChoosedStone,Number),
									Number > 0 ->format('~w', [ChoosedStone]), NewNum is Number -1,
									setStoneNumber(Stones,ChoosedStone,NewNum,RemainingStones),
									StoneColor = ChoosedStone;
									withdrawStoneBOT(Stones,RemainingStones,StoneColor).

getWinningOnDropBOT(Board,RemainingStones1,FinalBoard,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos):-
											winner(FinalBoard, [H|_], Area),getPlayer(Players,H,ID),
											(
												(ID \= 0, Area == 15) ->  nl,Winner is ID;

												drawBoard(Board, FinalBoard),
												dragStoneBOT(FinalBoard,RowIdentifier,RowPos,FinalBoard1),
												getWinningOnDrag(Board,RemainingStones1,FinalBoard1,Tail,Players,ResultBoard,RemainingStones,2,Winner,RowIdentifier,RowPos)
											).
											
											


dragStoneBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard):-
										getStoneCellBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,Initial1,Initial2),
										random(1, 7, Direction),
										random(1, 5, NumberCells),
										checkDrag(LogicalBoard,Initial1,Initial2,Direction,NumberCells,Message,Final1,Final2), 
										Message == valid -> getInfo(Initial1,Initial2,Stone,LogicalBoard),setInfo(Initial1,Initial2,empty,LogicalBoard,Res),setInfo(Final1,Final2,Stone,Res,ResultBoard);
										dragStoneBOT(LogicalBoard,PlayedStoneCoord1,PlayedStoneCoord2,ResultBoard).	



displayGetNumberCellsBOT(NumberCells):-	write('Insert the number of cells you want to drag your stone: '), random(1,10,NumberCells).					
										
getStoneCellBOT(Board,PlayedStoneCoord1,PlayedStoneCoord2,Row,Pos):-
					getColorCells(Board,1, 1, ResultBlues, blue),
					getColorCells(Board,1, 1, ResultReds, red),
					getColorCells(Board,1, 1, ResultGreens, green),
					getColorCells(Board,1, 1, ResultYellows, yellow),
					append(ResultBlues, ResultYellows, Result1),
					append(ResultGreens, ResultReds, Result2),
					append(Result1, Result2, ResultStones),
					getNotEqualCoordsBOT(ResultStones, PlayedStoneCoord1, PlayedStoneCoord2, Row, Pos).
	
				
getNotEqualCoordsBOT(ResultStones, RowIdentifier,RowPos, ResultRow, ResultPos):-
					length(ResultStones, Length), L is Length + 1,  
					random(1, L, Index),
					getIndexInfo(ResultStones, Index, [Row|Pos]), compCoords(RowIdentifier, RowPos, Row, Pos, Message),
					(
						Message == equal -> getNotEqualCoordsBOT(ResultStones, RowIdentifier,RowPos, ResultRow, ResultPos);

						ResultRow is Row, ResultPos is Pos
					).
	

getEmptyCellBOT(Board,Row,Pos):-	getEmptyCells(Board, 1, 1, ResultBoardWithEmptyCells),
									length(ResultBoardWithEmptyCells, Length),
									L is Length + 1,
									random(1, L, Index),
									getIndexInfo(ResultBoardWithEmptyCells,Index,[Row|Pos]).

getEmptyCellBOT(_, 9, 6).


	
getValidCoordsBOT(X,Y):-
				random(1,10,X),
				random(1,10,Y),
				validCell(X,Y),!.
				
getValidCoordsBOT(X,Y):-
				getValidCoordsBOT(X,Y).
	


dropStoneBOT(ID,LogicalBoard,Stones,RemainingStones1,RowIdentifier,RowPos,ResultBoard1):-
			format('BOT ~d dropped a ', [ID]),
			withdrawStoneBOT(Stones,RemainingStones1,ChoosedStone),
			getEmptyCellBOT(LogicalBoard,RowIdentifier,RowPos),
			setInfo(RowIdentifier,RowPos,ChoosedStone,LogicalBoard,ResultBoard1),
			format(' stone into the position [~d, ~d].', [RowIdentifier,RowPos]), nl.
