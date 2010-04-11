function test_suite = testDistancePointEdge(varargin)
%TESTDISTANCEPOINTEDGE  One-line description here, please.
%   output = testDistancePointEdge(input)
%
%   Example
%   testDistancePointEdge
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

function testBasic
point = [0 0];
edge = [1 2 3 4];
assertElementsAlmostEqual(distancePointEdge(point, edge), sqrt(5));

function testHorizontal
% an horizontal edge, with points all around
edge = [2 2 4 2];
assertElementsAlmostEqual(distancePointEdge([1 1], edge), sqrt(2));
assertElementsAlmostEqual(distancePointEdge([2 1], edge), 1);
assertElementsAlmostEqual(distancePointEdge([3 1], edge), 1);
assertElementsAlmostEqual(distancePointEdge([4 1], edge), 1);
assertElementsAlmostEqual(distancePointEdge([5 1], edge), sqrt(2));
assertElementsAlmostEqual(distancePointEdge([5 2], edge), 1);


function testDiagonal
% diagonal (slope 1.5)
edge = [1 1 5 7];
assertElementsAlmostEqual(distancePointEdge([0 0], edge), sqrt(2));
assertElementsAlmostEqual(distancePointEdge([2 0], edge), sqrt(2));
assertElementsAlmostEqual(distancePointEdge([4 8], edge), sqrt(2));
assertElementsAlmostEqual(distancePointEdge([1 0], edge), 1);
assertElementsAlmostEqual(distancePointEdge([0 1], edge), 1);
assertElementsAlmostEqual(distancePointEdge([6 7], edge), 1);
assertElementsAlmostEqual(distancePointEdge([5 8], edge), 1);
assertElementsAlmostEqual(distancePointEdge([6 2], edge), sqrt(13));
assertElementsAlmostEqual(distancePointEdge([0 6], edge), sqrt(13));

