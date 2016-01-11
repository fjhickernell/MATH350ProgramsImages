%% Publish MATH 565 Demo Scripts
% This m-file publishes as html files the sample programs used in MATH 565
% Monte Carlo Methods in Finance.
%
% First we move to the correct directory
cd(fileparts(which('PublishMATH350Demos'))) %change directory to where this is
clearvars %clear all variables
tPubStart = tic; %start timer
save('PublishTime.mat','tPubStart') %save it because clearvars is invoked by demos

%% Vehicle Suspension Example
% Simple MATLAB commands for an application problem
publishMathJax('VehicleSuspension')

%%
% Clean up and publish the total time taken.
load PublishTime.mat %load back tPubStart
disp('Total time required to publish all scripts is')
disp(['   ', num2str(toc(tPubStart)) ' seconds'])
delete PublishTime.mat %delete the file because it is no longer needed