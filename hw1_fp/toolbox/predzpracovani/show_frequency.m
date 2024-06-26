function show_frequency(imOriginal, frequencyArray,step)
    if nargin < 3
        step = 30;
    end

    frequencyImage = ones(size(imOriginal));
    
    % Iterate through frequencyArray
    for k = 1:size(frequencyArray, 2)
        i = frequencyArray(2, k);  % Row index
        j = frequencyArray(3, k);  % Column index
        frequency = frequencyArray(1, k);
        
        frequencyImage((i-10):(i+step-10),(j-10):(j+step-10)) = frequency;
    end

    frequencyImage = 1 - frequencyImage;
    imshow(frequencyImage)
end
