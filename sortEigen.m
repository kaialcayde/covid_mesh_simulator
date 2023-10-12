function [orderedEigenVectors] = sortEigen(eigenVectorMatrix, eigenValueMatrix)
% SortEigen obtains the isolated eigenValues from myPCA and applies
% insertion sort to both the eigenVectors and Values to order them in
% descending order (greatest to least)
% inputs:
% eigenVectorMatrix - matrix of all eigenvectors
% eigenValueMatrix - diagonal matrix of all eigenvalues
% otuputs:
% orderedEigenVectors,orderedEigenValues respectively (self explanatory,
% they are ordered)

% used another version of insertion sort I learned previously as the code given in week 8 was
% confusing to me


numColumns=width(eigenValueMatrix); %find number of columns in eigenvaluematrix

tempEigenValues = zeros(1, numColumns);    % this array will store all eigenvalues only

% find eigenvalue in each col
for j = 1:numColumns
    % find each individual eigenvalue along diagonal
    tempEigenValues(1, j) = eigenValueMatrix(j, j);
end

% Insertion sort in descending order
N = length(tempEigenValues);

% first consider every index after the first (because we'll be inserting
% them, can't insert the first index)
% then 
for i = 2:N
    dummy = i;    
    % in the current spot we are on, we compare teh current element to the
    % one before. If the element before is smaller than the current,
    % keep looping and replace as we go though each iteration
    while(dummy > 1) && (tempEigenValues(dummy) > tempEigenValues(dummy-1))
    
        % store the values of interest into a temporary variable
        temporary = tempEigenValues(1, dummy);
        temporary2 = eigenVectorMatrix(:, dummy);

        % replace them with the ones that came before
        tempEigenValues(dummy) = tempEigenValues(dummy-1);
        eigenVectorMatrix(:, dummy) = eigenVectorMatrix(:, dummy-1);

        % do the switch using the temp trick
        tempEigenValues(dummy-1) = temporary;
        eigenVectorMatrix(:, dummy-1) = temporary2;

        % decrease the dummy iteration
        dummy = dummy-1;
    end
end

% set the new organized eigenvectormatrix to the one we output
orderedEigenVectors = eigenVectorMatrix;


end




