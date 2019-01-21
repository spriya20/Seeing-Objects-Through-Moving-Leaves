clc;
clear all;
im1 = imread('Images/im1.jpg');
im2 = imread('Images/im2.jpg');
im3 = imread('Images/im3.jpg');
load('NikonValues.mat');
%% 
[R3,T3,Z3] = getRT(im3,im1,cameraParams,1,'N');
T3 = T3'; 
[R2,T2,Z2] = getRT(im2,im1,cameraParams,1,'N');
T2 = T2';
%%
O = [0 0 0]';
M1 = [eye(3) O];
M2 = [R2 T2];
M3 = [R3 T3];
%%
K = cameraParams.IntrinsicMatrix;
K = K';
Hi2 = K*R2*inv(K);
Hi3 = K*R3*inv(K);
S2 = (K*T2)/(-1*Z2);
S3 = (K*T3)/(-1*Z3);
%%
new_im = im1;
for r = 1:4000
%     r
    for c = 1:6000
        x = [c,r,1];
        w = Hi2*x'+S2;
        Y = round(w(1)/w(3));
        X = round(w(2)/w(3));
        if X>0 && Y>0 && X < 4000 && Y < 6000
            new_im(X,Y,:) = new_im(X,Y,:)/2 + im2(r,c,:)/2;
        end
    end
end
% for r = 1:4000
% %     r
%     for c = 1:6000
%         x = [c,r,1];
%         w = Hi3*x'+S3;
%         Y = round(w(1)/w(3));
%         X = round(w(2)/w(3));
%         if X>0 && Y>0 && X < 4000 && Y < 6000
%             new_im(X,Y,:) = new_im(X,Y,:) + im3(r,c,:)/3;
%         end
%     end
% end
