% The unit test for testing the covariance function is defined in this file
classdef Test_MathComputation < matlab.unittest.TestCase
    
  methods (Test)
      function test_MathComputationFunction(testCase)
      % a patch in an image with scaled values for testing purposes      
      Fground = [0.2510, 0.2118, 0.2078; 0.2078, 0.1961, 0.1725; 0.0824, 0.0863, 0.0588];
      Bground = [0.1923, 0.1923, 0.1924; 0.3804, 0.3806, 0.3806; 0.2297, 0.2299, 0.2300];
      % weights to be applied
      Bweight = [0, 4.67338987255646e-08, 1.06238930920776e-07];
      Fweight = [1.38146008841722e-13, 4.67341923929458e-13, 1.48520956266117e-12];
      [Fg_Covf, Bg_Covf, Bmean, Fmean] =  MathComputation (Fground, Bground, Bweight, Fweight); 
      expected_Fmean = [0.211548641443730, 0.180107902889633, 0.066506590146076];
      expected_Bmean = [0.192369449542881, 0.380600000000000, 0.229969449542881];
      verifyEqual(testCase, Fmean, expected_Fmean, 'AbsTol', 0.001);
      verifyEqual(testCase, Bmean, expected_Bmean, 'AbsTol', 0.001);
      expected_Fg_Covf = [0.000112838870246519, 9.33463528112866e-05, 6.30658248874166e-05; 9.33463528112866e-05, 0.000148956584151412, 0.000141489585911970; 6.30658248874166e-05, 0.000141489585911970, 0.000146458014702120];
      expected_Bg_Covf = [2.12171528173845e-09, 0, 2.12171528173904e-09; 0, 0, 0; 2.12171528173904e-09, 0, 2.12171528173963e-09];
      verifyEqual(testCase, Fg_Covf, expected_Fg_Covf, 'AbsTol', 0.001);
      verifyEqual(testCase, Bg_Covf, expected_Bg_Covf, 'AbsTol', 0.001);
      end
  end
end

