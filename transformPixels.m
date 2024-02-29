function [new_mat] = transformPixels(input_mat, image_mask)
% The ambiguous dimension of input matrix will be converted to [3, position
% that is required to be overseen]
  input_mat(isnan(image_mask)) = [];
  new_mat = reshape(input_mat, [length(input_mat) / 3, 3]);
  new_mat = new_mat'; 
end
