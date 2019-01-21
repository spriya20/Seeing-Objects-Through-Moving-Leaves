% clc;
% clear all;
im1 = imread('102_1704/SFM/SAI/toycar/DKS28910.jpg');
im2 = imread('102_1704/SFM/SAI/toycar/DKS28912.jpg');
% im3 = imread('MaskedToys/Minnie/DKS28317.jpg');
im0 = imread('102_1704/SFM/SAI/toycar/DKS28911.jpg');
% im4 = imread('MaskedToys/Minnie/DKS28319.jpg');
% im5 = imread('MaskedToys/Minnie/DKS28320.jpg');
load('PentaxCamCalib.mat');
%% 

[R1,T1,Z1] = getRTbest(im0,im1,cameraParams,1,'N');
T1 = T1';

[R2,T2,Z2] = getRTbest(im0,im2,cameraParams,1,'N');
T2 = T2';

% [R3,T3,Z3] = getRTbest(im0,im3,cameraParams,1,'N');
% T3 = T3';
% 
% [R4,T4,Z4] = getRTbest(im0,im4,cameraParams,1,'N');
% T4 = T4';
% 
% [R5,T5,Z5] = getRTbest(im0,im5,cameraParams,1,'N');
% T5 = T5';

%%
K = cameraParams.IntrinsicMatrix;
K = K';
Hi1 = K*R1*inv(K);
Hi2 = K*R2*inv(K);
% Hi3 = K*R3*inv(K);
S1 = (K*T1)/(-1*Z1);
S2 = (K*T2)/(-1*Z2);
% S3 = (K*T3)/(-1*Z3);
%%
% r = [1:size(im1,1)];
% c = [1:size(im1,2)];

tic;
new_im = im0/3;
for r = 1:size(im0,1)
    for c = 1:size(im0,2)
        x = [c,r,1];
        w = Hi1*x'+S1;
        Y = round(w(1)/w(3));
        X = round(w(2)/w(3));
        if X>0 && Y>0 && X <= size(im0,1) && Y <= size(im0,2)
            new_im(X,Y,:) = new_im(X,Y,:) + im1(r,c,:)/3;
        end
        w = Hi2*x'+S2;
        Y = round(w(1)/w(3));
        X = round(w(2)/w(3));
        if X>0 && Y>0 && X <= size(im0,1) && Y <= size(im0,2)
            new_im(X,Y,:) = new_im(X,Y,:) + im2(r,c,:)/3;
        end
%         w = Hi3*x'+S3;
%         Y = round(w(1)/w(3));
%         X = round(w(2)/w(3));
%         if X>0 && Y>0 && X <= size(im0,1) && Y <= size(im0,2)
%             new_im(X,Y,:) = new_im(X,Y,:) + im3(r,c,:)/3;
%         end
    end
end
toc