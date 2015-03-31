%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Pepijn van Diepen
%%	tudentennummer: 10537473
%% 	Email: pepijnvandiepen@gmail.com
%% 
%% 	Joris Baan
%% 	Studentennummer: 10576681
%% 	Email: jsbaan@gmail.com
%% 
%% 	This code has been tested on Python 2.7.6
%% 	Instruction on testing can be found in the report
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

grandparent(X, Z) :- 
	parent(X,Y),
	parent(Y, Z).

thing(X) :- 
	human(X).

parent(pepijn, niemand).

human(pepijn).