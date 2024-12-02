function indx_0 = genarateNeighborhood(KC,tau)

num = size(KC,1);
%KC0 = KC - 10^8*eye(num);
[val,indx] = sort(KC,'descend'); %按照降序排列，index的每一列由上到下标识KC0中每一行由大到小值的序号
indx_0 = indx(1:tau,:);