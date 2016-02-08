%% Radial Basis Function Interpolation Example
%%
% Professor Greg Fasshauer in our department is an expert in this subject
% and has written two monographs, one with an IIT BS alumnus:
%
% G. E. Fasshauer, _Meshfree Approximation Methods with MATLAB_,
% Interdisciplinary Mathematical Sciences, vol. 6, World Scientific
% Publishing Co., Singapore, 2007.
%
% G. E. Fasshauer and M. McCourt, _Kernel-based Approximation Methods using
% MATLAB_, Interdisciplinary Mathematical Sciences, vol. 19, World
% Scientific Publishing Co., Singapore, 2015.
%
% In this script we do some demos.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters

%% The Idea
% The problem is one of fiting a curve or surface through a set of data
% points: 
%
% \[ (\boldsymbol{x}_1, y_1), \ldots, (\boldsymbol{x}_n,y_n), \qquad
% \text{where } y_i=f(\boldsymbol{x}_i), \ \boldsymbol{x}_i \in \mathbb{R}^d,
% \]
%
% where \(f\) is not known explicitly, but we have a way to find values of
% \(f\).  Given a certain kernel with certain properties that we will not
% discuss, e.g., 
%
% \[ K(\boldsymbol{t},\boldsymbol{s})=\mathrm{e}^{-\gamma^2[(t_1-s_1)^2 + \cdots +
% (t_d-s_d)^2]}, \]
% 
% one a assumes that the true function $f$ can be approximated by
%
% \[ \tilde{f}(\boldsymbol{t}) = \sum_{j=1}^n
% K(\boldsymbol{t},\boldsymbol{x}_j) c_j. \]
%
% where \(\boldsymbol{c}=(c_1, \ldots, c_n)^T\), must be determined.  These
% coefficients are determined by forcing the approximation to fit the data:
% 
% \[ y_i=f(\boldsymbol{x}_i) = \tilde{f}(\boldsymbol{x}_i) = \sum_{j=1}^n
% K(\boldsymbol{x}_i,\boldsymbol{x}_j) c_j, \qquad i=1, \ldots, n. \]
% 
% The equations determining \(\boldsymbol{c}\) may be written in
% vector-matrix form:
% 
% \[
% \underbrace{\begin{pmatrix}
% y_1 \\
% y_2 \\
% \vdots \\
% y_n 
% \end{pmatrix}}_{\boldsymbol{y}}
% =
% \underbrace{\begin{pmatrix}
% K(\boldsymbol{x}_1,\boldsymbol{x}_1) & \cdots & K(\boldsymbol{x}_1,\boldsymbol{x}_n) \\
% K(\boldsymbol{x}_2,\boldsymbol{x}_1) & \cdots & K(\boldsymbol{x}_2,\boldsymbol{x}_n) \\
% \vdots & & \vdots \\
% K(\boldsymbol{x}_n,\boldsymbol{x}_1) & \cdots & K(\boldsymbol{x}_n,\boldsymbol{x}_n) 
% \end{pmatrix}}_{\mathsf{K}}
% \underbrace{\begin{pmatrix}
% c_1 \\
% c_2 \\
% \vdots \\
% c_n 
% \end{pmatrix}}_{\boldsymbol{c}}, \qquad
% \text{so } \boldsymbol{c}=\mathsf{K}^{-1}\boldsymbol{y}
% \]

%% Numerical Experiment with Uniform Data Sites
% Let's try a simple test function for which we know the answer and see how
% well this method performs.  We will approximate this test function using
% equally spaced data points.  We choose the kernel function based on the
% parameter \(\gamma = 1\).

