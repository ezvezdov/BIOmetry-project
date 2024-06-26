function singularityPoint = findsingularitypoint2(im, imS)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes positions of singularity point of the fingerprint, i.e. loops, deltas, archs, ...
% computes the irregularity values for every point from Fp.orientationArray
%
% input : Fp structure
% outputs : Fp.singularityPoint coord. of SP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% [x y]=find(imS);
% I=double(im(min(x):max(x),min(y):max(y)));
% mask=imS(min(x):max(x),min(y):max(y));
% mask=imresize(mask,size(I));
mask = imS;
% scalex = min(x);
% scaley = min(y);
w=16;
% Ip=padarray(I,[w w],1,'both');
Ip = im;
[Ix,Iy] = gradient(Ip);
Ixx=Ix.^2;
Iyy=Iy.^2;
Ixy=Ix.*Iy;
PDFx=zeros(size(Ip,1),size(Ip,2));
PDFy=PDFx;

for y=w+1:size(Ip,1)-w
    for x=w+1:size(Ip,2)-w

        Gxx=mean2(Ixx(y-w:y+w,x-w:x+w));
        Gyy=mean2(Iyy(y-w:y+w,x-w:x+w));
        Gxy=mean2(Ixy(y-w:y+w,x-w:x+w));

        PDFx(y,x)=Gxx-Gyy;
        PDFy(y,x)=2*Gxy;
    end
end

PDFx=PDFx(w+1:size(Ip,1)-w,w+1:size(Ip,2)-w);
PDFy=PDFy(w+1:size(Ip,1)-w,w+1:size(Ip,2)-w);
f=fspecial('gaussian',w,3.5);
PDFx=imfilter(PDFx,f);
PDFy=imfilter(PDFy,f);
% T=PDFx./PDFy;
% A1=0.5*atan(T);
% A2=0.5*atan(1./T);
B=0.5*asin(PDFx);
C=0.5*acos(PDFy);

E1=edge(sign(PDFx));
E1=bwmorph(E1,'thick');
E2=edge(sign(PDFy));
E2=bwmorph(E2,'thick');
[y1,x1]=find(E1);
[y2,x2]=find(E2);


p=[]; %look for SP
for n=1:length(x1)
    if mask(y1(n),x1(n))==1
        for m=1:length(x2)
            if (x1(n)==x2(m))&&(y1(n)==y2(m))
                if imS(y1(n), x1(n))==1;
                    p=cat(1,p,[x1(n) y1(n)]);
                end
            end
        end
    end
end


if isempty(p)
    singularityPoint = [];
    return;
else
    [pnew]=Cluster(p);
    pnew = pnew + repmat([w w], size(pnew, 1), 1);
end

% M=imag(C).*imag(B);
% M=edge(M);
% [i j]=find(M);

% Fp.imSPGrad = abs(C).*abs(B);
% [Fp.GradEdgeArray(:,1),Fp.GradEdgeArray(:,2)] = find(M);
% Fp.GradEdgeArray(:,1) = Fp.GradEdgeArray(:,1) + ones(length(Fp.GradEdgeArray(:,1)),1)*scalex;
% Fp.GradEdgeArray(:,2) = Fp.GradEdgeArray(:,2)+ ones(length(Fp.GradEdgeArray(:,2)),1)*scaley;
% % scale = [scaley,scalex];
% % s = [scaley,scalex];
% % for i=1:(size(pnew,1)-1)
% %     scale = cat(1,scale,s);
% % end
filter = false(size(im));
ind = sub2ind(size(im), pnew(:, 2), pnew(:, 1));
filter(ind) = true;
[pnewy pnewx] = find(filter .* imS);
singularityPoint = [pnewx pnewy];% + scale; 
% singularityPoint = pnew;% + scale; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pnew]=Cluster(p)

dx=diff(p(:,1));
dy=diff(p(:,2));
d=dx.^2+dy.^2;
n=unique([1;find(d>1000)+1]);
pnew=[];
for m=1:length(n)
    if n(m)==n(length(n))
        pnew=cat(1,pnew,[mean(p(n(m):size(p,1),1)) mean(p(n(m):size(p,1),2))]);
    else
        pnew=cat(1,pnew,[mean(p(n(m):n(m+1)-1,1)) mean(p(n(m):n(m+1)-1,2))]);
    end
end
pnew=round(pnew);
