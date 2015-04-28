function [keypoints, descriptors] = parse_sift(sift_filepath)

    % keypoints   = 4   x N, single, (x, y, scale, orientation)
    % descriptors = 128 x N, uint8

    keypoints = [];
    descriptors = [];

    % Attempt to open the file for reading.
    file = fopen(sift_filepath, 'rb');
    if file == -1
        disp(['ERROR: failed to open file: ' sift_filepath])
        return
    end

    % Read the SIFT file header.
    header = 'SIFTV4.0';
    data = fread(file, [1, length(header)], '*char');
    if ~strcmp(header, data)
        disp('ERROR: expected valid header, received:')
        disp(data)
        fclose(file);
        return
    end

    % Read the specifications of the file.
    num_features = fread(file, 1, 'int');
    num_feature_dims = fread(file, 1, 'int');
    num_descriptor_dims = fread(file, 1, 'int');

    % Verify the file's specifications.
    if num_features <= 0
        disp(['ERROR: expected positive, non-zero number of features: ' num2str(num_features)])
        fclose(file);
        return
    end
    if num_feature_dims ~= 5
        disp(['ERROR: expected 5 feature dimensions: ' num2str(num_feature_dims)])
        fclose(file);
        return
    end
    if num_descriptor_dims ~= 128
        disp(['ERROR: expected 128 descriptor dimensions: ' num2str(num_descriptor_dims)])
        fclose(file);
        return
    end

    % Read the file's contents.
    keypoints = fread(file, [5, num_features], '*single');
    descriptors = fread(file, [128, num_features], '*uint8');
    
    % Read the SIFT file footer.
    footer = '_EOF';
    footer(1) = 255;
    data = fread(file, [1, length(footer)], '*char');
    if ~strcmp(footer, data)
        disp('ERROR: expected valid footer, received:')
        disp(data)
        fclose(file);
        return
    end

    % Discard the color information embedded in the 3rd dimension of the
    % keypoints vector.
    keypoints(3,:) = [];

    fclose(file);

end % function
