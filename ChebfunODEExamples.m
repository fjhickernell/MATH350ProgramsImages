%% Chebfun Solutions to Ordinary Differential Equations
% The Chebfun package may also be used to solve differential equations.
% This is done through the the command |chebop|, which creates an
% _operator_, which is a function of a function.  In this demo we used
% Chebfun to solve the ODE examples that we have looked at previously.

%% Population Model
% We first look at the population model with some immigration.

tic
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
alpha = 1.5; %low population growth rate
beta = 1000; %limiting population
gamma = @(t) 100.*real((t>=0)&(t<=1)); %immigration rate
tint=[0,4]; %interval of time
y0 = 10; %initial condition
Diffop = chebop(tint); %create a differential operator over a time interval
Diffop.op = @(t,y) diff(y,1) - alpha*y.*(1 - y/beta); 
   %parts involving y and perhaps t, note that diff means derivative
Diffop.lbc = y0; %initial condition
RHS = chebfun(@(t) gamma(t),tint,'splitting','on'); %parts involving only t
   %since this function is discontinuous, we should turn splitting on
y = Diffop \ RHS; %a nonlinear backslash solver
plot(y) %plot the solution
xlabel('\(t\)')
ylabel('\(y(t)\)')
print -depsc 'popChebfun.eps'

%% Forced damped pendulum model
% Next we look at the forced, dampled pendulum

beta = 3; %damping coefficient
omega2 = 0.8; %non-dimensional gravitational constant
delta = @(t) 2*cos(2.5*t);
tint=[0,10]; %interval of time
y0=[0; 1]; %initial condition
Diffop=chebop(tint); %create a differential operator
Diffop.op=@(t,theta) diff(theta,2) + beta*diff(theta) + omega2*sin(theta); 
   %parts involving theta, v and perhaps t
Diffop.lbc = y0; %initial condition
RHS = chebfun(@(t) delta(t),tint); %parts involving only t
y = Diffop \ RHS; %a nonlinear backslash solver to get a Chebfun
figure
hand(1) = plot(y);
hold on
hand(2) = plot(diff(y)); %plot the solution
xlabel('\(t\)')
legend(hand,{'\(\theta(t)\)', '\(v(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'pendChebfun.eps'
figure
plot(y,diff(y),'-') %plot solution in the phase plane
xlabel('\(\theta(t)\)')
ylabel('\(v(t)\)')
print -depsc 'pendChebfunphase.eps'

%% Rabbits and Foxes Predator-Prey Model
% Finally, we look at the system of preys and predators

alpha = 10;
beta = 3;
gamma = 2;
delta = 1;
f = @(t,y) [alpha*y(1) - beta*y(1)*y(2); -gamma*y(2) + delta*y(1)*y(2)];
   %predator prey
y0=[1; 1]; %initial condition
tint=[0,5]; %interval of time
Diffop=chebop(tint); %create a differential operator
Diffop.op=@(t,r,f) [diff(r) - alpha*r + beta*r*f; ...
   diff(f) + gamma*f - delta*r*f]; 
   %parts involving y and perhaps t
Diffop.lbc = @(r,f) [r - y0(1); f - y0(2)]; %initial condition
RHS = [0; 0]; %parts involving only t
y = Diffop \ RHS; %a nonlinear backslash solver to get a Chebfun
figure
hand = plot(y); %plot the solution
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitsFoxesChebfun.eps'
figure
plot(y{1},y{2},'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitFoxesChebfunphase.eps'
toc

%%
% _Author: Fred J. Hickernell_

