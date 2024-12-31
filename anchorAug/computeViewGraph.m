function G = computeViewGraph(Z)

nv=length(Z);
D = zeros(nv,nv);
G = zeros(nv,nv);

for i = 1:nv
    for j = 1:nv
        D(i,j) = ws_distance(Z{i}, Z{j}, 2);
        if D(i,j) ~=0
            G(i,j) = 1/D(i,j);
        end
    end
    for j = 1:nv
        if G(i,j) ~=0
            G(i,j) = G(i,j)/norm(G(i,:),1);
        end
    end
end


