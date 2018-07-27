function [c] = color_from_cmap(val, cmap, lims)
% COLOR_FROM_CMAP Get a  color from a color map
% 
% 
%     USAGE:
%         [c] = color_from_cmap(val, cmap, lims)
%
%
%     INPUTS:
%           val: Current value
%          cmap: Colormap, as an mx3 array in RGB
%          lims: Limits on the colormap
%
%
%     OUTPUTS:
%             c: Color corresponding to val scaled with the given limits
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 01-Jun-2018  1:49 PM


% Constrain between 0 and 1
val = (val - lims(1)) / range(lims);

hsv = rgb2hsv(cmap);
cm_data = interp1(linspace(0,1,size(cmap,1)),hsv,val);
c = hsv2rgb(cm_data);

end