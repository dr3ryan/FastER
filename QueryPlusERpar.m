function [queryFun,Z]=QueryPlusERpar(Graph,tol,epsilon)
    % function [queryFun,Z]=QueryPlusER(Graph,tol,epsilon)
    % This function output the Z linear system and a query function that
    % allow the user to query effective resistances for a given list of edges.
    % Input
    %   Graphs is and array data structure in where:
    %       Graph{1} is equal to the edges of the graph a M x 2 matrix.
    %       Graph{2} is the weight of the edges in Graph{1} a M x 1 vector.
    %   [tol] optional input for the solver tolerance
    %   [epsilon] optional input for the sparsification tolerance. Control
    %             the number of rows in the Z system
    % Output
    %   queryFun the query function to compute the ER of a given list of edge.
    %      The queryFun inputs are the:
    %        Z linear system
    %        elist the list of edges the user want to compute its ER
    %      The queryFun output is the:
    %        er the ER for each edge in elist.
    %      The queryFun call: er = queryFun(Z,elist);
    %   Z the linear system for querying the ERs
    %
    % Example: The path graph.
    %   Graph{1} = [(1:49)' (2:50)']; Graph{2} = ones(49,1);
    %   [queryFun,Z] = QueryPlusER(Graph);
    %   elist = [1 50; 2 50];
    %   ers = queryFun(Z,elist);
    %
    if nargin == 3
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},tol,epsilon,'spl');
    elseif nargin == 2
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},tol,1,'spl');
    elseif nargin == 1
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},1e-4,1,'spl');
    end
    queryFun = @(Z_,elist) sum(((Z_(:,elist(:,1))- ...
                                Z_(:,elist(:,2))).^2),1)';
end