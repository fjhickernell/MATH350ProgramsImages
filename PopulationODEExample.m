%% Population Ordinary Differential Equation Example
% The population of a habitat or area can be modeled by a differential
% equation (ODE).  Here is a relatively simple model
%
% \begin{align*}
% t & = \text{time} \\
% y & = \text{population} \\
% \alpha & = \text{growth rate} \\
% \beta & = \text{limiting population} \\
% \gamma(t) & = \text{rate of immigration of emigration} \\
% \frac{\textrm{d}y}{\textrm{d}t} &  =  \alpha y (1 - y/\beta) + \gamma(t),
% \qquad 0 \le t \\
% y(0) &= y_0
% \end{align*}
%
% This ODE cannot be solved in general by analytic means.  In this script
% we show how to numerically compute the solution for certain values of the
% parameters.


%% Population model
% First we set up the population ODE model.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
alpha = 1.5; %low population growth rate
beta = 1000; %limiting population
gamma = @(t) 100.*real((t>=0)&(t<=1)); %immigration rate
f = @(t,y) alpha*y.*(1 - y/beta) + gamma(t); %right-hand-side of the ODE
y0 = 10; %initial condition
tint = [0,4]; %time interval

%% Euler's method
% The simplest method for solving ODEs is Euler's method.  This method has
% been coded as follows
%
% <include>Euler.m</include>
%
% We will compute the Euler's method approximation to the population ODE
% for different time steps.

hvec = [0.5 0.1 0.05 0.01]; %vector of time steps
nh = numel(hvec); %number of different time steps
hand1 = zeros(nh,1); %initialize graphics handle
hand2 = hand1;
legtext=cell(nh,1); %initialize legend text
MATLABColors = [0, 0.447, 0.741; ... %these are 
   0.85,  0.325, 0.098; ... %MATLAB plotting
   0.494,  0.184, 0.556; ... %colors that 
   0.466,  0.674, 0.188]; %we want to use
tplot=(tint(1):0.002:tint(2)); %times to plot at
for i=1:nh;
   [tEuler,yEuler] = Euler(f,tint,y0,hvec(i)); %compute by Euler's method
   yplot = spline(tEuler,yEuler,tplot); %values of y to plot
   hand1(i) = plot(tEuler,yEuler,'.'); %plot y at times in Euler method
   set(hand1(i),'color',MATLABColors(mod(i-1,4)+1,:))
   hold on
   hand2(i) = plot(tplot,yplot,'-'); %plot finer mesh of y values
   set(hand2(i),'color',MATLABColors(mod(i-1,4)+1,:))
   legtext{i} = ['\(h=' num2str(hvec(i)) '\)'];
end
axis([tint 0 1.1*max(yplot)])
xlabel('\(t\)')
ylabel('\(y(t)\)')
legend(hand1,legtext,'location','southeast')
print -depsc 'popEuler.eps'

%%
% Notice that as the stepsize gets smaller, the approximate answer
% converges (to the correct answer).

%% Modified Euler's method
% The modified Euler method is more accurate than Euler's method because it
% adds a correction to the original approximation at each time step. It has
% been coded as follows
%
% <include>modifiedEuler.m</include>
%
% We will compute the modified Euler's method approximation to the
% population ODE.

figure
for i=1:nh;
   [tmEuler,ymEuler]=modifiedEuler(f,tint,y0,hvec(i)); %compute by modified Euler's method
   yplot=spline(tmEuler,ymEuler,tplot); %values of y to plot
   hand1(i) = plot(tmEuler,ymEuler,'.'); %plot y at times in the modified Euler method
   set(hand1(i),'color',MATLABColors(mod(i-1,4)+1,:))
   hold on
   hand2(i) = plot(tplot,yplot,'-'); %plot finer mesh of y values
   set(hand2(i),'color',MATLABColors(mod(i-1,4)+1,:))
   legtext{i} = ['\(h=' num2str(hvec(i)) '\)'];
end
axis([tint 0 1.1*max(yplot)])
xlabel('\(t\)')
ylabel('\(y(t)\)')
legend(hand1,legtext,'location','southeast')
print -depsc 'popmodEuler.eps'
%%
% Again, as the stepsize gets smaller, the approximate answer converges (to
% the correct answer), but the convergence is faster.

%% |ode45|
% The modified Euler method is the simplest example of a Runge-Kutta
% method.  MATLAB's |ode45| is a higher order Runge Kutta method, that
% automatically adjusts the step-size to meet the desired error tolerance.
% Notice that the number of time steps required for high accuracy is fewer
% than the Euler and modified Euler methods.  According to the
% documentation, the default relative error tolerance is \(0.001\), and the
% default absolute error tolerance is \(0.000001\).

sol=ode45(f,tint,y0); %get solution as a structure variable
yplot=deval(sol,tplot); %evaluate solution of ODE at many points
figure
plot(tplot,yplot,'-',sol.x,sol.y,'.'); %plot solution
axis([tint 0 1200])
xlabel('\(t\)')
ylabel('\(y(t)\)')
print -depsc 'popode45.eps'

%% |ode113|
% The modified Euler method is also the simplest example of a
% predictor-corrector method.  MATLAB's |ode113| is a higher (and even
% variable) order predictor-corrector method, that automatically adjusts
% the step-size to meet the desired error tolerance.  Notice that the
% number of time steps required for high accuracy is fewer than the Euler
% and modified Euler methods.  In this example, it requires more steps than
% the |ode45|.

sol=ode113(f,tint,y0); %get solution as a structure variable
yplot=deval(sol,tplot); %evaluate solution of ODE at many points
figure
plot(tplot,yplot,'-',sol.x,sol.y,'.'); %plot solution
axis([tint 0 1200])
xlabel('$t$')
ylabel('$y(t)$')
print -depsc 'popode113.eps'

%%
% The additional steps needed after \(t = 1\) may be due to the
% discontinuity in the function \(\gamma\) at \(t = 1\).
%
% _Author: Fred J. Hickernell_



