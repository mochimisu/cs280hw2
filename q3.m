function results = q3(use_full)
  if nargin < 1
    use_full = false;
  end
  results = run_svm(@phog_features, use_full);
  
  sample_axis = [100 200 500 1000 2000 5000 10000 60000];
  error_max = [1 1 1 1 1 1 1 1];
  if not(use_full)
    sample_axis = sample_axis(1:7);
    error_max = error_max(1:7);
  end
  
  error = error_max - results/10000;
      
  plot(sample_axis,error);
end

function features = phog_features(images)
    %new_size = 2286;
    new_size = 2214;
    max = size(images,3);
    features = zeros(new_size, max);
    parfor i = 1:max
        features(:,i) = double(phog(images(:,:,i)));
    end;
end