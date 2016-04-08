%% Forced and Dampled Simple Pendulum
% The simple pendulum is governed by a second order ordinary differential
% equation:
%
% \[ \theta'' + \beta \theta' + \omega^2 \sin(\theta) = \delta(t), \]
%
% where 
%
% \begin{align*}
% \theta & = \text{the angular displacement} \\
% \beta & = \text{the non-dimensional damping coefficient} \\
% \omega^2 & = \text{the non-dimensional gravitational constant} \\
% \delta & = \text{the non-dimensional external forcing}
% \end{align*}
%
% Since most ordinary differential equation solvers are designed for first
% order equations, we make a change of variable:
%
% \[ \boldsymbol{y} = \begin{pmatrix} \theta \\ \theta' \end{pmatrix},
% \quad 
% f(t,\boldsymbol{y}) = \begin{pmatrix} y_2 \\ 
% -\beta y_2 - \omega^2 \sin(y_1) + \delta(t)  \end{pmatrix}, \qquad 
% \boldsymbol{y}' = f(t,\boldsymbol{y}) \]
%
% We will solve this second order equation, or equivalently first order
% system using several methods.

%% Simple pendulum model
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
beta = 3;
omega2 = 0.8;
delta = @(t) 2*cos(2.5*t);
f = @(t,y) [y(2); -beta*y(2) - omega2*sin(y(1)) + delta(t)];
y0 = [0 1]; %initial condition
tint = [0,10]; %interval of time

%% Euler's method
h = 0.05; %time step
tplot = (tint(1):0.002:tint(2)); %times to plot solution at
[tEuler,yEuler] = Euler(f,tint,y0,h); %compute by Euler's method
thetaplot = spline(tEuler,yEuler(1,:),tplot); %get theta values to plot
vplot = spline(tEuler,yEuler(2,:),tplot); %get v=theta' values to plot
hand = plot(tplot,thetaplot,'-',tplot,vplot,'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(\theta(t)\)', '\(v(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'pendEuler.eps'
figure
plot(thetaplot,vplot,'-') %plot solution in the phase plane
xlabel('\(\theta(t)\)')
ylabel('\(v(t)\)')
print -depsc 'pendEulerphase.eps'

%%
% Note that the amplitude and velocity settle into a periodic pattern.  The
% oscillation of the amplitude starts out not centered around zero, but
% drifts towards that

%% modified Euler's method
% We solve this system with the modified Euler's method as well.
[tmEuler,ymEuler] = modifiedEuler(f,tint,y0,h); %compute by Euler's method
thetaplot = spline(tmEuler,ymEuler(1,:),tplot); %get theta values to plot
vplot = spline(tmEuler,ymEuler(2,:),tplot); %get v=theta' values to plot
figure
hand = plot(tplot,thetaplot,'-',tplot,vplot,'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(\theta(t)\)', '\(v(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'pendmodEuler.eps'
figure
plot(thetaplot,vplot,'-') %plot solution in the phase plane
xlabel('\(\theta(t)\)')
ylabel('\(v(t)\)')
print -depsc 'pendmodEulerphase.eps'

%% ode45
% Now we use the Runge-Kutta method
sol = ode45(f,tint,y0); %get solution as a structure variable
yplot = deval(sol,tplot); %evaluate solution of ODE at many points
figure
hand = plot(tplot,yplot(1,:),'-',tplot,yplot(2,:),'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(\theta(t)\)', '\(v(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'pendode45.eps'
figure
plot(yplot(1,:),yplot(2,:),'-') %plot solution in the phase plane
xlabel('\(\theta(t)\)')
ylabel('\(v(t)\)')
print -depsc 'pendode45phase.eps'

%% ode113
% Finally, we use the predictor corrector method.
sol = ode113(f,tint,y0); %get solution as a structure variable
yplot=deval(sol,tplot); %evaluate solution of ODE at many points
figure
hand = plot(tplot,yplot(1,:),'-',tplot,yplot(2,:),'k-'); %plot solution versus time
xlabel('\(t\)')
legend(hand,{'\(\theta(t)\)', '\(v(t)\)'},'location','northeast')
legend('boxoff')
print -depsc 'pendode113.eps'
figure
plot(yplot(1,:),yplot(2,:),'-') %plot solution in the phase plane
xlabel('\(\theta(t)\)')
ylabel('\(v(t)\)')
print -depsc 'pendode113phase.eps'

%%
% _Author: Fred J. Hickernell_

