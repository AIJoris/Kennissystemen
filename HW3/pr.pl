%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Kennissystemen week 3 programmeeropdracht 
%%  April 2015
%% 
%%  Pepijn van Diepen
%%  Studentennummer: 10537473
%%  Email: pepijnvandiepen@gmail.com
%% 
%%  Joris Baan
%%  Studentennummer: 10576681
%%  Email: jsbaan@gmail.com
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
%% :- dynamic has_symptom/1.
:- dynamic symptom/1.
:- dynamic not_has_symptom/1.
:- dynamic not_has_disease/1.

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

if_then(Condition, Conclusion):-
    if Condition then Conclusion;
    descends_from(SubCondition, Condition),
    if_then(SubCondition, Conclusion).

/* --- User interaction model--- */
%% Symptoms
symptom(transpiration).
symptom(fever).
    symptom(constant_fever).
    symptom(recurrent_fever).
        symptom(recurrent_fever_48).
        symptom(recurrent_fever_72).
symptom(shivers).

symptom(headache).
symptom(diarrhea).
symptom(barf).

%% Diseases
disease(malaria).
    disease(benign_malaria).
        disease(tertiana_malaria).
        disease(quartana_malaria).
    disease(tropica_malaria).

disease(intestinal_infection).
    disease(tyfus).
    disease(giardiases).
    disease(jaundice).

disease(worms).
    disease(pin_worm).
    disease(whip_worm).
    disease(tape_worm).
        disease(taenia_saginata).
        disease(taenia_solium).

disease(skin_disease).
    disease(lepra).
    disease(fungus).
        disease(panoe).
disease(sick).
disease(arse_worm).

%% Diseases inheritances
descends_from(benign_malaria, malaria).
descends_from(tertiana_malaria, benign_malaria).
descends_from(quartana_malaria, benign_malaria).
descends_from(tropica_malaria, malaria).

descends_from(tyfus, intestinal_infection).
descends_from(giardiases, intestinal_infection).
descends_from(jaundice, intestinal_infection).

descends_from(pin_worm, worms).
descends_from(whip_worm, worms).
descends_from(tape_worm, worms).
descends_from(taenia_saginata, tape_worm).
descends_from(taenia_solium, tape_worm).

descends_from(lepra, skin_disease).
descends_from(fungus, skin_disease).
descends_from(panoe, fungus).

%% Symptoms inheritances
descends_from(constant_fever, fever).
descends_from(recurrent_fever, fever).
descends_from(recurrent_fever_48, recurrent_fever).
descends_from(recurrent_fever_72, recurrent_fever).

not_has_symptom(dummy).
not_has_disease(dummy).

extract_symptom(S1 and S2, Z):-
    %% gtrace,
    extract_symptom(S1, Z);
    extract_symptom(S2, Z).

extract_symptom(S1, Z):-
    not(has_symptom(S1)),
    not(not_has_symptom_Inh(S1)),
    not(S1 = _ and _),
    Z = S1.

%% Also check whether the inheritances are not present (if you said: I do not
%% suffer from fever you do not want to be asked if you have recurrent fever)
not_has_symptom_Inh(Symptom):-
    not_has_symptom(Symptom);
    descends_from(Symptom, ParentSymptom),
    not_has_symptom_Inh(ParentSymptom).

%% Also check whether the inheritances are not present (if you said: I do not
%% suffer from malaria (implicit) you dont want to be asked if you have recurrent fever)
not_has_disease_Inh(Disease):-
    not_has_disease(Disease);
    descends_from(Disease, ParentDisease),
    not_has_disease_Inh(ParentDisease).

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
    not(not_has_disease_Inh(PlausibleDisease)),
    write('Do you alsof suffer from '), write(Z), write('? (y/n)'),nl,
    read(Answer),
    add_symptom(Answer, Z, PlausibleDisease),
    diagnose.

/* --- Knowledge system --- */

add_symptom(n, Symptom, Disease):-
    write_ln('Noted.'),
    assert(not_has_symptom(Symptom)),
    assert(not_has_disease(Disease)).

add_symptom(y, Symptom, _):-
    assert(has_symptom(Symptom)).

if fever and transpiration and shivers then malaria.
if constant_fever and transpiration and shivers then tropica_malaria.
if recurrent_fever and transpiration and shivers then benign_malaria.
if recurrent_fever_48 and transpiration and shivers then tertiana_malaria.
if recurrent_fever_72 and transpiration and shivers then quartana_malaria.

if worm_out_arse and ass_scratch then arse_worm.
if transpiration and nausiated and worm_out_arse and barf then sick.




