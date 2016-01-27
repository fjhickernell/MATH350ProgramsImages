function [x,n]=bisection(f,a,b,tol)
% x=BISECTION(f,a,b,tol) finds the roots of the nonlinear equation
%   f(x) = 0 via the bisection method
n=0; %number of iterations;
sfa=sign(f(a)); %evaluate signs of the values of the function 
sfb=sign(f(b)); %at the endpoints of the interval
if sfa==0; x=a; return %a is a root
elseif sfb==0; x=b; return %b is a root
end
if sfa*sfb == 1; %not sure of a root inside
   error('Function must have different signs at interval endpoints')
end
if nargin<4; tol=2*eps; end %set relative error tolerance
tol=max(2*eps,tol); %relative error tolerance cannot be too small
while abs(b-a) > tol*min(abs(a),abs(b)) %tolerance not satisfied
   x=(a+b)/2; %bisect the interval
   if f(x)==0; break; end %found a root
   if sign(f(x))==sfb; b=x; %root between a and x 
   else a=x; %root between x and b 
   end
   n=n+1; %increment iteration counter
end

