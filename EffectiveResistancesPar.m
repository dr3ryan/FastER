function [eff_res,Z] = EffectiveResistancesPar(elist,e,w,tol,epsilon,type_,pfun_)
% Function [eff_res,Z] = EffectiveResistances(e,w,tol,epsilon,type_,pfun_)
% calculate the effective resistance (ER) in a given graph, the graph
% is view as an electrical network in where the weight of the edges
% in the graph are the capacitances.
%
%
% Input:
%   elist: list of the effective resistance to compute (edges) [K x 2]
%   e: edges of the graph [M x 2]
%   w: weights in the graph [M x 1]
%   [tol]: optional string, specify the tolerance of the solver.
%            1e-4 <default>
%   [epsilon]: optional string, control the number of systems that solve
%            1 <default>
%   [type_]: optional string
%           'slm' <default>: this version use less memory.
%           'spl': this is the exact version of the Spielman Sirvastava
%                  2008 paper.
%
%           'org': find the exact effective resistances.
%   [pfun_]: cmg_sdd(L), if already computed.
%
% Output:
%   eff_res: the effective resistance between v and u
%   Z: the [s x N] system described in Spielman Sirvastava 2008.
%       Available only with the 'spl' version.
%
% User Recomendations:
%   1) Use 'slm' version when the elist is know and there are no
%      more ER to compute.
%   2) Use 'slm' version when the graph is bigger relative to the
%      amount of memory in the machine (RAM).
%   3) Use 'spl' versioin when the elist is not know a future ER
%      computations are needed. For progressive ER computations.
%      See Example 2.
%   4) Using the 'spl' version in machines with small amount of RAM
%      may hang the system due to RAM demand.
%
% Example 1: The path graph.
%   E = [(1:49)' (2:50)']; w = ones(length(E),1); elist = [1 50];
%   [er] = EffectiveResistances(elist,E,w,1e-5,1,'org')
%
% Example 2: The path graph alternative version.
%   E = [(1:49)' (2:50)']; w = ones(length(E),1); elist = [1 50];
%   [er,Z] = EffectiveResistances(elist,E,w,1e-5,1,'spl');
%   % Compute other ER.
%   o_elist = [2 49;3 48];
%   o_er = sum(((Z(:,o_elist(:,1))-Z(:,o_elist(:,2))).^2),1)';
%
% Richard Garcia-Lebron
%
    %% input Validation
    [m,two] = size(e);
    [~,two1] = size(elist);
    % Check input
    if nargin > 7
        error('Too many arguments, see help EffectiveResistancesJL.');
    elseif nargin < 3
        error('More arguments needed, see help EffectiveResistancesJL.');
    elseif nargin == 5
        type_ = 'slm';
    elseif nargin == 4
        type_ = 'slm';
        tol = 10^-4; %tolerance for the cmg solver
        epsilon = 1;
    elseif nargin == 3
        type_ = 'slm';
        tol = 10^-4; %tolerance for the cmg solver
        epsilon = 1;
    elseif two ~= 2 ||  two1 ~= 2
        estring = ['The first or the second input have wrong' ...
                    ' column dimension should be [M  x 2].'];
        error(estring);
    end
    % Check output
    if nargout > 2 || nargout < 1
        error('Wrong number of outputs: see help EffectiveResistances.');
    elseif nargout == 2 && strcmp(type_,'slm')
        error('Second output not available with this version: see help EffectiveResistances.');
    elseif nargout == 2 && strcmp(type_,'org')
        error('Second output not available with this version: see help EffectiveResistances.');
    end

    %% Creating data for effective resitances
    numIterations = 300; %iteration for the cmg solver
    tolProb = 0.5;%use to create the johnson lindestraus projection matrix
    n = max(max(e));%number of node in the graph
    A = sparse([e(:,1);e(:,2)],[e(:,2);e(:,1)],[w;w],n,n); %adjacency matrix
    L = diag(sum(abs(A),2)) - A; %laplacian matrix
    clear 'A' %adjacensy matrix no needed
    B = sparse([1:m 1:m],[e(:,1) e(:,2)],[ones(m,1) -1*ones(m,1)]);
    [m,n] = size(B);
    W = sparse(1:length(w),1:length(w),w.^(1/2),length(w),length(w));
    scale = ceil(log2(n))/epsilon;
    %% Finding the effective resitances
    if strcmp(type_,'slm')
        if nargin == 7 % Creating the preconditioned function
            pfun = pfun_;
        elseif (length(L) > 600)
            pfun = cmg_sdd(L);
        end
        [rows,~,~] = size(elist);
        eff_res = zeros(1,rows);
        eff_res1 = cell(1,rows);
        optimset('display','off');
        if (length(L) > 600) % bigger graphs
            parfor j=1:scale
                ons = (rand(1,m) > tolProb);
                ons = ons - not(ons);
                ons = ons./sqrt(scale);
                [Z flag]= pcg(L,(ons*(W)*B)',tol,numIterations,pfun);
                if flag > 0
                    error(['PCG FLAG: ' num2str(flag)])
                end
                Z = Z';
                eff_res(j,:) = (abs((Z(elist(:,1))-Z(elist(:,2)))).^2);
            end
            eff_res = sum(eff_res,1);
            Z = NaN;
        else % smaller graphs
            for j=1:scale
                ons = (rand(1,m) > tolProb);
                ons = ons - not(ons);
                ons = ons./sqrt(scale);
                [Z flag]= pcg(L,(ons*(W)*B)',tol,numIterations);
                if flag > 0
                    error(['PCG FLAG: ' num2str(flag)])
                end
                Z = Z';
                eff_res = eff_res + (abs((Z(elist(:,1))-Z(elist(:,2)))).^2); % the second "loop"
            end
        end
        eff_res = eff_res';
    elseif strcmp(type_,'spl')
        Q = sparse((rand(scale,m)) > tolProb);
        Q = Q - not(Q);
        Q = Q./sqrt(scale);
        SYS = sparse(Q*(W)*B); % Creation the system
        if nargin == 7 % Creating the preconditioned function
            pfun = pfun_;
        elseif (length(L) > 600)
            pfun = cmg_sdd(L);
        end
        optimset('display','off');
        %% Solving the systems
        if (length(L) > 600) % bigger graphs
            parfor j=1:scale
                [Z(j,:) flag] = pcg(L,SYS(j,:)',tol,numIterations,pfun);
                if flag > 0
                    error(['PCG FLAG: ' num2str(flag)])
                end
            end
        else % smaller graphs
            for j=1:scale
                [Z(j,:) flag] = pcg(L,SYS(j,:)',tol,numIterations);
                if flag > 0
                    error(['PCG FLAG: ' num2str(flag)])
                end
            end
        end
        eff_res = sum(((Z(:,elist(:,1))-Z(:,elist(:,2))).^2),1)';

    elseif strcmp(type_,'org')
        [m,~] = size(elist);
        B = sparse([1:m 1:m],[elist(:,1) elist(:,2)],[ones(m,1) -1*ones(m,1)],m,length(L));
            if length(L) > 600 % bigger graphs
                if nargin == 7
                    pfun = pfun_;
                else
                    pfun = cmg_sdd(L);
                end
                optimset('display','off');
                for j=1:m
                    [Z flag]= pcg(L,B(j,:)',1e-10,numIterations,pfun);
                    if flag > 0
                        error(['PCG FLAG: ' num2str(flag)])
                    end
                    eff_res(j) = B(j,:)*Z;
                end
            else % smaller graphs
                opts.type = 'nofill'; opts.michol = 'on';
                for j=1:m
                    [Z,flag] = pcg(L,B(j,:)',1e-10,numIterations);
                    eff_res(j) = B(j,:)*Z;
                end
            end
        eff_res = eff_res';
    end
end

