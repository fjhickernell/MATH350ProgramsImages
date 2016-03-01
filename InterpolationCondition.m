%% Quadratic Function Interpolation with Condition Number
% Here we look at the problem of interpolating a function using three data
% points.  This leads to a system of linear equations.  However, depending
% on the placement of the data sites, this system may be ill-conditioned.

%% Compute a Quadratic Polynomial Approximation to Data with Noise
% We start with a simple quadratic function, which is sampled at three
% points, \(0\), \(1\), and \(t\), where \(0 < t < 1\).  We start with \(t
% = 0.5\).

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
y=@(x) 1 + 3.*x - 5*x.^2; %test function
tic %start the clock
t=0.5; %middle point
x=[0 t 1]'; %where data is taken
A=[ones(3,1) x x.*x]; %matrix to perform interpolation that includes constant, linear and quadratic terms
epsvec=0.01*randn(3,1); %we add some Gaussian random noise
yvec=y(x)+epsvec; %y data with Gaussian random noise
c=A\yvec; %coefficients of the polynomial
xplot=(0:0.005:1)'; %points to plot function and its approximation
yplot=y(xplot); %true function values at plotting points
yappxplot=[ones(size(xplot)) xplot xplot.*xplot]*c; %approximate function values at plotting points
esterr=max(abs(yplot-yappxplot)); %estimated error of the approximation
toc

%% Plot Approximation
figure; 
h = plot(xplot, yplot, '-', xplot, yappxplot, 'k-', x, yvec, '.');
axis([-0.1 1.1 -1.2 2.5])
xlabel('\(x\)')
ylabel('\(y(x)\)')
legend(h, {'true \(y\)', 'approximation \(\tilde{y}\)', 'data'}, ...
   'location','southwest')
legend('boxoff')
text(0.3, 2.3, ['error = ' num2str(esterr)])
text(0.3, 2, ['cond(A) = ' num2str(cond(A),4)])
text(0.3, 1.7, ['\(\|\epsilon\| =\) ' num2str(norm(epsvec),4)])
eval(['print -depsc QuadInterpCondition' num2str(1000*t) '.eps']);

%%
% Note that the original function and the approximation are
% indistinguishable to the eye.

%% Now Use a \(t\) Close to Zero
% Now we use \(t = 0.001\).  Although there are still three points, it is
% almost as if there were only two darta points. This time the error is
% much larger and the condition number of the matrix is much larger as
% well.

tic %start the clock
t=0.001; %middle point
x=[0 t 1]'; %where data is taken
A=[ones(3,1) x x.*x]; %matrix to perform interpolation that includes constant, linear and quadratic terms
epsvec=0.01*randn(3,1); %we add some Gaussian random noise
yvec=y(x)+epsvec; %y data with Gaussian random noise
c=A\yvec; %coefficients of the polynomial
xplot=(0:0.005:1)'; %points to plot function and its approximation
yplot=y(xplot); %true function values at plotting points
yappxplot=[ones(size(xplot)) xplot xplot.*xplot]*c; %approximate function values at plotting points
esterr=max(abs(yplot-yappxplot));
toc

%% Plot Approximation
figure; 
h = plot(xplot, yplot, '-', xplot, yappxplot, 'k-', x, yvec, '.');
axis([-0.1 1.1 -1.2 2.5])
xlabel('\(x\)')
ylabel('\(y(x)\)')
legend(h, {'true \(y\)', 'approximation \(\tilde{y}\)', 'data'}, ...
   'location','southwest')
legend('boxoff')
text(0.3, 2.3, ['error = ' num2str(esterr)])
text(0.3, 2, ['cond(A) = ' num2str(cond(A),4)])
text(0.3, 1.7, ['\(\|\epsilon\| =\) ' num2str(norm(epsvec),4)])
eval(['print -depsc QuadInterpCondition' num2str(1000*t) '.eps']);

%%
% In this case the original function and the approximation are quite far
% apart away from the data sites.
%
% _Author: Fred J. Hickernell_
