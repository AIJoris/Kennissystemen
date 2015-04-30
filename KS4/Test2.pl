
:- op(800, xfy, before).
:- op(800, xfy, after).
:- op(800, xfy, concurrent).
:- op(900, xfy, or).
:- dynamic before/2.
:- dynamic after/2.
:- dynamic concurrent/2. 

%% Knowledge base
d before e.
b before c.
c before d.
a before b.
f before d.
f before g.

event(a).
event(b).
event(c).
event(d).
event(e).
event(f).
event(g).


is_before(X before Y):- 
	X before Y.
is_before(X before Z):- 
	Y before Z,
	 is_before(X before Y).

is_before(X before Y):-
	 \+Y == X,
	 \+is_before2(Y before X).

is_before2(X before Y):-
	 X before Y.
is_before2(X before Y):-
	 Z before Y,
	  is_before2(X before Z).

is_before3(X before Y):-
	 X before Y.
is_before3(X before Y):-
	 Z before Y,
	 is_before3(X before Z).

earliest(X):-
	X before _,
	\+ _ before X.


add_next(A,C):-
	event(B),
	setof(B, is_before(A before B), List),
	member(C, List).


af(Result):-
	setof(X, earliest(X), Earliest),
	member(Early, Earliest),
	setof(X, add_everything([Early], X), Timelines),
	setof(Y, event(Y), Events),
	af1(Timelines, Events, Result).

af1(Timelines, Events, Timeline):-
	member(Timeline, Timelines),
	af2(Timeline, Events).

af2(_, []).
af2(Timeline, [Event|Events]):-
	member(Event, Timeline),
	af2(Timeline, Events).


add_everything(Result, Result):-
	reverse(Result, [H|_]),
	(\+add_next(H,_);
	\+validate_timeline(Result, _)).

add_everything(List, Result):-
	reverse(List, [H|_]),
	add_next(H, Next),
	validate_timeline(List, Next),
	append(List, [Next], NewList),
	add_everything(NewList, Result).


validate_timeline([H|TTimeline], Next):-
	is_before(H before Next),
	validate_timeline(TTimeline, Next),!.

validate_timeline([], _).

	
point(X):-
	write('Input please'),
	read(Input),
	assert(Z),
	write('More input or quit (q)'),
	read(Y),
	(Y == q, af(X)

















































make_timeline(X):-
	setof(X, earliest(X), List),
	member(Start, List),
	add_everything([Start], Result),
	write(Z, Result).

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

%% check(A before B):-
%% 	write(A before B),
%% 	write(' '),
%% 	\+ C before A.

%% check(A before B):-
%% 	_ before A,
%% 	check(_ before A),
%% 	write(A before B).

check(X before Y, [X before Y|Result]):-
	X before Y or _,
	(_ before Y, check(_ before Y,Result));
	(\+_ before Y).

check(X before Y, [X before Y|Result]):-
	_ or X before Y,
	(_ before Y, check(_ before X,Result));
	(\+_ before Y).

%% check(X before Y, [X before Y]):-
%% 	_ or X before Y or _,.

check(Y before Z, [Y before Z]) :-
	 Y before Z,
	 \+ A before Y.

check(Y before Z, [Y before Z|Result]) :- 
	Y before Z,
	check(_ before Y,Result).