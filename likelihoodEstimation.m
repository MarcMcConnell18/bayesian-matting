function [F_final, B_final, alpha] = likelihoodEstimation(obs_color, init_alpha, ...
            fg_mu, bg_mu, fg_covariance, bg_covariance,... 
            sigma_camera, max_iter, likelihood_min)

  fg_cov_inv = pinv(fg_covariance);
  bg_cov_inv = pinv(bg_covariance);
  iteration_count = 0;
  % define the identity matrix
  I = eye(3);
    
  sigma_c_sq = sigma_camera ^ 2;
  alpha = init_alpha;
  alpha_sq = alpha ^ 2;
  likelihood_diff = 1;
  prev_likelihood = 0;
  while (iteration_count <= max_iter) && (likelihood_diff > likelihood_min)

    % Construct matrices from the first matrix
    FM_LU = fg_cov_inv + (I * (alpha_sq / sigma_c_sq));
    FM_RU = (I * alpha * (1 - alpha)) / sigma_c_sq;
    FM_LD = (I * alpha * (1 - alpha)) / sigma_c_sq;
    FM_RD = bg_cov_inv + ((I * ((1 - alpha) ^ 2)) / sigma_c_sq); 
                   
    FM = [FM_LU FM_RU;FM_LD FM_RD];
    FM_inv = pinv(FM);

    % Construct matrices from the first matrix

    SMU = (fg_cov_inv * fg_mu) + ((obs_color * alpha) / sigma_c_sq);
    SMD = (bg_cov_inv * bg_mu) + ((obs_color * (1 - alpha)) / sigma_c_sq);
    SM = [SMU ;SMD];
    
    %  Calculate the first function
    FB_matrix = FM_inv * SM;

    % Cap values between 0 and 1
    FB_matrix(FB_matrix > 1) = 1;
    FB_matrix(FB_matrix < 0) = 0;

    Foreground_update = FB_matrix(1 : 3);
    Background_update = FB_matrix(4 : 6);

    % Update alpha
    alpha_numerator = dot((obs_color - Background_update), (Foreground_update - Background_update));
    alpha_denominator = norm(Foreground_update - Background_update) .^ 2;
    alpha = alpha_numerator / alpha_denominator;

    % Ensure alpha is between 0 and 1
    alpha = max(0, min(1, alpha));

    fg_difference = Foreground_update - fg_mu;
    bg_difference = Background_update - bg_mu;
    
    fg_likelihood = - (transpose(fg_difference) * fg_cov_inv * fg_difference) / 2;
    bg_likelihood = - (transpose(bg_difference) * bg_cov_inv * bg_difference) / 2;

    composite_likelihood = obs_color - (alpha * Foreground_update) - ((1 - alpha) * Background_update);
    composite_likelihood = - (norm(composite_likelihood, 2).^ 2) / sigma_c_sq; 

    total_likelihood = composite_likelihood + fg_likelihood + bg_likelihood;

    iteration_count = iteration_count + 1;
    
    % Calculate likelihood difference for loop condition
    if iteration_count == 1
      likelihood_diff = abs(total_likelihood);
    else
      likelihood_diff = abs(total_likelihood - prev_likelihood);
    end
    prev_likelihood = total_likelihood;

    alpha_sq = alpha ^ 2;
    
  end
    
    % Return F, B, and alpha
    F_final = Foreground_update;
    B_final = Background_update;
end
