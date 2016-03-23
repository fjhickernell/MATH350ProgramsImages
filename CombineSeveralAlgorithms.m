%% Combining Various Numerical Algorithms
% In most of the MATLAB demo scripts that we have worked with, just one
% numerical algorithm was used.  In some problems we may wish to use
% multiple algorithms.

%% Finding the Amplitude that Yields a Certain Pendulum Period
% Consider the period of a simple pendulum again:
%
% \[ T(\theta_{\max}) = \frac{4}{\omega\sqrt{1 - E}}\Bigg[ \frac{\pi}{2} -
% \int_{0}^{1} \frac{E \sqrt{1-y^2}} {\sqrt{1 - E y^2} \bigl\{\sqrt{1 - E}
% + \sqrt{1 - E y^2} \bigr\} } \, \textrm{d} y \Bigg], \qquad 
% \text{where }E = \sin^2(\theta_{\max}/2). \]
%
% Suppose that we want to find the inverse function of \(T\), i.e., the
% function \(\Theta\) such that \(\Theta(T(\theta_{\max})) =
% \theta_{\max}\).  How do we do that?
%
% First we construct a function \(T\) numerically

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
g = 980; %gravitational constant in grams cm sec^-2
l = 80; %length of the pendulum in cm
omega = sqrt(g/l); %angular frequency, inverse time
Tsmall = 2*pi/omega %small amplitude approximation
integrand = @(y,E) -E*sqrt(1-y.*y)./(sqrt(1-E.*y.*y).*...
   (sqrt(1-E.*y.*y)+sqrt(1-E))); %new integrand without singularity
period = @(E) (4/(omega*sqrt(1-E)))*(integral(@(y) integrand(y,E),0,1)+pi/2); 
T = @(theta) period(sin(theta/2).^2); %function to compute the period of a pendulum
Tpi2 = T(pi/2)