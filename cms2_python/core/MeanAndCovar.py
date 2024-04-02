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
#     print(whole_weight)
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




# import numpy as np

# def meanv(certain_ground, weight):
#     if np.sum(weight) == 0:
#         return np.zeros(3)
#     else:
#         return np.average(certain_ground, axis=1, weights=weight)

# def covariance(mean_value, certain_ground, weight):
#     if np.sum(weight) == 0:
#         return np.zeros((3, 3))
#     else:
#         weighted_ground = (certain_ground - mean_value[:, np.newaxis]) * weight
#         return np.dot(weighted_ground, weighted_ground.T) / np.sum(weight)

# def math_computation(pxls_fg, pxls_bg, bg_weights, fg_weights):
#     F_mean = meanv(pxls_fg, fg_weights)
#     B_mean = meanv(pxls_bg, bg_weights)
#     F_covar = covariance(F_mean, pxls_fg, fg_weights)
#     B_covar = covariance(B_mean, pxls_bg, bg_weights)
#     return F_covar, B_covar, B_mean, F_mean



# import numpy as np

# def meanv(certain_ground, weight):
#     certain_ground = certain_ground.astype(np.float64)
#     weight = weight.astype(np.float64)
#     whole_weight = np.sum(weight)

#     if whole_weight == 0:
#         return np.zeros(3, dtype=np.float64)
#     else:
#         return np.average(certain_ground, axis=1, weights=weight)

# def covariance(mean_value, certain_ground, weight):
#     certain_ground = certain_ground.astype(np.float64)
#     weight = weight.astype(np.float64)
#     whole_weight = np.sum(weight)

#     if whole_weight == 0:
#         return np.zeros((3, 3), dtype=np.float64)
#     else:
#         weighted_ground = (certain_ground - mean_value[:, np.newaxis]) * weight
#         return np.dot(weighted_ground, weighted_ground.T) / whole_weight

# def math_computation(pxls_fg, pxls_bg, bg_weights, fg_weights):
#     pxls_fg = pxls_fg.astype(np.float64)
#     pxls_bg = pxls_bg.astype(np.float64)
#     bg_weights = bg_weights.astype(np.float64)
#     fg_weights = fg_weights.astype(np.float64)

#     F_mean = meanv(pxls_fg, fg_weights)
#     B_mean = meanv(pxls_bg, bg_weights)
#     F_covar = covariance(F_mean, pxls_fg, fg_weights)
#     B_covar = covariance(B_mean, pxls_bg, bg_weights)

#     return F_covar, B_covar, B_mean, F_mean





# import numpy as np

# def meanv(certain_ground, weight):
#     whole_weight = np.sum(weight)
#     if whole_weight == 0:
#         return np.zeros(3)
#     else:
#         # 确保 certain_ground 是 3 x N 的形状
#         certain_ground = np.atleast_2d(certain_ground)
#         if certain_ground.shape[0] != 3:
#             certain_ground = certain_ground.T

#         # 确保 weight 是长度为 N 的一维数组
#         weight = np.array(weight).flatten()
#         assert certain_ground.shape[0] == 3 and certain_ground.shape[1] == len(weight), "Shape mismatch"

#         # 使用 np.dot 进行加权平均计算
#         weighted_sum = np.dot(certain_ground, weight)
#         return weighted_sum / whole_weight

# def covariance(mean_value, certain_ground, weight):
#     whole_weight = np.sum(weight)
#     if whole_weight == 0:
#         return np.zeros((3, 3))
#     else:
#         shift = certain_ground - mean_value[:, np.newaxis]
#         weighted_shift = shift * weight
#         return np.dot(weighted_shift, shift.T) / whole_weight

# def math_computation(pxls_fg, pxls_bg, bg_weights, fg_weights):
#     F_mean = meanv(pxls_fg, fg_weights)
#     B_mean = meanv(pxls_bg, bg_weights)
#     F_covar = covariance(F_mean, pxls_fg, fg_weights)
#     B_covar = covariance(B_mean, pxls_bg, bg_weights)
#     return F_covar, B_covar, B_mean, F_mean

# import numpy as np

# def meanv(certain_ground, weight):
#     whole_weight = np.sum(weight)
#     if whole_weight == 0:
#         return np.zeros(3)
#     else:
#         return np.average(certain_ground, axis=1, weights=weight)

# def covariance(mean_value, certain_ground, weight):
#     whole_weight = np.sum(weight)
#     if whole_weight == 0:
#         return np.zeros((3, 3))
#     else:
#         shift = certain_ground - mean_value[:, np.newaxis]
#         weighted_shift = shift * weight  # 逐元素乘法
#         return np.dot(weighted_shift, shift.T) / whole_weight

# def math_computation(pxls_fg, pxls_bg, bg_weights, fg_weights):
#     F_mean = meanv(pxls_fg, fg_weights)
#     B_mean = meanv(pxls_bg, bg_weights)
#     F_covar = covariance(F_mean, pxls_fg, fg_weights)
#     B_covar = covariance(B_mean, pxls_bg, bg_weights)
#     return F_covar, B_covar, F_mean, B_mean



