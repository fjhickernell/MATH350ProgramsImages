%% Loaded Beam Boundary Value Problem
% A loaded beam satisfies a fourth-order differential equation
%
% \[ y'''' = \ell(x), \]
%
% where \(\ell(x)\) denotes the load at \(x\).  We consider the beam
% starting from \(0\) and ending at \(1\) with different kinds of
% conditions at each end.

%% MATLAB's bvp5c
tic
loadf = @(x) -30*exp(-100*(x-0.8).^2); %load on the beam
f = @(x,y) [y(2); y(3); y(4); loadf(x)]; %right hand side of ODE
leftheight = 0; %height of the left side
rightheight = 0; %height of the right side
xint=[0 1]; %interval of x
bcf = @(ya,yb) [ya(1)-leftheight; ya(3); yb(1)-rightheight; yb(3)];
%   %boundary conditions for a simply supported beam
%bcf = @(ya,yb) [ya(1)-leftheight; ya(2); yb(3); yb(4)];
   %boundary conditions for a left clamped and right free beam
solinit = bvpinit(xint(1):diff(xint)/5:xint(2),[leftheight 0 0 0]);
sol = bvp5c(f,bcf,solinit); %get solution as a structure variable
xplot = xint(1):0.002:xint(2);
yplot = deval(sol,xplot); %evaluate solution of ODE at many points
figure
plot(xplot,yplot(1,:),'-'); %plot solution versus time
xlabel('\(x\)')
ylabel('\(y(x)\)')
axis([xint(1) xint(2) 1.2*min(yplot(1,:)) 1.2*max(yplot(1,:))]);
print -depsc 'beambvp5c.eps'
toc

%% Chebfun
tic
Diffop = chebop(xint); %create a differential operator
Diffop.op = @(x,y) diff(y,4); 
   %parts involving y and perhaps x, note that diff means derivative
Diffop.lbc = @(y) [y-leftheight; diff(y,2)]; 
   %simply supported on left
%Diffop.lbc = @(y) [y-leftheight; diff(y,1)]; 
   %clamped on left
Diffop.rbc = @(y) [y-rightheight; diff(y,2)]; 
   %simply supported on right
%Diffop.rbc = @(y) [diff(y,2); diff(y,3)];
   %free on right
RHS = chebfun(loadf,xint); %parts involving only x
y = Diffop \ RHS; %a nonlinear backslash solver
figure
plot(y) %plot the solution
xlabel('\(x\)')
ylabel('\(y(x)\)')
axis([xint(1) xint(2) 1.2*min(yplot(1,:)) 1.2*max(yplot(1,:))]);
print -depsc 'beamChebfun.eps'
toc

%%
%
% _Author: Fred J. Hickernell_