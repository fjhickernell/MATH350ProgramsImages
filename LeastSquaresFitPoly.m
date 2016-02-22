%% Quadratic Function Least Squares Fit
% In this script we demonstrate how the backslash operator, |\|, may be
% used to solve least squares problems, in particular fitting a quadratic
% function to data.
 
%% Fitting a Simple Function
% Here is some synthetic (made-up) data for which we can compute the fit
% by a parabola.  The two variables are \(t\) and \(y\).  The data is
% \((t_1, y_1), \ldots, (t_5,y_5)\), and the fit polynomial is called
% \(p\).  Note that the polynomial is only of degree \(2\), so it will not
% in general fit \(5\) data points exactly.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
MATLABBlue = [0, 0.447, 0.741]; %these are 
MATLABOrange = [0.85,  0.325, 0.098]; %MATLAB plotting
MATLABPurple = [0.494,  0.184, 0.556]; %colors that 
MATLABGreen = [0.466,  0.674, 0.188]; %we want to use
tic %start the clock
tdata = (-1:0.5:1)'; %t data
ydata = [-3 0 1 0.5 -1]'; %y data
A = [ones(5,1) tdata tdata.*tdata]; %matrix to perform interpolation
c = A \ ydata %coefficients
residuals = ydata - A*c; %residuals or lack-of-fit
stdResid = std(residuals) %size of the residuals
tplot = (-1.2:0.005:1.2)'; %points to plot function and its approximation
yplot = [ones(size(tplot)) tplot tplot.*tplot]*c;
toc

%% Plot data and approximation
figure; 
h = plot(tplot,yplot,'-',tdata,ydata,'.');
axis([-1.2 1.2 -3.5 1.5])
xlabel('\(t\)')
ylabel('\(p(t)$')
legend(h,{'fitted polynomial','data'},'location','south')
legend('boxoff')
print -depsc LeastSquaresQuadFit.eps;

%% Fit World-Class Mile Times
% Now we look at the winning times recorded at major mile races for female atheletes:

data = [
1967	277
1969	276.8
1971	275.3
1973	274.9
1973	269.5
1977	263.8
1979	262.09
1980	261.68
1981	260.89
1980	257.55
1982	258.08
1982	257.44
1984	255.8
1985	256.71
1989	255.61
1996	252.56];
year = data(:,1);
mileTime = data(:,2); %in seconds
figure; 
h = plot(year,mileTime,'.','color',MATLABOrange);
axis([1965 2020 240 280])
xlabel('Year, \(t\)')
ylabel('Mile Time, \(T\)')

%%
% We may again fit some a quadratic function to the data.  This time,
% define things slightly differently:

basis = @(t) [ones(numel(t),1) t t.*t]; %the basis for our linear regression
A = basis(year); %regression matrix
c = A \ mileTime %coefficients
residuals = mileTime - A*c; %residuals or lack-of-fit
stdResid = std(residuals) %size of the residuals
yearPlot = (1965:0.01:2020)'; %points to plot function and its approximation
mileTimeplot = basis(yearPlot)*c; %fitted mile times
hold on 
h = [h; plot(yearPlot,mileTimeplot,'-','color',MATLABBlue)];
legend(h(2:-1:1),{'fitted polynomial','data'},'location','northeast')
legend('boxoff')

%% Condition Number Problem
% The condition number of this matrix |A| is quite high

condA = cond(A)

%%
% which means that we could be losing many digits of accuracy.  The reason
% for this is that \(t\) does not change much in relative size, so the
% columns of the matrix are nearly parallel.  We can change this by
% centering time as follows:

basis = @(t) [ones(numel(t),1) t-1980 (t-1980).*(t-1980)]; %the basis, now with t centered
A = basis(year); %regression matrix
c = A \ mileTime %these coefficients are now different
residuals = mileTime - A*c; %residuals or lack-of-fityear
stdResid = std(residuals) %size of the residuals
mileTimeplot = basis(yearPlot)*c; %fitted mile times
h = [h; plot(yearPlot,mileTimeplot,'-','color',MATLABPurple)];
legend(h(3:-1:1),{'fit (centered \(t\))','fit','data'},'location','northeast')
legend('boxoff')

%%
% Note that the coefficients are different, but the fitted polynomial is
% the same in theory. The purple curve overlays the blue one, so the
% difference is negligible to the eye.  However, the condition number of
% |A| is now much smaller:

condA = cond(A)

%%
% so the accuracy of our coefficients should be higher.

%% Revising the model
% This quadratic curve fits the data better than a line would, but the
% times start to move up, so another model might be better.  We could try
% an asymptotic function

basis = @(t) [ones(numel(t),1) t-1980 1./(t-1950)]; %the new
A = basis(year); %regression matrix
c = A \ mileTime %these coefficients are now different
residuals = mileTime - A*c; %residuals or lack-of-fityearPlot =(1965:0.01:2000)'; %points to plot function and its approximation
stdResid = std(residuals) %size of the residuals
mileTimeplot = basis(yearPlot)*c; %fitted mile times
figure
h=plot(yearPlot,mileTimeplot,'-',year,mileTime,'.');
axis([1965 2020 240 280])
legend(h,{'new model fit','data'},'location','northeast')
legend('boxoff')
condA = cond(A)

%%
% This model seems more reasonable and has a similar size of residuals, but
% _extrapolation is always a risky business_.
%
% _Author: Fred J. Hickernell_


