%% Row Operations Example
% This script works out some of the examples in the lecture notes.  The
% intent is to show how row operations lead to the LU decomposition, which
% is used to solve systems of linear equations.

%% Solving \(\mathsf{A}\boldsymbol{x} = \boldsymbol{b}\) Using Row Operations

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
A = [3 -1 4
   0 2 1
   -6 5 2] %our original matrix
b = [13
   7
   10] %our original right hand vector

%%
% This first part is called _forward elimination_.  The goal is to use row
% operations to obtain a new set of linear equations where the matrix has
% all zeros under the diagonal.  First eliminate in the first column, rows 2
% and 3:

M1 = [1 0 0; -A(2,1)/A(1,1) 1 0; -A(3,1)/A(1,1) 0 1]
A1 = M1 * A %add multiples of row one to rows two and three
b1 = M1 * b %add multiples of row one to rows two and three

%%
% Next eliminate in the second column, row 3:

M2 = [1 0 0; 0 1 0; 0 -A1(3,2)/A1(2,2) 1]
A2 = M2 * A1 %add a multiple of row two to row three
b2 = M2 * b1 %add a multiple of row two to row three

%%
% Give new names to our final A and b.  We have new equations with the same
% solution as the original.

U = A2 %an upper triangular matrix = M2*M1*A
c = b2 %the final right side = M2*M1*b

%%
% Now we solve \(\mathsf{U} \boldsymbol{x} = \boldsymbol{c}\) for
% \(\boldsymbol{x}\) using _backward substitution_.  This is easy because
% \(\mathsf{U}\) is upper triangular. We solve for \(x_3\), then \(x_2\),
% then \(x_1\).

x(3,1) = c(3)/U(3,3); %make sure that x is a column vector
x(2) = (c(2) - U(2,3)*x(3))/U(2,2);
x(1) = (c(1) - U(1,2)*x(2) - U(1,3)*x(3))/U(1,1)

%%
% Note that U = M2*M1*A, so A = L * U, where L = (M2*M1)^-1

Linv = M2 * M1 %inverse of L
L = inv(Linv) %don't use inv if you can help it, but we can't help it here
shouldBeA = L * U %should equal A, which it does
   
%% Now Using Partial Pivoting (Switching Rows)
% Now we re-do this process, but switch rows when needed. For the first
% column, we find the row i for which abs(A(i,1)) is largest and choose
% that as the new first row.

[~,i] = max(abs(A(:,1)))
P1 = eye(3); %initialize the permutation matrix
temp = P1(1,:); P1(1,:) = P1(i,:); P1(i,:) = temp %switch rows 1 and i
A11 = P1 * A %switch rows of A
b11 = P1 * b %switch rows of b


%%
% Now eliminate elements in column 1

M1 = [1 0 0; -A11(2,1)/A11(1,1) 1 0; -A11(3,1)/A11(1,1) 0 1]
A1 = M1 * A11 %add multiples of row one to rows two and three
b1 = M1 * b11 %add multiples of row one to rows two and three

%%
% Again switch rows when needed

[~,i] = max(abs(A1(2:3,2)))
P2 = eye(3); %initialize the permutation matrix
temp = P2(2,:); P2(2,:) = P2(i+1,:); P2(i+1,:) = temp %switch rows 2 and i
A21 = P2 * A1 %switch rows of A
b21 = P2 * b1 %switch rows of b

%%
% Again, eliminate in column 2

M2 = [1 0 0; 0 1 0; 0 -A21(3,2)/A21(2,2) 1]
A2 = M2 * A21 %add a multiple of row two to row three
b2 = M2 * b21 %add a multiple of row two to row three
U = A2 %an upper triangular matrix
c = b2 %the final right side

%%
% Now we solve for the elements of \(\boldsymbol{x}\) using _backward
% substitution_.  We solve for \(x_3\), then \(x_2\), then \(x_1\).

x(3,1) = c(3)/U(3,3);
x(2) = (c(2) - U(2,3)*x(3))/U(2,2);
x(1) = (c(1) - U(1,2)*x(2) - U(1,3)*x(3))/U(1,1)

%% 
% Since we had permutation matrices, the LU decomposition is a bit more
% complicated.  Note that each permutation matrix is the inverse of itself.
% Since U = M2*P2*M1*P1*A = M2*P2*M1*P2*P2*P1*A, we may identify

Linv = M2 * P2 * M1 * P2 %inverse of L
L = inv(Linv) %compute L
P = P2 * P1 %permutation matrix P
PA = P * A % a re-ordering of the rows of A
shouldBePA = L * U %should equal P*A

%%
% MATLAB has an LU factorization algorithm.  We see that what we computed
% is what they compute:

[theirL,theirU,theirP] = lu(A)


%%
% If you wish, you can try another 3 x 3 A and/or 3 x 1 b, and the program
% should still work.  For example, change A(2,2) to 1, and see how the
% switching of rows changes.
% 
% _Author: Fred J. Hickernell_