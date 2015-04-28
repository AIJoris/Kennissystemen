%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kennissystemen Assignment 3
%% Joris Baan 10576681
%% Haitam Ben Yahia 10552359
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(800, xfy, before).
:- op(700, xfy, after).
:- op(300, xfy, concurrent).

go1:-
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	a before b,
	c before a.
go2:-
.