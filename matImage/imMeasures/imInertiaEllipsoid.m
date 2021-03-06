function [ellipsoid, labels] = imInertiaEllipsoid(img, varargin)
%IMINERTIAELLIPSOID Inertia ellipsoid of a 3D binary image
%
%   ELLI = imInertiaEllipsoid(IMG)
%   IMG is a binary image of a single particle or region.
%   ELLI = [XC YC ZC A B C PHI THETA PSI] is an ellipsoid defined by its
%   center [XC YC ZC], 3 radii A, B anc C, and a 3D orientation angle given
%   by (PHI, THETA, PSI).
%
%   ELLI = imInertiaEllipsoid(LBL)
%   Computes inertia ellipsoid of each region in the label image LBL. The
%   result is NL-by-9 array, with NL being the number of unique labels in
%   input image.
%
%   ELLI = imInertiaEllipsoid(..., SCALE)
%   Specifies a spatial calibration for ech of the x, y and z axes. SCALE
%   is a 1-by-3 row vector containing size of elementary voxel in each
%   direction.
%
%   ELLI = imInertiaEllipsoid(..., LABELS)
%   Specify the labels for which the ellipsoid needs to be computed. The
%   result is a N-by-9 array with as many rows as the number of labels.
%
%   Example
%     % Generate an ellipsoid image and computes the inertia ellipsoid
%     % (one expects to obtain nearly same results)
%     elli = [50 50 50   50 30 10  40 30 20];
%     img = discreteEllipsoid(1:100, 1:100, 1:100, elli);
%     elli2 = imInertiaEllipsoid(img)
%     elli2 =
%       50.00  50.00  50.00  50.0076  30.0035  10.0073  40.0375  29.9994  20.0182
%
%     % Draw inertia ellipsoid of human head image
%     % (requires image processing toolbox, and slicer program for display)
%     metadata = analyze75info('brainMRI.hdr');
%     I = analyze75read(metadata);
%     bin = imclose(I > 0, ones([3 3 3]));
%     orthoSlices3d(I, [60 80 13], [1 1 2.5]);
%     axis equal;
%     view(3);
%     elli = imInertiaEllipsoid(bin, [1 1 2.5]);
%     drawEllipsoid(elli)
%     
%   See also
%     inertiaEllipse, drawEllipsoid

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-12-01,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%   HISTORY
%   2014-02-28 fix bug for labels with only one voxel
%   2014-03-07 change constant to fit ellipsoids

% size of image
dim = size(img);

% extract spatial calibration
scales = [1 1 1];
if ~isempty(varargin)
    scales = varargin{1};
end

% extract the set of labels, without the background
labels = imFindLabels(img);
nLabels = length(labels);

% allocate memory for result
ellipsoid = zeros(nLabels, 9);

for i = 1:nLabels
    % extract points of the current particle
    inds = find(img==labels(i));
    [y, x, z] = ind2sub(dim, inds);
    
%     % number of points
%     n = length(inds);

    % compute approximate location of ellipsoid center
    xc = mean(x);
    yc = mean(y);
    zc = mean(z);

    center = [xc yc zc] .* scales;
    
    % recenter points (should be better for numerical accuracy)
    x = (x - xc) * scales(1);
    y = (y - yc) * scales(2);
    z = (z - zc) * scales(3);

    points = [x y z];
    
    % compute the covariance matrix
%     covPts = cov(points) / n;
    covPts = cov(points) + diag(1/12 * ones(1, 3));
      
    % perform a principal component analysis with 3 variables,
    % to extract inertia axes
    [U, S] = svd(covPts);
    
    % extract length of each semi axis
%     radii = 2 * sqrt(diag(S)*n)';
    radii = sqrt(5) * sqrt(diag(S))';
    
    % sort axes from greater to lower
    [radii, ind] = sort(radii, 'descend');
    
    % format U to ensure first axis points to positive x direction
    U = U(ind, :);
    if U(1,1) < 0
        U = -U;
        % keep matrix determinant positive
        U(:,3) = -U(:,3);
    end
    
    % convert axes rotation matrix to Euler angles
    angles = rotation3dToEulerAngles(U);
    
    % concatenate result to form an ellipsoid object
    ellipsoid(i, :) = [center radii angles];
end


function varargout = rotation3dToEulerAngles(mat)
%ROTATION3DTOEULERANGLES Extract Euler angles from a rotation matrix
%
%   [PHI, THETA, PSI] = rotation3dToEulerAngles(MAT)
%   Computes Euler angles PHI, THETA and PSI (in degrees) from a 3D 4-by-4
%   or 3-by-3 rotation matrix.
%
%   ANGLES = rotation3dToEulerAngles(MAT)
%   Concatenates results in a single 1-by-3 row vector. This format is used
%   for representing some 3D shapes like ellipsoids.
%
%   Example
%   rotation3dToEulerAngles
%
%   References
%   Code from Graphics Gems IV on euler angles
%   http://tog.acm.org/resources/GraphicsGems/gemsiv/euler_angle/EulerAngles.c
%   Modified using explanations in:
%   http://www.gregslabaugh.name/publications/euler.pdf
%
%   See also
%   transforms3d, rotation3dAxisAndAngle, createRotation3dLineAngle,
%   eulerAnglesToRotation3d
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


% conversion from radians to degrees
k = 180 / pi;

% extract |cos(theta)|
cy = hypot(mat(1, 1), mat(2, 1));

% avoid dividing by 0
if cy > 16*eps
    % normal case: theta <> 0
    psi     = k * atan2( mat(3, 2), mat(3, 3));
    theta   = k * atan2(-mat(3, 1), cy);
    phi     = k * atan2( mat(2, 1), mat(1, 1));
else
    % 
    psi     = k * atan2(-mat(2, 3), mat(2, 2));
    theta   = k * atan2(-mat(3, 1), cy);
    phi     = 0;
end

% format output arguments
if nargout <= 1
    % one array
    varargout{1} = [phi theta psi];
else
    % three separate arrays
    varargout = {phi, theta, psi};
end
