function plotTimeSeries(mesh, t, X, coord)
% plotTimeSeries: a function that plots and saves the local S.I.R ...
%  distribution at spatial coordinate (x, y, z).
%   Inputs:
%       mesh: an struct of mesh information of the triangulated surface
%       t: a vector of time steps
%       X: an N*3*length(t) matrix, where each point in the M*3 space
%       corresponds to a local S.I.R. model with states whose values ...
%  are between 0 and 1. This 2D matrix is repeated for each time step, ...
%  making it a 3D matrix.
%       coord: a 1*3 vector of local vertex's coordinate
%   Outputs:
%       This function has no outputs

N = numel(t);   % number of steps
Nloc = size(X,1); % number of locations
spotInX = 0;    % will tell where in mesh, which is connected to the state

% make t column vector so it is graphable
t = t';
S = zeros(N, 1);   % susceptible rate over time
I = zeros(N, 1);   % infected rate over time 
R = zeros(N, 1);   % recovered rate over time

% find locations in the mesh of the coord
for i = 1:Nloc
    if mesh(i).location == coord
        spotInX = i;    % store the value of the location index once found
    end
end

% m = ismember(mesh.location, coord, 'rows');


% loop through all time
for i = 1:N
    S(i) = X(spotInX, 1, i);  % susceptible rate at ith step
    I(i) = X(spotInX, 2, i);  % infected rate at ith step
    R(i) = X(spotInX, 3, i);  % recovered rate at ith step
end




% make coordinates into string to use for title
formatString = 'Local S.I.R. distribition at spatial coordinate (%.2f,%.2f,%.2f).';
str = sprintf(formatString, coord(1), coord(2), coord(3));

figure;
% title for everything
sgtitle(str);

% subplot for susceptibles
subplot(3, 1, 1);
plot(t, S, 'b');
xlabel('time');
ylabel('Susceptible ratio');
grid on

% subplot for infections
subplot(3, 1, 2);
plot(t, I, 'r');
xlabel('time');
ylabel('Infected ratio');
grid on

% subplot for recovered
subplot(3, 1, 3);
plot(t, R, 'g');
xlabel('time');
ylabel('Recovered ratio');

grid on


% save as a png
formatString = 'time_series_%.2f_%.2f_%.2f.png';
fin = sprintf(formatString, coord(1), coord(2), coord(3));
saveas(gcf, fin, 'png');




end