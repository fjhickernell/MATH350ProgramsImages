%% The Guaranteed Automatic Integrtion Library
% This library, developed by a number of faculty and students associated
% with Illinois Tech, contains algorithms that have guaranteed stopping
% criteria for meeting error tolerances.

%% The algorithm |integ_g|
% This is an adaptive trapezoidal rule algorithm.  First we try it for a
% problem whose answer is known in analytic form:

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
format long e
tic
integ = integral_g(@cos,0,1,1e-12) %tolerance = 1e-12
exactinteg = sin(1) %true integral
err = exactinteg-integ %actual error is smaller than tolerance

%%
% Next we try it for an integral whose answer is not known in closed form:

integ = integral_g(@(x) (1/sqrt(2*pi))*exp((-x.^2)/2),-1.96,1.96,1e-10) ...
%Gaussian probability, tolerance = 1e-10
indef = @(x) erf(x/sqrt(2))/2; %indefinite integral
exactinteg = indef(1.96) - indef(-1.96) %exact integral
err = exactinteg-integ %actual error is smaller than tolerance

%%
% _Author:  Fred J. Hickernell_
