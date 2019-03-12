addpath(genpath(pwd)); 
% Initialize variables for calling datasets_feature 
function info = load('images/filelist.mat'); 
datasets = {'demo'}; 
train_lists = {info.train_list}; 
test_lists = {info.test_list}; 
feature = 'color'; 
% Load the configuration and set dictionary size to 20 (for fast demo) 
c = conf(); 
c.feature_config.(feature).dictionary_size=20; 
% Compute train and test features datasets_feature(datasets, train_lists, test_lists, feature, c); 
% Load train and test features train_features = load_feature(datasets{1}, feature, 'train', c); test_features = load_feature(datasets{1}, feature, 'test', c);

% Below is a simple nearest-neighbor classifier % The images have a border color of black and white to indicate the two % different classes in the demo dataset. % Display train images in Figure 1 train_labels = info.train_labels; classes = info.classes; unique_labels = unique(train_labels); numPerClass = max(histc(train_labels, unique_labels)); h = figure(1); set(h, 'name', 'Train Images'); border = 10; for i=1:length(unique_labels) idx = find(train_labels==unique_labels(i)); for j=1:length(idx) subplot(length(unique_labels), numPerClass, j+(i-1)*numPerClass); im = imread(train_lists{1}{idx(j)}); im = padarray(im, [border border], 255*(i-1)/(length(unique_labels)-1)); imshow(im); title(sprintf('Example: %d, Class: %s', j, classes{unique_labels(i)})); end end % Display test images and nearest neighbor from train images in Figure 2 test_labels = info.test_labels; classes = info.classes; numPerClass = max(histc(test_labels, unique_labels)); h = figure(2); set(h, 'name', 'Test Images'); border = 10; [~, nn_idx] = min(sp_dist2(train_features, test_features)); for i=1:length(unique_labels) idx = find(test_labels==unique_labels(i)); for j=1:length(idx) subplot(length(unique_labels), numPerClass*2, 2*(j-1)+1+(i-1)*numPerClass*2); im = imread(test_lists{1}{idx(j)}); im = padarray(im, [border border], 255*(i-1)/(length(unique_labels)-1)); imshow(im); title(sprintf('Example: %d, Class: %s', j, classes{unique_labels(i)})); subplot(length(unique_labels), numPerClass*2, 2*(j-1)+2+(i-1)*numPerClass*2); im = imread(train_lists{1}{nn_idx(idx(j))}); im = padarray(im, [border border], 255*(train_labels(nn_idx(idx(j)))-1)/(length(unique_labels)-1));
imshow(im); 
title(sprintf('Nearest neighbor, predicted class: %s', classes{train_labels(nn_idx(idx(j)))})); 
end end