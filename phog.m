function features = phog(image)
  [hr, vr] = responses(image);
  w4 = phog_helper(hr, vr, 4);
  w7 = phog_helper(hr, vr, 7);
  features = double([w4; w7]);
end

function features = phog_helper(image_horiz, image_vert, window_size)
  [width, height] = size(image_horiz);
  overlap = floor(window_size / 2);
  features = zeros(9, floor((width - window_size) / overlap) + 1, floor((height - window_size) / overlap) + 1);
  for x = 1:overlap:(width - window_size)
    for y = 1:overlap:(height - window_size)
      xrange = x : (x + window_size - 1);
      yrange = y : (y + window_size - 1);
      window_horiz = image_horiz(yrange, xrange);
      window_vert = image_vert(yrange, xrange);
      features(:, floor(x / overlap) + 1, floor(y / overlap) + 1) = count_orientations(window_horiz, window_vert);
    end
  end
  features = reshape(features, [], 1);
end

function features = phog_helper2(hr, vr, kern)
    [width, height] = size(hr);
    overlap = floor(kern/2);
    new_width = floor(width/overlap)-1;
    new_height = floor(height/overlap)-1;
    num_buckets = 9;

    feat = zeros(new_width, new_height, num_buckets);
    parfor i = 1:new_width-kern
        for j = 1:new_height-kern
            effi = i*overlap;
            effj = j*overlap;
            xrange = effi:(effj+kern-1);
            yrange = effj:(effj+kern-1);
            window_horiz = hr(xrange, yrange);
            window_vert = vr(xrange, yrange);

            angles = arrayfun(@(hr, vr) atan2(hr, vr), window_horiz, window_vert);
            buckets = angles / (2*pi/num_buckets);

            for k = 1:num_buckets
                feat(i,j,k) = sum(sum((buckets == (i-1))));
            end
        end
    end

    features = double(reshape(feat,[],1));
    features = features / sum(features);

end

function hist = count_orientations(window_horiz, window_vert)
  %magnitudes = arrayfun(@(hr, vr) sqrt(hr^2 + vr^2), window_horiz, window_vert);
  orientations = arrayfun(@(hr, vr) atan2(hr, vr), window_horiz, window_vert);
  orientations = floor(orientations / (2 * pi / 9));
  results = zeros(9, 1);
  for i = 1:9
    %results(i) = sum(sum(magnitudes .* (orientations == (i - 1))));
    results(i) = sum(sum((orientations == (i - 1))));
  end
  summed_results = sum(results);
  if(summed_results > 0)
    hist = results / summed_results;
  else
    hist = results;
  end
end

function [hr, vr] = responses(image)
  tap = [-1, 0, 1];
  hr = convn(image, tap);
  vr = convn(image, tap');
end

function y = gauss_deriv(x)
  sigma = 2;
  y = (1 / (sigma * sqrt(2 * pi))) * -x * exp(- x^2 / (2 * sigma^2));
end

function [hr, vr] = gauss_responses(image)
  filter = arrayfun(@gauss_deriv, -10:10);
  hr = convn(image, filter);
  vr = convn(image, filter');
end
