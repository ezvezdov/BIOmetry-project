% iris_init.m - initialize Iris toolbox, set path, constants etc
% E. Bakstein 21.11.2011
% initialize variables, constants etc.

% settings
global irisConfig;

irisConfig.databasePath = 'Data/'; % path to image database
irisConfig.useCache = true;
irisConfig.MyIrisParameters = true;

if irisConfig.MyIrisParameters == true
    irisConfig.loNoiseThreshold = 0.2; % MY IRIS
else
    irisConfig.loNoiseThreshold = 100; % REPORT
end

irisConfig.cachePath = [irisConfig.databasePath 'cache/'];
irisConfig.diagPath = [irisConfig.databasePath 'consecutive/'];
irisConfig.showImages = 0;

addpath('Normal_encoding','Segmentation','ToDo');