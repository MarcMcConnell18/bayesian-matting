close all;
clear;
clc;
% Read input data
original_image = imread('input_training_lowres\GT19.png');
trimap = imread('trimap_training_lowres\Trimap1\GT19.png');
ground_truth_trimap = imread('gt_training_lowres\GT19.png');

sizeimg_2_dims = size(original_image(:, :, 1));
sizetrimap = size(trimap);

  if sizeimg_2_dims == sizetrimap
      disp("sizechecking: Successfull alignment of image and trimap!");
  else
      disp("sizechecking: size not match, asking for new trimap!");
      [File, Path] = ...
      uigetfile ...
      ({'*.jpg;*.jpeg; *.png; *.gif;*.bmp;*.tiff', ...
     'Image files (.jpg, .jpeg, .png, .gif, .bmp, .tiff'}, ...
     'Select a new trimap');
      trimap = imread([Path File]);
  end

  if size(trimap, 3) ~= 1
     trimap = rgb2gray(trimap);
  end
% Convert input data to double ranged from 0 to 1

  original_image = double(original_image) / 255.0;
  ground_truth_trimap = double(ground_truth_trimap) / 255.0;
  [rows, cols, c] = size(original_image);

% Define foreground, background, and unknown areas
  fgmask = (trimap == 255);
  bgmask = (trimap == 0);
  unknown = (trimap == 128);

% Initialize alpha matte (background: 0, foreground: 1, unknown area: NaN)
  alpha = zeros(size(trimap));
  alpha(fgmask) = 1;
  alpha(unknown) = NaN;
  alpha = repmat(alpha, [1, 1, 3]);

% Initialize F and B matrices
  F = original_image;
  F(repmat( ~ fgmask, [1, 1, 3])) = NaN;
  B = original_image;
  B(repmat( ~ bgmask, [1, 1, 3])) = NaN;

% Copy initial values to be used later
  F_init = F;
  B_init = B;
  alpha_init = alpha;

% Set parameters
  initial_side_length = 41;
  increment_for_side_length = 8;
  sigma_for_gsn = 4;
  remaining_unknown_pxls = [];

  tic

% First Loop: Iterate over pixels in the unknown area
  for i = 1:rows
    for j = 1:cols
        if unknown(i, j)
            % Initialize parameters
            side_length = initial_side_length;
            increment = increment_for_side_length;

            % Calculate the number of foreground and background pixels required
            num_fg_pxls = 0;
            num_bg_pxls = 0;
            min_fg_pxls = 200;
            min_bg_pxls = 200;
            max_side_length = 75;

            % Iterate to find neighborhood information
            for num_iterations = 1:max_side_length
                if ((num_fg_pxls >= min_fg_pxls) && (num_bg_pxls >= ...
                        min_bg_pxls)) || (side_length > max_side_length)
                    break;
                end

                % Get neighborhood information
                [fg_neighb, bg_neighb, fg_weights, bg_weights, ...
                    initial_alpha] = extractNeighborhoodInfo...
                    (F_init, B_init, alpha_init, i, j, side_length, ...
                    sigma_for_gsn);

                % Calculate the number of foreground and background ...
                % pixels in the neighborhood
                num_fg_pxls = (numel(fg_neighb) - ...
                nnz(isnan(fg_neighb))) / 3;
                num_bg_pxls = (numel(bg_neighb) - ...
                nnz(isnan(bg_neighb))) / 3;

                % Increment window size
                side_length = side_length + increment;
            end

            % Store remaining unknown pixels if information is insufficient
            if side_length > max_side_length
                remaining_unknown_pxls(:, end + 1) = [i; j];
                continue;
            end

            % Estimate alpha, F, B values for pixels with enough ...
            % information
            fg_weights = transformMatrix(fg_weights, fg_neighb);
            bg_weights = transformMatrix(bg_weights, bg_neighb);
            pxls_fg = transformPixels(fg_neighb, fg_neighb);
            pxls_bg = transformPixels(bg_neighb, bg_neighb);
            [F_covar, B_covar, B_mean, F_mean] = MathComputation ...
            (pxls_fg, pxls_bg, bg_weights, fg_weights);
            C = original_image(i, j, :);
            C = reshape(C, [3, 1]);
            max_iterations = 50;
            min_likelihood = 1e-6;
            sigma_C = 0.01;
            F_mean = F_mean';
            B_mean = B_mean';

            [F_element, B_element, alpha_element] = likelihoodEstimation...
                (C, initial_alpha, F_mean, B_mean, F_covar, B_covar, ...
                sigma_C, max_iterations, min_likelihood);

            F_element(isnan(F_element)) = 0;
            B_element(isnan(B_element)) = 0;

            F(i, j, :) = F_element;
            B(i, j, :) = B_element;
            alpha(i, j, :) = alpha_element;
        end
    end
 end

