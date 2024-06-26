function [images names] = loadfprint(id, num, database)
% funkce na nacitani otisku prstu. vzdy je mozna nacist maximalne jednoho
% cloveka, ale libovolny pocet otisku.
%
%   [images names] = loadfprint(id, num, database)
%      vstupy:  id: cislo cloveka
%               num: cislo nebo vektor cisel otisku
%               database: databaza, moznosti jsou 'upek', 'fvc02_{1-4}',
%                  fvc04_{1-4}
%      vystupy: images: matice s otiskem, pripadne cell array s vice otisky
%               names: string se jmenem otisku, pripadne cell array s vice
%                   jmeny

if nargin < 3
    database = 'upek';
    if nargin < 2
        num = 1:8;
    end
end

DataBase = false;

switch database(1:min(end,5))
    case 'upek'
        path = '../data/upek';
        type = 'png';
    case 'fvc04'
        path = ['../data/fvc04/DB' database(end) '_B'];
        type = 'tif';
        id = id + 100;
    case 'fvc02'
        path = ['../data/fvc02/DB' database(end) '_B'];
        id = id + 100;
        type = 'tif';
    case 'DataB'
        path = '../data/DataBase';
        DataBase = true;
        type = 'bmp';
end


ii = 0;
if length(num) == 1
    [images names] = load_one(num, path, id, type, DataBase);
else
    images = cell(1, length(num));
    names = cell(1, length(num));
    for m = num
        ii = ii+1;
        [im name] = load_one(m, path, id, type, DataBase);
        images{ii} = im;
        names{ii} = name;
    end
end
end


function [im name] = load_one(m, path, id, type, DataBase)
if ~DataBase
    name = [num2str(id) '_' num2str(m) '.' type];
else
    name = [num2str(id) ' (' num2str(m) ').' type];
end
[im map] = imread([path '/' name], type);

if isempty(map)
    im = im2double(im);
else
    im = im2double(reshape(map(im+1, 1), size(im)));
end
end

