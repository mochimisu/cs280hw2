function results = q3(gauss_filter, normalize, use_full)
  if nargin < 1
    gauss_filter = false;
  end
  if nargin < 2
    noramlize = true;
  end
  if nargin < 3
    use_full = false;
  end
  fn = @phog_features
  if not(normalize)
    fn = @phog_features_unnormalized
  end
  if gauss_filter
    fn = @phog_features_gauss
  end
  results = run_svm(fn, use_full);
  
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
    new_size = 2097;
    max = size(images,3);
    features = zeros(new_size, max);
    parfor i = 1:max
        features(:,i) = double(phog(images(:,:,i), false, true));
    end;
end

function features = phog_features_unnormalized(images)
    new_size = 2097;
    max = size(images,3);
    features = zeros(new_size, max);
    parfor i = 1:max
        features(:,i) = double(phog(images(:,:,i), false, false));
    end;
end

function features = phog_features_gauss(images)
    new_size = 2097;
    max = size(images,3);
    features = zeros(new_size, max);
    parfor i = 1:max
        features(:,i) = double(phog(images(:,:,i), true, true));
    end;
end


