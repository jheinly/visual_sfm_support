function [] = plot_cameras(camera_data, camera_relative_size, camera_color)

    if ~exist('camera_relative_size', 'var') ||...
            isempty(camera_relative_size) ||...
            camera_relative_size <= 0
        camera_relative_size = 0.02;
    end

    if ~exist('camera_color', 'var') || isempty(camera_color)
        camera_color = 'k';
    end

    min_center = min(camera_data.centers, [], 2);
    max_center = max(camera_data.centers, [], 2);
    camera_size = camera_relative_size * norm([min_center max_center]);

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
    axis equal
    axis vis3d
    hold off

end
