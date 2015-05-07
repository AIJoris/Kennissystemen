add(A,B,Result,Label):-
	integer(Result),
	\+ Result is A + B,
	write('The component '),
	write(Label),
	write_ln(' is kapoet.').

add(A,B,Result,_):-
	integer(Result),
	randset(Result,Result,List),!,
	member(A,List),
	member(B,List),
	Result is A + B.

add(A,B,Result,_):-
	Result is A + B.

multiply(A,B,Result, Label):-
	integer(Result),
	randset(Result,Result,List),!,
	member(A,List),
	member(B,List),
	Result is A * B.

multiply(A,B,Result,Label):-
	Result is A * B.

multiply(A,B,Result,Label):-
	\+ Result is A * B,
	write('The component '),
	write(Label),
	write_ln(' is kapoet.').

system1(A,B,C,D,E,[F,G]):-
	integer(F), integer(G),
	add(X,Y,F),
	add(Y,Z,G),
	multiply(A,C,X),
	multiply(B,D,Y),
	multiply(C,E,Z).

system1(A,B,C,D,E,[F,G]):-
	multiply(A,C,X),
	multiply(B,D,Y),
	multiply(C,E,Z),
	add(X,Y,F),
	add(Y,Z,G).
