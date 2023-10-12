function [coeffOrth, pcaData] = myPCA(data)
% myPCA analyzes the principal components of given COVID-19 statistical
% data from multiple countries - covid_countries.csv
% Inputs:
% data: A nxp matrix representing only the numerical parts of
% the dataset
% Outputs:
% coeffOrth: a pxp matrix whose columns are the eigenvectors
% corresponding to the sorted eigenvalues
% pcaData: a nxp matrix representing the data projected onto 
% the principal components

numRows=height(data); % find number of rows in data
numColumns=width(data); %find number of columns in data
dataCopy = data;
Normdata = data;

avgs = zeros(1,numColumns);
stDev = zeros(1, numColumns);

% standardize the data
% for each column, find avg and standard deviation
for j = 1:numColumns 

    currentAvg = 0;

%     compute avg of current column
    for i = 1:numRows
        currentAvg = currentAvg + dataCopy(i, j);
    end

    % put into avgs array
    avgs(1,j) = currentAvg / numRows;
    

%   compute standard deviation
currentStDev = 0;

%   for each number: subtract the Mean and square each result while
%   adding them all together
    for i = 1:numRows
        dataCopy(i, j) = (dataCopy(i,j) - currentAvg)^2;
        currentStDev = currentStDev + dataCopy(i, j);
    end

    % then divide by one less than num of items in column and square root
    % it
    currentStDev = sqrt( currentStDev / (numRows-1));

    % put into standard deviations
    stDev(1,j) = currentStDev;

end


for j = 1:numColumns
    % subtract average of each column fromn each element
    Normdata(:, j) = data(:, j) - avgs(1, j);

    % divide each element of the column by the stdev
    Normdata(:, j) = Normdata(:, j) / stDev(1, j); 

end


% covariance matrix
C = (Normdata' * Normdata) / (numRows - 1);

% computing eigen stuff
[eigenVectorMatrix, eigenValueMatrix] = eig(C);

% sort in descending order
[orderedEigenVectors] = sortEigen(eigenVectorMatrix, eigenValueMatrix);

coeffOrth = orderedEigenVectors;


% E2D is first 2 eigenvectors
E2D = orderedEigenVectors(:, 1:2);

% only care about 2D most important 2 eigenvectors
% multiply normalized data by first 2 eigenvectors
pcaData = Normdata * E2D;


end


















