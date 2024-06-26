function imrt = imrotatearound(im, ang, pt)
% Funkce slouzi k otaceni obrazku okolo daneho bodu proti smeru hodinovych
% rucicek.
%
%   imrt = imrotatearound(im, ang, pt)
%       input: im - vstupni obraz, pole rozmetu M x N, trida double
%       ang: uhel ve stupnich
%       pt: stred otaceni [x; y]. sour. system: 0,0 ---> x
%                                                |
%                                                |
%                                                v
%                                                y

szin = size(im);
st = szin / 2 + .5; 
str = [st(2); st(1)];

imr = imrotate(im, ang, 'crop');
Rm = [cosd(ang) sind(ang); -sind(ang) cosd(ang)];

move = (pt - str) - Rm*(pt - str);
imrt = imtransform(imr, maketform('affine',[1 0 ; 0 1; move']),...
    'XData',[1 szin(2)],'YData',[1 szin(1)]);