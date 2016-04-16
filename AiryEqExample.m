%% Airy's Equation Boundary Value Problem
% Airy's equation looks simple, but cannot be solved analytically.
%
% \[ y'' = xy. \]
%
% We solve it with boundary conditions on the left and right of zero:
%
% \[ y(-10) = 1, \quad y(10) = 0.\]

%% MATLAB's bvp5c
% First we try |bvp5c|.

tic
f = @(x,y) [y(2); x.*y(1)]; %right hand side of ODE
leftbc = 1; %value of y' on the left side
rightbc = 0; %value of y the right side
xint=[-10 10]; %interval of x
bcf=@(ya,yb) [ya(2)-leftbc; yb(1)-rightbc];
solinit = bvpinit(xint(1):diff(xint)/5:xint(2),[leftbc rightbc]);
sol = bvp5c(f,bcf,solinit); %get solution as a structure variable
xplot = xint(1):0.05:xint(2); %x values to plot the solution at
yplot = deval(sol,xplot); %evaluate solution of ODE at many points
toc
figure
plot(xplot,yplot(1,:),'-'); %plot solution versus time
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'Airybvp5c.eps'

%% Chebfun
% Next we use a |chebop| in Chebfun.

tic
Diffop = chebop(xint); %create a differential operator
Diffop.op = @(x,y) diff(y,2) - x.*y; 
   %parts involving y and perhaps x, note that diff means derivative
Diffop.lbc = @(y) diff(y,1)-leftbc; %left boundary condition
Diffop.rbc = rightbc; %right boundary condition
RHS = 0; %parts involving only x
y = Diffop \ RHS; %a nonlinear backslash solver
toc
figure
plot(y) %plot the solution
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'AiryChebfun.eps'

%% Shooting Method Using ODE45
% Finally we try a shooting method.

tic
sol = shootingMethod(f,xint,[leftbc rightbc]); %get the answer using the shootingMethod
yplot=deval(sol,xplot); %evaluate solution of ODE at many points
toc
figure
plot(xplot,yplot(1,:),'-'); %plot solution versus time
xlabel('\(x\)')
ylabel('\(y(x)\)')
print -depsc 'Airyshoot.eps'

%%
% Notice that in this case all methods seem to take about the same amount
% of time.
%
% _Author: Fred J. Hickernell_
