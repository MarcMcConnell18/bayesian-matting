import numpy as np


def meanv(certain_ground, weight):
    whole_weight = sum(weight)
    color_channel = [1, 2, 3]
    if whole_weight == 0:
        mean_value = np.zeros(3)
    else:
        mean_value = np.zeros(3)
        for channel in color_channel:
            mean_value[channel - 1] = np.sum(certain_ground[(channel - 1), :] * weight) / whole_weight
    return mean_value


def covariance(mean_value, certain_ground, weight):
    whole_weight = sum(weight)
    if whole_weight == 0:
        covar = np.zeros((3,3))
    else:   
        shift = [certain_ground[0, :] - mean_value[0], certain_ground[1, :] - mean_value[1], certain_ground[2, :] - mean_value[2]]
        shift = np.array(shift)
        covar = np.dot(np.dot(weight * shift, shift.T), 1 / whole_weight)
    return covar

def math_computation(pxls_fg, pxls_bg, bg_weights, fg_weights):
    F_mean = meanv(pxls_fg, fg_weights)
    B_mean = meanv(pxls_bg, bg_weights)
    F_covar = covariance(F_mean, pxls_fg, fg_weights)
    B_covar = covariance(B_mean, pxls_bg, bg_weights)
    return F_covar, B_covar, B_mean, F_mean