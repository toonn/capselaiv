% Consider a social network with two types of relations (friend and spouse) as
% in Figure 1. Represent this network as a ProbLog input database (no 
% probabilities).

person(alice).
person(bob).
person(carla).
person(dan).

friend(alice,dan).
friend(dan,bob).
friend(carla,alice).
friend(carla,bob).

spouse(alice,bob).
spouse(bob,alice).

% We consider three (types of) holiday destinations (seaside, mountains and
% city), and two attributes of people (enjoying sports and sightseeing,
% respectively).

destination(mountains).
destination(seaside).
destination(city).

0.8::enjoys(P,sports) :-
    person(P).
0.4::enjoys(P,sightseeing) :-
    person(P).
0.65::favorite(P,mountains);0.3::favorite(P,seaside);0.05::favorite(P,city) <-
    enjoys(P,sports),
    \+ enjoys(P,sightseeing).
0.8::favorite(P,city);0.15::favorite(P,seaside);0.05::favorite(P,mountains) <-
    enjoys(P,sightseeing),
    \+ enjoys(P,sports).
0.9::favorite(P,seaside);0.1::favorite(P,city) <-
    \+ enjoys(P,sports),
    \+ enjoys(P,sightseeing).
K::favorite(P,D) :-
    destination(D),
    K is 1.0/3,
    enjoys(P,sightseeing),
    enjoys(P,sports).

likes(P,A) :-
    favorite(P,A).

0.8::likes(P,D) :-
    spouse(P,S),
    likes(S,D).
0.1::likes(P,D) :-
    friend(P,F),
    likes(F,D).

% (a)
% (b)
%evidence(likes(bob,city),false).
% (c)
%evidence(likesame(alice,dan),true).

likesame(P1,P2) :-
    destination(D),
    likes(P1,D),
    likes(P2,D).

likes_(P,D) :-
    person(P),
    destination(D),
    likes(P,D).

%query(likes_(P,D)).

% Destination choices

0.8::visits(P,Fav,1);0.1::visits(P,O1,1);0.1::visits(P,O2,1) <-
    person(P),destination(Fav),destination(O1),destination(O2),
    favorite(P,Fav),O1\==Fav,O2\==Fav,O2\==O1.

0.7::happy(P,Y) <-
    person(P),
    destination(D),
    likes(P,D),
    visits(P,D,Y).

0.7::visits(P,D,Y);0.15::visits(P,O1,Y);0.15::visits(P,O2,Y) <-
    Y>1,
    person(P),destination(D),destination(O1),destination(O2),
    Prev is Y-1,visits(P,D,Prev),happy(P,Prev),
    O1\==D,O2\==D,O2\==O1.

0.4::visits(P,D,Y);0.3::visits(P,O1,Y);0.3::visits(P,O2,Y) <-
    Y>1,
    person(P),destination(D),destination(O1),destination(O2),
    Prev is Y-1,visits(P,D,Prev),
    \+ happy(P,Prev),
    O1\==D,O2\==D,O2\==O1.

query(happy(_,2)).

% 10
0.4::happy(P,Y) <-
    person(P),
    destination(D),
    visits(P,D,Y),
    spouse(P,S),
    visits(S,D,Y).

% 11
0.4::happy(P,Y) <-
    person(P),
    destination(D),
    visits(P,D,Y),
    friend(P,F),
    visits(F,D,Y).
