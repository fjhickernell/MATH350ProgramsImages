function [tout,yout]=Euler(f,tint,y0,h)
% [tout,yout]=Euler(f,tint,h) solves the differential equation
%      y'=f(t,y), y(tint(1))=y0
% by Euler's method using a stepsize of h

tout=(tint(1):h:tint(2)); %vector of t values
n=numel(tout); %number of t values
yout=zeros(size(y0,2),n); %initialize y values
yout(:,1)=y0; %apply initial condition
for i=1:n-1;
   yout(:,i+1)=yout(:,i)+h*f(tout(i),yout(:,i)); %next y value
end