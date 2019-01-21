function [ R,T,Z ] = getRT( im1,im2,cameraParams,show,filename )
    KK = cameraParams.IntrinsicMatrix;
    I1 = im2double(rgb2gray(im1));
    I2 = im2double(rgb2gray(im2));
    POINTS1 = detectSURFFeatures(I1);
    POINTS2 = detectSURFFeatures(I2);
    [featuresI1,validPoints1] = extractFeatures(I1,POINTS1);
    [featuresI2,validPoints2] = extractFeatures(I2,POINTS2);
    indexPairs = matchFeatures(featuresI1,featuresI2);
    matchedPoints1 = validPoints1(indexPairs(:,1),:);
    matchedPoints2 = validPoints2(indexPairs(:,2),:);
    [E,inliersIndex] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,cameraParams,'Confidence', 99.99);
    if(show)
        figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
        figure; showMatchedFeatures(I1,I2,matchedPoints1(inliersIndex,:),matchedPoints2(inliersIndex,:));
    end
    
    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(inliersIndex, :);
    inlierPoints2 = matchedPoints2(inliersIndex, :);

    [orient, loc] = relativeCameraPose(E, cameraParams, inlierPoints1, inlierPoints2);
    [R, T] = cameraPoseToExtrinsics(orient, loc);
    camMatrix1 = cameraMatrix(cameraParams, eye(3), [0 0 0]);
    camMatrix2 = cameraMatrix(cameraParams, R, T);
    points3D = triangulate(inlierPoints1, inlierPoints2, camMatrix1, camMatrix2);
    Z = sum(points3D(:,3))/size(points3D,1);
    
%     [U,D,V] = svd(E);
%     W = [0 -1 0; 1 0 0; 0 0 1];
%     Hresult_c2_c1(:,:,1) = [ U*W*V'   U(:,3) ; 0 0 0 1];
%     Hresult_c2_c1(:,:,2) = [ U*W*V'  -U(:,3) ; 0 0 0 1];
%     Hresult_c2_c1(:,:,3) = [ U*W'*V'  U(:,3) ; 0 0 0 1];
%     Hresult_c2_c1(:,:,4) = [ U*W'*V' -U(:,3) ; 0 0 0 1];
% 
%     % make sure each rotation component is a legal rotation matrix
%     for k=1:4
%         if det(Hresult_c2_c1(1:3,1:3,k)) < 0
%             Hresult_c2_c1(1:3,1:3,k) = -Hresult_c2_c1(1:3,1:3,k);
%         end
%     end
% 
%     for x=1:size(inliersIndex,1)
%         if(inliersIndex(x))
%             break;
%         end
%     end
%     
%     u1 = round(matchedPoints1(x,:).Location);
%     u2 = round(matchedPoints2(x,:).Location);
%     p1 = inv(KK)*[u1 1]';
%     p2 = inv(KK)*[u2 1]';
%     
%     M1 = [ 1 0 0 0;
%            0 1 0 0;
%            0 0 1 0];
% 
%     % Get skew symmetric matrices for point number 1
%     p1x = [ 0        -p1(3,1)   p1(2,1);
%             p1(3,1)   0        -p1(1,1);
%            -p1(2,1)   p1(1,1)   0  ];
% 
%     p2x = [ 0        -p2(3,1)   p2(2,1);
%             p2(3,1)   0        -p2(1,1);
%            -p2(2,1)   p2(1,1)   0  ];
% 
%     % See which of the four solutions will yield a 3D point position that is in
%     % front of both cameras (ie, has its z>0 for both).
%     for i=1:4
%         Hresult_c1_c2 = inv(Hresult_c2_c1(:,:,i));
%         M2 = Hresult_c1_c2(1:3,1:4);
% 
%         A = [ p1x * M1; p2x * M2 ];
%         % The solution to AP=0 is the singular vector of A corresponding to the
%         % smallest singular value; that is, the last column of V in A=UDV'
%         [U,D,V] = svd(A);
%         P = V(:,4);                     % get last column of V
%         P1est = P/P(4);                 % normalize
% 
%         P2est = Hresult_c1_c2 * P1est;
% 
%         if P1est(3) > 0 && P2est(3) > 0
%             % We've found a good solution.
%             P1est(3)
%             P2est(3)
%             Z = (P1est(3)+P2est(3))/2;
%             Hest_c2_c1 = Hresult_c2_c1(:,:,i);
%             break;      % break out of for loop; can stop searching
%         end
%     end
% 
%     % Now we have the transformation between the cameras (up to a scale factor)
%     fprintf('Reconstructed pose of camera2 wrt camera1:\n');
%     disp(Hest_c2_c1);
%     
%     R = Hest_c2_c1(1:3,1:3);
%     T = Hest_c2_c1(1:3,4);
    if(filename ~= 'N')
        save(filename);
    end
end