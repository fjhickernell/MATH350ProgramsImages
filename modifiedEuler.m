function [tout,yout]=modifiedEuler(f,tint,y0,h)
% [tout,yout]=modifiedEuler(f,tint,h) solves the differential equation
%      y'=f(t,y), y(tint(1))=y0
% by the modified Euler method using a stepsize of h

tout=(tint(1):h:tint(2)); %vector of t values
n=numel(tout);
yout=zeros(size(y0,2),n); %initialize y values
yout(:,1)=y0; %apply initial condition
for i=1:n-1;
   fleft=f(tout(i),yout(:,i)); %f value on the left
   ytemp=yout(:,i)+h*fleft; %first guess next y value
   yout(:,i+1)=yout(:,i)+(h/2)*(fleft+f(tout(i+1),ytemp)); %next y value
end