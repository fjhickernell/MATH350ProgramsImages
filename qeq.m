function x=qeq(a,b,c)
% x=QEQ(a,b,c) finds the roots of the quadratic equation
%   a x^2 + b x + c = 0

%% Scale the inputs to avoid overflow or underflow
a=a(:); b=b(:); c=c(:); %make a, b, and c column vectors
scale=max(abs([a b c]),[],2); %the largest coefficient in each row
a1=a./scale; %scale coefficients to avoid overflow or underflow below
b1=b./scale;
c1=c./scale;

%% Compute the roots
sb1=-1+2*(b1>=0); %sign of b1, MATLAB's sign doesn't work for b1=0
term=-b1 - sb1.*sqrt(b1.^2-4*a1.*c1); %no cancellation error here
x=[(2*c1)./term term./(2*a1)]; %two roots
x=sort(x,2); %put smallest first
