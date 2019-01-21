%%
rootFolder = fullfile(pwd,'Objects');
categories = {'Dumbbell', 'Headphones', 'Mouse', 'Mug', 'Trimmer'};
trainingSet = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
%%
maskFolder = fullfile(pwd,'Objects/Leaves');
validationSet = imageDatastore(fullfile(maskFolder, categories), 'LabelSource', 'foldernames');
%%
tbl = countEachLabel(trainingSet)
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
trainingSet = splitEachLabel(trainingSet, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
%countEachLabel(trainingSet)
%%
for i = 1:size(trainingSet.Labels,1)
    im = rgb2gray(readimage(trainingSet,i));
    imfeature{i} = extractFeatures(im,detectSURFFeatures(im));
end
%%
class = validationSet.Labels;
for i=1:size(class,1)
    im = rgb2gray(readimage(validationSet,i));
    class(i) = KNNonSURF(imfeature,trainingSet.Labels,im,3);
end
%%
categories{6}='None';
C = confusionmat(validationSet.Labels,class,'Order',categories);
CTable = array2table(C,'RowNames',categories,'VariableNames',categories);