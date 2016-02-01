function [x,n]=secant(f,a,b,tol)
% x=SECANT(f,a,b,tol) finds the roots of the nonlinear equation
%   f(x) = 0 via the secant method.  The points a and b are the starting
%   points of the secant method.  The answer x is expected to be have a
%   relative error of no more than tol.  The number of iterations needed is
%   n.
n=0; %number of iterations;
if nargin<4; tol=2*eps; end %set relative error tolerance
tol=max(2*eps,tol); %relative error tolerance cannot be too small
fa=f(a); %evaluate function value
if fa==0; x=a; return; end %check if a is a root
while abs(b-a) > tol*abs(b) %tolerance not satisfied
   fb=f(b);
   if fb==0, x=b; break; end %check if b is a root
   if fa==fb %cannot iterate any more
      x=b; warning('f(a)=f(b) so cannot iterate further'), break
   end 
   x=b+(b-a)/(fa/fb-1); %next iterate
   a=b; %new a
   fa=fb; %new fa
   b=x; %new b
   n=n+1; %increment iteration counter
   if n>1000, warning('Not converging'); return, end
end
