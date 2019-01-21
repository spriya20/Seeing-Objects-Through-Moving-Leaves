function classLabel = KNNonSURF( imfeatures, classLabels, testImage, K )
%KNNonSURF Summary of this function goes here
%   Detailed explanation goes here
%   imfeatures  - 1xN Cell of extracted SURF Features
%   classLabels - Nx1 Array of class labels
%   testImage   - Greyscale Image to be classified
%   K           - Number of neighbours
%   Distance Used : matchFeatures measuremetric
    points = detectSURFFeatures(testImage);
    f = extractFeatures(testImage,points);
    dists = [];
    classes = [];
    for i = 1:size(imfeatures,2)
        [~,temp] = matchFeatures(f,imfeatures{i});
        dists = [dists;temp];
        for j = 1:size(temp)
            classes = [classes;classLabels(i)];
        end
    end
    if(size(dists,1)==0)
        classLabel = 'None';
    else
        indices = zeros(K,1);
        for i = 1:K
            [~,indices(i)] = min(dists);
            dists(indices(i)) = NaN;
        end
        classLabels = [];
        for i = 1:K
            classLabels =[classLabels;classes(indices(i))];
        end
        classLabel = mode(classLabels);
    end
end

