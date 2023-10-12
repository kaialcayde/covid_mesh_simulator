function animate(mesh, t, X)
% animate: a function that shows the change in the ratio of susceptible,
% infected, and recovered individuals in the grid as an image.
%   Inputs:
%       mesh: an struct of mesh information of the triangulated surface
%       t: the time vector
%       X: an N*3*length(t) matrix, where each Nx3 matrix corresponds to
%       the state of the S.I.R. system at a particular instance in time.
%       This 2D matrix is repeated for each time step, making it a 3D 
%       matrix. 
% Output: this function does not output anything.


N = length(mesh);   % number of nodes

coord = zeros(N,3); % coordinates of the nodes
color = zeros(size(X)); % colors representing S, I, R
% color = zeros(N,3, length(t));  % alternative way

for i = 1:N % loop over each node
    coord(i,:) = mesh(i).location;
end

color(:,1,:) = X(:, 2, :);  % Red for infected
color(:,2,:) = X(:, 3, :);  % Green for recovered
color(:,3,:) = X(:, 1, :);  % Blue for susceptible

figure;
currT = 0;  % current time
d = 20;
for i = 1:length(t) % loop over time
    if t(i) >= currT
        % plot with corresponding colors
    pcshow(coord, color(:, :, i), 'MarkerSize', 500);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    pause(0.1);
    drawnow
    currT = currT + 0.1 * d;    % Update current time
    end
end









end