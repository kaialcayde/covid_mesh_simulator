 function [t, x] = solveSpatialSIR(tFinal, mesh, initialCondition, ...
     alpha, beta, gamma, odeSolver)
% solveSpatialSIR Solve the spatial SIR model
% Inputs:
% tFinal: end time for the simulation (assuming start is t=0) mesh: the underlying mesh
% initialCondition: a Nx3 matrix that sums to 1 in third dimension alpha, beta, gamma: model parameters
% odeSolver: a function handle for an ode45-compatible solver
% Outputs:
%     t: a vector of the time-steps
%     x: Nx3xlength(t) matrix representing the state vs. time



% use mesh, alpha, beta, and gamma values to obtain the change in the SIR
% system over time
dSIRdt = @(t,x) dynamicsSIR(x, mesh, alpha, beta, gamma);
% this is the same as 
%   dSIRdt (t,x) =  dynamicsSIR(x, mesh, alpha, beta, gamma);


% change initialCondition matrix into an array (s, then i, then r)
[t,y] = odeSolver(dSIRdt, [0,tFinal], initialCondition(:));




% lengths for mesh and steps of time
N = length(mesh);
Nsteps = length(t);
    % fprintf("Number of nodes = %d\n", N);
    % fprintf("Number of time steps=%d\n", Nsteps);
    % fprintf("Size of y is:");
    % % y says at each timestep, we have 3350 elements (considers all S, I, R)
    % disp(size(y));

% Nsteps is length of t
% pre-allocate
x = zeros(N,3, Nsteps);
% go through time loop and obtain the values
for i = 1:Nsteps
    local_sol = y(i, :); % S,I,R values at the i-th step
    reshaped_sol = reshape(local_sol, [N,3]);   % Nx3 matrix
    x(:,:,i) = reshaped_sol;    % put location and SIR values into each step
end


 end