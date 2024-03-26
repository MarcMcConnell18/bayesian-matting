#!/usr/bin/env python
# coding: utf-8



# This is a unittest function to validate the implementation of the
# mean function
import unittest
import numpy as np
from core.Estim import likelihood_estimation


class TestLikelihoodEstimation(unittest.TestCase):

    def test_likelihoodEstimation(self):
        # a patch in an image with scaled values for testing purposes 
        obs_color = np.array([[0.1961, 0.4157, 0.2471]]).T
        init_alpha = 0.7651
        fg_mu = np.block([0.1214, 0.1106, 0.0461])
        bg_mu = np.block([0.1903, 0.3803, 0.2303])
        fg_covariance = np.array([[0.000112838870246519, 9.33463528112866e-05, 6.30658248874166e-05], [9.33463528112866e-05, 0.000148956584151412, 0.000141489585911970], [6.30658248874166e-05, 0.000141489585911970, 0.000146458014702120]])
        bg_covariance = np.array([[2.12171528173845e-09, 0, 2.12171528173904e-09], [0, 0, 0], [2.12171528173904e-09, 0, 2.12171528173963e-09]])
        sigma_camera = 0.01
        max_iter = 50
        likelihood_min = 1.0000e-06
        expected_F_final = np.block([[0.27937021264216355], [0.0], [0.4820475716105648]])
        expected_B_final = np.block([[0.2651628005733073], [1.0], [0.15543608804728137]])
        expected_alpha = np.block([[0.5540428895878071]])

        # Call the likelihoodEstimation function
        F_final, B_final, alpha = likelihood_estimation(obs_color, init_alpha,
                                                        fg_mu, bg_mu, fg_covariance, bg_covariance,
                                                        sigma_camera, max_iter, likelihood_min)

        # Perform assertions
        self.assertEqual(expected_F_final.tolist(),F_final.tolist())
        self.assertEqual(expected_B_final.tolist(),B_final.tolist())
        self.assertEqual(expected_alpha.tolist(), alpha.tolist())
        #np.testing.assert_allclose(F_final, expected_F_final, rtol=1e-3)
        #np.testing.assert_allclose(B_final, expected_B_final, rtol=1e-3)
        #np.testing.assert_allclose(alpha, expected_alpha, rtol=1e-3)

if __name__ == '__main__':
    unittest.main()







