function data = preprocess(mode, data)
% data = preprocess(mode, data)
%   vstupy:
%       MODE: typ predzpracovani dat, string
%               'xyp' znamena, ze z dat vytahne pouze polohu a pritlak

switch mode
    case 'xyp'
        for m = 1 : length(data)
            data{m} = data{m}(:, [1 2 7]);
        end
    case 'norm'
        for m = 1 : length(data)
            data_mu = mean(data{m});
            data_std = std(data{m});
          
            data{m} = (data{m} - data_mu) / data_std;
        end

end
