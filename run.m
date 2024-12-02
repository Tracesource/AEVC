clear;

addpath(genpath('./'));
dsPath = '.\datasets\';
dataname='Dermatology';
disp(dataname);

%load data
load(strcat(dsPath,dataname));
y=Y;
nv=length(X);
k=length(unique(y));

%normalization
for i=1:nv
    X{i} = mapstd(X{i}',0,1);
end

% Parameter 1: number of anchors (tunable)
m=2*k;

% Parameter 2: alignPara (tunable)
alignPara=10000;

% Parameter 3: theta (tunable)
gamma=100;

% Parameter 4: alpha (tunable)
lambda=100;

%%%Anchor augmention.
[AMix,AIni,omega,ZAlign,ZIni] = anchorAug(X,k,m,alignPara,gamma);

%%%Optimization.
[F,Z] = optZ(X,y,AMix,omega,ZAlign,lambda);
[resmean,resstd] = myNMIACCwithmean(F,y,k);
fprintf('Anchor:%d \t AlignNumber:%d\t Gamma:%d\t Lambda:%d\t Res:%12.6f %12.6f %12.6f %12.6f',[m alignPara gamma lambda resmean(1) resmean(2) resmean(3) resmean(4)]);