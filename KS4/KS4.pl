%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kennissystemen Assignment 3
%% Joris Baan 10576681
%% Haitam Ben Yahia 10552359
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(800, xfy, before).
:- op(800, xfy, after).
:- op(800, xfy, concurrent).
:- op(200, xfy, or).


%% The timeline in this case is a-b-c
go1:-
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	assert(a before b),
	assert(b before c).

% The possible timelines are the following
% c-b-a
% b-c-a
go2:-
	assert(event(a)),
	assert(event(b)),
	assert(event(c)),
	a after b,
	c before a.

foo(A or B):-
	foo(A);
	foo(B).
% Transitive before rule
transitive_before(X, Y, Operator) :-
	 X before Y.

transitive_before(X, Z, Operator) :- 
	X before Y,
	transitive_before(Y, Z, Operator),
	\+ X before Z,
	assert(X before Z).