% Second Loop: Iterate over remaining unknown pixels
for k = 1:length(remaining_unknown_pxls)
    i = remaining_unknown_pxls(1, k);
    j = remaining_unknown_pxls(2, k);

    side_length = initial_side_length;
    increment = increment_for_side_length;
    num_fg_pxls = 0;
    num_bg_pxls = 0;
    min_fg_pxls = 200;
    min_bg_pxls = 200;
    max_side_length = 80;

    % Get neighborhood information for remaining pixels
    for num_iterations = 1:max_side_length
        if ((num_fg_pxls >= min_fg_pxls) && (num_bg_pxls >= ...
                min_bg_pxls)) || (side_length > max_side_length)
            break;
        end

        [fg_neighb, bg_neighb, fg_weights, bg_weights, initial_alpha] = ...
            extractNeighborhoodInfo(F, B, alpha, i, j, ...
            side_length, sigma_for_gsn);
        num_fg_pxls = (numel(fg_neighb) - nnz(isnan(fg_neighb))) / 3;
        num_bg_pxls = (numel(bg_neighb) - nnz(isnan(bg_neighb))) / 3;
        side_length = side_length + increment;
    end
    
    fg_weights = transformMatrix(fg_weights, fg_neighb);
    bg_weights = transformMatrix(bg_weights, bg_neighb);
    pxls_fg = transformPixels(fg_neighb, fg_neighb);
    pxls_bg = transformPixels(bg_neighb, bg_neighb);

    % Handle remaining pixels with insufficient information
    if side_length >= max_side_length
        if num_fg_pxls > num_bg_pxls
            alpha(i, j, :) = 1;
            [F_covar, B_covar, B_mean, F_mean] = MathComputation...
            (pxls_fg, pxls_bg, bg_weights, fg_weights);
            F(i, j, :) = F_mean;
            continue;
        elseif num_fg_pxls < num_bg_pxls
            alpha(i, j, :) = 0;
            [F_covar, B_covar, B_mean, F_mean] = MathComputation...
            (pxls_fg, pxls_bg, bg_weights, fg_weights);
            B(i, j, :) = B_mean;
            continue;
        end
    else
        % Estimate alpha, F, B values for pixels with enough information
        [F_covar, B_covar, B_mean, F_mean] = MathComputation...
            (pxls_fg, pxls_bg, bg_weights, fg_weights);

        C = original_image(i, j, :);
        C = reshape(C, [3, 1]);
        max_iterations = 50;
        min_likelihood = 1e-6;
        sigma_C = 0.01;
        F_mean = F_mean';
        B_mean = B_mean';
        [F_element, B_element, alpha_element] = likelihoodEstimation...
            (C, initial_alpha, F_mean, B_mean, F_covar, B_covar, ...
            sigma_C, max_iterations, min_likelihood);

        F_element(isnan(F_element)) = 0;
        B_element(isnan(B_element)) = 0;

        F(i, j, :) = F_element;
        B(i, j, :) = B_element;
        alpha(i, j, :) = alpha_element;
    end
end
toc
alpha_1 = rgb2gray(alpha);
ground_truth_trimap = rgb2gray(ground_truth_trimap);
PSNR = psnr(alpha_1, ground_truth_trimap);
MSE = immse(alpha_1, ground_truth_trimap);
F(isnan(F)) = 0;
B(isnan(B)) = 0;
% Display results
figure(1);
subplot(2, 3, 1), imshow(trimap);
title('Trimap');
subplot(2, 3, 2), imshow(alpha);
title('Our Result');
subplot(2, 3, 3), imshow(ground_truth_trimap);
title('Ground Truth');
subplot(2, 3, 4), imshow(original_image);
title('Original Image');
subplot(2, 3, 5), imshow(F);
title('Foreground');
subplot(2, 3, 6), imshow(B);
title('Background');
fprintf('The PSNR of Bayesian matting is: %0.5f\n', PSNR);
fprintf('The MSE of Bayesian matting is: %0.5f\n ', MSE);
disp(['Running Time of Bayesian: ', num2str(toc)]);

% ask for new background
F = F * 255;
[File, Path] = uigetfile({'*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.tiff', ...
    'Image files (.jpg, .jpeg, .png, .gif, .bmp, .tiff'}, ...
    'Select a new background');
Bg_new = imread([Path File]);
Bg_new = imresize(Bg_new, [rows cols]);
Bg_new = double(Bg_new);
new_image = zeros(size(Bg_new));
for i = 1 : 3
    new_image(:, :, i) = F(:, :, i) .* alpha_1(:, :) + ...
        Bg_new(:, :, i) .* (1 - alpha_1(:, :));
end
figure(2);
imshow(uint8(new_image));
imwrite(uint8(new_image), 'newoutput.png')
drawnow;
%%

%get laplacian
input = imread('input_training_lowres\GT19.png');
% im = imresize(im, 0.5);
trimap = imread('trimap_training_lowres\Trimap1\GT19.png');
% trimap = imresize(trimap, 0.5);
ground_truth = imread('gt_training_lowres\GT19.png');


%  Laplacain Matting
tic
[L_alpha] = get_Laplacian(input, trimap);
toc
figure(3);
subplot(1, 3, 1), imshow(input);
title('Input');

subplot(1, 3, 2), imshow(trimap);
title('Trimap');

subplot(1, 3, 3), imshow(L_alpha);
title('Laplacian Alpha Matte');
gt = double(ground_truth) / 255;
gt = rgb2gray(gt);

L_PSNR = psnr(gt, L_alpha);
L_MSE = immse(L_alpha, gt);
fprintf('The PSNR of Laplacian matting is: %0.5f\n', L_PSNR);
fprintf('The MSE of Laplacian matting is: %0.5f\n ', L_MSE);
disp(['Running Time of Laplacian: ', num2str(toc)]);