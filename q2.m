function results = q2(use_full)
  if nargin < 1
    use_full = false;
  end
  results = run_svm(@pyramid_features, use_full);
  
  sample_axis = [100 200 500 1000 2000 5000 10000 60000]
  if not(use_full)
    sample_axis = sample_axis(1:7)
  end
      
  plot(sample_axis,results)
end
