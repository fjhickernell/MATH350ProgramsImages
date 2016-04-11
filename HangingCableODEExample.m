%% Hanging Cable Boundary Value Problem
% A hanging cable is governed by the following second-order differential
% equation boundary value problem
%
% \[ \frac{\textrm{d}^2 y}{\textrm{d} x^2} = \alpha \sqrt{1 +
% \left(\frac{\textrm{d} y}{\textrm{d} x}\right)^2}, \qquad y(a) = y_a, \
% y(b)=y_b. \]
%
% Here we use three different ways to solve this problem numerically.

%% MATLAB's bvp5c
% First we try |bvp5c|.
tic
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
cablelength = 3; %constant involving length of the cable
f = @(x,y) [y(2); cablelength.*sqrt(1+y(2).*y(2))]; %right hand side of ODE
leftheight = 1; %height of the left side
rightheight = 2; %height of the right side
xint = [0 1]; %interval of x
bcf = @(ya,yb) [ya(1)-leftheight; yb(1)-rightheight]; %boundary conditions
solinit = bvpinit(xint(1):diff(xint)/5:xint(2),[leftheight rightheight]);
sol = bvp5c(f,bcf,solinit); %get solution as a structure variable
xplot = xint(1):0.002:xint(2);
yplot = deval(sol,xplot); %evaluate solution of ODE at many points
figure
plot(xplot,yplot(1,:),'-'); %plot solution versus time
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'cablebvp5c.eps'
toc

%% Chebfun
% Next we use a |chebop| in Chebfun.
tic
Diffop = chebop(xint); %create a differential operator
Diffop.op = @(x,y) diff(y,2) - cablelength.*sqrt(1+diff(y,1).^2); 
   %parts involving y and perhaps x, note that diff means derivative
Diffop.lbc = leftheight; %left boundary condition
Diffop.rbc = rightheight; %right boundary condition
RHS = 0; %parts involving only x
y = Diffop \ RHS; %a nonlinear backslash solver
figure
plot(y) %plot the solution
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'cableChebfun.eps'
toc

%% Shooting Method Using ODE45
% Finally we try a shooting method.  The main work is done by the function
% |shootingMethod|.
%
% <include>shootingMethod</include>
%

tic
sol = shootingMethod(f,xint,[leftheight rightheight]); %get the answer using the shootingMethod
yplot=deval(sol,xplot); %evaluate solution of ODE at many points
toc
figure
plot(xplot,yplot(1,:),'-'); %plot solution versus time
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'cableshoot.eps'

%%
% Notice that in this case the shooting method seems to be the quickest.
%
% _Author: Fred J. Hickernell_


