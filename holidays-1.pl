% Consider a social network with two types of relations (friend and spouse) as
% in Figure 1. Represent this network as a ProbLog input database (no 
% probabilities).

friend(alice,dan).
friend(dan,bob).
friend(carla,alice).
friend(carla,bob).

spouse(alice,bob).
spouse(bob,alice).
