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
%% 
%% 
%% - Mag je vereisen dat de user alles in vaste termen beschrijft bv 38.5_degrees_fever
%% - Moet je een correlatie mechanisme inbouwen (symptomen matchen met ziekten en doorvragen over de hoogste match)
%% - 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* --- Defining operators --- */
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).


/* --- A simple backward chaining rule interpreter --- */

is_true( P ):-
    has_symptom( P ).

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
    %% write( 'Derived:' ), write_ln( P ),
    disease(P),
    not(has_disease(P)),
    assert(has_disease(P)),
    forward
    ;
    write_ln( '' ).

new_derived_fact( Conclusion ):-
    if Condition then Conclusion,
    assert(has_disease(dummy)),
    not( has_disease( Conclusion )),
    retract(has_disease(dummy)),
    composed_fact( Condition ).

composed_fact( Condition ):-
    has_symptom( Condition ).

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
disease(malaria).
disease(sick).
disease(arse_worm).

%% Main function
go:-
	display_options,
	take_input(y, Symptoms),
	assert_symptoms(Symptoms),
	diagnose.

display_options:-
	bagof(Symptom, symptom(Symptom), Symptoms),
	write('You can choose from the following list of symptoms: '), write(Symptoms),nl.


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

%% Check if the given symptoms match a disease exactly
diagnose:-
	forward,
	bagof(Disease, has_disease(Disease), Diseases),
	Diseases = [_],
	write('You are suffering from '), write(Diseases),!;
	ask_questions.

%% Hier moet nog daadwerkelijk shit gebeuren, dit is meer dummy
ask_questions:-
	write_ln('Do you alsof suffer from headache?'),
	write_ln('thats good'),
	assert(has_disease(fever)),
	diagnose.

/* --- Knowledge system --- */

if high_fever and transpiration then malaria.
if worm_out_arse then arse_worm.
if transpiration and nausiated and worm_out_arse and barf then sick.




