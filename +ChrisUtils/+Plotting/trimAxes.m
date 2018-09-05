function trimAxes(varargin)
% TRIMAXES Trim axes, similar to seaborn.despine(trim=True)
% 
% 
%     USAGE:
%         trimAxes(varargin)
%
%
%     INPUTS:
%         varargin:
%                   'ax': The axes object to use
%                 'grow': If true, will grow the axes a little before
%                         trimming. If false (default), will just use the
%                         axes ticks.
%
%
%     OUTPUTS:
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 01-Jun-2018 11:06 AM

% Parse inputs
p = inputParser();
p.addOptional('ax', gca, @(x) isa(x, 'matlab.graphics.axis.Axes'))
p.addOptional('grow', false)

p.parse(varargin{:})

ax = p.Results.ax;
grow = p.Results.grow;

if grow
    % Grow the axes a bit
    ax.XLim(1) = ax.XLim(1) - (ax.XTick(2) - ax.XTick(1)) / 4;
    ax.YLim(1) = ax.YLim(1) - (ax.YTick(2) - ax.YTick(1)) / 4;
    ax.XLim(2) = ax.XLim(end) + (ax.XTick(2) - ax.XTick(1)) / 4;
    ax.YLim(2) = ax.YLim(end) + (ax.YTick(2) - ax.YTick(1)) / 4;
end

% Add a listener to update the axes limits
addlistener(ax, 'MarkedClean', @(obj, event) resetVertex(obj));

end

function resetVertex(ax)
% Reset the vertex, to make the changes persisent

% For the bottom left corner
ax.XRuler.Axle.VertexData(1,1) = ax.XTick(1);
ax.YRuler.Axle.VertexData(2,1) = ax.YTick(1);

% The upper edges of the x- and y-axes
ax.YRuler.Axle.VertexData(2,2) = ax.YTick(end);
ax.XRuler.Axle.VertexData(1,2) = ax.XTick(end);

% If the box is on, do the rest of the axes as well
if strcmp(ax.Box, 'on')
    % For the upper left corner
    ax.XRuler.Axle.VertexData(1,3) = ax.XTick(1);
    
    % For the bottom right corner
    ax.YRuler.Axle.VertexData(2,3) = ax.YTick(1);

    % For the upper right corner
    ax.XRuler.Axle.VertexData(1,end) = ax.XTick(end);
    ax.YRuler.Axle.VertexData(2,4) = ax.YTick(end);
end

end