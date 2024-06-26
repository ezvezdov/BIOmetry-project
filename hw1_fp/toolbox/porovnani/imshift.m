function ims = imshift(im, shift)

szin = size(im);
ims = imtransform(im, maketform('affine',[1 0 ; 0 1; shift']),...
    'XData',[1 szin(2)],'YData',[1 szin(1)]);