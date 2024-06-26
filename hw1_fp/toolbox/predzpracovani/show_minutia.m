function show_minutia(im1, imSkeleton, minArray, f)
% Plot minutiae found in a fingerprint
%
% show_minutia(im1, imSkeleton, minArray, f)
% Input: im1 - original fingerprint image
%        imSkeleton - skeletonized fprint image
%        minArray - minutiae array
%        f - figure handle (optional, defult new figure)

if nargin < 4
    figure;
else
    figure(f);
end

subplot(121); imshow(full(imSkeleton));% title('kostra otisku po vycisteni')
subplot(122); imshow(im1); hold on
[x1 y1] = find(minArray == 1); [x2 y2] = find(minArray == 2);
plot(y1,x1,'r.','markersize',8); plot(y2,x2,'ob','markersize',8);
legend('End of Ridge', 'Bifurcation');
%title('v otisku vyznacene markanty')