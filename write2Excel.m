function write2Excel(mesh, t, X, filename)
% write2Excel: a function that stores the vertices' locations, the ...
%  ratios of infected, susceptible and recovered in an Excel file.
%   Inputs:
%       mesh: an struct of mesh information of the triangulated surface
%       t: a vector of time steps
%       X: an N*3*length(t) matrix, where each Nx3 matrix corresponds to
%       the state of the S.I.R. system at a particular instance in time.
%       This 2D matrix is repeated for each time step, making it a 3D ...
%  matrix.
%       filename: the name of Excel file used to store data
%   Output: this function does not output anything.

% filename is 'SIRData.xlsx'

N = numel(t);   % number of steps
Nloc = size(X,1); % number of locations

x = zeros( Nloc, 1); % xcoord
y = zeros( Nloc, 1); % ycoords
z = zeros( Nloc , 1); % zcoords
S = zeros(Nloc, 1);   % susceptible rate
I = zeros(Nloc, 1);   % infected rate
R = zeros(Nloc, 1);   % recovered rate

% variable names for labes
varNames = {'CoordinateX', 'CoordinateY', 'CoordinateZ', ...
    'Susceptible Rate', 'Infected Rate', 'Recovered Rate'};

% X,Y, Z coords
% store coords of cities, which won't change so we find them before the
% loop
for(j=1:1178)
    x(j) = mesh(j).location(1);
    y(j) = mesh(j).location(2);
    z(j) = mesh(j).location(3);
end

% set initial old time at first step
t_old = t(1);

% for all time
for i = 1:N

    % without going over bounds
    if(i+1 <= N)

        % if t2 - t1 < 15
        % special first case when i = 1
        if (t(i)- t_old >= 15 || i == 1)
    
            % disregard first case when i = 1
            % else update the new old time
            if(i ~= 1)
            t_old = t(i);
            end
          
            S(:) = X(:, 1, i);  % susceptible rate at ith step
            I(:) = X(:, 2, i);  % infected rate at ith step
            R(:) = X(:, 3, i);  % recovered rate at ith step
            
            % store into a table, which will be written into filename
            % after
            T = table(x, y, z, S, I, R, 'VariableNames', varNames);
            nameOfSheet = sprintf('t = %f', t(i));
            writetable(T, filename, 'Sheet', nameOfSheet, 'Range', 'A1');
            
        end
    end
end


end