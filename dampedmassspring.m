function y = dampedmassspring(t,m,beta,k,v0)
% DAMPEDMASSSPRING computes the displacement, |y|, at time |t| of a
% mass |m| under the influence of a restoring spring force with spring
% constant |k| and a linear friction force with constant |beta|.  The
% initial displacement is assumed to be zero and the initial velocity |v0|.

a = beta.^2 - k*m;
if a < 0 %underdamped case
   omega = sqrt(-a)/m; 
   y = (v0/omega)*exp(-(beta/m)*t).*sin(omega*t);
elseif a == 0 %critically damped case
   y = v0*exp(-(beta/m)*t).*t; 
else %overdamped case
   omega = sqrt(a)/m; 
   y = (v0/omega)*exp(-(beta/m)*t).*sinh(omega*t);
end
   