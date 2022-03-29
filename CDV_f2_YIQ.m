function s = CDV_f2_YIQ( img )
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


Y = 0.299 * double(img(:,:,1)) + 0.587 * double(img(:,:,2)) + 0.114 * double(img(:,:,3));
I = 0.596 * double(img(:,:,1)) - 0.274 * double(img(:,:,2)) - 0.322 * double(img(:,:,3));
Q = 0.211 * double(img(:,:,1)) - 0.523 * double(img(:,:,2)) + 0.312 * double(img(:,:,3));


F1 = [0 0; -1 1];
F2 = F1';
Y1 = conv2(Y, F1, 'valid');
Y2 = conv2(Y, F2, 'valid');
I1 = conv2(I, F1, 'valid');
I2 = conv2(I, F2, 'valid');
Q1 = conv2(Q, F1, 'valid');
Q2 = conv2(Q, F2, 'valid');

c1 = sqrt(Y1.^2+I1.^2+Q1.^2);
c2 = sqrt(Y2.^2+I2.^2+Q2.^2);
c = (c1+c2)/2; 
%c = sqrt(c1.^2+c2.^2) ; 
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

