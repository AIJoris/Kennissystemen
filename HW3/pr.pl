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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* --- Defining operators --- */
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).
:- op(800, xfx, <=).

%% :- dynamic has_symptom/1.
:- dynamic symptom/1.
:- dynamic not_has_symptom/1.
:- dynamic not_has_disease/1.

/* --- A simple backward chaining rule interpreter altered to return --- */
/* --- the how-explanation. (Brakto chapter 15)                      --- */
is_true(P, P ):-
    has_symptom(P).

is_true(P, P <= CondProof):-
    if Cond then P,
    is_true(Cond, CondProof).

is_true(P1 and P2, Proof1 and Proof2):-
    is_true(P1, Proof1),
    is_true(P2, Proof2).

is_true(P1 or P2, Proof):-
    is_true(P1, Proof)
    ;
    is_true(P2, Proof).

/* --- A simple backward chaining rule interpreter MODIFIED--- */
is_plausible( P ):-
    has_symptom_Inh(P, _ );
    has_symptom_Inh(_,P).

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
    %% Dit uitroepteken moest weg (weet niet waarom hij der stond)
    %% write( 'Derived:' ), write_ln( P ),
    disease(P),
    not(has_disease(P)),
    %% gtrace,
    not(descends_from(_,P)),
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

symptom(head_complaints).
    symptom(yellowish_discoloration).
    symptom(headache).
    symptom(drowsy).

symptom(stomach_complaints).
    symptom(stomach_ache).
    symptom(nausiated).

symptom(excretion_complaints).
    symptom(stool_complaints).
        symptom(diarrhea).
        symptom(sticky_diarrhea).
        symptom(light_colored_stools).
        symptom(worms_in_stool).
            symptom(worms_in_stool_big).
                symptom(worms_in_stool_3m).
                symptom(worms_in_stool_10m).
            symptom(worms_in_stool_1cm).
            symptom(worms_in_stool_4cm).
    symptom(dark_colored_urine).

symptom(skin_complaints).
    symptom(itchy_anus).
    symptom(nodule).
    symptom(stung_by_mosquito).


%% Diseases
disease(malaria).
    disease(tropica_malaria).
    disease(benign_malaria).
        disease(tertiana_malaria).
        disease(quartana_malaria).

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

descends_from(yellowish_discoloration, head_complaints).
descends_from(headache, head_complaints).
descends_from(drowsy, head_complaints).

descends_from(stomach_ache, stomach_complaints).
descends_from(nausiated, stomach_complaints).

descends_from(dark_colored_urine, excretion_complaints).
descends_from(stool_complaints, excretion_complaints).
descends_from(diarrhea, stool_complaints).
descends_from(sticky_diarrhea, stool_complaints).
descends_from(light_colored_stools, stool_complaints).
descends_from(worms_in_stool, stool_complaints).
descends_from(worms_in_stool_4cm, worms_in_stool).
descends_from(worms_in_stool_1cm, worms_in_stool).
descends_from(worms_in_stool_big, worms_in_stool).
descends_from(worms_in_stool_3m, worms_in_stool_big).
descends_from(worms_in_stool_10m, worms_in_stool_big).

related(X, Y):-
    descends_from(X, Y);
    descends_from(Y, X).

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

has_symptom_Inh(Symptom, _):-
    has_symptom(Symptom).

has_symptom_Inh(Symptom, ParentSymptom):-
    descends_from(Symptom, Sub_symptom),
    has_symptom_Inh(Sub_symptom, ParentSymptom).

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
    Diseases = [Disease|_],
    is_true(Disease, HowExplanation),
    write('You are suffering from '), write(Diseases),nl, write_ln(HowExplanation),!;
    ask_questions.

%% Hier moet nog daadwerkelijk shit gebeuren, dit is meer dummy
ask_questions:-
    disease(PlausibleDisease),
    is_plausible(PlausibleDisease),
    if PlausibleSymptoms then PlausibleDisease,
    extract_symptom(PlausibleSymptoms, Z),
    not(not_has_disease_Inh(PlausibleDisease)),
    write('Do you also suffer from '), write(Z), write('? (y/n)'),nl,
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

if fever and transpiration and shivers and stung_by_mosquito then malaria.
    if constant_fever and transpiration and shivers and stung_by_mosquito then tropica_malaria.
    if recurrent_fever and transpiration and shivers and stung_by_mosquito then benign_malaria.
        if recurrent_fever_48 and transpiration and shivers and stung_by_mosquito then tertiana_malaria.
        if recurrent_fever_72 and transpiration and shivers and stung_by_mosquito then quartana_malaria.

if fever and headache and drowsy then tyfus.
if sticky_diarrhea and stomach_ache and nausiated then giardiases.
if yellowish_discoloration and dark_colored_urine and light_colored_stools and stomach_ache then jaundice.

if worms_in_stool then worms.
    if worms_in_stool_big then tape_worm.
        if stomach_ache and worms_in_stool_10m then taenia_saginata.
        if nodule and worms_in_stool_3m then taenia_solium.
    if itchy_anus and nausiated and worms_in_stool_1cm then pin_worm.
    if stomach_ache and diarrhea and worms_in_stool_4cm then whip_worm.

