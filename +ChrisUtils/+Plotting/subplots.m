function [axs] = subplots(m, n, varargin)
% SUBPLOTS Create an array of subplots all at once, returning all the axes an a matrix of the corresponding size
% 
% 
%     USAGE:
%         [axs] = subplots(m, n)
%
%
%     INPUTS:
%           m: Number of rows
%           n: Number of columns
%
%
%     OUTPUTS:
%         axs: Matrix of axes handles
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 01-Jun-2018  1:26 PM

% Create the axes
axs = gobjects(n,m);  % To take advantage of matlab indexing. Will transpose later

for i = 1:numel(axs)
    axs(i) = subplot(m, n, i);
end

axs = axs';
end