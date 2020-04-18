function s = CDV( img )
%========================================================================
% Version 1.0
% Copyright(c) 2019 Chenyang Shi£¬Yandan Lin
% All Rights Reserved.
%
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
labImg = RGB2Lab(img);

if ndims(labImg) == 3 %images are colorful
    L = labImg(:,:,1);
    a = labImg(:,:,2);
    b = labImg(:,:,3);
    
end

F1 = [0 0; -1 1];
F2 = F1';
    
L1 = conv2(L, F1, 'valid');
L2 = conv2(L, F2, 'valid');
a1 = conv2(a, F1, 'valid');
a2 = conv2(a, F2, 'valid');
b1 = conv2(b, F1, 'valid');
b2 = conv2(b, F2, 'valid');

c = sqrt(L1.^2+L2.^2+a1.^2+a2.^2+b1.^2+b2.^2);  
  
[row, col]= size(c);
B = round(min(row, col)/16);
c_center  = c(B+1:end-B, B+1:end-B); %used from LPC_SI

MaxC = max(c_center(:));
MinC = min(c_center(:)); 
CDa = MaxC-MinC;
CDr = CDa./mean2(c_center); 
   

alpha = 0.65;
s = (CDa.^alpha).*(CDr.^(1-alpha));

end

function labImage = RGB2Lab(image)

image = double(image);
normalizedR = image(:,:,1) / 255;
normalizedG = image(:,:,2) / 255;
normalizedB = image(:,:,3) / 255;

RSmallerOrEqualto4045 = normalizedR <= 0.04045;
RGreaterThan4045 = 1 - RSmallerOrEqualto4045;
tmpR = (normalizedR / 12.92) .* RSmallerOrEqualto4045;
tmpR = tmpR + power((normalizedR + 0.055)/1.055,2.4) .* RGreaterThan4045;

GSmallerOrEqualto4045 = normalizedG <= 0.04045;
GGreaterThan4045 = 1 - GSmallerOrEqualto4045;
tmpG = (normalizedG / 12.92) .* GSmallerOrEqualto4045;
tmpG = tmpG + power((normalizedG + 0.055)/1.055,2.4) .* GGreaterThan4045;

BSmallerOrEqualto4045 = normalizedB <= 0.04045;
BGreaterThan4045 = 1 - BSmallerOrEqualto4045;
tmpB = (normalizedB / 12.92) .* BSmallerOrEqualto4045;
tmpB = tmpB + power((normalizedB + 0.055)/1.055,2.4) .* BGreaterThan4045;

X = tmpR*0.4124564 + tmpG*0.3575761 + tmpB*0.1804375;
Y = tmpR*0.2126729 + tmpG*0.7151522 + tmpB*0.0721750;
Z = tmpR*0.0193339 + tmpG*0.1191920 + tmpB*0.9503041;

epsilon = 0.008856;	%actual CIE standard
kappa   = 903.3;		%actual CIE standard
 
Xr = 0.9642;	%reference white D50
Yr = 1.0;		%reference white
Zr = 0.8251;	%reference white

xr = X/Xr;
yr = Y/Yr;
zr = Z/Zr;

xrGreaterThanEpsilon = xr > epsilon;
xrSmallerOrEqualtoEpsilon = 1 - xrGreaterThanEpsilon;
fx = power(xr, 1.0/3.0) .* xrGreaterThanEpsilon;
fx = fx + (kappa*xr + 16.0)/116.0 .* xrSmallerOrEqualtoEpsilon;

yrGreaterThanEpsilon = yr > epsilon;
yrSmallerOrEqualtoEpsilon = 1 - yrGreaterThanEpsilon;
fy = power(yr, 1.0/3.0) .* yrGreaterThanEpsilon;
fy = fy + (kappa*yr + 16.0)/116.0 .* yrSmallerOrEqualtoEpsilon;

zrGreaterThanEpsilon = zr > epsilon;
zrSmallerOrEqualtoEpsilon = 1 - zrGreaterThanEpsilon;
fz = power(zr, 1.0/3.0) .* zrGreaterThanEpsilon;
fz = fz + (kappa*zr + 16.0)/116.0 .* zrSmallerOrEqualtoEpsilon;

[rows,cols,junk] = size(image);
labImage = zeros(rows,cols,3);
labImage(:,:,1) = 116.0 * fy - 16.0;
labImage(:,:,2) = 500.0 * (fx - fy);
labImage(:,:,3) = 200.0 * (fy - fz);
end