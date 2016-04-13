%Three State Disease model
clear all
close all
format short
format compact

%% Looking at first several steps in time
P=[0.8 0 0.3; 0.2 0.5 0; 0 0.5 0.7];
x0=[1;0;0]; %everyone is susceptible
nt=10;
x=[x0 zeros(3,nt)];
for i=1:nt
   x(:,i+1)=P*x(:,i);
end
disp(['The states for the first ' int2str(nt) ' times are'])
disp(x)

%% Seeking steady state
[eigvec,eigval]=eig(P);
steadystate=eigvec(:,1)/sum(eigvec(:,1))