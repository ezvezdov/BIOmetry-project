function freqim =  freqestfft(imc)
% Funkce pocitajici frekvencni pole vyuzitim Rychle Fourierovy
% transformace.
%   freqim =  freqestfft(imc)
%   	imc - vyrez obrazku otisku s papilarnimi liniemi

imcd = im2double(imc); 

% vypocet FFT a prehozeni kvadrantu pomoci fftshift, aby byla nulta
% spektralni cara (stredni hodnota) uprostred obrazku.
fi = fftshift(abs(fft2(imcd - mean(imcd(:)))));

% vyuziti pouze poloviny spektra
fi = fi(:, ceil(end / 2) : end); mid = [ceil(size(fi, 1) / 2), 1];
fi(mid(1), mid(2) + 1) = fi(mid(1), mid(2) + 1) / 10;

% nalezeni nejvyssiho peaku ve spektru a vypocet jeho vzdalenosti od nulte
% spektralni cary
[xm ym] = find(fi == max(fi(:)));
dd = sqrt(sum(([xm ym] - repmat(mid, [length(xm), 1])) .^ 2, 2));
dd = dd(dd > sqrt(2)); dd = mean(dd); dd(isnan(dd)) = 0;
freqim = dd / size(imc, 1);