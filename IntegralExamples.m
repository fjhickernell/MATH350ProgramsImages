%% MATLAB's Premier Quadrature Routine, |integral|
% While the rectangle, trapezoidal, and Simpson's rule are rather easy to
% understand, MATLAB's best routine for approximating integrals,
%
% \[ \int_a^b f(x) \, \textrm{d} x \]
% 
% is based on high order Gaussian quadrature rules and is called |integral|

%% Easy Examples
% The syntax for integral is to provide the integrand and the left and right
% endpoints of the integral.  The default error tolerance is something
% close to machine precision.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
format long e
integ = integral(@cos,0,1) %integrate cosine between 0 and 1
sin(1) %this should be the answer, and it is

%%
% This next example computes the normal probability
%
% \[ \int_{-1.96}^{1.96} \frac{\mathrm{e}^{-x^2/2}}{\sqrt{2 \pi}}  \,
% \textrm{d} x. \]
%
% The value of this integral should be close to 95%.

Gausspdf = @(x) (1/sqrt(2*pi))*exp((-x.^2)/2)
figure
plot(-2:0.002:2,Gausspdf(-2:0.002:2)) %plot the integrand
integ = integral(Gausspdf,-1.96,1.96) %approximate answer
Gausscdf = @(x) erf(x/sqrt(2))/2;  %the antiderivative
Gausscdf(1.96) - Gausscdf(-1.96) %true answer

%% 
% Now we try a very oscillatory example.

a = 1000; 
f = @(x)1+cos(a*x)
figure
plot(-2:0.002:2,f(-2:0.002:2)) %plot the integrand
integ = integral(f,0,1) 
1+sin(a)/a %this should be the answer, and it is
integ=integral(@(x)1+cos(a*x),0,1,'abstol',2e-3) %don't need much absolute accuracy
integ=integral(@(x)1+cos(a*x),0,1,'reltol',2e-3) %don't need much relative accuracy

%%
% Note that the error is a bit more than the tolerance.

%% Harder Examples
% Now we consider one spiky function
%
% \[ f(x) = \frac{\alpha \exp(-(\alpha(x-\beta))^2)}{\sqrt{2\pi}} , \]
%
% where \(1/\alpha\) is the half-width of the spike.

alpha = 10; beta = 1/pi; 
f=@(x) (alpha/sqrt(2*pi))*exp((-(alpha*(x-beta)).^2)/2); 
figure
plot(-1:0.001:1,f(-1:0.001:1)) %plot the integrand
integ = integral(f,0,1) %approximate integral
indef = @(x) erf(alpha*(x-beta)/sqrt(2))/2; %indefinite integral
indef(1) - indef(0) %exact answer

%%
% For a spike that is not too narrow, there is no problem, but for a very
% narrow spike the approximate answer given by |integral| is totally wrong.

alpha = 1e4; %a very narrow spike
f = @(x) (alpha/sqrt(2*pi))*exp((-(alpha*(x-beta)).^2)/2);
figure
plot(0.3:0.00002:0.35,f(0.3:0.00002:0.35)) %plot the integrand
integ = integral(f,0,1) %approximate integral
indef = @(x) erf(alpha*(x-beta)/sqrt(2))/2; %indefinite integral
indef(1) - indef(0) %exact answer
toc

%%
% _Author: Fred J. Hickernell_
