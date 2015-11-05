
:- use_module(library(random)).
:- use_module(library(system)).
:- use_module(library(lists)).
:- include('utilities.pl').
:- include('menus.pl').
:- include('game.pl').


meerkats :- mainMenu.

emptyCell(empty).
blueStone(blue).
yellowStone(yellow).
redStone(red).
greenStone(green).