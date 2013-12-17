function [er] = StaticER(elist,Graph,tol,epsilon)
    % function [er] = StaticER(elist,Graph,tol,epsilon)
    % This function output a query function that allow the user to
    % query effective resistances for a given edges (i,j).
    % Input
    %   elist the list of edges to compute the ER.
    %   Graphs is and array data structure in where:
    %       Graph{1} is equal to the edges of the graph a M x 2 matrix.
    %       Graph{2} is the weight of the edges in Graph{1} a M x 1 vector.
    %   [tol] optional input for the solver tolerance
    %   [epsilon] optional input for the sparsification tolerance. Control
    %             the number of rows in the Z system.
    %
    % Output
    %   er the effective resistance for each edge in the elist.
    %
    % Example: The path graph.
    %   Graph{1} = [(1:49)' (2:50)']; Graph{2} = ones(49,1);
    %   elist = [1 50; 2 50];
    %   [ers] = StatticER(elist,Graph);
    %
    if nargin == 4
        [er] = EffectiveResistances(elist,Graph{1},Graph{2},tol,epsilon,'slm');
    elseif nargin == 3
        [er] = EffectiveResistances(elist,Graph{1},Graph{2},tol,1,'slm');
    elseif nargin == 2
        [er] = EffectiveResistances(elist,Graph{1},Graph{2},1e-4,1,'slm');
    end
end