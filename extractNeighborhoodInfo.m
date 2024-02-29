function [fg_neigh, bg_neigh, fg_w, bg_w, init_alpha] = extractNeighborhoodInfo(Foreground_image, Background_image, alpha_for_pixels, x, y, start_dim, sigma_gaussian)
% Retrieves foreground and background neighborhood pixels and weights, along with initial alpha,
% for a given pixel in the unknown area.
%
% Inputs:


%   x, y - Coordinates of the given unknown pixel
%   start_dim - Side length of the square neighborhood
%   sigma_gaussian - Standard deviation for the Gaussian distribution
%
% Outputs:
%   fg_neigh - Neighborhood area in Foreground_image
%   bg_neigh - Neighborhood area in Background_image
%   fg_w - Weights for foreground pixels in the neighborhood
%   bg_w - Weights for background pixels in the neighborhood
%   init_alpha - Mean of the alpha values in the neighborhood
%

  % Image dimensions
  [rows, cols, ~] = size(Foreground_image);
    
  % Half window size
  half_start_dim = (start_dim - 1) / 2;
    
  % Index of four vertices of the square neighborhood
  min_x = max(1, x - half_start_dim);
  max_x = min(rows, x + half_start_dim);
  min_y = max(1, y - half_start_dim);
  max_y = min(cols, y + half_start_dim);
    
  % Extract alpha, Foreground_image, Background_image, neighborhood
  fg_neigh = Foreground_image((min_x : max_x), (min_y : max_y), :);
  bg_neigh = Background_image((min_x : max_x), (min_y : max_y), :);
  alpha_neigh = alpha_for_pixels((min_x : max_x), (min_y : max_y), :);
    
  % Relative index for Gaussian distribution
  rel_min_x = min_x - (x - half_start_dim) + 1;
  rel_max_x = start_dim - ((x + half_start_dim) - max_x);
  rel_min_y = min_y - (y - half_start_dim) + 1;
  rel_max_y = start_dim - ((y + half_start_dim) - max_y);
    
  % Gaussian distribution area
  init_gaussian = fspecial('gaussian', [start_dim start_dim], sigma_gaussian);
  rel_gaussian = init_gaussian((rel_min_x : rel_max_x), (rel_min_y : rel_max_y));
  rel_gaussian = repmat(rel_gaussian, [1, 1, 3]);
    

    
  % Foreground weight = (alpha^2) * gaussian_fall_off
  fg_w = alpha_neigh;
  fg_w(isnan(alpha_neigh)) = 0;
  fg_w = (fg_w .^ 2) .* rel_gaussian;
    
  % Background weight = ((1 - alpha)^2) * gaussian_fall_off
  bg_w = alpha_neigh;
  bg_w(isnan(alpha_neigh)) = 1;
  bg_w = ((1 - bg_w) .^ 2) .* rel_gaussian;
    
  % Calculate the mean of all the alpha values in the neighborhood as the initial alpha
  alpha_neigh_part = alpha_neigh(:, :, 1);
  alpha_neigh_part(isnan(alpha_neigh_part)) = [];
  init_alpha = mean(alpha_neigh_part);
    
  % Assign initial alpha as 0 if it's NaN
  if isnan(init_alpha)
      init_alpha = 0;
  end
end
