function features = pyramid_features(images)
    %change this later, hardcoded for now
    kernel_size = 4;
    new_size = 28-kernel_size+1;
    max = size(images, 3);
    features = zeros(new_size * new_size, max);
    for i = 1:max
        features(:,i) = double(pyramid_feature(images(:,:,i), kernel_size));
    end;
    %features = double(reshape(arrayfun(@(image) pyramid_feature(image, kernel_size), images), new_size*new_size, []));
end
