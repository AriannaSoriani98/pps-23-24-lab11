% search2 (Elem , List )
% looks for two consecutive occurrences of Elem
search2(E, [E, E | T]).
search2(E, [H | T]) :- search2(E, T).

% search_two (Elem , List )
% looks for two occurrences of Elem with any element in between !
search_two(E, [E, _, E | T]).
search_two(E, [H | T]) :- search_two(E, T).

% size (List , Size )
% Size will contain the number of elements in List

size([], 0).
size([E | T], R) :- size(T, R1), R is R1 + 1.

% sum(List , Sum )

sum([], 0).
sum([H | T], S) :- sum(T, R), S is R + H. 

% max(List ,Max , Min )
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element

max_min([], TMax, TMin, TMax, TMin).
max_min([H | T], Max, Min) :- max_min(T, Max, Min, H, H).
max_min([H | T], Max, Min, TMax, TMin) :- H > TMax, max_min(T, Max, Min, H, TMin).
max_min([H | T], Max, Min, TMax, TMin) :- H < TMin, max_min(T, Max, Min, TMax, H).
max_min([H | T], Max, Min, TMax, TMin) :- max_min(T, Max, Min, TMax, TMin).

% split (List1 , Elements , SubList1 , SubList2 )
% Splits a list into two sublists based on a given set of elements .
% example : split ([10 ,20 ,30 ,40 ,50] ,2 ,L1 ,L2). -> L1/[10 ,20] L2 /[30 ,40 ,50]

split(L, E, S1, S2) :- split(L, E, S1, S2, []).
split([H | T], N, S1, S2, S1Temp) :- N > 0, N2 is N - 1, split(T, N2, S1, S2, [H | S1Temp]). 
split(T, 0, S1, T, S1Temp) :- reverse(S1, S1Temp).

% rotate (List , RotatedList )
% Rotate a list , namely move the first element to the end of the list .
% example : rotate ([10 ,20 ,30 ,40] , L). -> L /[20 ,30 ,40 ,10]

rotate([H | T], L) :- append(T, [H], L).

% dice (X)
% Generates all possible outcomes of throwing a dice .
% example : dice (X): X /1; X/2; ... X/6

dice(X) :- member(X, [1, 2, 3, 4, 5, 6]).

 % three_dice (5 , L).
% Generates all possible outcomus of throwing three dices
% exmple : three_dice (5 , L). -> L /[1 ,1 ,3]; L /[1 ,2 ,2];...; L/[3 ,1 ,1]

three_dice(N, L) :-     findall([X, Y, Z], 
            (member(X, [1, 2, 3, 4, 5, 6]), 
             member(Y, [1, 2, 3, 4, 5, 6]), 
             member(Z, [1, 2, 3, 4, 5, 6]), 
             X + Y + Z =:= N), 
            L).

% dropAny (? Elem ,? List ,? OutList )

dropAny(X, [X | T], T).
dropAny(X, [H | Xs], [H | L]) :- dropAny(X, Xs, L).



dropFirst(X, [X | T], T) :- !.
dropFirst(X, [H | Xs], [H | L]) :- dropFirst(X, Xs, L).

dropLast(X, L, R) :- reverse(L, R1), dropFirst(X, R1, R2), reverse(R2, R).

 
dropAll(_, [], []).
dropAll(X, L, T) :- dropFirst(X, L, R), dropAll(X, R, T).

% fromList (+ List ,- Graph )

fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).

% fromCircList (+ List ,- Graph )

fromCircList([_], []).
fromCircList([H | T], G) :- append([H | T], [H], R), fromList(R, G). 

% outDegree (+ Graph , +Node , -Deg )
% Deg is the number of edges which start from Node


outDegree([], _, Degree, Degree).
outDegree(Graph, Node, Degree) :- outDegree(Graph, Node, Degree, 0).
outDegree([e(H1, H2) | T], Node, Degree, N) :- H1 =:= Node, N1 is N + 1, outDegree(T, Node, Degree, N1).
outDegree([e(H1, H2) | T], Node, Degree, N) :- H1 \= Node, outDegree(T, Node, Degree, N).

% dropNode (+ Graph , +Node , -OutGraph )

% drop all edges starting and leaving from a Node
% use dropAll defined in 1.1??

dropNode (G ,N , OG ):- dropAll (e(N , _) ,G , G2 ) ,
dropAll (e(_ , N) ,G2 , OG ) .

% reaching (+ Graph , +Node , -List )

% all the nodes that can be reached in 1 step from Node
% possibly use findall , looking for e(Node ,_) combined
% with member (? Elem ,? List )

reaching(G, E1, L) :- findall(E2, (member(e(E1, E2), G)), L).

% nodes (+ Graph , -Nodes )
% craate a list of all nodes (no duplicates ) in the graph ( inverse of fromList )


nodes([], []).
nodes([e(H1, H2) | T], L) :- nodes(T, L), member(H1, L), member(H2, L).
nodes([e(H1, H2) | T], [H2 | L]) :- nodes(T, L), member(H1, L).
nodes([e(H1, H2) | T], [H1 | L]) :- nodes(T, L), member(H2, L).


% anypath(+Graph, +Node1, +Node2, -ListPath)
% Trova tutti i percorsi possibili da Node1 a Node2 nel grafo Graph, restituendo il percorso sotto forma di lista di archi.
anypath(Graph, Node1, Node2, ListPath) :-
    travel(Graph, Node1, Node2, [], ListPath).

% travel(+Graph, +CurrentNode, +Node2, +Acc, -Path)
% Visita ricorsivamente i nodi del grafo e costruisce la lista di archi (e(Node1, Node2)) che costituisce il percorso.
travel(_, Node, Node, Path, ReversePath):- reverse(ReversePath,Path).  % Caso base: siamo arrivati a Node2, il percorso è completo.
travel(Graph, Node1, Node2, Acc, Path) :-
    adjacent(Node1, NodeNext, Graph),          % Trova un arco tra Node1 e NodeNext.
    \+ member(e(Node1, NodeNext), Acc),        % Verifica che l'arco non sia già stato visitato.
    \+ member(e(NodeNext, Node1), Acc),        % Per evitare cicli in grafi non orientati.
    travel(Graph, NodeNext, Node2, [e(Node1, NodeNext)|Acc], Path).  % Continua la ricerca.

% adjacent(+Node1, -Node2, +Graph)
% Verifica se esiste un arco tra Node1 e Node2 nel grafo.
adjacent(Node1, Node2, Graph) :-
    member(e(Node1, Node2), Graph).  % Arco diretto Node1 -> Node2.
