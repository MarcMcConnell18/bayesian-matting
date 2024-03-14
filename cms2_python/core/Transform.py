import numpy as np


def transform_matrix(f_b_mat, image_mask):
    """
    Reshapes the f_b_mat [m, n, 3] into a vector [1, N] using image_mask.
    """
    f_b_mat = f_b_mat[:, :, 0]
    image_mask = image_mask[:, :, 0]
    image_mask = image_mask.reshape(image_mask.size)
    f_b_mat = np.delete(f_b_mat, np.where(np.isnan(image_mask)))
    result_vector = f_b_mat
    return result_vector


def transform_pixels(input_mat, image_mask):
    """
    The ambiguous dimension of input matrix will be converted to [3, position
    that is required to be overseen]
    """
    image_mask = image_mask.reshape(image_mask.size)
    input_mat = np.delete(input_mat, np.where(np.isnan(image_mask)))
    input_mat = input_mat.reshape(np.uint32(input_mat.size / 3), 3)
    new_mat = input_mat.T
    return new_mat
