function results = run_svm(feature_func, use_full)
  if nargin < 2
      use_full = false;
  end
  load('train_small.mat');
  load('test.mat');
  results = zeros(1, 7 + use_full);
  for i = 1:7
    params = train_svm(feature_func, train{i});
    pred_labels = predict_svm(feature_func, params, test);
    %benchmark(pred_labels, test.labels);
    results(i) = num_correct(pred_labels, test.labels)
  end
  if use_full
    load('train.mat');
    params = train_svm(feature_func, train);
    pred_labels = predict_svm(feature_func, params, test);
    results(8) = num_correct(pred_labels, test.labels)
  end
end

function n = num_correct(predictions, labels)
  % NUM_CORRECT Counts how many predictions were correct.
  n = sum(not(logical(predictions - labels)));
end

function svm_params = train_svm(feature_func, train_struct)
  features = feature_func(train_struct.images);
  svm_params = train_linear_svm(features, train_struct.labels);
end

function predictions = predict_svm(feature_func, params, test_struct)
  features = feature_func(test_struct.images);
  predictions = predict_linear_svm(features, params);
end