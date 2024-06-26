function frequencyVector = choosefrequency(frequencyArray)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts 3 representative frequencies that will be used
% to built the directional filters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% count = 1;
frequencyInterval = unique(frequencyArray);
%0.01 is the interval between 2 consecutive frequences

for i = 1 : length(frequencyInterval)
    nbPixels = find(frequencyArray == frequencyInterval(i));
    fVector(i) = length(nbPixels);   
    %compute the number of pixels that have this freq
end

for f = 1 : 3
    temp = find(fVector == max(fVector));
    frequencyVector(f) = frequencyInterval(temp(1));
    fVector(temp) = 0;
    if f == length(frequencyInterval)
        break
    end
end


frequencyVector = unique(sort(frequencyVector));