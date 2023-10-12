% Kai Alcayde
% 505539304
% 3.2.8 Problem 2 Main Script
% solving for a spatial SIR system, and animating it as well as 
% obtaining various data using various functions that we write to solve the
% ODE's associated with it


clc; clear all; close all;
% this main script solves for a spatial SIR system on the provided mesh
% using solveSpatialSIR



%%%%%%%%%%%%%%%%%
%% Load STL
%%%%%%%%%%%%%%%%%
% call STL to load mesh
% get the timing of how long it takes to load
ticStart = tic;
mesh = stlRead("modifiedSphereSTL.txt");    % form mesh with STL read
fprintf("stlRead done in %.3f seconds\n", toc(ticStart));
N = length(mesh);   % number of nodes



%%%%%%%%%%%%%%%%%
%% SIR Parameters
%%%%%%%%%%%%%%%%%


% load the parameters
load('SIRparameters.mat');
% make initial conditions
% when pass into od45 or rk solver, need to convert this matrix into an
% array / vector
initialConditions = zeros(N, 3);

% first one person was susceptible. Wasn't infected or recovered yet. We
% will find out where the infected are next.
initialConditions(:,1) = 1; % S's  
initialConditions(:,2) = 0; % I's
initialConditions(:,3) = 0; % R's


num_infect = numel(initialInfections); % 3 places have been infected

% which locations in mesh have infection?
for i = 1:num_infect  % loop over each infected place

    % find where in mesh have infeciton
    for j = 1:N  % Loop over each node
        % distance btwn Jth node and initial infected place
        % use norm to change from vector to distance
        dist = norm(mesh(j).location - initialInfections{i} );
        % basically if it is the location (tiny distance difference)
        if dist < 1e-10
            ind = j;   % infection has happened
            break
        end
    end
    initialConditions(ind, :) = [0,1,0]; % S=0; I = 1; R = 0
end



%%%%%%%%%%%%%%%%%
%% SolveSpatialSIR
%%%%%%%%%%%%%%%%%


% solveSpatialSIR with ode45
fprintf("Calling solveSpatialSIR with ode45 ...\n");
ticStart = tic;

% finding vetor of time states, as well as Nx3Xlength(time) matrix which
% is used later in plot time series
[ty, y] = solveSpatialSIR(tFinal, mesh, initialConditions, alpha, beta, ...
    gamma, @ode45);
fprintf("Done in %.3f seconds\n", toc(ticStart));



% solveSpatialSIR with RK4
fprintf("Calling solveSpatialSIR with RK4 ...\n");
ticStart = tic;

% finding vetor of time states, as well as Nx3Xlength(time) matrix which
% is used later in plot time series
[tx, x] = solveSpatialSIR(tFinal, mesh, initialConditions, alpha, beta, ...
    gamma, @RK4);
fprintf("Done in %.3f seconds\n", toc(ticStart));


%%%%%%%%%%%%%%%%%
%% plotTimeSeries
%%%%%%%%%%%%%%%%%

fprintf("Calling plotTimeSeries at the specified coordinates...\n");
ticStart = tic;

% for all monitoring locations
for i = 1:numel(monitorLocations)
    
    % plot the time series
    plotTimeSeries(mesh, tx, x, monitorLocations{i});

end
fprintf("Done in %.3f seconds\n", toc(ticStart));


% %%%%%%%%%%%%%%%%%
%% animation
% %%%%%%%%%%%%%%%%%
 
% animate the spread
fprintf('Calling animate to generate animation...\n');
ticStart = tic;
animate(mesh, tx, x);
fprintf("Done in %.3f seconds\n", toc(ticStart));


% %%%%%%%%%%%%%%%%%
%% exporting to excel
% %%%%%%%%%%%%%%%%%
 
% write the results to excel
fprintf("Calling write2Excel to export data ..\n");
ticStart = tic;
write2Excel(mesh, tx, x, 'SIRData.xlsx');
fprintf("Done in %.3f seconds\n", toc(ticStart));





