function [dbSkelp inSkelp inMinDil dwnSampleFac, f, se] = ...
    prepareAlign(dbSkel, inSkel, inMin, dwnSampleFac, f, se)

if ~exist('dwnSampleFac', 'var'), dwnSampleFac = []; end
if ~exist('f', 'var'), f = []; end
if ~exist('se', 'var'), se = []; end

if isempty(dwnSampleFac), dwnSampleFac = 2; end
if isempty(f), f = fspecial('gaussian',[8 8],  6); end
if isempty(se), se = ones(3); end

dbSkel= imcomplement(full(dbSkel));
dbSkelp = imfilter(double(dbSkel), f);
dbSkelp = dbSkelp/max(dbSkelp(:));
dbSkelp = imresize(dbSkelp, 1/dwnSampleFac);

inSkel = imcomplement(full(inSkel));
inSkelp = imfilter(double(inSkel), f);
inSkelp = inSkelp/max(inSkelp(:));
inSkelp = imresize(inSkelp, 1/dwnSampleFac);

inputMinutia = full(inMin);
inMinDil = imdilate(inputMinutia, se);

