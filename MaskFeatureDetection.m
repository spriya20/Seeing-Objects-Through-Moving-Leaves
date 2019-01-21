%%
rootFolder = fullfile(pwd,'102_1704');
categories = {'boy', 'toycar'};
trainingSet = imageDatastore(fullfile(rootFolder, categories), 'LabelSource', 'foldernames');
%%
maskFolder = fullfile(pwd,'Masked');
validationSet = imageDatastore(fullfile(maskFolder, categories), 'LabelSource', 'foldernames');
%%
tbl = countEachLabel(trainingSet)
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
% Use splitEachLabel method to trim the set.
trainingSet = splitEachLabel(trainingSet, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(trainingSet)
%%
% Find the first instance of an image for each category
boy = find(trainingSet.Labels == 'boy', 1);
%shell = find(trainingSet.Labels == 'shell', 1);
toycar = find(trainingSet.Labels == 'toycar', 1);
%%
% figure
subplot(1,3,1);
imshow(readimage(trainingSet,boy))
subplot(1,3,2);
imshow(readimage(trainingSet,shell))
subplot(1,3,3);
imshow(readimage(trainingSet,toycar))
%%
bag = bagOfFeatures(trainingSet);
categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
%confMatrix = evaluate(categoryClassifier, trainingSet);
%%
confMatrixF = evaluate(categoryClassifier, validationSet);
