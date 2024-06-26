% iris_demo.m - preview of the iris recognition process
% E. Bakstein 21.11.2011
% based on Iris toolbox by Libor Masek, University of Australia

%% createiristemplate CAN WORK WITH CACHE
%% SET irisConfig.MyIrisParameters 

% settings
iris_init

eyeimage_filename = "./my_iris_cropped/L1.bmp";
if irisConfig.MyIrisParameters == true
    % My iris images
    folderPath = './my_iris_cropped';
else 
    % Provided images
    folderPath = './Images';
end
files = dir(fullfile(folderPath, '*.*'));
fileNames = {files.name};
fileNames = folderPath + "/" + fileNames;


% start the encoding process:
tic

% for i = 3:numel(fileNames)
%     disp(fileNames{i})
%     [template mask] = createiristemplate(fileNames{i});
% end

% tUsing with single image
[template mask] = createiristemplate(eyeimage_filename);



disp(['iris template created in ' num2str(toc) 's']);