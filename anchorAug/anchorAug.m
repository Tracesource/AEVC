function [AMix,AIni,gamma,ZAlign,ZIni] = anchorAug(X,k,m,pp,theta)

XI = X;
nv=length(X);

%% Initialize the anchor matrix A, anchor graph Z and their unified
%% version with the concatenation matrix.
XX = [];
for i=1:nv
    rand('twister',12);
    XX = [XX;XI{i}];
    [~, AIni{i}] = litekmeans(XI{i}',m,'MaxIter', 100,'Replicates',10);
    AIni{i} = mapstd(AIni{i}',0,1);
    ZIni{i} = computeIniGraph(XI{i},AIni{i});
end
[~, AAlign] = litekmeans(XX',m,'MaxIter', 100,'Replicates',10);
AAlign = mapstd(AAlign',0,1);
ZAlign = computeIniGraph(XX,AAlign);

%% Performing the alignment algorithm on each graph and anchor matrix.
[ZIni,T] = aligned(ZIni,ZAlign,pp);
for i=1:nv
    AIni{i} = AIni{i}*T{i};
end

%% Calculate the view-graph.
GView = computeViewGraph(ZIni);
NNRate = ceil(nv/3);
GNeighbor = genarateNeighborhood(GView, NNRate);

%% Mixup the anchor matrix.
GViewN = zeros(nv,NNRate);
gamma = zeros(nv,1);
for i = 1:nv
    gamma(i) = sum(GView(:,i))-GView(i,i);
    for jj = 1:NNRate
        GViewN(i,jj) = GView(i,GNeighbor(jj,i));
    end
    for jj = 1:NNRate
        GViewN(i,:) = GViewN(i,:)/norm(GViewN(i,:),1);
    end
end
AMix=AIni;
AMixR=AIni;
gamma = gamma/sum(gamma);

mixIter = 1;

for iter = 1:mixIter
    for jj = 1:nv
        for l = 1:NNRate
            ANew=XI{jj}*ZIni{GNeighbor(l,jj)}';
            ANew = mapstd(ANew,0,1);
            AMix{jj} = AMix{jj}+theta*GViewN(jj,l)*ANew;
        end
        AMix{jj} = mapstd(AMix{jj},0,1);
    end
    AMixR=AMix;
end
