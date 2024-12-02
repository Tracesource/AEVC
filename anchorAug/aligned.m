function [S,T] = aligned(Z,ZAlign,c)
numview = length(Z);
for nv = 1:numview
    K = ZAlign*Z{nv}';  %%% һ�����ƶ�
    S1 = ZAlign* ZAlign';
    S2 = Z{nv}* Z{nv}';
    T{nv} = DSPFP(S1,S2,K,c);
    S{nv} = T{nv}*Z{nv};
end