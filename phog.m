function features = phog(image)
  [hr, vr] = responses(image);
  w4 = phog_helper(hr, vr, 4);
  w7 = phog_helper(hr, vr, 7);
  features = double([w4; w7]);
end

function features = phog_helper(image_horiz, image_vert, window_size)
  [width, height] = size(image_horiz);
  overlap = floor(window_size / 2);
  features = zeros(9, 1, floor((width - window_size) / overlap), floor((height - window_size) / overlap));
  for x = 1:overlap:(width - window_size)
    for y = 1:overlap:(height - window_size)
      xrange = x : (x + window_size - 1);
      yrange = y : (y + window_size - 1);
      window_horiz = image_horiz(yrange, xrange);
      window_vert = image_vert(yrange, xrange);
      features(:, :, x, y) = count_orientations(window_horiz, window_vert);
    end
  end
  features = reshape(features, [], 1);
end

function hist = count_orientations(window_horiz, window_vert)
  orientations = arrayfun(@(hr, vr) atan2(hr, vr), window_horiz, window_vert);
  orientations = floor(orientations * (2 * pi / 9));
  results = zeros(9, 1);
  for i = 1:9
    results(i) = sum(orientations(:) == (i - 1));
  end
  hist = results / sum(results);
end

function [hr, vr] = responses(image)
  tap = [-1, 0, 1];
  hr = convn(image, tap);
  vr = convn(image, tap');
end