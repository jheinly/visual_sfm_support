function [] = plot_cameras(camera_data, camera_size, camera_color)

    if ~exist('camera_size', 'var')
        camera_size = -1;
    end

    % If the camera size is not specified, set it based on the extent
    % of the camera positions.
    if camera_size <= 0
        min_center = min(camera_data.centers, [], 2);
        max_center = max(camera_data.centers, [], 2);
        camera_size = 0.04 * norm([min_center max_center]);
    end

    if ~exist('camera_color', 'var')
        camera_color = 'k';
    end

    num_cameras = camera_data.num_cameras;
    centers = camera_data.centers;
    orientations = camera_data.orientations;

    % Compute the corners of the camera viewing frusta (pyramids).
    camera_corners = zeros(4*3, num_cameras);
    for i = 1:num_cameras
        camera_corners(1:3,i) = centers(:,i) + orientations{i} * camera_size * [0.4 0.4 1]';
        camera_corners(4:6,i) = centers(:,i) + orientations{i} * camera_size * [0.4 -0.4 1]';
        camera_corners(7:9,i) = centers(:,i) + orientations{i} * camera_size * [-0.4 -0.4 1]';
        camera_corners(10:12,i) = centers(:,i) + orientations{i} * camera_size * [-0.4 0.4 1]';
    end

    hold on
    axis equal
    % Construct the camera viewing frusta (pyramids).
    line(...
        [camera_corners(10,:); camera_corners(1,:); centers(1,:); camera_corners(4,:); camera_corners(1,:)],...
        [camera_corners(11,:); camera_corners(2,:); centers(2,:); camera_corners(5,:); camera_corners(2,:)],...
        [camera_corners(12,:); camera_corners(3,:); centers(3,:); camera_corners(6,:); camera_corners(3,:)],...
        'LineWidth', 1, 'Color', camera_color);
    line(...
        [camera_corners(4,:); camera_corners(7,:); centers(1,:); camera_corners(10,:); camera_corners(7,:)],...
        [camera_corners(5,:); camera_corners(8,:); centers(2,:); camera_corners(11,:); camera_corners(8,:)],...
        [camera_corners(6,:); camera_corners(9,:); centers(3,:); camera_corners(12,:); camera_corners(9,:)],...
        'LineWidth', 1, 'Color', camera_color);

end
