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
