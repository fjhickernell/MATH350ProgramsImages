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

%% Find Where \(y\) Reaches Maximum
% The maximum value of the function \(y\) may be found by elementary
% calculus operations.  The first derivative of this function is 
%
% \[ \frac{\textrm{d}y}{\textrm{d}t} = 20 \textrm{e}^{-2t}(1 -2t)\]
%

tmax=1/2; %time of maximum computed using calculus
ymax=y(tmax); %value of maximum displacement
hold on %to add further elements to the plot
plot([0 tmax tmax],[ymax ymax 0],'k--',tmax,ymax,'r.') %plot maximum
text(tmax-0.2,-0.2,num2str(tmax,2)) %add tmax
text(-0.5,ymax,num2str(ymax,3)) %add ymax

%% Find where y reaches one tenth of maximum and plot it
tenthymax=ymax/10; %target value of the displacement
ttenth=fzero(@(t) y(t)-tenthymax,[tmax 4]); %compute time where tenth of maximum is reached
plot([0 ttenth ttenth],[tenthymax tenthymax 0],'k--',ttenth,tenthymax,'r.')
text(ttenth-0.25,-0.2,num2str(ttenth,3))
text(-0.5,tenthymax,num2str(tenthymax,2))

%% Print it to a figure
print -depsc VehicleSuspensionGraph.eps %Make an .eps file

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
