import numpy as np


def transform_matrix(f_b_mat, image_mask):
    """
    Reshapes the f_b_mat [m, n, 3] into a vector [1, N] using image_mask.
    """
    f_b_mat = f_b_mat[~np.isnan(image_mask)]
    f_b_mat = f_b_mat[:len(f_b_mat) // 3]
    result_vector = f_b_mat.flatten()
    return result_vector


def transform_pixels(input_mat, image_mask):
    """
    The ambiguous dimension of input matrix will be converted to [3, position
    that is required to be overseen]
    """
    image_mask = image_mask.reshape(image_mask.size)
    input_mat = input_mat.flatten()[~np.isnan(image_mask)]
    new_mat = np.reshape(input_mat, (len(input_mat) // 3, 3))
    new_mat = new_mat.T
    return new_mat

