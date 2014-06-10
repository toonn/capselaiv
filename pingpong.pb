% Approximation of the normal distribution, the probability for every "strength"
% is calculated using the following WolframAlpha query:
%   solve 0.5 * (erfc((10-(x+d))/(3*sqrt(2))) - erfc((10-(x-d))/(3*sqrt(2)))),
%       d=0.5, x=<strength>
% The given probability for each strength is therefore:
%   Pr("strength"-0.5 < X <= "strength"+0.5)
% The number of "strength" values to use was determined using the 3-sigma rule.
% ~99.7% of observations for a normally distributed population are within
% 3 standard deviations from the mean.
% This results in the interval [1,19], which, for convenience, was replaced by
% (0.5,19.5], containing 99.8% of observations.
0.00153228 :: personstrength(Person, 1) ;
0.0039064 :: personstrength(Person, 2) ;
0.00892047 :: personstrength(Person, 3) ;
0.0182464 :: personstrength(Person, 4) ;
0.0334307 :: personstrength(Person, 5) ;
0.0548653 :: personstrength(Person, 6) ;
0.0806559 :: personstrength(Person, 7) ;
0.106209 :: personstrength(Person, 8) ;
0.125279 :: personstrength(Person, 9) ;
0.132368 :: personstrength(Person, 10) ;
0.125279 :: personstrength(Person, 11) ;
0.106209 :: personstrength(Person, 12) ;
0.0806559 :: personstrength(Person, 13) ;
0.0548653 :: personstrength(Person, 14) ;
0.0334307 :: personstrength(Person, 15) ;
0.0182464 :: personstrength(Person, 16) ;
0.00892047 :: personstrength(Person, 17) ;
0.0039064 :: personstrength(Person, 18) ;
0.00153228 :: personstrength(Person, 19) <- true.

% Because more intervals make the computation take alot longer we added these.
% Every value represents the interval (value-3, value+3].
%0.157305 :: personstrength(Person, 4) ;
%0.682689 :: personstrength(Person, 10) ;
%0.157305 :: personstrength(Person, 16) <- true.

% Every value represents the interval (value-2, value+2].
%0.0223211 :: personstrength(Person, 2) ;
%0.229742 :: personstrength(Person, 6) ;
%0.495015 :: personstrength(Person, 10) ;
%0.229742 :: personstrength(Person, 14) ;
%0.0223211 :: personstrength(Person, 18) <- true.


0.1 :: lazy(Person, Game).


teamstrength([], _, 0).
teamstrength([Person | RTeam], Game, TeamStrength) :-
    lazy(Person, Game),
    personstrength(Person, PersonStrength),
    Strength is PersonStrength / 2,
    teamstrength(RTeam, Game, RTeamStrength),
    TeamStrength is Strength + RTeamStrength.
teamstrength([Person | RTeam], Game, TeamStrength) :-
    personstrength(Person, PersonStrength),
    teamstrength(RTeam, Game, RTeamStrength),
    TeamStrength is PersonStrength + RTeamStrength.
    

minteamstrength([], _, inf).
minteamstrength([Person | RTeam], Game, TeamStrength) :-
    lazy(Person, Game),
    personstrength(Person, PersonStrength),
    Strength is PersonStrength / 2,
    minteamstrength(RTeam, Game, RTeamStrength),
    TeamStrength is min(Strength, RTeamStrength).
minteamstrength([Person | RTeam], Game, TeamStrength) :-
    personstrength(Person, PersonStrength),
    teamstrength(RTeam, Game, RTeamStrength),
    TeamStrength is min(PersonStrength, RTeamStrength).


winner(Team1, Team2, Game, win) :-
    teamstrength(Team1, Game, TS1),
    teamstrength(Team2, Game, TS2),
    TS1 >= TS2.
winner(Team1, Team2, Game, loss) :-
    teamstrength(Team1, Game, TS1),
    teamstrength(Team2, Game, TS2),
    TS1 < TS2.


minwinner(Team1, Team2, Game, win) :-
    minteamstrength(Team1, Game, TS1),
    minteamstrength(Team2, Game, TS2),
    TS1 >= TS2.
minwinner(Team1, Team2, Game, loss) :-
    minteamstrength(Team1, Game, TS1),
    minteamstrength(Team2, Game, TS2),
    TS1 < TS2.


% Configuration 1: confounded evidence
evidence(winner([a], [b], 1, win), true).
evidence(winner([a], [b], 2, win), true).
evidence(winner([a], [b], 3, win), true).

query(personstrength(a, SA)).
% For the shifted gauss plot, this was also used.
query(personstrength(b, SB)).


% Configuration 2: strong indirect evidence
%evidence(winner([a], [b], 1, win), true).
%evidence(winner([b], [c], 2, win), true).
%evidence(winner([b], [d], 3, win), true).
%
%query(personstrength(a, SA)).


% Configuration 3: weak indirect evidence
%evidence(winner([a], [b], 1, win), true).
%evidence(winner([b], [c], 2, loss), true).
%evidence(winner([b], [d], 3, loss), true).
%
%query(personstrength(a, SA)).


% Configuration 4: diverse evidence
%evidence(winner([a], [b], 1, win), true).
%evidence(winner([a], [c], 2, win), true).
%evidence(winner([a], [d], 3, win), true).
%
%query(personstrength(a, SA)).

% The probabilities in these two queries do not add up to 1. Why?
%query(winner([a], [b], 1, win)).
%query(winner([a], [b], 1, loss)).

%query(winner([a,b], [y,z], 1, win)).
%query(winner([a,b,c], [x,y,z], 1, win)).

%query(minwinner([a,b], [y,z], 1, win)).
%query(minwinner([a,b,c], [x,y,z], 1, win)).
