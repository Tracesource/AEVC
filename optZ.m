function [U,Z] = optZ(X,y,A,gamma,ZAlign,alpha)

nv=length(X);
num=size(X{1},2);
m=size(A{1},2);
k=length(unique(y));

options = optimset( 'Algorithm','interior-point-convex','Display','off');
H=2*alpha*eye(m);
B=2*alpha*ZAlign';
for j=1:nv
    H=H+2*gamma(j)*A{j}'*A{j};
    B=B+2*gamma(j)*X{j}'*A{j};
end
H=(H+H')/2;
parfor ji=1:num
    ff=-B(ji,:)';
    Z(:,ji)=quadprog(H,ff',[],[],ones(1,m),1,zeros(m,1),ones(m,1),[],options);
end
[U,~,~] = mySVD(Z',k);