:- use_module(library(random)).

% The following predicate is necessary because problog does not allow one to
% specify a continuous normal distribution for a variable.
% The code is translation into prolog that stays as close as possible to the
% original python implementation (function normalvariate in random.py) from the
% python standard library, this implementation is based on the Kinderman and
% Monahan method.
gauss(Mu, Sigma, N) :-
    random(U1),
    random(U2_),
    U2 is 1.0 - U2_,
    NV_MAGICCONST is 4 * exp(-0.5)/sqrt(2.0),
    Z is NV_MAGICCONST*(U1-0.5)/U2,
    ZZ is Z*Z/4.0,
    (ZZ =< -log(U2), N is Mu + Z*Sigma
        ;
    gauss(Mu, Sigma, N)).

personstrength(Person, PersonStrength) :-
    gauss(10, 3, PersonStrength).

0.1 :: lazy(Person, Game).

teamstrength([], _, 0).
teamstrength([Person | RTeam], Game, TeamStrength) :-
    lazy(Person, Game),
    personstrength(Person, PersonStrength),
    Strength is PersonStrength / 2,
    teamstrength(RTeam, Game, RTeamStrength),
    TeamStrength is Strength + RTeamStrength).
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
/*
(mh-query 1000 100 ;Monte Carlo Inference
    ;CONCEPTS
    (define personstrength (mem (lambda (person) (gaussian 10 3))))
    (define lazy (mem (lambda (person game) (flip 0.1))))
    (define (teamstrength team game)
        (sum
            (map
                (lambda (person)
                    (if (lazy person game)
                        (/ (personstrength person) 2)
                        (personstrength person)))
                team)))
    (define winner team1 team2 game)
        (if (< (teamstrength team 1 game)
            (teamstrength team2 game))
            'team2 'team1))
    ;QUERY
    (personstrength 'A)
    ;EVIDENCE
    (and
        (= 'team1 (winner '(TG) '(NG) 1))
        (= 'team1 (winner '(NG) '(AS) 2))
        (= 'team1 (winner '(NG) '(BL) 3))
        (lazy '(NG) 1) ;additional evidence, used in Experiment 2
    )
)
*/
