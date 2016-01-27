function [x,n]=Newton(f,fprime,x,tol)
% x=NEWTON(f,fprime,x,tol) finds the roots of the nonlinear equation
%   f(x) = 0 via Newton's method
n=0; %number of iterations;
if nargin<4; tol=2*eps; end %set relative error tolerance
tol=max(2*eps,tol); %relative error tolerance cannot be too small
xprev=Inf; %don't stop yet
while abs(x - xprev) > tol*abs(x) %tolerance not satisfied
   fx=f(x);
   fpx=fprime(x);
   if fx==0, break, end %x is a root
   if fpx==0 %cannot iterate any more
      warning('f''(x) so cannot iterate further'), break
   end 
   xprev=x; %save old iterate
   x=x-fx/fpx; %next iterate
   n=n+1; %increment iteration counter
   if n>1000, warning('Newton''s method not converging'); return, end
end