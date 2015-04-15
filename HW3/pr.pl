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
%% - Hierarchy within diseases (zoekruimte beperken)
%% - Abstraction of symptoms
%% - 
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* --- Defining operators --- */
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).
:- dynamic has_symptom/1.
:- dynamic symptom/1.
:- dynamic not_has_symptom/1.

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

/* --- A simple backward chaining rule interpreter MODIFIED--- */
is_plausible( P ):-
    has_symptom( P ).

is_plausible( P ):-
    if Condition then P,
    is_plausible( Condition ).

is_plausible( P1 and P2 ):-
    is_plausible( P1 or P2 ).

is_plausible( P1 or P2 ):-
    is_plausible( P1 )
    ;
    is_plausible( P2 ).

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
    retract(has_disease(dummy));
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
not_has_symptom(dummy).

extract_symptom(S1 and S2, Z):-
    extract_symptom(S1, Z);
    extract_symptom(S2, Z).

extract_symptom(S1, Z):-
    not(has_symptom(S1)),
    not(not_has_symptom(S1)),
    not(S1 = _ and _),
    Z = S1.


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
%% take_input(n, []).
take_input(y, Symptoms):-
	write_ln('Please enter your symptoms comma-seperated within square brackets:'),
	read(Symptoms).
	%% write('Do you want to name another symptom? (y/n)'), nl,
	%% read(Y),
	%% take_input(Y, Symptoms).

%% Assert symptoms the user suffers from to the database
assert_symptoms([]).
assert_symptoms([Symptom|Symptoms]):-
	assert(has_symptom(Symptom)),
	assert_symptoms(Symptoms).

%% Check if the given symptoms match a disease exactly
diagnose:-
	forward,
	bagof(Disease, has_disease(Disease), Diseases),
	Diseases = [_|_],
	write('You are suffering from '), write(Diseases),!;
	ask_questions.

%% Hier moet nog daadwerkelijk shit gebeuren, dit is meer dummy
ask_questions:-
    disease(PlausibleDisease),
    is_plausible(PlausibleDisease),
    if PlausibleSymptoms then PlausibleDisease,
    extract_symptom(PlausibleSymptoms, Z),
	write('Do you alsof suffer from '), write(Z), write('? (y/n)'),nl,
    read(Answer),
    add_symptom(Answer, Z),
	%% write_ln('thats good'),
	%% assert(has_disease(fever)),
	diagnose.

/* --- Knowledge system --- */

add_symptom(n, Symptom):-
    write_ln('Noted.'),
    assert(not_has_symptom(Symptom)).
    % Hier miss de hele symptom uit de database verwijderen?

add_symptom(y, Symptom):-
    assert(has_symptom(Symptom)).

if fever and transpiration then malaria.
if worm_out_arse and ass_scratch then arse_worm.
if transpiration and nausiated and worm_out_arse and barf then sick.




