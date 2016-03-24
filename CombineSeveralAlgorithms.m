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
g = 980; %gravitational constant in grams cm sec^-2
l = 80; %length of the pendulum in cm
omega = sqrt(g/l); %angular frequency, inverse time
Tsmall = 2*pi/omega %small amplitude approximation
integrand = @(y,E) -E*sqrt(1-y.*y)./(sqrt(1-E.*y.*y).*...
   (sqrt(1-E.*y.*y)+sqrt(1-E))); %new integrand without singularity
period = @(E) (4/(omega*sqrt(1-E)))*(integral(@(y) integrand(y,E),0,1)+pi/2); 
T = @(theta) period(sin(theta/2).^2); %function to compute the period of a pendulum
Ttiny = T(0.01)
Tpi2 = T(pi/2)
Amplitude = @(tau) fzero(@(theta) T(theta) - tau,[0,pi-1e-5]);
tic
Amp_pi2 = Amplitude(2.1189)
toc

%% Plot the Amplitude Versus Period
tic
tauplot = (Tsmall:0.001:5);
Ampplot = tauplot;
for i = 1:numel(tauplot)
   Ampplot(i) = Amplitude(tauplot(i));
end
figure
plot(tauplot,Ampplot,'-');
xlabel('Period')
ylabel('Amplitude')
toc

%% Build an Approximation to the Amplitude Function
taudata = (Tsmall:0.02:5);
Ampdata = taudata;
for i = 1:numel(taudata)
   Ampdata(i) = Amplitude(taudata(i));
end
pp = spline(taudata,Ampdata);
AmpSpline = @(tau) ppval(pp,tau);
AmpSpline_pi2 = AmpSpline(2.1189)
hold on
tic
plot(tauplot,AmpSpline(tauplot),'-');
toc
legend({'Data','Spline'})
legend boxoff
