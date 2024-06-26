% findIrisAnnulus - find circular iris boudaries in the input eye image
%
% USAGE:
%   [circlePupil, circleIris] = findIrisAnnulus(eyeimage)
%    circlePupil - inner iris edge circle parameter vector [x,y,radius]
%    circleIris - outer iris edge circle parameter vector [x,y,radius]
%
% E. Bakstein 21.11.2011
% Based on original Iris Toolbox by Libor Masek


function [circlepupil, circleiris] = findIrisAnnulus(eyeimage)

global irisConfig;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new_brightness = 0.5;
gauss_std = 15;
gauss_kern_size = 12;
thres = 0.1;

if irisConfig.MyIrisParameters == true
    gauss_kern_size = 15;
    thres = 0.05;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Normailize image to scale [0,1]
ImgOriginal = double(eyeimage) / 255;

% Brightness adjustment to 50% 
brightness = mean(ImgOriginal(:));
adjustment_factor = new_brightness - brightness;
ImgAdj = ImgOriginal + adjustment_factor; 
ImgAdj = max(0, min(1, ImgAdj)); % Cutting off out of range values

% Bluring the image
G = fspecial('gaussian',[gauss_kern_size gauss_kern_size], gauss_std); % REPORT
ImgSmooth = imfilter(ImgAdj,G);

% Detecting edges
ImgEdge = edge(ImgSmooth,'Canny',thres);

if irisConfig.showImages==1
    figure;
    % First subplot
    subplot(2, 2, 1);
    imshow(eyeimage);
    title('eyeimage');
    
    % Second subplot
    subplot(2, 2, 2);
    imshow(ImgAdj);
    title('ImgAdj');
    
    % Third subplot
    subplot(2, 2, 3);
    imshow(ImgSmooth);
    title('ImgSmooth');
    
    % Fourth subplot
    subplot(2, 2, 4);
    imshow(ImgEdge);
    title('ImgEdge');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_radius = 25;
max_radius = round(min(size(ImgEdge)) / 2);
min_x = 1;
max_x = size(ImgEdge,1);
min_y = 1;
max_y = size(ImgEdge,2);
coordinates_step = 1;
radius_step = 1;
circles_radius_diff = 40;
circles_center_diff = 10;

if irisConfig.MyIrisParameters == true
    min_radius = 60;
    circles_center_diff = 20;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HYPERPARAMETERS ZONE END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


parameters = zeros(size(ImgEdge,1) * size(ImgEdge,2), max_radius);

for x_center = min_x:coordinates_step:max_x
    for y_center = min_y:coordinates_step:max_y

        if ImgEdge(x_center, y_center) == 0
            continue
        end

        for r = min_radius:radius_step:max_radius
            % Get coordinates of circle bounders
            [y x] = circlecoords([x_center y_center], r, size(ImgEdge), 600);

            % Remove out of image coordinates
            inRangeFilter = (x >= min_x+1 & x <= max_x-1) & (y >= min_y+1 & y <= max_y-1);
            xFiltered = x(inRangeFilter);
            yFiltered = y(inRangeFilter);
            
            % Convert 2d indexes to 1d indexes
            lin_indexes = sub2ind(size(ImgEdge), xFiltered, yFiltered);

            % Remove non-unique indexes
            lin_indexes = unique(lin_indexes);

            parameters(lin_indexes,r) = parameters(lin_indexes,r) + (1/r);
        end
    end    
end


% Selecting the first circle
[maxValue, maxIndex] = max(parameters(:));
[xy_indexes, radius1] = ind2sub(size(parameters), maxIndex);
[center_x1, center_y1] = ind2sub(size(ImgEdge), xy_indexes);
circle1 = [center_x1 center_y1 radius1];

% Remove from searching space
parameters(xy_indexes,radius1) = -inf;

while 1
    % Choose the slice along the third dimension to visualize
    [maxValue, maxIndex] = max(parameters(:));
    [xy_indexes, radius2] = ind2sub(size(parameters), maxIndex);
    [center_x2, center_y2] = ind2sub(size(ImgEdge), xy_indexes);
    circle2 = [center_x2 center_y2 radius2];
    
    % Difference between two circles should be more than circles radius diff
    if abs(radius1 - radius2) < circles_radius_diff

        % Remove from searching space
        parameters(xy_indexes,radius2) = -inf;
        continue
    end
    
    % The centers of the circles can be spaced a maximum of circles center diff pixels apart on each side.
    if abs(center_x1 - center_x2) > circles_center_diff || abs(center_y1 - center_y2) > circles_center_diff
        parameters(xy_indexes,radius2) = -inf;
        continue
    end

    % Circles shouldn’t cross
    [xout,yout] = circcirc(center_x1,center_y1,radius1,center_x2,center_y2,radius2);
    if sum(isnan(xout)) == 0
        parameters(xy_indexes,radius2) = -inf;
        continue
    else
     break
    end
end

% % ab-space slices
% sliceData1 = reshape(parameters(:, radius1), size(ImgEdge, 1), size(ImgEdge, 2));
% sliceData2 = reshape(parameters(:, radius2), size(ImgEdge, 1), size(ImgEdge, 2));

if irisConfig.showImages == 1
    figure;
    imshow(ImgOriginal)
    hold on;
    viscircles([center_x1, center_y1], radius1, 'EdgeColor', 'r');
    viscircles([center_x2, center_y2], radius2, 'EdgeColor', 'g');
    title('Segmented iris');
    hold off;
end

% Setting circlepupil and circleiris
if circle1(3) < circle2(3)
     circlepupil = circle1;
     circleiris = circle2;
else
    circlepupil = circle2;
    circleiris = circle1;
end