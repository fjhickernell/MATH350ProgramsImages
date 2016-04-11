function sol = shootingMethod(f,xint,boundCond)
% SHOOTINGMETHOD solves a second-order boundary value problem by the
% shooting method using |ode45|.

shootfun = @(ypa) [1 0]*deval(ode45(f,xint,[boundCond(:,1); ypa]),xint(2)) ...
   - boundCond(:,2);
   %set up the function whose zero gives us the correct boundary condition
ypashoot = fzero(shootfun,0); %find first-derivative initial condition 
sol = ode45(f, xint, [boundCond(1), ypashoot]); %get solution as a structure variable

%%
% _Author: Fred J. Hickernell_