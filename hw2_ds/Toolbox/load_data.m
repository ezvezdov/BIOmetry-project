function [data clss] = load_data(source, input)
% [data clss] = load_data(source, input)
%   vstupy:
%       SOURCE je string oznacujici zdroj dat
%       INPUT jsou vstupni parametry metody, zadavaji se jako struktura
%               INPUT.id je id subjektu, ktereho podpisy chceme nacist
%   
%   vystupy:
%       DATA je cell array s jednotlivymi nactenymi daty v raw formatu
%       CLSS je zarazeni do class, pole stejne delky jako vstupni DATA s 0
%       oznacujucu v datech pozici originalu a 1 oznacujuci pozici
%       falsifikatu
    

switch source
    case 'SVC'
        fpath = './SVC2004';
        id = input.id;
        clss = [zeros(20, 1); ones(20, 1)];
end

data = cell(length(clss), 1);
for m = 1 : length(data)
    txtfile = sprintf('U%dS%d.TXT', id, m);
    fname = fullfile(fpath,txtfile);
    %fid = fopen(fname);
    fid = fileread(fname);
    
    % nacteni dat
    mat = textscan(fid,'%f %f %f %f %f %f %f','Delimiter',' ','HeaderLines',1);
    
    
    data{m} = cell2mat(mat);
end