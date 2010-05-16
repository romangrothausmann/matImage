function test_suite = testClipLine(varargin)
% Tests the function 'clipLine'
%   output = testClipLine(input)
%
%   Example
%   testClipLine
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

function testHoriz
% test clipping of horizontal lines

box = [0 100 0 100];

% inside, to the right
line = [30 40 10 0];
edge = [0 40 100 40];
assertElementsAlmostEqual(edge, clipLine(line, box));

% inside, to the left
line = [30 40 -10 0];
edge = [100 40 0 40];
assertElementsAlmostEqual(edge, clipLine(line, box));

% outside
line = [30 140 10 0];
assertTrue(sum(isnan(clipLine(line, box)))==4);

function testVert
% test clipping of vertical lines

box = [0 100 0 100];

% inside, upward
line = [30 40 0 10];
edge = [30 0 30 100];
assertElementsAlmostEqual(edge, clipLine(line, box));

% inside, downward
line = [30 40 0 -10];
edge = [30 100 30 0];
assertElementsAlmostEqual(edge, clipLine(line, box));

% outside
line = [140 30 0 10];
assertTrue(sum(isnan(clipLine(line, box)))==4);

function testDiagUp
% test clipping of upward diagonal lines

box = [0 100 0 100];

% inside, top right corner
line = [80 30 10 10];
edge = [50 0 100 50];
assertElementsAlmostEqual(edge, clipLine(line, box));

% inside, down right corner
line = [20 70 10 10];
edge = [0 50 50 100];
assertElementsAlmostEqual(edge, clipLine(line, box));

% outside
line = [140 -30 10 10];
assertTrue(sum(isnan(clipLine(line, box)))==4);

line = [-40 130 10 10];
assertTrue(sum(isnan(clipLine(line, box)))==4);

