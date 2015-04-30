%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kennissystemen Assignment 3
%% Joris Baan 10576681
%% Haitam Ben Yahia 10552359
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- op(800, xfy, before).
:- op(800, xfy, after).
:- op(800, xfy, concurrent).
:- op(200, xfy, or).
:- dynamic before/2.
:- dynamic after/2.
:- dynamic concurrent/2. 

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

% Explicitely add all transitive before relations to the knowledge base
transitive_before(X, Y) :-
	 X before Y.
transitive_before(X, Z) :- 
	X before Y,
	transitive_before(Y, Z),
	(\+ X before Z,
	assert(X before Z));
	true.

% Explicitely add all transitive after relations to the knowledge base
transitive_after(X, Y) :-
	 X after Y.
transitive_after(X, Z) :- 
	X after Y,
	transitive_after(Y, Z),
	(\+ X after Z,
	assert(X after Z));
	true.

% Explicitely add all transitive concurrent relations to the knowledge base
transitive_concurrent(X, Y) :-
	 X concurrent Y.
transitive_concurrent(X, Z) :- 
	X concurrent Y,
	transitive_concurrent(Y, Z),
	(\+ X concurrent Z,
	assert(X concurrent Z));
	true.

%% Explicitely add all transitive relations to the KB
transitive:-
	bagof(_, transitive_before(_,_), _),!,
	bagof(_, transitive_after(_,_), _),!,
	bagof(_, transitive_concurrent(_,_), _),!.

earliest(X):-
	X before _,
	\+ _ before X.

is_earlier(X,Y):-
	X before Y.
is_earlier(X,Z):-
	X before Y,
	is_earlier(Y,Z),!.

generate_timeline([X|Timeline]):-
	transitive,
	earliest(X), write(X),
	bagof(Y, is_earlier(X, Y), Temp),
	reverse(Temp, [_|Temp1]),
	reverse(Temp1, Timeline).

timeline(Result):-
	transitive,
	setof([A before B], A before B, [Rule|Ruleset]),
	X before Z = Rule,
	perm([[X,Z]], Ruleset, Result).

perm(Result, [], Result).
perm(Timelines, [Rule|Ruleset], Result):-
	perm1(Timelines, Rule, Newtimelines),
	perm(Newtimelines, Ruleset, Result).

perm1([], _, []).
perm1([Timeline|Timeslines], Rule, [Newtimeline|Newtimelines]):-
	(nomatch(Timeline, Rule, Newtimeline);
	leftmatch(Timeline, Rule, Newtimeline);
	rightmatch(Timeline, Rule, Newtimeline)),
	perm1(Timelines, Rule, Newtimelines).

nomatch(Timeline, X before Y, [[X,Y], Timeline]):-
	\+ member(X, Timeline),
	\+ member(Y, Timeline).

leftmatch(Timeline, X before Y, Newtimelines):-
	append(Beginning, [Y|End],Timeline),
	length(Beginning, Length),
	addX(Beginning,[Y|End], X, Newtimelines, Length).

addX(_,_, _, [], 0).
addX(Beginning, End, X, [Tempresult|Result], Length):-
	ins(X, Beginning, Length, Tempresult, End),
	Templength is Length-1,
	addX(Beginning, End, X, Result, Templength),!.

% ins(Val,List,Pos,Res)
ins(Val,[H|List],Pos,[H|Res], End):-
	Pos > 1, !, 
	Pos1 is Pos - 1,
	ins(Val,List,Pos1,Res, End).
ins(Val, List, 1, Result, End):-
	append([Val|List], End, Result).






check(A before B, [], [A,B]).
check(A concurrent B, [], [[A,B]]).
check(A before B, [H|T], [H|Result]):-
	member(B, Timeline),
	append([BeforeB],[B|Btail],[H|T]),
	add(BeforeB, B, Result).

add([H|[]], B, [H,B]).
add([H|T], B, [[B,H|T]|Result]):-
	add(T,B,[H|Result]).
	
	





%% Knowledge base
event(a).
event(b).
event(c).

d before e.
b before c.
c before d.
a before b.
f before d.


b concurrent e.









%% earliest(X):-
%% 	X before _,
%% 	\+ _ before X.

%% is_earlier(X,Y):-
%% 	X before Y.
%% is_earlier(X,Z):-
%% 	X before Y,
%% 	is_earlier(Y,Z),!.

%% timeline([X|Timeline]):-
%% 	transitive,
%% 	earliest(X),
%% 	bagof(Y, is_earlier(X, Y), Temp),
%% 	reverse(Temp, [_|Temp1]),
%% 	reverse(Temp1, Timeline).