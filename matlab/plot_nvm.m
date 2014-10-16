% crop_outer_percentile - the percentage of the points/cameras to remove from
%                         the outer-most bounds of the model
function [] = plot_nvm(...
    camera_data, point_data, camera_relative_size, camera_color, point_color,...
    crop_outer_percentile)

    if ~exist('camera_relative_size', 'var')
        % plot_cameras() will set a default camera size.
        camera_relative_size = -1;
    end

    if ~exist('camera_color', 'var') || isempty(camera_color)
        % plot_cameras() will set a default camera color.
        camera_color = '';
    end

    if ~exist('point_color', 'var') || isempty(point_color)
        point_color = 'k';
    end

    if ~exist('crop_outer_percentile', 'var')
        crop_outer_percentile = -1;
    end

    if crop_outer_percentile > 0
        center = mean([camera_data.centers point_data.xyzs], 2);
        camera_dists = pdist2(center', camera_data.centers');
        point_dists = pdist2(center', point_data.xyzs');
        threshold = prctile([camera_dists point_dists], 100 - crop_outer_percentile);
        valid_cameras = camera_dists < threshold;
        valid_points = point_dists < threshold;

        camera_data.num_cameras = sum(valid_cameras);
        camera_data.names = camera_data.names(valid_cameras);
        camera_data.paths = camera_data.paths(valid_cameras);
        camera_data.focals = camera_data.focals(valid_cameras);
        camera_data.centers = camera_data.centers(:,valid_cameras);
        camera_data.orientations = camera_data.orientations(valid_cameras);
        camera_data.dimensions = camera_data.dimensions(:,valid_cameras);

        point_data.num_points = sum(valid_points);
        point_data.xyzs = point_data.xyzs(:,valid_points);
        point_data.rgbs = point_data.rgbs(:,valid_points);
    end

    plot_cameras(camera_data, camera_relative_size, camera_color);
    hold on
    plot3(point_data.xyzs(1,:), point_data.xyzs(2,:), point_data.xyzs(3,:),...
        '.', 'MarkerSize', 1, 'Color', point_color);
    axis equal
    axis vis3d
    hold off

end
