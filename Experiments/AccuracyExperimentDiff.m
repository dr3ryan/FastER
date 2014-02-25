% FastER accuracy experiment
numTrials = 5;
%% Loading libraries
	addpath(genpath('../'));
	addpath(genpath('../../../svnrepo/matlablibs/'));
%% Loading graph
gpath = '../DataSets/ca-GrQc.txt';
gdata = importdata(gpath);
try 
	G{1} = gdata.data;
catch
	G{1} = gdata;
end
mn = min(min(G{1}));
if mn < 1
	G{1} = G{1} + (abs(mn) + 1);
end
G{2} = ones(1,length(G{1}));

%{
exact_er = ExactER(G{1},G,1e-8,0.1);
for i=1:numTrials
	static_er(i,:) = abs(exact_er - StaticER(G{1},G,1e-8,0.1));
	queryFun = QueryER(G,1e-8,0.1);
	query_er(i,:) = abs(exact_er - queryFun(G{1}(:,1),G{1}(:,2)));
end

static_er_mean = mean(static_er,1);
static_er_std = std(static_er,1);

query_er_mean = mean(query_er,1);
query_er_std = std(query_er,1);

results = [static_er_mean;
	static_er_std;
	query_er_mean;
	query_er_std];
fid = fopen('AccuracyResutls10diff.txt','w');
fprintf(fid,'%e %e %e %e\n',results(:));
fclose(fid);
%}

exact_er = ExactER(G{1},G,1e-8,0.01);
for i=1:numTrials
	static_er(i,:) = abs(exact_er - StaticER(G{1},G,1e-8,0.01));
	queryFun = QueryER(G,1e-8,0.01);
	query_er(i,:) = abs(exact_er - queryFun(G{1}(:,1),G{1}(:,2)));
end

static_er_mean = mean(static_er,1);
static_er_std = std(static_er,1);

query_er_mean = mean(query_er,1);
query_er_std = std(query_er,1);

results = [static_er_mean;
	static_er_std;
	query_er_mean;
	query_er_std];
fid = fopen('AccuracyResutls100diff.txt','w');
fprintf(fid,'%e %e %e %e\n',results(:));
fclose(fid);
