function dists = SURFDistance( test, trainf )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   test  - 1 Image
%   trainf - List of training SURF Features (Extracted)
%   dists - List of distances
    test = rgb2gray(test);
    points = detectSURFFeatures(test);
    f = extractFeatures(test,points);
    dists = zeros(size(trainf,2),1);
    for i = 1:size(dists)
        [~,temp] = matchFeatures(f,trainf{i});
        dists(i) = mean(temp);
    end
end

