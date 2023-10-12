% Kai Alcayde
% 505539304
% 3.1.2 Problem 1 Main Script
% Main Component Analysis with PCA
% This problem aims to realize PCA (principal component analysis)
% for our covid_countries.csv data, in which we reduce dimensionality and 
% identify which components / principal components are most important.

clear all; close all; clc;
% 1. load covid_countries.csv
country_data = readtable('covid_countries.csv', 'VariableNamingRule', 'preserve');

% all rows starting from column 3 to the  to avoid the words
dataDuct = table2array(country_data(:, 3:end));

% 2. call myPCA with the loaded data
    % coeffOrth are eigenvectors sorted
    % pcaData is data projected onto space spanned by eigenvectors
[coeffOrth,pcaData1] = myPCA(dataDuct);


% 3. Use MATLAB ’s biplot function to visualize the first two principal component eigenvectors
    % obtain variables
vbls = country_data.Properties.VariableNames;
    %   don't want data and country variables
vbls = vbls(3:end);

% changing pcaData and eigenvectors to only the 2D
pcaData2D = pcaData1(:,1:2);
E2D = coeffOrth(:,1:2);

% biplot it. pcaData2D are the red dots, E2D are the lines
% need to add axis labels
biplot(E2D, 'Scores', pcaData2D, 'Varlabels', vbls);

saveas(gcf, 'biplot.png');



% 4. Provide explanations for what the axes of the plot represent and describe how the features
% are correlated to the two principal components.
% FIXME: use matlab
% component 1 is the eigenvector that distinguishes between 
% component 2 is the eigenvector that distinguishes between 

