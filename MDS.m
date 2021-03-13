function Z = MDS(D, d)
%% Multiple Dimensional Scailing Method 
% Suppose there exists n samples in m-dim, try to reduce dimension
% D: distence matric 
% d: dimension
% Z: new sample \in R^(d*n)
[n1, n2] = size(D);
if n1~=n2
    disp('D is not a square matrix');
else 
    n = n1;
    e = ones(n,1);
    H = eye(n) - 1 / n * (e *e');
    D2 = D .* D;
    B =-1/2 * H'* D2* H;
    [eigenvector, eigenvalue] = eig(B);
    eigenvalue = diag(eigenvalue);
    [~, pos] = sort(eigenvalue,'descend');
    index = pos(1:d);
    eigenvector = eigenvector(:, index);
    Z = diag(eigenvalue(index))^(0.5) * eigenvector';
end
