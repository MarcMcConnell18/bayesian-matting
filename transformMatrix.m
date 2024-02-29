function [result_vector] = transformMatrix(f_b_mat, image_mask)
% Reshapes the f_b_mat [m, n, 3] into a vector [1, N] using image_mask.
  f_b_mat = f_b_mat(~isnan(image_mask));
  f_b_mat = f_b_mat(1 : (length(f_b_mat) / 3));
  result_vector = f_b_mat';
end
