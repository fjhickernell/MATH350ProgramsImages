%% Polynomial Interpolation Demonstrated
% Fitting a polynomial exactly to data is used to draw smooth curves
% through data and to approximate functions for more complicated purposes,
% such as calculating their integrals or solutions to differential
% equations.  However, the placement of the data sites and the derivatives
% of the function can affect the error

%% Example Using Uniform Data Sites
% Consider the following test function.  
%
% \[ f(x) = \sin(10x) \exp(-3x).\]
%
% This is not a polynomial, but we can fit a polynomial using MATLAB's
% |polyfit| and |polyval| functions.

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
testfun = @(x) sin(10*x).*exp(-3*x);
n = 11;
xunif = -1:2/(n-1):1; %uniformly spaced data sites on [-1,1]
ynodes = testfun(xunif); %function values at data sites
xeval = -1:0.001:1; %evaluation sites
yeval = polyval(polyfit(xunif, ynodes, n-1), xeval); %fit a polyonomial of degree n-1
feval = testfun(xeval); %true function values
err = max(abs(feval-yeval)); %maximum error
figure
h = plot(xeval,feval,'-',xeval,yeval,'k-',xunif,ynodes,'.');
xlabel('\(x\)')
ylabel('\(y\)')
text(-0.8,10,['error = ' num2str(err,4)])
text(-0.8,13,[int2str(n) ' uniform data sites'])
legend(h,{'true','approximation','data'},'location','southeast')
legend('boxoff')
axis([-1 1 -15 15])
eval(['print -depsc polyinterunifn' int2str(n) '.eps'])

