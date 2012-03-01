function features = phog(image, gauss_filter, normalize)
  if gauss_filter
    [hr, vr] = gauss_responses(image);
  else
    [hr, vr] = responses(image);
  end
  w4 = phog_helper(hr, vr, 4, normalize);
  w7 = phog_helper(hr, vr, 7, normalize);
  features = double([w4; w7]);
end

function [hr, vr] = responses(image)
  tap = [-1, 0, 1];
  hr = convn(image, tap, 'same');
  vr = convn(image, tap', 'same');
end

function y = gauss_deriv(x)
  sigma = 2;
  y = (1 / (sigma * sqrt(2 * pi))) * -x * exp(- x^2 / (2 * sigma^2));
end

function [hr, vr] = gauss_responses(image)
  filter = arrayfun(@gauss_deriv, -10:10);
  hr = convn(image, filter, 'same');
  vr = convn(image, filter', 'same');
end

%O(nk): summed area tables
function features = phog_helper(hr, vr, kern, normalize)
    [width, height] = size(hr);
    overlap = floor(kern/2);
    new_width = floor(width/overlap)-1;
    new_height = floor(height/overlap)-1;
    num_buckets = 9;

    angles = arrayfun(@(hr, vr) atan2(hr, vr), hr, vr);
    buckets = floor(angles / (2 * pi / num_buckets));

    feat = zeros(new_width, new_height, num_buckets);

    %summed area
    padded_width = width + 2*overlap;
    padded_height = height + 2*overlap;
    summed_area = zeros(num_buckets, padded_width, padded_height);

    parfor i = 1:num_buckets
        summed_area(i,:,:) = padarray(cumsum(cumsum((buckets==i),1),2), [overlap overlap]);
    end

    parfor i = 1:new_width
        for j = 1:new_height
            effi = i*overlap;
            effj = j*overlap;

            results = zeros(num_buckets,1);

            for k = 1:num_buckets
                results(k) = summed_area(k,effi+kern, effj+kern) + ...
                summed_area(k,effi,effj) - summed_area(k,effi+kern, effj) - ...
                summed_area(k,effi, effj+kern); 
            end
            summed_results = sum(results)
            if (summed_results > 0) && normalize
              feat(i,j,:) = results / summed_results;
            else
              feat(i,j,:) = results;
            end

        end
    end

    features = double(reshape(feat,[],1));

end


%O(nk^2), n: image size, kxk kernel
function features = phog_helpersq(hr, vr, kern, normalize)
    [width, height] = size(hr);
    overlap = floor(kern/2);
    new_width = floor(width/overlap)-1;
    new_height = floor(height/overlap)-1;
    num_buckets = 9;

    angles = arrayfun(@(hr, vr) atan2(hr, vr), hr, vr);
    buckets = floor(angles / (2 * pi / num_buckets));

    feat = zeros(new_width, new_height, num_buckets);
    parfor i = 1:new_width-2
        for j = 1:new_height-2
            effi = i*overlap;
            effj = j*overlap;
            xrange = effi:(effi+kern-1);
            yrange = effj:(effj+kern-1);

            cur_buckets = buckets(xrange,yrange);

            results = zeros(num_buckets,1);
            for k = 1:num_buckets
              results(k) = sum(sum((cur_buckets == (k-1))));
            end
            summed_results = sum(results)
            if(summed_results > 0) && normalize
              feat(i,j,:) = results / summed_results;
            else
              feat(i,j,:) = results;
            end

        end
    end

    features = double(reshape(feat,[],1));

end



%old
function features = phog_helperold(image_horiz, image_vert, window_size, normalize)
  [width, height] = size(image_horiz);
  overlap = floor(window_size / 2);
  features = zeros(9, floor((width - window_size) / overlap) + 1, floor((height - window_size) / overlap) + 1);
  for x = 1:overlap:(width - window_size)
    for y = 1:overlap:(height - window_size)
      xrange = x : (x + window_size - 1);
      yrange = y : (y + window_size - 1);
      window_horiz = image_horiz(yrange, xrange);
      window_vert = image_vert(yrange, xrange);
      features(:, floor(x / overlap) + 1, floor(y / overlap) + 1) = count_orientations(window_horiz, window_vert, normalize);
    end
  end
  features = reshape(features, [], 1);
end
function hist = count_orientations(window_horiz, window_vert, normalize)
  %magnitudes = arrayfun(@(hr, vr) sqrt(hr^2 + vr^2), window_horiz, window_vert);
  orientations = arrayfun(@(hr, vr) atan2(hr, vr), window_horiz, window_vert);
  orientations = floor(orientations / (2 * pi / 9));
  results = zeros(9, 1);
  for i = 1:9
    %results(i) = sum(sum(magnitudes .* (orientations == (i - 1))));
    results(i) = sum(sum((orientations == (i - 1))));
  end
  summed_results = sum(results);
  if(summed_results > 0) && normalize
    hist = results / summed_results;
  else
    hist = results;
  end
end

