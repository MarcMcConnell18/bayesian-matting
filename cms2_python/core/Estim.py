import numpy as np


def likelihood_estimation(obs_color, init_alpha, fg_mu, bg_mu, fg_covariance, bg_covariance,
                          sigma_camera, max_iter, likelihood_min):
    #if np.linalg.matrix_rank(fg_covariance) == fg_covariance.shape[0]:
   #     fg_cov_inv = np.linalg.inv(fg_covariance)
    #else:    
    fg_cov_inv = np.linalg.pinv(fg_covariance)
        
    #if np.linalg.matrix_rank(bg_covariance) == bg_covariance.shape[0]:
    #    bg_cov_inv = np.linalg.inv(bg_covariance)
    #else:    
    bg_cov_inv = np.linalg.pinv(bg_covariance)    
    
    iteration_count = 0
    I = np.eye(3)
    
    sigma_c_sq = sigma_camera ** 2
    alpha = init_alpha
    alpha_sq = alpha ** 2
    likelihood_diff = 1
    prev_likelihood = 0
    
    while (iteration_count <= max_iter) and (likelihood_diff > likelihood_min):
        FM_LU = fg_cov_inv + (I * (alpha_sq / sigma_c_sq))
        FM_RU = (I * alpha * (1 - alpha)) / sigma_c_sq
        FM_LD = (I * alpha * (1 - alpha)) / sigma_c_sq
        FM_RD = bg_cov_inv + ((I * ((1 - alpha) ** 2)) / sigma_c_sq) 
                   
        FM = np.block([[FM_LU, FM_RU], [FM_LD, FM_RD]])
        FM_inv = np.linalg.pinv(FM)

        SMU = (fg_cov_inv @ fg_mu) + ((obs_color * alpha) / sigma_c_sq)
        SMD = (bg_cov_inv @ bg_mu) + ((obs_color * (1 - alpha)) / sigma_c_sq)
        SM = np.vstack([SMU, SMD])
        
        FB_matrix = FM_inv @ SM

        FB_matrix[FB_matrix > 1] = 1
        FB_matrix[FB_matrix < 0] = 0

        Foreground_update = FB_matrix[:3]
        Background_update = FB_matrix[3:]

        alpha_numerator = np.dot((obs_color - Background_update), (Foreground_update - Background_update))
        alpha_denominator = np.linalg.norm(Foreground_update - Background_update) ** 2
        alpha = alpha_numerator / alpha_denominator
        alpha = max(0, min(1, alpha))

        fg_difference = Foreground_update - fg_mu
        bg_difference = Background_update - bg_mu
        
        fg_likelihood = - np.dot(np.dot(fg_difference.T, fg_cov_inv), fg_difference) / 2
        bg_likelihood = - np.dot(np.dot(bg_difference.T, bg_cov_inv), bg_difference) / 2

        composite_likelihood = obs_color - (alpha * Foreground_update) - ((1 - alpha) * Background_update)
        composite_likelihood = - np.linalg.norm(composite_likelihood, ord=2) ** 2 / sigma_c_sq

        total_likelihood = composite_likelihood + fg_likelihood + bg_likelihood

        iteration_count += 1
        
        if iteration_count == 1:
            likelihood_diff = abs(total_likelihood)
        else:
            likelihood_diff = abs(total_likelihood - prev_likelihood)
        prev_likelihood = total_likelihood

        alpha_sq = alpha ** 2
    
    F_final = Foreground_update
    B_final = Background_update
    return F_final, B_final, alpha

