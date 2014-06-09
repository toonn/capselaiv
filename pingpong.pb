% Approximation of the normal distribution, the probability for every "strength"
% is calculated using the following WolframAlpha query:
%   solve 0.5 * (erfc((10-(x+d))/(3*sqrt(2))) - erfc((10-(x-d))/(3*sqrt(2)))),
%       d=9.5, x=<strength>
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
    

winner(Team1, Team2, Game, 2) :-
    teamstrength(Team1, Game, TS1),
    teamstrength(Team2, Game, TS2),
    TS1 < TS2.
winner(Team1, Team2, Game, 1).


evidence(winner([a], [b], 1, 1), true).
evidence(winner([a], [b], 2, 1), true).
evidence(winner([a], [b], 3, 1), true).

query(personstrength(a, SA)).
query(personstrength(b, SB)).
