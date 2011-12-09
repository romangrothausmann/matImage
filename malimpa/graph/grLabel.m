function labels = grLabel(nodes, edges)
%GRLABEL associate a label to each connected component of the graph
%   LABELS = grLabel(NODES, EDGES)
%   Returns an array with as many rows as the array NODES, containing index
%   number of each connected component of the graph. If the graph is
%   totally connected, returns an array of 1.
%
%   Example
%       nodes = rand(6, 2);
%       edges = [1 2;1 3;4 6];
%       labels = grLabel(nodes, edges);
%   labels =
%       1
%       1
%       1
%       2
%       3
%       2   
%
%   See also
%   getNeighbourNodes
%
%
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2007-08-14,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2007 INRA - BIA PV Nantes - MIAJ Jouy-en-Josas.
% Licensed under the terms of the LGPL, see the file "license.txt"

% init
Nn = size(nodes, 1);
labels = (1:Nn)';

% iteration
modif = true;
while modif
    modif = false;
    
    for i=1:Nn
        neigh = getNeighbourNodes(i, edges);
        neighLabels = labels([i;neigh]);
        
        % check for a modification
        if length(unique(neighLabels))>1
            modif = true;
        end
        
        % put new labels
        labels(ismember(labels, neighLabels)) = min(neighLabels);
    end
end

% change to have fewer labels
labels2 = unique(labels);
for i=1:length(labels2)
    labels(labels==labels2(i)) = i;
end

