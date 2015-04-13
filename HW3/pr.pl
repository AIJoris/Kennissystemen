%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Kennissystemen week 3 programmeeropdracht 
%%  April 2015
%% 
%%	Pepijn van Diepen
%%	Studentennummer: 10537473
%% 	Email: pepijnvandiepen@gmail.com
%% 
%% 	Joris Baan
%% 	Studentennummer: 10576681
%% 	Email: jsbaan@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* --- Defining operators --- */

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).


/* --- A simple backward chaining rule interpreter --- */

is_true( P ):-
    symptom( P ).

is_true( P ):-
    if Condition then P,
    is_true( Condition ).

is_true( P1 and P2 ):-
    is_true( P1 ),
    is_true( P2 ).

is_true( P1 or P2 ):-
    is_true( P1 )
    ;
    is_true( P2 ).


/* --- A simple forward chaining rule interpreter --- */

forward:-
    new_derived_fact( P ),
    !,
    write( 'Derived:' ), write_ln( P ),
    assert( fact( P )),
    forward
    ;
    write_ln( 'No more facts' ).

new_derived_fact( Conclusion ):-
    if Condition then Conclusion,
    not( fact( Conclusion ) ),
    composed_fact( Condition ).

composed_fact( Condition ):-
    fact( Condition ).

composed_fact( Condition1 and Condition2 ):-
    composed_fact( Condition1 ),
    composed_fact( Condition2 ).

composed_fact( Condition1 or Condition2 ):-
    composed_fact( Condition1 )
    ;
    composed_fact( Condition2 ).


/* --- User interaction model--- */

%% Symptoms
symptom(transpiration).
symptom(fever).
symptom(shivers).
symptom(headache).
symptom(diarrhea).
symptom(barf).

%% Main function
go:-
	take_input(y, Symptoms),
	write(Symptoms),
	assert_symptoms(Symptoms),
	diagnose(Symptoms, Disease).


%% Take input from the user
take_input(n, []).
take_input(y, [X|Symptoms]):-
	write('Please enter your symptom'),nl,
	read(X),
	write('Do you want to name another symptom? (y/n)'), nl,
	read(Y),
	take_input(Y, Symptoms).

%% Assert symptoms the user suffers from to the database
assert_symptoms([]).
assert_symptoms([Symptom|Symptoms]):-
	assert(has_symptom(Symptom)),
	assert_symptoms(Symptoms).

diagnose(Symptoms, Disease):-
	

/* --- Knowledge system --- */

if high_fever and transpiration then malaria.
if worm_out_arse then arse_worm.
if transpiration and nausiated then sick.
has_disease(A, B):-
	if A then B.



