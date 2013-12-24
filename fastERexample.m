%
% Example of computing the effective resistances 
%
% %
% Getting and preparing the graph structures
%
fileName = gunzip('http://snap.stanford.edu/data/facebook_combined.txt.gz'); % unzip the data file 
Edges = load('fileName{1}'); % load the data file edges i -> j; start in 0
Graph{1} = Edges + 1; % adjust the node ids to start from 1
Graph{2} = ones(length(Edges),1); % set graph edges weights to 1
n = max(max(Graph{1}));
% %
% Example of computing fast er; static version 
%
elist = Graph{1}; % list of pair of node
[ers] = StatticER(elist,Graph); % compute the ER of the given pair of nodes
% %
% Example of computing fast er; query version. Choosing a random pair of node.
%
[queryFun] = QueryER(Graph); % produce function for computing the ER
head = randi(n,1); tail = randi(n,1); % random pair of nodes
ers_rnd = queryFun(head,tail); % compute the ER of the random pair of nodes
% %
% Example of computing fast er; query plus version. Choosing random pair of node.
%
[queryFun,Z] = QueryPlusER(Graph); % produce the function and access to the system.
rnd_nodes = randi(n,5,2); % generating various pair of nodes
ers = queryFun(Z,rnd_nodes); % computing the ER of all the pair of nodes
