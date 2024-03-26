#!/usr/bin/env python
# coding: utf-8



# This is a unittest function to validate the implementation of the
# mean function
import unittest
import numpy as np
from core.MeanAndCovar import math_computation

class Testcalc(unittest.TestCase):
    def test_mean(self):
        Fground = np.block([[0.2510, 0.2118, 0.2078], [0.2078, 0.1961, 0.1725], [0.0824, 0.0863, 0.0588]])
        Bground = np.block([[0.1923, 0.1923, 0.1924], [0.3804, 0.3806, 0.3806], [0.2297, 0.2299, 0.2300]])
        Bweight = np.array([0, 4.67338987255646e-08, 1.06238930920776e-07])
        Fweight = np.array([1.38146008841722e-13, 4.67341923929458e-13, 1.48520956266117e-12])
        expected_Fmean = np.block([0.21154864144373,0.18010790288963285, 0.066506590146076])
        expected_Bmean = np.block([0.19236944954288052, 0.3806, 0.22996944954288054])
        expected_Fg_Covf = np.block([[2.9040106313806964e-17, 4.0482479029178254e-17, 3.672366959048999e-17],[4.0482479029178254e-17, 9.47851442712537e-17, 9.89454740613437e-17],[3.672366959048999e-17, 9.89454740613437e-17, 1.0589635120871279e-16]])
        expected_Bg_Covf = np.block([[1.3772681512057668e-16, 0.0, 1.3772681512060421e-16], [0, 0, 0], [1.3772681512060421e-16, 0.0, 1.3772681512063173e-16]])
    
        # calling mean function
        Fg_Covf, Bg_Covf, Bmean, Fmean =  math_computation (Fground, Bground, Bweight, Fweight); 

        # Checking the desired output with achieved result
        self.assertEqual(expected_Fmean.tolist(),Fmean.tolist())
    
        self.assertEqual(expected_Bmean.tolist(),Bmean.tolist())
        
        self.assertEqual(expected_Fg_Covf.tolist(),Fg_Covf.tolist())
        self.assertEqual(expected_Bg_Covf.tolist(),Bg_Covf.tolist())
    

if __name__ == '__main__':
    unittest.main()







