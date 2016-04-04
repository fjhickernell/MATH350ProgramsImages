%% Rabbits & Foxes Predator-Prey Model
% The following system of two first-order ODEs models the dynamics of
% populations of predators (foxes) and prey (rabbits):
%
% \[ \begin{pmatrix} r' \\ f' \end{pmatrix} = 
% \begin{pmatrix} \alpha r - \beta r f\\ -\gamma r + \delta rf
% \end{pmatrix}. \]
%
% where 
%
% \begin{align*}
% r & = \text{the number of rabbits} \\
% f & = \text{the number of foxes} \\
% \alpha & = \text{the low-fox growth rate of rabbits} \\
% \beta & = \text{the rate of rabbit loss due to foxes} \\
% \beta & = \text{the low-rabbit death rate of foxes} \\
% \delta & = \text{the rate of fox growth due to rabbits}
% \end{align*}
%
% Although the behavior should be periodic, for the Euler
% method it does not quite look that way.

%% Rabbits and foxes model
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
alpha = 10;
beta = 3;
gamma = 2;
delta = 1;
f = @(t,y) [alpha*y(1) - beta*y(1)*y(2); -gamma*y(2) + delta*y(1)*y(2)];
   %predator prey
y0=[1 1]; %initial condition
tint=[0,5]; %interval of time

%% Euler's method
% First we try Euler's method.
h = 0.01; %time step
tplot = (tint(1):0.002:tint(2)); %times to plot solution at
[tEuler,yEuler] = Euler(f,tint,y0,h); %compute by Euler's method
rabbitplot = spline(tEuler,yEuler(1,:),tplot); %get r values to plot
foxplot = spline(tEuler,yEuler(2,:),tplot); %get f values to plot
hand = plot(tplot,rabbitplot,'-',tplot,foxplot,'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitfoxEuler.eps'
figure
plot(rabbitplot,foxplot,'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitfoxEulerphase.eps'

%%
% Notice that the oscillations seem to be getting bigger each time.  We may
% try a smaller time step.

h = 0.001; %time step
tplot = (tint(1):0.002:tint(2)); %times to plot solution at
[tEuler,yEuler] = Euler(f,tint,y0,h); %compute by Euler's method
rabbitplot = spline(tEuler,yEuler(1,:),tplot); %get r values to plot
foxplot = spline(tEuler,yEuler(2,:),tplot); %get f values to plot
figure
hand = plot(tplot,rabbitplot,'-',tplot,foxplot,'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitfoxEulerSmall.eps'
figure
plot(rabbitplot,foxplot,'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitfoxEulerphaseSmall.eps'

%%
% This is better, but not ideal.

%% Modified Euler's method
% A higher order method works better.
[tmEuler,ymEuler] = modifiedEuler(f,tint,y0,h); %compute by modified Euler's method
rabbitplot = spline(tmEuler,ymEuler(1,:),tplot); %get r values to plot
foxplot = spline(tmEuler,ymEuler(2,:),tplot); %get f values to plot
hand = plot(tplot,rabbitplot,'-',tplot,foxplot,'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitfoxmodEuler.eps'
figure
plot(rabbitplot,foxplot,'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitfoxmodEulerphase.eps'

%%
% Now the dynamics look periodic.

%% ode45
% The Runge-Kutta method does well
sol = ode45(f,tint,y0); %get solution as a structure variable
yplot = deval(sol,tplot); %evaluate solution of ODE at many points
figure
hand = plot(tplot,yplot(1,:),'-',tplot,yplot(2,:),'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitfoxode45.eps'
figure
plot(yplot(1,:),yplot(2,:),'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitfoxode45phase.eps'

%% ode113
% So does the predictor-corrector method.
sol = ode113(f,tint,y0); %get solution as a structure variable
yplot = deval(sol,tplot); %evaluate solution of ODE at many points
figure
hand = plot(tplot,yplot(1,:),'-',tplot,yplot(2,:),'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(r(t)\)', '\(f(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'rabbitfoxode113.eps'
figure
plot(yplot(1,:),yplot(2,:),'-') %plot solution in the phase plane
xlabel('\(r(t)\)')
ylabel('\(f(t)\)')
print -depsc 'rabbitfoxode113phase.eps'


