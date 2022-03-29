function s = CDV_f8( img )
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
%labImg = RGB2Lab(img);

%if ndims(labImg) == 3 %images are colorful
%    L = labImg(:,:,1);
%    a = labImg(:,:,2);
%    b = labImg(:,:,3);
    
%end

L = 0.06 * double(img(:,:,1)) + 0.63 * double(img(:,:,2)) + 0.27 * double(img(:,:,3));
M = 0.30 * double(img(:,:,1)) + 0.04 * double(img(:,:,2)) - 0.35 * double(img(:,:,3));
N = 0.34 * double(img(:,:,1)) - 0.60 * double(img(:,:,2)) + 0.17 * double(img(:,:,3));



%F1 = [0 0; -1 1];
%F2 = F1';
F1 = [-1 0 0;0 1 0; 0 0 0];
F2 = [0 -1 0;0 1 0; 0 0 0];
F3 = [0 0 -1;0 1 0; 0 0 0];
F4 = F2';
F5 = [0 0 0;0 1 -1; 0 0 0];
F6 = F3';
F7 = F5';
F8 = [0 0 0;0 1 0; 0 0 -1];


L1 = conv2(L, F1, 'valid');
L2 = conv2(L, F2, 'valid');
L3 = conv2(L, F3, 'valid');
L4 = conv2(L, F4, 'valid');
L5 = conv2(L, F5, 'valid');
L6 = conv2(L, F6, 'valid');
L7 = conv2(L, F7, 'valid');
L8 = conv2(L, F8, 'valid');

a1 = conv2(M, F1, 'valid');
a2 = conv2(M, F2, 'valid');
a3 = conv2(M, F3, 'valid');
a4 = conv2(M, F4, 'valid');
a5 = conv2(M, F5, 'valid');
a6 = conv2(M, F6, 'valid');
a7 = conv2(M, F7, 'valid');
a8 = conv2(M, F8, 'valid');

b1 = conv2(N, F1, 'valid');
b2 = conv2(N, F2, 'valid');
b3 = conv2(N, F3, 'valid');
b4 = conv2(N, F4, 'valid');
b5 = conv2(N, F5, 'valid');
b6 = conv2(N, F6, 'valid');
b7 = conv2(N, F7, 'valid');
b8 = conv2(N, F8, 'valid');

l = L1.^2+L2.^2+L3.^2+L4.^2+L5.^2+L6.^2+L7.^2+L8.^2;
A = a1.^2+a2.^2+a3.^2+a4.^2+a5.^2+a6.^2+a7.^2+a8.^2;
B = b1.^2+b2.^2+b3.^2+b4.^2+b5.^2+b6.^2+b7.^2+b8.^2;
c = sqrt(l+A+B);  
  
[row, col]= size(c);
B = round(min(row, col)/16);
c_center  = c(B+1:end-B, B+1:end-B); %used from LPC_SI

MaxC = max(c_center(:));
MinC = min(c_center(:)); 
CDa = MaxC-MinC;
%CDr = CDa./mean2(c_center); 
CDr = mean2(c_center)./MaxC;   

alpha = 0.65;
s = (CDa.^alpha).*(CDr.^(1-alpha));
%s = (CDa.^alpha);
%s = alpha.*CDa+(1-alpha).*CDr;
%s=  mad( (s(:) .^ 0.5) .^ 0.5 )^0.15;

end

