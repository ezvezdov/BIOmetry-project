function [im2Align offset ang jadra] = align_manually(imDatabase, imVerify)
% Manual aligning of two fingeprints
%
% [im2Align offset ang jadra] =
%       align_manually(imDatabase, imVerify)

f = figure; p1 = subplot(121);
imshow(imDatabase); hold on
title('Zadejte jadro otisku (levy).')
p2 = subplot(122);
imshow(imVerify); hold on

jadra(1,1:2) = ginput(1);

figure(f);
axes(p1)
plot(jadra(1, 1), jadra(1, 2), 'r.', 'markersize', 20);
axes(p2)
title('Zadejte jadro otisku (pravy).')
jadra(2,1:2) = ginput(1);

figure(f);
axes(p2)
plot(jadra(2, 1), jadra(2, 2), 'r.', 'markersize', 20);
axes(p1)
title('Zadejte dva markanty v levem obraze.')
axes(p2)
title('')

ii = 0;
while true
    ii = ii+1;
    markanty1(ii, :) = ginput(1);
    axes(p1)
    plot(markanty1(ii, 1), markanty1(ii, 2), '.g', 'markersize', 15);
    if ii == 2, break; end
end

title('Zadejte dva markanty v pravem obraze.')
ii = 0;
while true
    ii = ii+1;
    markanty2(ii, :) = ginput(1);
    axes(p2)
    plot(markanty2(ii, 1), markanty2(ii, 2), '.g', 'markersize', 15);
    if ii == 2, break; end
end

a1 = markanty1(1, :) - jadra(1, :);
a1 = a1(1) + a1(2)*1i;

b1 = markanty1(2, :) - jadra(1, :);
b1 = b1(1) + b1(2)*1i;

a2 = markanty2(1, :) - jadra(2, :);
a2 = a2(1) + a2(2)*1i;

b2 = markanty2(2, :) - jadra(2, :);
b2 = b2(1) + b2(2)*1i;

u1 = unwrap(angle(a2)) - unwrap(angle(a1));
u2 = unwrap(angle(b2)) - unwrap(angle(b1));
uhly = [u1 u2];

if abs(uhly(1)-uhly(2)) > 180/180*pi
    uhly = sort(uhly);
    uhly(2) = uhly(2)-2*pi;
elseif abs(uhly(1)-uhly(2)) > 10/180*pi
    warning('bio:fingerprint:align','Angles between images differs in markants of more than 10 deg.');
end
ang = mean(uhly)/pi*180;
offset = jadra(1, :) - jadra(2, :);


% zarovnani vstupniho obrazku s databazovym
im2Align = imrotatearound(imshift(imVerify, offset'), ang, jadra(1,:)');