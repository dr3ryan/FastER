function [queryFun] = QueryERpar(Graph,tol,epsilon)
    % function [queryFun] = QueryER(Graph,tol,epsilon)
    % This function output a query function that allow the user to
    % query effective resistances for a given edges (i,j).
    % Input
    %   Graphs is and array data structure in where:
    %       Graph{1} is equal to the edges of the graph a M x 2 matrix.
    %       Graph{2} is the weight of the edges in Graph{1} a M x 1 vector.
    %   [tol] optional input for the solver tolerance
    %   [epsilon] optional input for the sparsification tolerance. Control
    %             the number of rows in the Z system.
    %
    % Output
    %   queryFun the query function to compute the ER of a given edge.
    %      The queryFun inputs are the:
    %        i the edge head
    %        j the edge tail
    %      The queryFun output is
    %        er the effective resistance for the edge (i,j);
    %      The queryFun call: er = QueryER(i,j)
    %
    % Example: The path graph.
    %   Graph{1} = [(1:49)' (2:50)']; Graph{2} = ones(49,1);
    %   [queryFun] = QueryER(Graph);
    %   ers = queryFun(1,2);
    %

    if nargin == 3
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},tol,epsilon,'spl');
    elseif nargin == 2
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},tol,1,'spl');
    elseif nargin == 1
        [~,Z] = EffectiveResistancesPar([1,1],Graph{1},Graph{2},1e-4,1,'spl');
    end
    queryFun = @(i,j) sum(((Z(:,i) - Z(:,j)).^2),1)';
end