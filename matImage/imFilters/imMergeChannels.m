function rgb = imMergeChannels(r, g, b)
%IMMERGECHANNELS  Merge 3 channels to create a 2D or 3D color image
%
%   RGB = imMergeChannels(R, G, B)
%   R, G and B are 3 images the same size. The result RGB is a color image
%   with channels given by R, G and B.
%
%   Example
%   % change channel order of a 2D image
%   img = imread('peppers.png');
%   [r, g, b] = imSplitChannels(img);
%   bgr = imMergeChannels(b, g, r);
%   imshow(bgr);
%
%   See also
%     imSplitChannels

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-02-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% small control on inputs
if nargin < 3
    b = [];
end

% choose one of the 3 inputs as reference
ref = r;
if isempty(ref)
    ref = g;
    if isempty(ref)
        ref = b;
        if isempty(ref)
            error('Can not manage three empty arrays');
        end
    end
end

% get ref size
dim = size(ref);
nd = ndims(ref);

% different processing for 2D or 3D images
if nd == 2
    % create empty result image
    if islogical(ref)
        rgb = false([dim 3]);
    else
        rgb = zeros([dim 3], class(ref)); %#ok<ZEROLIKE>
    end
    
    % fill result with data
    if ~isempty(r), rgb(:,:,1) = r; end
    if ~isempty(g), rgb(:,:,2) = g; end
    if ~isempty(b), rgb(:,:,3) = b; end
    
elseif nd == 3
    % create empty result image
    newDim = [dim(1:2) 3 dim(3)];
    if islogical(ref)
        rgb = false(newDim);
    else
        rgb = zeros(newDim, class(ref)); %#ok<ZEROLIKE>
    end
    
    % fill result with data
    if ~isempty(r), rgb(:,:,1,:) = r; end 
    if ~isempty(g), rgb(:,:,2,:) = g; end
    if ~isempty(b), rgb(:,:,3,:) = b; end
else
    error('unprocessed image dimension');
end
