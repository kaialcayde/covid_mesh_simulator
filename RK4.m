function [t, y] = RK4(f, tspan, y0)
% RK4 Bogacki-Shampine method of RK4 with adaptive step size
%   Inputs:
%       f: function handle of f(t, y)
%       tspan: the time period for simulation (should be a 1x2 array 
%              contain start time and end time)
%       y0: the initial conditions for the differential equation
%   Outputs:
%       t: corresponding time sequence as a T x 1 vector
%       y: the solution of the differential equation as a T x n matrix, 
%          where T is the number of time steps and n is the dimension of y
 

    y(:,1) = y0; % make everyting column vectors for ease, dont have to transpose everything
    t = []; % dynamically grow matrix

    % initialize variables  
    hO = 0.1;
    eO = 1e-4;  % target error
    tO = tspan(1);  % obtain starting time
    tf = tspan(2);  % obtain ending time

    % set initial to k variables
    hk = hO;
    tk = tO;
    yk = y0;
    
    % while we haven't surpased the full time
    while tk < tf

        % find the min time step
        hk = min(hk, tf - tk);
        tkp1 = tk + hk;

        % have various slopes at various points along the
        % line
        k1 = f(tk, yk);
        k2 = f(tk + 0.5 * hk, yk + 0.5 * hk * k1);
        k3 = f(tk + 0.75 * hk, yk + 0.75 * hk * k2);

        % which later on accumulate to form the basis of our final
        % approximations
        ykp1 = yk + (2/9) * hk * k1 + (1/3) * hk * k2 + (4/9) * hk * k3;
        k4 = f(tk + hk, ykp1);
        zkp1 = yk + (7/24) * hk * k1 + 0.25 * hk * k2 + (1/3) * hk * k3 ...
            + (1/8) * hk * k4;

        % consistently keep column vector notation
        % store tkp1 and ykp1 in t and y respectively
        y(:,end+1) = ykp1;
        t = [t,tkp1];


        % find the best approximations for e, which goes into h, our
        % timestep factor
        ekp1 = vecnorm(ykp1 - zkp1);
        hkp1 = hk * (eO / ekp1) ^ 0.2 ;

        % iterate vars
        tk = tkp1;
        hk = hkp1;
        yk = ykp1;

    end

    % transpose the matrix back
    y = y';
end
