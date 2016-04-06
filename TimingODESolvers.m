%% Timing Versus Error for ODE solvers
% Let's try some examples of solving ODEs with different solvers and
% compare their errors for different number of steps.

%% Population Model with Exact Solution
% Consider the population model without immigration/emigration. 
%
% \begin{align*}
% t & = \text{time} \\
% y & = \text{population} \\
% \alpha & = \text{growth rate} \\
% \beta & = \text{limiting population} \\
% \frac{\textrm{d}y}{\textrm{d}t} &  =  \alpha y (1 - y/\beta),
% \qquad 0 \le t \\
% y(0) &= y_0
% \end{align*}
%
% This ODE can be solved in general by analytic means,  
%
% \[ y(t) = \frac{y_0 \beta}{y_0 + (\beta - y_0)\exp(- \alpha t)}, \]
%
% which allows us to compute exact errors.

%% Population model
% First we set up the population ODE model.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
alpha = 1.5; %low population growth rate
beta = 1000; %limiting population
f = @(t,y) alpha*y.*(1 - y/beta); %right-hand-side of the ODE
y0 = 10; %initial condition
tint = [0,6]; %time interval
tcheck = (tint(1):0.0002:tint(2)); %times to check against the exact solution
yexact = @(t) y0*beta./(y0 + (beta-y0)*exp(-alpha*t)); %exact solution
ycheck = yexact(tcheck); %places to check the exact solution with the approximations
MATLABColors = [0, 0.447, 0.741; ... %these are 
   0.85,  0.325, 0.098; ... %MATLAB plotting
   0.494,  0.184, 0.556; ... %colors that 
   0.466,  0.674, 0.188]; %we want to use
figure
plot(tcheck,ycheck,'-')
xlabel('Time')
ylabel('Population')

%% Euler's method
% We will compute the Euler's method approximation to the population ODE
% for different time steps.

hvec = [0.5 0.2 0.1 0.05 0.02 0.01 0.005 0.002 0.001]'; %vector of time steps
nvec = (tint(2)-tint(1))./hvec; %numbers of time steps
nh = numel(hvec); %number of different time steps
errEuler = zeros(nh,1); %initialize error vector
for i=1:nh;
   [tEuler,yEuler] = Euler(f,tint,y0,hvec(i)); %compute by Euler's method
   yapprox = spline(tEuler,yEuler,tcheck); %values of y to check
   errEuler(i) = max(abs(ycheck - yapprox));
end
figure
h = loglog(nvec,errEuler,'.','color',MATLABColors(1,:));
legtext = {'Euler Method'};
legend(h,legtext,'location','northeast')
legend boxoff
xlabel('\(n\)')
ylabel('Error')
hold on

%%
% Now let's find the rate of decay.  Since the points on this log-log plot
% fall approximately in a straight line, we are expecting that
% \(\text{error} \approx c n^{-p}\), or equivalently \(\log(\text{error})
% \approx \log(c) - p \log(n)\).  We may find \(c\) and \(p\) by
% regression.

coeff = [ones(nh,1) log(nvec)] \ log(errEuler); %linear regression with \
pEuler = -coeff(2) %the p value
cEuler = exp(coeff(1)) %the 
loglog(nvec([1 nh]),cEuler * nvec([1 nh]).^-pEuler, ...
   '-','color',MATLABColors(1,:))

%%
% Since \(p \approx 1\), this affirms that the error for Euler's method decays like \(O(1/n)\).

%% Modified Euler's method
% Let's do the same for the Modified Euler's Method.
errMEuler = zeros(nh,1); %initialize error vector
for i=1:nh;
   [tMEuler,yMEuler] = modifiedEuler(f,tint,y0,hvec(i)); %compute by the modified Euler method
   yapprox = spline(tMEuler,yMEuler,tcheck); %values of y to check
   errMEuler(i) = max(abs(ycheck - yapprox));
end
coeff = [ones(nh,1) log(nvec)] \ log(errMEuler); %linear regression with \
pMEuler = -coeff(2) %the p value
cMEuler = exp(coeff(1)) %the c value
h = [h; loglog(nvec,errMEuler,'.', ...
   nvec([1 nh]),cMEuler * nvec([1 nh]).^-pMEuler,'-', ...
   'color',MATLABColors(2,:))];
legtext{2} = 'Modified Euler Method';
legend(h,legtext,'location','northeast')
legend boxoff
toc
