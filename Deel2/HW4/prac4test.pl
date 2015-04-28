is_after(X,Z):-
	X after Z.
is_after(X,Z):-
	X after Y,
	is_after(Y,Z).