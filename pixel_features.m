function features = pixel_features(images)
%PIXEL_FEATURE Summary of this function goes here
%   Detailed explanation goes here
  features = double(reshape(images, 28*28, []));
end

%How we ran it:
%load('train_small.mat')
%load('test.mat')
%svm = train_linear_svm(pixel_feature(train{1}.images), train{1}.labels);
%pred_labels = predict_linear_svm(pixel_feature(test.images), svm)
%sum(not(logical(pred_labels - test.labels)))