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

%% ode45
sol=ode45(f,tint,y0); %get solution as a structure variable
yplot=deval(sol,tplot); %evaluate solution of ODE at many points
figure
plot(tplot,yplot,'-',sol.x,sol.y,'.'); %plot solution
axis([tint 0 1200])
xlabel('\(t\)')
ylabel('\(y(t)\)')
print -depsc 'popode45.eps'

%% ode113
sol=ode113(f,tint,y0); %get solution as a structure variable
yplot=deval(sol,tplot); %evaluate solution of ODE at many points
figure
plot(tplot,yplot,'-',sol.x,sol.y,'.'); %plot solution
axis([tint 0 1200])
xlabel('$t$')
ylabel('$y(t)$')
print -depsc 'popode113.eps'



