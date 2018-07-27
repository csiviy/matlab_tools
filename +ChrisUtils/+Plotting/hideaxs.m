function hideaxs(ax)
% HIDEAXS Hide the lines for axes, leaving the labels
% 
% 
%     USAGE:
%         hideaxs(ax)
%
%
%     INPUTS:
%         ax: 
%
%
%     OUTPUTS:
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 01-Jun-2018  2:28 PM

if nargin == 0
    ax = gca();
end

% Hide the lines
drawnow
ax.XRuler.Axle.Visible = 'off';
ax.XAxis.TickLength = [0 0];
ax.YRuler.Axle.Visible = 'off';
ax.YAxis.TickLength = [0 0];

end