%% 
% The error is not too bad in the middle of the interval \([-1,1\), but
% becomes large towards the endpoints of the interval.
%
% We may try more points in the hopes of getting a more accurate answer.

n = 71;
xunif = -1:2/(n-1):1; %uniformly spaced data sites on [-1,1]
ynodes = testfun(xunif); %function values at data sites
yeval = polyval(polyfit(xunif, ynodes, n-1), xeval); %fit a polyonomial of degree n-1
err = max(abs(feval-yeval)); %maximum error
figure
h = plot(xeval,feval,'-',xeval,yeval,'k-',xunif,ynodes,'.');
xlabel('\(x\)')
ylabel('\(y\)')
text(-0.8,10,['error = ' num2str(err,4)])
text(-0.8,13,[int2str(n) ' uniform data sites'])
legend(h,{'true','approximation','data'},'location','southeast')
legend('boxoff')
axis([-1 1 -15 15])

%%
% Now the problem is that the polynomial interpolation is badly conditoned.
%  The error also does not look good.

%% Barycentric Interpolation
% There is another method for polynomial interpolation called _barycentric
% interpolation_.  This is the program that performs this kind of
% interpolation:
%
% <include>barycentric.m</include>
%
% Now we use this method instead of |polyfit|.

yeval = barycentric(xunif,ynodes,xeval); %perform barycentric interpolation
err = max(abs(feval-yeval));
figure
h=plot(xeval,feval,'-',xeval,yeval,'k-',xunif,ynodes,'.');
xlabel('\(x\)')
ylabel('\(y\)')
text(-0.8,10,['error = ' num2str(err,4)])
text(-0.8,13,[int2str(n) ' uniform data sites'])
legend(h,{'true','approximation','data'},'location','southeast')
legend('boxoff')
axis([-1 1 -15 15])
eval(['print -depsc polyinterunifn' int2str(n) '.eps'])

%%
% The error is larger than with fewer nodes, but it is not primarily a
% conditioning problem.  It is a problem of a poor choice of nodes.

%% Using Chebyshev Data Sites
% High order polynomial interpolation tends to work better if the data
% sites are concentrated towards the endpoints of the interval. "Chebyshev"
% nodes are good choices.  First, we perform the interpolation for a small
% number of data sites.

n = 11;
xcheb = cos((2*(1:n)-1)*pi/(2*n)); %data sites
ynodes = testfun(xcheb); %function values at data sites
yeval = barycentric(xcheb,ynodes,xeval); %perform barycentric interpolation
err = max(abs(feval-yeval));
figure
h=plot(xeval,feval,'-',xeval,yeval,'k-',xcheb,ynodes,'.');
xlabel('\(x\)')
ylabel('\(y\)')
text(-0.8,10,['error = ' num2str(err,4)])
text(-0.8,13,[int2str(n) ' Chebyshev data sites'])
legend(h,{'true','approximation','data'},'location','southeast')
legend('boxoff')
axis([-1 1 -15 15])
eval(['print -depsc polyinterchebn' int2str(n) '.eps'])

%%
% The error is much smaller than for the uniform nodes.  Next, we perform the interpolation for a larger number of data sites.

n = 71;
xcheb = cos((2*(1:n)-1)*pi/(2*n)); %data sites
ynodes = testfun(xcheb); %function values at data sites
yeval = barycentric(xcheb,ynodes,xeval); %perform barycentric interpolation
err = max(abs(feval-yeval));
figure
h=plot(xeval,feval,'-',xeval,yeval,'k-',xcheb,ynodes,'.');
xlabel('\(x\)')
ylabel('\(y\)')
text(-0.8,10,['error = ' num2str(err,4)])
text(-0.8,13,[int2str(n) ' Chebyshev data sites'])
legend(h,{'true','approximation','data'},'location','southeast')
legend('boxoff')
axis([-1 1 -15 15])
eval(['print -depsc polyinterchebn' int2str(n) '.eps'])

%%
% The error is again much smaller than for the uniform nodes.  The message:
% if you have a choice, use Chebyshev nodes and barycentric interpolation.

%% Why Error Is Smaller for Chebyshev Nodes
% The error anlaysis of polynomial interpolation using \(n\) data says that
%
% \[ f(x) - \underbrace{p(x)}_{\text{interpolating polynomial}} =
% f^{(n)}(\xi_{x}) \frac{\overbrace{(x - x_1) \cdots (x -
% x_n)}^{\ell(x)}}{n!}, \]
%
% where \(\xi_x\) lies somewhere between the minimum and maximum of \(x,
% x_1, \cdots, x_n\).  For uniform and Chebyshev nodes \(\ell(x)\) can act
% quite differently.

ellxunif = prod(bsxfun(@minus,xeval',xunif),2);
ellxCheb = prod(bsxfun(@minus,xeval',xcheb),2);
figure
plot(xeval,ellxunif,'-')
xlabel('\(x\)')
ylabel('\(\ell_{\mbox{unif}}(x)\)')
print -depsc ellxunif.eps
figure
plot(xeval,ellxCheb,'-')
xlabel('\(x\)')
ylabel('\(\ell_{\mbox{Cheb}}(x)\)')
print -depsc ellxCheb.eps

%%
% See how much larger \(\ell(x)\) can be for uniform points, especially
% towards the endpoints of the interval.

%% A Peek at Chebfun
% The Chebfun system approximates functions by polynomials based on their
% values at the Chebyshev nodes and the allows you to do all sorts of
% things.  Here is an example

fcheb = chebfun(@(x) testfun(x),[-1,1]) %approximate the test function by a Chebyshev polynomial

%%
% We see that only a 33rd degre polynomial is all that is required to
% repsresent the test function to machine precision.

figure
plot(fcheb) %plot it
xlabel('\(x\)')
ylabel('\(f(x)\)')
derivative_of_f = diff(fcheb) %derivative of f
figure
plot(derivative_of_f) %plot f'
xlabel('\(x\)')
ylabel('\(f''(x)\)')
integral_of_f = sum(fcheb) %integrate f over its domain
antideriv_of_f = cumsum(fcheb) %compute the indefinite integral of f
figure
plot(antideriv_of_f)
xlabel('\(x\)')
ylabel('\(\int_{-1}^x f(t) \, {\rm d}t\)')
min_of_f = min(fcheb) %minimmum of the f
where_f_is_1 = roots(fcheb-1) %all roots of f-1
toc

%%
% Chebfun is pretty cool.
%
% _Author: Fred J. Hickernell_

