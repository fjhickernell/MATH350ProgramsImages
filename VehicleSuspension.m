%% Calculating and Plotting a Vehicle's Suspension System

%% The Situation
% Automobiles, trucks and other vehicles have
% <http://en.wikipedia.org/wiki/Suspension_(vehicle) suspension systems>
% for keeping passengers comfortable. They are comprised of springs and
% shock absorbers and look like this:
%
% <<../ShockAbsorberSpring.jpg>>
%
% This script performs some computations related to vehicle suspension
% systems.
%
% One mathematical model for how a suspension system responds to a bump
% describes the vertical position of the vehicle, \(y\) (in centimeters),
% as a function of time, \(t\) (in seconds), as
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
% The maximum value of the function \(y\) may be found analytically by
% elementary calculus.  The first derivative of this function is
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
% which means finding the zero of the function defined by \(t \mapsto y(t) -
% y_{max}/10\).  
%
% This can be done using the MATLAB function |fzero|.  We need to tell
% |fzero| where to look for the solution.  We know that it is to the right
% of \(t_\max\) and to the left of \(4\) because \(y(4) < y_\max/10\).

tenthymax=ymax/10; %target value of the displacement
tic %start the internal stopwatch
ttenth=fzero(@(t) y(t)-tenthymax,[tmax 4]); %compute time where tenth of maximum is reached
toc %display the elapsed time 
plot([0 ttenth ttenth],[tenthymax tenthymax 0],'k--',ttenth,tenthymax,'r.') %plot these new values
text(ttenth-0.25,-0.2,num2str(ttenth,3)) %and label
text(-0.5,tenthymax,num2str(tenthymax,2)) %them
print -depsc VehicleSuspensionGraph.eps %Make an .eps file of our final figure

%%
% The time for the displacement to go back to one tenth of its maximum as
% computed by |fzero| to \(15\) significant digits is

format long %increase number of digits shown
ttenth %the answer that we were looking for
discrepancy = y(ttenth) - tenthymax %it makes y equal to one tenth of the max to 15 digits

%%
% The default error tolerance for |fzero| is close to the machine epsilon,
% denoted \(\epsilon_{\text{mach}}\) or |eps| in MATLAB:

eps %machine epsilon

%%
% |eps| is defined as the smallest number \(x\) such that \(1 + x > 1\)
% numerically. 
%
% We cannot expect to have a relative  error in our answer
% that is less than |eps|.  However, to save some time we can set the error
% tolerance to be larger than |eps|:

tic %start the internal stopwatch
ttenth = fzero(@(t) y(t)-tenthymax,[tmax 5],optimset('tolx',1e-4)) %a larger tolerance
toc %display the elapsed time
discrepancy = y(ttenth)-tenthymax %the answer is only approximately correct

%% Modeling the Vehicle Suspension
% Where does the formula for the displacement of the vehicle, \(y(t)=20t
% \textrm{e}^{-2t}\), come from?  The vehicle suspension can be modeled by
% a mass connected to spring and a damper described by a differential
% equation:
%
% \[ \underbrace{m}_{\text{mass}} \times \underbrace{y''}_{\text{acceleration}} =
% \underbrace{- 2\beta \underbrace{y'}_{\text{velocity}}}_{\text{shock
% absorbing force}} \underbrace{- k y}_{\text{spring force}}, \qquad
% y(0)=0, \ y'(0)=v_0 \]
%
% This equation may have modeling error.  The solution of this equation
% takes three possible forms with their respective names:
%
% \[ y(t) = \begin{cases}\displaystyle  \frac{v_0}{\omega}
% \textrm{e}^{-\beta t/m} \sin(\omega t), & \omega =\sqrt{km-\beta^2}/m, \
% \beta^2<km \qquad \text{underdamped},\\[1ex] \displaystyle  v_0 t
% \textrm{e}^{-\beta t/m}, & \beta^2=km \qquad \text{critically
% damped},\\[1ex] \displaystyle \frac{v_0}{\omega} \textrm{e}^{-\beta t/m}
% \sinh(\omega t), & \omega =\sqrt{\beta^2-km}/m, \ \beta^2>km \qquad
% \text{overdamped}, \end{cases} \]
%
% We write a MATLAB function named |dampedmassspring.m| to perform these
% computations.
%
% <include>dampedmassspring.m</include>
%
% This function can now be used to plot examples of all three cases

m = 4e5; %mass of one fourth of a car (since it has 4 wheels) in grams
k = 1.6e6; %spring coefficient grams/seconds^2
betacrit = 8e5; %damping coefficient in grams/seconds for critical case
betaunder = 4e5; %too small
betaover = 16e5; %damping coefficient in grams/seconds
v0 = 20; %initial velocity in centimeters/second
figure
h=plot(tplot,dampedmassspring(tplot,m,betacrit,k,v0),'b-', ... critical
   tplot,dampedmassspring(tplot,m,betaunder,k,v0),'k-', ... underdamped
   tplot,dampedmassspring(tplot,m,betaover,k,v0),'r-'); %overdamped
   %plot all three y
xlabel('time, \(t\)') %x-axis label
ylabel('displacement, \(y\)') %y-axis label
axis([0 4 -1 6]); %set horizontal and vertical axis ranges
legend(h([2 1 3]),{'underdamped','critically damped','overdamped'}) %add a legend
print -depsc VehicleSuspension3CaseGraph.eps %make an .eps file

%%
% _Author: Fred J. Hickernell_