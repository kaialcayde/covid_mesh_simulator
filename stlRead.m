function mesh = stlRead(fileLocation)
% stlRead takes the location a modified stl file (.txt format) is ...
%  stored, reads the file, and finds the required parameters.
%   Input:
%       fileLocation: location of the tab delimited .txt file to be read
%   Output:
%       mesh: an array of structs representing the vertices. Each
%  element has members "location" and "neighbors". "location" is a 1x3 
%  array of x, y, z coordinates, and "neighbors" is an array of indices 
%  of the point's neighbors.

% read in the data
data = readcell(fileLocation, "Delimiter", '\t');

%%% NOTE: COULD HAVE PREALLOCATED BECAUSE WE KNOW HOW MANY POINTS ARE IN
% MESH, ETC. HOWEVER TO MAKE IT MORE GENERALIZED FOR ALL SITUATIONS,
% ALTHOUGH SLOWER, I DYNAMICALLY ALLOCATED MY ARRAYS
uniquePoints = [0 0 0]; % initialize with dummy variables 
mesh = [];

% go through whole file
for i = 1:size(data,1)

    if(data{i,1} == "outerLoop")
        % this is how we find a facet
        
        % now find values for each corner
        % p1,p2,p3 are corners 1,2,3 respectively
        p1 = cell2mat(data(i+1,2:end));
        p2 = cell2mat(data(i+2,2:end));
        p3 = cell2mat(data(i+3,2:end));

        % see if these points are already in our matrix. If it is, obtain
        % the value of the index of the point since we would already have
        % it.
        if(any(ismember(uniquePoints,p1,'rows')))
            index_p1 = find(ismember(uniquePoints,p1,'rows'));
            
        else % if not add it in

            % special case for first iteration, to take care of [0 0 0]
            if(i == 3)
            uniquePoints = [p1];
           index_p1 = size(uniquePoints,1);    % at very end
            mesh(end+1).location = p1;  % growing the mesh
            mesh(end).neighbors = [];   % at the end that was created
                                        % with location, make neighbors
        
            else
            uniquePoints = [uniquePoints; p1];  % add it to the end
            index_p1 = size(uniquePoints,1);    % at very end
            mesh(end+1).location = p1;  % growing the mesh
            mesh(end).neighbors = [];   % at the end that was created
                                        % with location, make neighbors
            end

        end

        % repeat for p2
        if(any(ismember(uniquePoints,p2,'rows')))
            index_p2 = find(ismember(uniquePoints,p2,'rows'));
        else % if not add it in
            uniquePoints = [uniquePoints; p2];  % add it to the end
            index_p2 = size(uniquePoints,1);    % at very end
            mesh(end+1).location = p2;  % growing the mesh
            mesh(end).neighbors = [];
        end

        % repeat for p3
        if(any(ismember(uniquePoints,p3,'rows')))
            index_p3 = find(ismember(uniquePoints,p3,'rows'));
        else % if not add it in
            uniquePoints = [uniquePoints; p3];  % add it to the end
            index_p3 = size(uniquePoints,1);    % at very end
            mesh(end+1).location = p3;  % growing the mesh because access
                                        % outside of bounds
            mesh(end).neighbors = [];
        end


        % now we have index_p1, index_p2, index_p3
        % we union only with two parts so we create a list as the second
        % point, to combine all into the nieghbors
        mesh(index_p1).neighbors = union(mesh(index_p1).neighbors, ...
            [index_p2, index_p3]);
        % do the same for other indices
        mesh(index_p2).neighbors = union(mesh(index_p2).neighbors, ...
            [index_p1, index_p3]);
        mesh(index_p3).neighbors = union(mesh(index_p3).neighbors, ...
            [index_p1, index_p2]);

    end

end

end

