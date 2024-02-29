% The unit test for testing the covariance function is defined in this file
classdef Test_likelihoodEstimation < matlab.unittest.TestCase
    
  methods (Test)
      function test_likelihoodEstimation(testCase)
      % a patch in an image with scaled values for testing purposes 
      obs_color = [0.1961;
                        0.4157;
                        0.2471];
      init_alpha = 0.7651;
      fg_mu = [0.1214; 0.1106; 0.0461];
      bg_mu = [0.1903; 0.3803; 0.2303];
      fg_covariance = [0.000112838870246519, 9.33463528112866e-05, 6.30658248874166e-05; 9.33463528112866e-05, 0.000148956584151412, 0.000141489585911970; 6.30658248874166e-05, 0.000141489585911970, 0.000146458014702120];
      bg_covariance = [2.12171528173845e-09, 0, 2.12171528173904e-09; 0, 0, 0; 2.12171528173904e-09, 0, 2.12171528173963e-09];
      sigma_camera = 0.01;
      max_iter = 50;
      likelihood_min = 1.0000e-06;
      expected_F_final = [0.2148; 0; 0.2444];
      expected_B_final = [0.1698; 1; 0.2508];
      expected_alpha = 0.5843;
      % weights to be applied
[F_final, B_final, alpha] = likelihoodEstimation(obs_color, init_alpha, ...
            fg_mu, bg_mu, fg_covariance, bg_covariance,... 
            sigma_camera, max_iter, likelihood_min);
      verifyEqual(testCase, F_final, expected_F_final, 'AbsTol', 0.001);
      verifyEqual(testCase, B_final, expected_B_final, 'AbsTol', 0.001);
      verifyEqual(testCase, alpha, expected_alpha, 'AbsTol', 0.001);
      end
  end
end

