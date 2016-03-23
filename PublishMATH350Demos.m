%% Publish MATH 565 Demo Scripts
% This m-file publishes as html files the sample programs used in MATH 565
% Monte Carlo Methods in Finance.
%
% First we move to the correct directory

cd(fileparts(which('PublishMATH350Demos'))) %change directory to where this is
clearvars %clear all variables
tPubStart = tic; %start timer
save('PublishTime.mat','tPubStart') %save it because clearvars is invoked by demos

%%
% The we use |publishMathJax|, which is an enhanced version of MATLAB's
% |publish| command.

%% Part I. Vehicle Suspension Example
% Simple MATLAB commands for an application problem
publishMathJax('VehicleSuspension')

%% Part I. Machine Precision and Round-Off Error
publishMathJax('RoundOffMachinePrecision')

%% Part I. Sine Function Round-Off and Truncation Error
publishMathJax('SineRoundOffTruncationError')

%% Part II. Various Methods for Solving Nonlinear Equations
publishMathJax('NonlinearEquationExamples')

%% Part III. Radial Basis Function Example
publishMathJax('RBFExample')

%% Part III. Step-By-Step Row Operations on a Matrix
publishMathJax('RowOperationsExample')

%% Part III. Interpolation Error Related to the Condition Number of a Matrix
publishMathJax('InterpolationCondition')

%% Part III. Least Squares Polynomial Fit
publishMathJax LeastSquaresFitPoly

%% Part III. Finding All Solutions to a System of Linear Equations
publishMathJax('AllSolutionsLinearEquations')

%% Part IV. Polynomial Interpolation with Uniform and Chebyshev Nodes
publishMathJax('PolynomialInterpolation')

%% Part IV. Piecewise Polynomial Interpolation with Splines and PCHIP
publishMathJax('PolySplinePCHIPExample')

%% Part IV. Convergence Rates of Various Interpolation Schemes
publishMathJax('InterpolationConvergenceExample')

%% Part IV. Using the FFT for Filtering
publishMathJax('AudioFilterExample')

%% Part V. Comparing the Errors of Different Quadrature Rules
publishMathJax('ComparingQuadratureRules')

%% Part V. Examples Using MATLAB's |integral|
publishMathJax('IntegralExamples')

%% Part V. Period of the Simple Pendulum
publishMathJax('PeriodSimplePendulum')

%% Part V. Examples of GAIL
publishMathJax('GAILExamples')

%% Part VI. Population ODE
publishMathJax('PopulationODEExample')

%%
% Clean up and publish the total time taken.
load PublishTime.mat %load back tPubStart
disp('Total time required to publish all scripts is')
disp(['   ', num2str(toc(tPubStart)) ' seconds'])
delete PublishTime.mat %delete the file because it is no longer needed