%% Period of the Simple Pendulum
% After some analytic manipulation, one can write the period of the simple
% pendulum as the integral
%
% \[ T(\theta_{\max})  = \frac{4}{\omega} \int_{0}^{1} \frac{1}{\sqrt{[1 -
% y^2][1 - \sin^2(\theta_{\max}/2)y^2]}} \, \textrm{d} y,\]
%
% where \(\theta_{\max}\) is the amplitude of the pendulum.  This integral
% cannot be evaluated analytically.  Here we show how to compute the
% period of the pendulum by numerical methods.

%% Naive Way
% First we start by computing the integral directly using |integral|.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
g = 980; %gravitational constant in grams cm sec^-2
l = 80; %length of the pendulum in cm
omega = sqrt(g/l); %angular frequency, inverse time
Tsmall = 2*pi/omega %small amplitude approximation
amplitude = pi/2; %amplitude of pendulum
E = sin(amplitude/2).^2; %scaled energy
integrand = @(y) (4/omega)./sqrt((1-y.*y).*(1-E.*y.*y));
T = integral(integrand,0,1) %pendulum amplitude

%%
% Notice that the period of the pendulum is signicantly longer than the
% small amplitude approximation.

%% Removing the Singularity at \(y = 1\)
% In the original integral for the period, the integrand has a singularity
% at \( y = 1\).  A change of variables can remove this singularity so that
% we get
%
% \[ T(\theta_{\max}) = \frac{4}{\omega\sqrt{1 - E}}\Bigg[ \frac{\pi}{2} -
% \int_{0}^{1} \frac{E \sqrt{1-y^2}} {\sqrt{1 - E y^2} \bigl\{\sqrt{1 - E}
% + \sqrt{1 - E y^2} \bigr\} } \, \textrm{d} y \Bigg]. \]
%
% Now for \(E <1\) the integrand has no singularity.

integrand2=@(y) -E*sqrt(1-y.*y)./(sqrt(1-E.*y.*y).*...
   (sqrt(1-E.*y.*y)+sqrt(1-E))); %new integrand without singularity
Tnew = (4/(omega*sqrt(1-E)))*(integral(integrand2,0,1)+pi/2) %a more accurate value for the period
abs(Tnew-T) %notice the small discrepancy between the two values of the period

%% Pendulum Upside Down
% When \(\theta_{\max}=\pi\), the pendulum is standing on its head.  The
% period becomes infinite.

amplitude = pi
E = sin(amplitude/2).^2
integrand=@(y) (4/omega)./sqrt((1-y.*y).*(1-E.*y.*y)); %integrand
T = integral(integrand,0,1) %pendulum amplitude
integrand2=@(y) -E*sqrt(1-y.*y)./(sqrt(1-E.*y.*y).*...
   (sqrt(1-E.*y.*y)+sqrt(1-E))); %new integrand without singularity
Tnew = (4/(omega*sqrt(1-E)))*(integral(integrand2,0,1)+pi/2) %a more accurate value for the period
toc

%%
% Without the re-write of the integrand and the period is a finite (and
% wrong) value.
%
% _Author:  Fred J. Hickernell_
