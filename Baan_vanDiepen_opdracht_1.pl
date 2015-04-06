%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Kennissystemen week 1 programmeeropdracht 
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

%%%%%%%%%% KNOWLEDGE BASE %%%%%%%%%%%
:- dynamic concept/1.
:- dynamic has_relation/3.
:- dynamic is_a/2.

%%%%% Hierarchic concepts %%%%%
concept(thing).

concept(animal).

concept(mammal).
concept(bird). 
concept(reptile).

concept(primate).
concept(bear).
concept(flightless_land_bird).
concept(duck_like_bird).
concept(turtle).
concept(snake).

concept(squirrel_monkey).
concept(long_nosed_monkey).
concept(grizzly_bear).
concept(polar_bear).
concept(ostrich).
concept(swan).
concept(velvet_scoter).
concept(ninja_turtle).
concept(sea_turtle).
concept(rattlesnake).


%%%%% Hierarchic structure %%%%%
is_a(squirrel_monkey, primate).
is_a(long_nosed_monkey, primate).
is_a(grizzly_bear, bear).
is_a(polar_bear, bear).
is_a(ostrich, flightless_land_bird).
is_a(swan, duck_like_bird).
is_a(velvet_scoter, duck_like_bird).
is_a(ninja_turtle, turtle).
is_a(sea_turtle, turtle).
is_a(rattlesnake, snake).

is_a(primate, mammal).
is_a(bear, mammal).
is_a(flightless_land_bird, bird).
is_a(duck_like_bird, bird).
is_a(turtle, reptile).
is_a(snake, reptile).

is_a(mammal, animal).
is_a(bird, animal).
is_a(reptile, animal).

is_a(animal, thing).


%%%%% Relations %%%%%
% Procreation
has_relation(X, procreation, Y):-
	X = mammal, Y = pregnancy;
	X = bird, Y = egg;
	X = reptile, Y = egg.

% Temperature
has_relation(X, temperature, Y):-
	X = mammal, Y = warm_blooded;
	X = bird, Y = warm_blooded;
	X = reptile, Y = cold_blooded.

% Covered by 
has_relation(X, covered_by, Y):-
	X = mammal, Y = fur;
	X = bird, Y = feathers;
	X = reptile, Y = scales.

% Natural habitat 
has_relation(X, natural_habitat, Y):-
	X = squirrel_monkey, Y = tropical_forest;
	X = grizzly_bear, Y = temperate_forest;
	X = polar_bear, Y = polar;
	X = ostrich, Y = savanna;
	X = swan, Y = temperate_forest;
	X = velvet_scoter, Y = sea;
	X = ninja_turtle, Y = city;
	X = sea_turtle, Y = sea;
	X = rattlesnake, Y = temperate_forest.

% Number of legs
has_relation(X, nr_legs, Y) :-
	X = animal, Y = 0/inf;
	X = mammal, Y = 2/inf;
	X = bird, Y = 2;
	X = primate, Y = 2;
	X = bear, Y = 4;
	X = turtle, Y = 4;
	X = snake, Y = 0.

%%%%%%%%%% Knowledge base rules %%%%%%%%%%
%% Display all information about relations, also using the inheritance tree
%% Example call: relations(mammal, X, Y).
relations(Concept, Attribute, Value):-
	has_relation(Concept, Attribute, Value);
	is_a1(Concept, Subsumer),
	relations(Subsumer, Attribute, Value).

%% Find all subsumers of a concept
all_subsumers(Concept, Subsumers) :-
	bagof(X, is_a1(Concept, X), Subsumers).

%% Find all subsumees of a concept
all_subsumees(Concept, Subsumees) :-
	bagof(X, is_a1(X, Concept), Subsumees).

%% These rules make use of the transitivity of the inheritance tree
is_a1(Concept, Subsumer):-
	is_a(Concept, Subsumer).
is_a1(X, Z) :-
	is_a(X, Y),
	is_a1(Y, Z).

%%%%%%%%%%% Pretty print procedure %%%%%%%%%%
%% Show information about a concept X
show(X):-
	write(X), write(' attributes: '),
	show(X, _, _).
show(Concept, Attribute, Value):-
	findall([Attribute | Value], has_relation(Concept, Attribute, Value), Bag),
	write(Bag),nl,

	is_a(Concept, Subsumer),
	show(Subsumer).

%% Show the contents of the entire knowledge base
show:-
	concept(X), nl,
	show(X).
show.

%%%%%%%%%% Alter database %%%%%%%%%%
%% Add fully new concept, which falls under 'thing' only
addConcept(Concept):-
	addConceptBelow(Concept, thing).

%% Add a concept with an is_a relation (Concept is_a Superclass).
addConceptBelow(Concept, Superclass):-
	not(concept(Concept)),
	assert(concept(Concept)),
	concept(Superclass),
	assert(is_a(Concept, Superclass)).

%% Add a concept between two other concepts, so this new concept has 
%% all the attributes from its superclass, and the subsumee inherits all 
%% information from the newly added concept
addConceptBetween(Concept, Subclass, Superclass):-
	retract(is_a(Subclass, Superclass)),
	retract(concept(Subclass)),
	addConceptBelow(Concept, Superclass),
	addConceptBelow(Subclass, Concept).

%% Add a relation to a concept
addRelation(Concept, Attribute, Value):-
	concept(Concept),
	assert(has_relation(Concept, Attribute, Value)).


%%%%%%%%%% FIVE SHORTCUTS %%%%%%%%%%
%% Add fully new concept plant, with no attributes. Thus, it comes
%% under 'thing' and next to 'animal'
go1:-
	write('Add a new concept plant'),nl,nl,
	addConcept(plant),
	show(plant).

%% Add a fully subsumed concept, being an instance of the class
%% squirrel_monkey which has all the attributes that squirrel_monkeys
%% have, plus one relation being bob's favorite fruit
go2:- 
	write('Add a new concept bob, which descends from squirrel_monkey'),nl,nl,
	addConceptBelow(bob, squirrel_monkey),
	addRelation(bob, favorite_fuit, banana),
	show(bob).

%% Add a new concept between two concepts in the Hierarchic structure.
%% In this case, add a venomous_snakes class under the snakes class,
%% which is the superclass of the already present class rattlesnake.
go3:-
	write('Add a new concept venomous_snake, which descends from snakes and is the superclass of rattlesnake'),nl, nl,
	addConceptBetween(venomous_snake, rattlesnake, snake),
	addRelation(venomous_snake, poison, deadly),
	show(venomous_snake).

%% Add a new type of animal next to bird, mammal and reptile: insects
go4:-
	write('Add a new concept insect, descending from animal'),nl,nl,
	addConceptBelow(insect, animal),
	addRelation(insect, covered_by, exoskeleton),
	addRelation(insect, temperature, cold_blooded),
	addRelation(insect, procreation, egg),
	show(insect).

%% Add a new class of insects: spiders
go5:-
	write('Add a new concept spider, which descends from insect'),nl,nl,
	addConceptBelow(spider, insect),
	addRelation(spider, nr_legs, 8),
	show(spider).





