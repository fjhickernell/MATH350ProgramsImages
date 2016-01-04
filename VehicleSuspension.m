%% Calculating and Plotting a Vehicle's Suspension System

%% The Situation
% Automobiles, trucks and other vehicles have
% <http://en.wikipedia.org/wiki/Suspension_(vehicle) suspension systems>
% for keeping and passengers comfortable. They are comprised of springs and
% shock absorbers, which look like this:
%
% <<../ShockAbsorberSpring.jpg>>
%
% In this script we perform some MATLAB computations related to vehicle
% suspension systems.
%
% One model has the vertical position of the vehicle, \(y\) (in centimeters),
% as a function of time, \(t\) (in seconds), described by
%
% \[
% y(t)=20t \textrm{e}^{-2t}
% \]
%
% Two questions that one may ask are
%
% * How long does it take for the \(y\) to reach its maximum?  
%
% * How long does it take for \(y\) to decrease back to one tenth of its maximum?

%% Define and Plot the Displacement 
% First we define a MATLAB function |y| that mirrors the mathematical
% formula above.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
y=@(t) 20*t.*exp(-2*t); %function that describes the vertical displacement

%%
% Next we plot this function for time between \(0\) and \(4\) seconds.

tplot=0:0.002:4; %time values for plot
plot(tplot,y(tplot),'b-') %plot y
xlabel('time, \(t\)') %x-axis label
ylabel('displacement, \(y\)') %y-axis label
axis([0 4 0 4]); %set horizontal and vertical axis ranges

%% Find Where \(y\) Reaches Its Maximum Value
% The maximum value of the function \(y\) may be found by elementary
% calculus operations.  The first derivative of this function is 
%
% \[ \frac{\textrm{d}y}{\textrm{d}t} = 20 \textrm{e}^{-2t}(1 -2t)
% \begin{cases} > 0 & t < 1/2, \\ < 0  & t > 1/2.\end{cases} \]
%
% Thus, the maximum occurs at \(t = 1/2 =:t_\max\) and is \(y(t_\max) =
% y(1/2) = 10/ \textrm{e} =: y_{\max}\). We add this maximum to the plot.

tmax=1/2; %time of maximum computed using calculus
ymax=y(tmax); %value of maximum displacement
hold on %to add further elements to the plot
plot([0 tmax tmax],[ymax ymax 0],'k--',tmax,ymax,'r.') %plot maximum
text(tmax-0.2,-0.2,num2str(tmax,2)) %add tmax
text(-0.5,ymax,num2str(ymax,3)) %add ymax

%% Find Where \(y\) Reaches One Tenth of Its Maximum Value
% The next question is harder to solve.  We want to find the value of \(t\)
% satisfying
% 
% \[ 20t \textrm{e}^{-2t} =  y(t) =  y_{\max}/10 =  1/\textrm{e}.\]
%
% This is a nonlinear equation without an analytic solution.  But the
% solution may be found numerically. We think of the problem as solving for
% \(t\) satisfying
%
% \[ y(t) - y_{\max}/10 = 0.\]
%
% which means finding the zero of the function defined by \(y(t) -
% y_{max}/10\).  
%
% This can be done using the MATLAB function |fzero|.  We need to tell
% |fzero| where to look for the solution.  We know that it is to the right
% of \(t_\max\) and to the left of \(4\) because \(y(4) < y_\max/10\).

tenthymax=ymax/10; %target value of the displacement
ttenth=fzero(@(t) y(t)-tenthymax,[tmax 4]); %compute time where tenth of maximum is reached
plot([0 ttenth ttenth],[tenthymax tenthymax 0],'k--',ttenth,tenthymax,'r.') %plot these new values
text(ttenth-0.25,-0.2,num2str(ttenth,3)) %and label
text(-0.5,tenthymax,num2str(tenthymax,2)) %them
print -depsc VehicleSuspensionGraph.eps %Make an .eps file of our final figure

%% Define and plot the displacement for three cases
figure
yunder=@(t) 20*exp(-t).*sin(t); %underdamped case
yover=@(t) (10/sqrt(3))*exp(-4*t).*sinh(2*sqrt(3)*t); %overdamped case
h=plot(tplot,y(tplot),'b-',tplot,yunder(tplot),'k-',tplot,yover(tplot),'r-'); 
   %plot all three y
xlabel('time, $t$','interpreter','latex') %x-axis label
ylabel('displacement, $y$','interpreter','latex') %y-axis label
axis([0 4 -1 7]); %set horizontal and vertical axis ranges
legend(h([2 1 3]),{'underdamped','critically damped','overdamped'})
print -depsc VehicleSuspension3CaseGraph.eps %Make an .eps file
