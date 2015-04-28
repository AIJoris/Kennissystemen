%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kennissystemen Assignment 3
%% Joris Baan 10576681
%% Haitam Ben Yahia 10552359
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(800, xfy, before).
:- op(800, xfy, after).
:- op(800, xfy, concurrent).
:- op(200, xfy, or).

go1:-
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	a before b,
	c before a.

% go2 aanpassen
go2:-
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	a before b,
	c before a.

foo(A or B):-
	foo(A);
	foo(B).