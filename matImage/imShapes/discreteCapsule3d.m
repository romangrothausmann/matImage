function img = discreteCapsule3d(varargin)
%DISCRETECAPSULE3D Create binary image of a 3D capsule
%
%   IMG = discreteCapsule3d(LX, LY, LZ, capsule)
%   LX, LY and LZ are row vectors specifying position of vertex centers
%   along each coordinate.
%   CAPSULE has the following format: [X1 Y1 Z1 X2 Y2 Z2 R]
%   P1 is the starting point of the capsule, given as a 1-by-3 row vector
%   P2 is the ending point of the capsule, given as a 1-by-3 row vector
%   RADIUS is the capsule radius.
%
%   Example
%     % Compute the union of three mutually orthogonal capsules
%     R = 15;
%     caps1 = [20 50 50  80 50 50  R];
%     caps2 = [50 20 50  50 80 50  R];
%     caps3 = [50 50 20  50 50 80  R];
%     img1 = discreteCapsule3d(1:100, 1:100, 1:100, caps1);
%     img2 = discreteCapsule3d(1:100, 1:100, 1:100, caps2);
%     img3 = discreteCapsule3d(1:100, 1:100, 1:100, caps3);
%     imgUnion = img1 | img2 | img3;
%     [f v] = isosurface(imgUnion, .5);
%     figure;
%     drawMesh(v, f, 'linestyle', 'none', 'facecolor', 'r');
%     l = light; view([120 20]);
%
%   See also
%   discreteBall, discreteCube, discretecylinder
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-07-29
% Copyright 2011 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).

%   HISTORY
%   2011-07-29 create from discretecylinder


%% Process input arguments

% compute coordinate of image voxels
[lx ly lz varargin] = parseGridArgs3d(varargin{:});
[x y z] = meshgrid(lx, ly, lz);

% process input parameters
if length(varargin) == 1
    % input is a 1-by-7 row vector
    var = varargin{1};
    if length(var) ~= 7
        error('Should specify a row vector with 7 inputs');
    end

    % extract first and last point coordinates
    p1 = var(1:3);
    p2 = var(4:6);
    radius = var(7);
    
elseif length(varargin) == 3
    % inputs are P1, P2 and R
    p1 = varargin{1};
    p2 = varargin{2};
    radius = varargin{3};
    
else
    error('Wrong number of arguments: should be 1 or 3');
end


%% Transform voxel coordinates

% direction vector of capsule
dirVect = p2 - p1;

% compute capsule direction angle (in radians)
[theta phi height] = cart2sph2(dirVect);

% compute coordinate of image voxels in capsule reference system
% (capsule pointing upwards)
trans = composeTransforms3d(...
    createTranslation3d(-p1),...
    createRotationOz(-phi),...
    createRotationOy(-theta),...
    createScaling3d(1 ./ [radius radius radius]));
[x y z] = transformPoint3d(x, y, z, trans);

height2 = height / radius;


%% Create image

% init image
img = false(size(x));

% capsinder image
img(((x.*x + y.*y) < 1) & (z > 0) & (z < height2)) = true;

% add a ball at each extremity
img((x.*x + y.*y + z.*z) < 1) = true;
img((x.*x + y.*y + (z-height2).^2) < 1) = true;
