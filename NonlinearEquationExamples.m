%% Nonlinear Equations: Solving Them *Fast* Without Becoming *Furious*
% Many nonlinear equations cannot be solved analytically.  That is, one
% cannot find the solution of
%
% \[
% f(x) = 0,
% \]
%
% for an arbitrary real-valued function, \(f\).  We call such solutions
% _roots_.  We also call them zeros of \(f\).

%% Bisection Method
% Let's try an example where we cannot solve the equation by hand:

InitializeWorkspaceDisplay %initialize the workspace and the display parameters
format short e
f1 = @(x) exp(x) - 5*x %test function whose zeros are unknown
f1([-10 1 10]) %evaluate the function at three different points

%%
% In fact we can plot this function, but normally we do not want to do this
% in practice because it takes too much time.

xplot = (-3:0.01:3);
plot(xplot, f1(xplot), 'b-', xplot, zeros(size(xplot)), 'k-')
xlabel('\(x\)')
ylabel('\(f_1(x)\)')

%%
% We can see that there is a zero of \(f\) between \(1\) and \(10\), as
% well as another zero between \(-10\) and \(1\).  By successively
% splitting this interval we can converge to the zero.  This is called the
% bisection method.  Here is the program
%
% <include>bisection.m</include>
%
% Here is the example:

tic, [z1Bisection,nitBisection] = bisection(f1,1,10), toc %find a zero by the bisection method
f1(z1Bisection) %check whether the function value is close to zero

%% 
% This is _not the fastest_, especially in terms of the number of
% iterations that are required.  For example, if we consider a simple
% function with a huge initial interval, we may take a large number of
% steps. 

f2 = @(x) x + 0.5*sin(x) - pi; % a simple linear function
tic, [z2Bisection,nitBisection] = bisection(f2,-realmax,realmax), toc %find a zero by the bisection method
f2(z2Bisection) %check whether the function value is close to zero

%%
% However, the bisection method is generally safe, i.e., it will _not make you
% furious_.

%% Newton's Method
% This method uses both function values and derivative values to find the
% zero.  At each step a straight line approximation is used.

f1p = @(x) exp(x) - 5 %we need to compute the derivative on our own for this method

%%
%
% <include>Newton.m</include>
%

tic, [z1Newton,nitNewton] = Newton(f1,f1p,1), toc %Newton's method
f1(z1Newton) %check whether the function value is close to zero

%%
% Newton's method takes much fewer iterations because it models the
% function in a better way than just looking at its sign.  Note that for
% this function, Newton's method finds a different zero than the bisection
% method. Although Newton's method is _fast_, it can make you _furious_,
% because it may not converge. Here is another function

f3 = @(x) log(5*x)./x + 1;
f3p = @(x) (1 - log(5*x))./(x.*x);
xplot = (0.1:0.01:3);
plot(xplot, f3(xplot), 'b-', [0 3], [0 0], 'k-')
xlabel('\(x\)')
ylabel('\(f_3(x)\)')
tic, [z3Newton,nitNewton] = Newton(f3,f3p,1), toc %Newton's method
f3(z3Newton) %check whether the function value is close to zero

%%
% Although the initial guess of \(1\) did not work, we may obtain the root
% by starting with another initial guess.

tic, [z3Newton,nitNewton] = Newton(f3,f3p,0.1), toc %Newton's method
f3(z3Newton) %check whether the function value is close to zero

%% Secant Method
% We may avoid the need for a derivative by using two points (like the
% bisection method), but now drawing a line through them and identifying
% the place where the line intersects the \(x\)-axis.  This is the secant
% method.
%
% <include>secant.m</include>
%
% Let's try it on our earlier examples.

tic, [z1secant,nitsecant] = secant(f1,1,10), toc %find a zero by the secant method
f1(z1Bisection) %check whether the function value is close to zero

tic, [z3secant,nitsecant] = secant(f3,0.1,1), toc %find a zero by the secant method
f3(z3secant) %check whether the function value is close to zero

%%
% Here we see that secant has the same problem with \(f_3\) that Newton's
% method does, since the secant method is not a bracketing method.  A
% modification of secant that makes it a bracketing method is called _false
% position_.  Unfortunately this method can be much slower than the secant
% method.  The best method is the next one.

%% Brent's method |fzero|
% Brent's method combines the best aspects of bisection and secant.  It is
% a bracketing method, but it converges quickly.  It is _fast_, and will
% not make you _furious_.  Here we find the two zeros of \(f_1\):

tic, [z1aBrent,f1aBrent,~,output] = fzero(f1,[1,10]), toc %find one zero of f1 by Brent's method
tic, [z1bBrent,f1bBrent,~,output] = fzero(f1,[-5,1]), toc %find the other zero of f1 by Brent's method

%%
% Next we find the zero of \(f_3\):

tic, [z3Brent,f3Brent,~,output] = fzero(f3,[0.1,1]), toc %find a zero of f3 by Brent's method

%%
% _Author:  Fred J. Hickernell_