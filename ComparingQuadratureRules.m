%% Comparing Quadrature Rules
% Here we compare the performance of various quadrature rules for various
% test functions.

%% Sample and Plot the Test Function
% Here are two test functions.  One has infinitely many derivatives, and
% the other has jump discontinuity in the first derivative.

tic
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
a = 0; b = 2; %limits of integration
alpha = -1/2; beta = 4; %parameters for the test function
f = @(x) exp(alpha*x).*cos(beta*x); %first test function
fname = 'damped_sinusoid';
integ = (1./(alpha^2 + beta^2)).*(-exp(a*alpha)*(alpha*cos(a*beta) ...
   + beta*sin(a*beta)) + exp(alpha*b)*(alpha*cos(b*beta) ...
   + beta*sin(b*beta))); %exact integral
% c = sqrt(2); f = @(x) abs(x-c); %second test function
% fname = 'vshape';
% integ = c^2-2*c+2; %exact integral
mmax = 14;
nmax = 2^mmax; %maximum number of nodes
x = a+(b-a)*(0:1/nmax:1); %places to evaluate f
fx = f(x);
figure
plot(x,fx,'-');
xlabel('\(x\)')
ylabel('\(f(x)\)')
print('-depsc',[fname '_plot.eps'])

%% Compute the Integral Using Various Quadrature Rules
% Next we compute the integral of the test function using four different
% quadrature rules.  Can you imagine which will give the better results?

leftrect = zeros(mmax,1); %initalize the rules
rightrect = leftrect; %to be zero
midpt = leftrect; %before 
trapezoidal = leftrect; %computing
Simpsons = leftrect; %the correct answer
for m = 1:mmax
   gap = 2^(mmax-m); %distance between nodes
   leftrect(m) = (b-a)*mean(fx(1:gap:nmax)); %left rectangle rule
   rightrect(m) = (b-a)*mean(fx(1+gap:gap:nmax+1)); %right rectangle rule
   midpt(m) = (b-a)*mean(fx(1+gap:2*gap:nmax+1-gap)); %midpoint rule
   trapezoidal(m) = (b-a)*mean([(fx(1)+fx(nmax+1))/2  ...
      fx(1+gap:gap:nmax+1-gap)]); %trapezoidal rule
   Simpsons(m) = ((b-a)/(3*2^m))*sum([fx(1) fx(nmax+1) ...
      4*fx(1+gap:2*gap:nmax+1-gap) ... 
      2*fx(1+2*gap:2*gap:nmax+1-2*gap)]); %Simpson's rule
end
errleftrect = abs(integ-leftrect); %compute 
errrightrect = abs(integ-rightrect); %the actual
errmidpt = abs(integ-midpt); midpt = leftrect; %error 
errtrapezoidal = abs(integ-trapezoidal); %of each
errSimpsons = abs(integ-Simpsons); %rule

%% Plot results
% Finally we plot the errors for the different rules

figure
h = loglog(2.^(1:mmax),errleftrect,'k.',2.^(1:mmax),errrightrect,'.', ...
   2.^(1:mmax),errmidpt,'.',2.^(1:mmax),errtrapezoidal,'.', ...
   2.^(1:mmax),errSimpsons,'.');
set(gca,'xtick',10.^(1:4),'ytick',10.^(-15:5:0))
xlabel('\(n\)')
ylabel('Error')
axis([1 2e4 1e-16 10])
legend(h,{'left','right','mid','trap','Simpson''s'},...
   'location','southwest')
legend('boxoff')
print('-depsc',['quadcompare_' fname '.eps'])

%%
% For smooth enough integrands:
%
% * Simpson's rule generally has the smallest error of these five rules,
% * Trapezoidal and the midpoint rules generally have the next smallest error, and
% * the rectangle rules have the worst error. 
%
% _Author: Fred J. Hickernell_
   