f=@(x) x.*cos(3*x.*x); %test function
tic %start the clock
n=20; %number of data sites
x=(0:2/(n-1):2)'; %uniform data sites
y=f(x); %function data
gamma=1; %kernel parameter
Kernel=@(t,s) exp(-(gamma.*bsxfun(@minus,t,s')).^2); %kernel function
Kmat=Kernel(x,x); %Gram matrix
c=Kmat\y; %coefficients
xplot=(0:0.005:2)'; %points to plot function and its approximation
fplot=f(xplot); %true function values at plotting points
fappxplot=Kernel(xplot,x)*c; %approximate function values at plotting points
esterr=max(abs(fplot-fappxplot));
toc

%% 
% Here we plot the true test function, its approximation, and the data
% used to aproximate it.  

figure; 
h=plot(xplot,fplot,'-',xplot,fappxplot,'k-',x,y,'r.');
xlabel('\(t\)')
ylabel('\(f(t)\)')
legend(h,{'true \(f\)','approximation \(\tilde{f}\)','data'}, ...
   'location','northwest','box','off')
text(0.1,-1.5,['\(\gamma\) = ' num2str(gamma)])
text(0.1,-1.8,['Error = ' num2str(esterr)])
eval(['print -depsc RBFExgam' num2str(gamma) '.eps']);
disp(['Approximation error = ' num2str(esterr)])
disp(['Condition of K matrix = ' num2str(cond(Kmat))])

%%
% Notice that the condition number of the matrix \(\mathsf{K}\) is very
% large.  This is an indication that \(\mathsf{K}\) may be close to singular.
%
% Here is a plot of the kernel function that we use.

figure; plot(xplot,Kernel(xplot,5/6),'-')
xlabel('\(t\)')
ylabel('\(K(t,5/6)\)')
text(1.5,1,['\(\gamma\) = ' num2str(gamma)])
axis([0 2 -0.1 1.1])
eval(['print -depsc RBFKernelgam' num2str(gamma) '.eps']);

%% Numerical Experiment with _Random_ Data Sites
% This radial basis function method for interpolation does not depend on
% the data sites having a particular structure.  We may try randomly placed
% data sites.

tic %start the clock
x=2*rand(n,1); %random data sites
y=f(x); %function data
Kmat=Kernel(x,x); %Gram matrix
c=Kmat\y; %coefficients
xplot=(0:0.005:2)'; %points to plot function and its approximation
fplot=f(xplot); %true function values at plotting points
fappxplot=Kernel(xplot,x)*c; %approximate function values at plotting points
esterr=max(abs(fplot-fappxplot));
toc

%% 
% Again we plot the true test function, its approximation, and the data
% used to aproximate it.  

figure; 
h=plot(xplot,fplot,'-',xplot,fappxplot,'k-',x,y,'r.');
xlabel('\(t\)')
ylabel('\(f(t)\)')
legend(h,{'true \(f\)','approximation \(\tilde{f}\)','data'}, ...
   'location','northwest','box','off')
text(0.1,-1.3,['\(\gamma\) = ' num2str(gamma)])
text(0.1,-1.8,['Error = ' num2str(esterr)])
eval(['print -depsc RBFExgam' num2str(gamma) 'Rand.eps']);
disp(['Approximation error = ' num2str(esterr)])
disp(['Condition of K matrix = ' num2str(cond(Kmat))])

%%
% The error is not as good as before because of the poor spacing of the
% data sites, but the method still works for values of \(x\) within the
% range of data sites.  _Extrapolation can be dangerous_.

%% Numerical Experiment with Larger \(\gamma\)
% Now let's choose a larger \(\gamma\) to make the kernel function more
% peaked.

tic %start the clock
x=(0:2/(n-1):2)'; %uniform data sites
y=f(x); %function data
gamma=10; %larger kernel parameter
Kernel=@(t,s) exp(-(gamma.*bsxfun(@minus,t,s')).^2); %kernel function
Kmat=Kernel(x,x); %Gram matrix
c=Kmat\y; %coefficients
xplot=(0:0.005:2)'; %points to plot function and its approximation
fplot=f(xplot); %true function values at plotting points
fappxplot=Kernel(xplot,x)*c; %approximate function values at plotting points
esterr=max(abs(fplot-fappxplot));
toc

%% 
% Again we plot the true test function, its approximation, and the data
% used to aproximate it.

figure; 
h=plot(xplot,fplot,'-',xplot,fappxplot,'k-',x,y,'r.');
xlabel('\(t\)')
ylabel('\(f(t)\)')
legend(h,{'true \(f\)','approximation \(\tilde{f}\)','data'}, ...
   'location','northwest','box','off')
text(0.1,-1.5,['\(\gamma\) = ' num2str(gamma)])
text(0.1,-1.8,['Error = ' num2str(esterr)])
eval(['print -depsc RBFExgam' num2str(gamma) '.eps']);
disp(['Approximation error = ' num2str(esterr)])
disp(['Condition of K matrix = ' num2str(cond(Kmat))])

%%
% Notice that the condition number of the matrix \(\mathsf{K}\) is not as
% large, but the error now approximation error for the radial basis
% function method is larger.
%
% Here is a plot of the kernel function that we use.

figure; plot(xplot,Kernel(xplot,5/6),'-')
xlabel('\(t\)')
ylabel('\(K(t,5/6)\)')
text(1.5,1,['\(\gamma\) = ' num2str(gamma)])
axis([0 2 -0.1 1.1])
eval(['print -depsc RBFKernelgam' num2str(gamma) '.eps']);

%%
% If you are interested in these problems, you should investigate the
% summer research experience led by Professors Fasshauer and Hickernell,
% <http://math.iit.edu/~openscholar/meshfree/event/summer-research-monte-carlo-methods-finance>.
%
% _Author: Fred J. Hickernell_