:- op(800, fx, if).
:- op(700, xfx, then).

fact(yes).
test:-
	then(
		if(fact(yes),
		write('hallo')
	).