function [xp,Xh,resid] = linearEquations(A,b)
% This function finds all solutions to Ax = b, if they exist, and finds the
% smallest solution in the least squares sense if an exact solution does
% not exist.  The final solution is
%
% xp + Xh*a  for arbitrary a
%
% where Xh denotes a matrix with linearly independent columns such that
% A*Xh = 0.  Moreover, resid denotes the Euclidean norm of Ax-b

if nargin < 1
   A = eye(2); %default A
   if nargin < 2
      b = zeros(size(A,1),1); %default b
   end
end
if size(A,1) ~= size(b,1) %A and b are incompatible
   error('Matrix and vector inputs are incompatible')
end
[m,n] = size(A); %find the number of rows and columns of A
[U,S,V] = svd(A); %find the SVD decomposition
c = U'*b; %new right hand side
Sdiag = diag(S); %diagonal elements of the S matrix
p = find(diag(S) > 10*eps,1,'last'); %number of nonzero singular values
y = Sdiag(1:p).\c(1:p); %preliminary solution
xp = V(:,1:p)*y(1:p); %a particular exact or approximate solution
Xh = []; %initialize solution of the Ax=0
resid = 0; %initialize residual
if p < n %many solutions exist
   Xh = V(:,p+1:n); %matrix whose columns are linear independent solutions of Ax = 0     
end
if p < m %solution may not be exact
   resid = norm(c(p+1:m));
end
if p < min(m,n)
   warning('Matrix is not of full rank.')
end