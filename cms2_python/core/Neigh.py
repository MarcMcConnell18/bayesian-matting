import numpy as np
from scipy.ndimage import gaussian_filter

def matlab_fspecial_gauss2d(shape=(3, 3), sigma=0.5):
  # return the same result as MATLAB's fspecial('gaussian',[shape],[sigma])
    m, n = [(l - 1.) / 2. for l in shape]
    y, x = np.ogrid[-m:m+1, -n:n+1]
    h = np.exp(-(x*x + y*y) / (2.*sigma*sigma))
  # h[h < 1e-10] = 1e-10
    h[h < np.finfo(h.dtype).eps * h.max()] = np.finfo(h.dtype).eps * h.max()
    sumh = h.sum()
    if sumh != 0:
        h /= sumh
    return h

def extract_neighborhood_info(foreground_image, background_image, alpha_for_pixels, x, y, start_dim, sigma_gaussian):
    """
    Retrieves foreground and background neighborhood pixels and weights, along with initial alpha,
    for a given pixel in the unknown area.
    """
    # Image dimensions
    rows, cols, _ = foreground_image.shape
    
    # Half window size
    half_start_dim = (start_dim - 1) / 2
    
    # Index of four vertices of the square neighborhood
    min_x = np.int32(max(0, x - half_start_dim))
    max_x = np.int32(min(rows, x + half_start_dim + 1))
    min_y = np.int32(max(0, y - half_start_dim))
    max_y = np.int32(min(cols, y + half_start_dim + 1))
    rela_min_x = np.int32(min_x - (x - half_start_dim))
    rela_max_x = np.int32(start_dim - (x + half_start_dim + 1 - max_x))
    rela_min_y = np.int32(min_y - (y - half_start_dim))
    rela_max_y = np.int32(start_dim - (y + half_start_dim + 1 - max_y))
    
    # Extract alpha, foreground_image, background_image, neighborhood
    fg_neigh = foreground_image[min_x:max_x, min_y:max_y, :]
    bg_neigh = background_image[min_x:max_x, min_y:max_y, :]
    alpha_neigh = alpha_for_pixels[min_x:max_x, min_y:max_y, :]
    
    
    # Gaussian distribution area
    init_gaussian = matlab_fspecial_gauss2d(shape=(start_dim, start_dim), sigma=sigma_gaussian)
    init_gaussian = np.stack((init_gaussian, init_gaussian,init_gaussian), axis=2)
    rel_gaussian = init_gaussian[rela_min_x:rela_max_x, rela_min_y:rela_max_y , :]
    
    
    # Foreground weight = (alpha^2) * gaussian_fall_off
    fg_w = alpha_neigh
    fg_w[np.isnan(fg_w)] = 0
    fg_w = np.power(fg_w, 2) * rel_gaussian
    
    # Background weight = ((1 - alpha)^2) * gaussian_fall_off
    bg_w = alpha_neigh
    bg_w[np.isnan(bg_w)] = 1
    bg_w = np.power((1 - bg_w), 2) * rel_gaussian
    
    # Calculate the mean of all the alpha values in the neighborhood as the initial alpha
    alpha_neigh = alpha_neigh[:, :, 0]
    num_of_nan = np.count_nonzero(np.isnan(alpha_neigh))
    alpha_neigh[np.isnan(alpha_neigh)] = 0
    init_alpha = (np.sum(alpha_neigh) / (alpha_neigh.size - num_of_nan))
                  
    # Assign initial alpha as 0 if it's NaN
    if np.isnan(init_alpha):
        init_alpha = 0
    
    return fg_neigh, bg_neigh, fg_w, bg_w, init_alpha

