%% Piecewise Polynomial--Spline and PCHIP--Interpolation
% Polynomial interpolation has drawbacks if the data sites are placed
% poorly, there number is large and the higher order derivatives of the
% function are large.  Piecewise polynomial interpolation, maintaining a
% certain degree of smoothness is a good alternative.

%% Data
% Here is some synthetic data that we want to fit a curve to:

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
xnodes=1:6;
ynodes=[16 18 21 17 15 12];
xeval=1:0.05:6; %evaluation sites

%% Testing polynomial, spline and PCHIP interpolation using the data set
% Now we fit curves using three different methods:

ypoly=barycentric(xnodes,ynodes,xeval); %perform spline interpolation
yspline=spline(xnodes,ynodes,xeval); %perform spline interpolation
ypchip=pchip(xnodes,ynodes,xeval); %perform spline interpolation
figure
h=plot(xeval,ypoly,'-',xnodes,ynodes,'.',xeval,yspline,'k-', ...
   xeval,ypchip,'-');
xlabel('\(x\)')
ylabel('\(y\)')
legend(h([1 3 4 2]),{'polynomial','spline','PCHIP','data'},'location','northeast')
legend('boxoff')
axis([0.5 6.5 10 25])
print -depsc polysplinePCHIPdata.eps

%%
% In this example, PCHIP tends to fit the shape better according to our eye
% because there is less oscillation of the fitted curve.  PCHIP often works
% better when the data sites are given and cannot be set by the user.
%
% _Author: Fred J. Hickernell_
