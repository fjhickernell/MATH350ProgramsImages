function MATH350PrepareforWork(GAIL,MATH350,Chebfun,PubDemo)
% This function downloads and installs GAIL version 2.1 into the
% location you choose
%
%   Step 1.  Place this M-file where you want GAIL to go
%
%   Step 2.  Set the MATLAB path to that same directory
%
%   Step 3.  Run this M-file in MATLAB
%
% This file installs 
% 
%    o the development branch of the latest version of GAIL, and
%
%    o the MATH350 repository
%
% where this function file is placed.  These repositories are also added to
% the MATLAB path.
%
% _Author: Fred J. Hickernell_

if nargin < 4
   PubDemo = true; %publish the demo
   if nargin < 3
      Chebfun = true; %install Chebfun
      if nargin < 2
         MATH350 = true; %install the MATH350 files
         if nargin < 1
            GAIL = true; %install GAIL
         end
      end
   end
end

%% Download the GAIL package and add to the MATLAB path
if GAIL
   disp('The GAIL package is now being downloaded...')
   unzip('https://github.com/GailGithub/GAIL_Dev/archive/develop.zip'); %download and unzip
   movefile('GAIL_Dev-develop', 'GAIL_Dev') 
   addpath(fullfile(cd,'GAIL_Dev'))
   savepath  
   movefile(['GAIL_Dev' filesep 'GAIL_Matlab' filesep 'GAILstart.m'], ...
      ['GAIL_Dev' filesep 'GAILstart.m']) %move GAILstart 
   movefile(['GAIL_Dev' filesep 'GAIL_Matlab' filesep 'GAIL_Install.m'], ...
      ['GAIL_Dev' filesep 'GAIL_Install.m']) %and GAIL_Install to the correct place
   GAIL_Install %this installs GAIL and sets the path
end

%% Download the MATH350ProgramsImages repository and add to the MATLAB path
if MATH350
   fprintf('The MATH350ProgramsImages package is now being downloaded...\n')
   unzip('https://github.com/fjhickernell/MATH350ProgramsImages/archive/master.zip'); %download and unzip
   movefile('MATH350ProgramsImages-master', 'MATH350ProgramsImages') 
   wholepath=genpath(fullfile(cd,'MATH350ProgramsImages'));% Generate strings of paths to GAIL subdirectories
   addpath(wholepath); % Add MATH350ProgramsImages directories and subdirectories
   savepath  
   fprintf('MATH350ProgramsImages has been succesfully installed.\n\n')
end

%% Download Chebfun
if Chebfun
   fprintf('The Chebfun package is now being downloaded...\n')
   unzip('https://github.com/chebfun/chebfun/archive/master.zip')
   movefile('chebfun-master', 'chebfun') 
   addpath(fullfile(cd,'chebfun'))
   savepath  
   fprintf('Chebfun has been succesfully installed.\n\n')
end

%% Test things out
if PubDemo 
   disp('Now we perform a test by publishing one demo: VehicleSuspension')
   publishMathJax VehicleSuspension
   web(['MATH350ProgramsImages' filesep 'html' filesep 'VehicleSuspension.html'])
end

end