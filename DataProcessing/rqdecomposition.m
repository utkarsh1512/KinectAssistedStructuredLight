% rqdecomposition - returns the RQ decomposition of a matrix (M)
function [R,Q] = rqdecomposition(M) 
[Q,R] = qr(rot90(M,3)); 
R = rot90(R,2)'; 
Q = rot90(Q);