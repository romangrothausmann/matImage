function test_suite = test_imEuler2dEstimate(varargin) %#ok<STOUT>
% Test function for function imEuler2d
%   output = testImEuler2dEstimate(input)
%
%   Example
%   testImEuler2dEstimate
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-04-22,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.
% Licensed under the terms of the LGPL, see the file "license.txt"

initTestSuite;

function testSquareInFourImages %#ok<*DEFNU>

% create structure that does not touch borders
img = false(20, 20);
img(5:15, 5:15) = true;

% real EPC of the image
chi = imEuler2d(img);

% estimate EPC in each image using edge correction
chi1 = imEuler2dEstimate(img(1:10, 1:10));
chi2 = imEuler2dEstimate(img(1:10, 10:20));
chi3 = imEuler2dEstimate(img(10:20, 1:10));
chi4 = imEuler2dEstimate(img(10:20, 10:20));

% sum of 4 estimates
chis = chi1 + chi2 + chi3 + chi4;

assertEqual(chi, chis);

function testLabels

% create a label image with 3 labels
img = zeros(10, 10);
img(2:3, 2:3) = 3;
img(6:8, 2:3) = 5;
img(3:5, 5:8) = 9;
img(4, 6) = 0;

[chi labels] = imEuler2dEstimate(img);

assertElementsAlmostEqual(chi, [1 1 0]');
assertElementsAlmostEqual(labels, [3 5 9]');
