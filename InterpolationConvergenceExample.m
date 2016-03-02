%% The Convergence of Various Interpolation Methods
% In class we have looked at polynomial and piecewise polynomial
% interpolation methods.  It is not always easy to know their convergence
% rates because these may depend on the placement of nodes, the smoothness
% of the function being interpolated, as well as the interpolation method.
% Here we investigate the convergence rates experimentally.

%% Testing using uniform data sites and polynomial interpolation 
% First we initialize the test functoin and the numbers of sites to be
% investigated.
InitializeWorkspaceDisplay %initialize the workspace and the display parameters
tic
testfun = @(x) sin(10*x).*exp(-3*x); %infinitely smooth test function but with larg derivatives
%testfun = @(x) abs(x - pi/10); %infinitely smooth test function with small derivatives
nvec = 2.^(3:11); %numbers of sites
nn = numel(nvec); %number of 
xeval = -1:0.00005:1; %evaluation sites
feval = testfun(xeval); %true function values
errupoly = ones(nn,1); %initialize these
errcpoly = ones(nn,1); %vectors
erruspline = ones(nn,1); %containing
errupchip = ones(nn,1); %errors
for i = 1:nn
   n = nvec(i); %number of data sites
   xunif = -1:2/(n-1):1; %uniform data sites
   yunif = testfun(xunif); %function values at uniform data sites
   xcheb = cos((2*(1:n) - 1)*pi/(2*n)); %Chebyshev data sites
   ycheb = testfun(xcheb); %function values at Chebyshev data sites
   yupoly = barycentric(xunif,yunif,xeval); %barycentric interpolation
   ycpoly = barycentric(xcheb,ycheb,xeval); %barycentric interpolation
   yuspline = spline(xunif,yunif,xeval); %spline interpolation
   yupchip = pchip(xunif,yunif,xeval); %PCHIP interpolation
   errupoly(i) = max(abs(feval-yupoly)); %evaluate the
   errcpoly(i) = max(abs(feval-ycpoly)); %errors for
   erruspline(i) = max(abs(feval-yuspline)); %each kind of
   errupchip(i) = max(abs(feval-yupchip)); %interpolation
end
disp('Convergence orders of ...')
disp('  polynomial interpolation with uniform data sites:')
disp(-diff(log(errupoly')))
disp('  polynomial interpolation with Chebyshev data sites:')
disp(-diff(log(errcpoly')))
disp('  spline interpolation uniform data sites:')
disp(-diff(log(erruspline')))
disp('  PCHIP interpolation uniform data sites:')
disp(-diff(log(errupchip')))
   
%% Plot errors
figure
h = loglog(nvec,errupoly,'.',nvec,errcpoly,'k.',...
   nvec,erruspline,'.',nvec,errupchip,'.');
xlabel('\(n\)')
ylabel('Absolute Error')
legend(h,{'unif, poly','Cheb, poly','unif, spline','unif, PCHIP',},...
   'location','northeast')
legend('boxoff')
axis([6 2200 1e-16 1e20])
set(gca,'xtick',10.^(1:3),'ytick',10.^(-16:8:16))
print -depsc polyinterconvergence.eps
toc

%%
% Here are some observations
% 
% * polynomial interpolation with many uniform nodes is ill-conditioned,
% the round-off error will kill you
% * polynomial interpolation with Chebyshev nodes may be very accurate if
% the function is very smooth
% * the cubic spline may be a bit better than PCHIP, but both are not
% highly accurate.  They can do better with uniform nodes than polynomial
% interpolation.
%
% _Author: Fred J. Hickernell_