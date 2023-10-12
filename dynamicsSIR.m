function dxdt = dynamicsSIR(x, mesh, alpha, beta, gamma)
% dynamicsSIR Compute the rate of change of the model
%   Inputs:
%       x: vectorized state
%       mesh: the underlying mesh
%       alpha, beta, gamma: model parameters
%   Output:
%       dxdt: vectorized time derivative of state


% length of the mesh
N = length(mesh); % length(x) / 3
% reshape vector x into N rows of [S,I,R]
x = reshape(x, [N, 3]);



derivatives = zeros(N,3);
% [dS1/dt, dI1/dt, dR1/dt;
% [dS2/dt, dI2/dt, dR2/dt;
% [dS3/dt, dI3/dt, dR3/dt;
% ...
% [dSN/dt, dIN/dt, dRN/dt;


for i=1:N % loop over nodes

%     obtain neighbor contributions
    neighborCntrbn = 0; 

    % consider neighbor contributions using the equation given. Convert 
    % it to code by considering the sumnation of the infected rate at a
    % point (x(_,2)) divided by the euclidian distance, then multiplying it
    % by the alpha over total neighbors at a point, |N(i)|
    for point = 1:length(mesh(i).neighbors)
        neighborCntrbn = neighborCntrbn + ...
            x(mesh(i).neighbors(point), 2) / ...
        vecnorm(mesh(i).location - mesh(mesh(i).neighbors(point)).location);
        % get euclidian distance
    end
    % this is the alpha over total neighbors at a point, |N(i)|
    neighborCntrbn = alpha / length(mesh(i).neighbors) * neighborCntrbn;

    % write down the SIR dynamics to model spatial influence on infection
    % rates

    %S_i(t)
    % x(i,2) is the infection rate
    % x(i,1) is the susceptibility rate
    derivatives(i,1) = - (beta * x(i,2) + neighborCntrbn) * x(i,1);
    %I_i(t)
    derivatives(i,2) = + (beta * x(i,2) + neighborCntrbn) * x(i,1) - gamma * x(i,2);
    %R_i(t)
    derivatives(i,3) = + (gamma * x(i,2));

end

% vectorize dxdt: [S1 S2 S3 ... SN I1 I2 I3 ... IN
%R1 R2 R3 ... RN] 
dxdt = derivatives(:);





end