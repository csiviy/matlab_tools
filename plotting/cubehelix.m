function map = cubehelix(varargin)
% CUBEHELIX Generate a colormap according to the cubehelix system
%
%
% More info on the cubehelix system:
%       https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/
% 
% The core code here was modified slightly from:
%       https://www.mrao.cam.ac.uk/~dag/CUBEHELIX/CubeHelix.m
%
% Default parameters were taken from seaborn
% 
%     USAGE:
%         [cmap] = cubehelix(varargin)
%
%
%     INPUTS:
%         varargin: 
%
%
%     OUTPUTS:
%             cmap: 
%
%
%     SEE ALSO:
%
%
% Chris Siviy, 01-Jun-2018  2:16 PM

%% Parse inputs
p = inputParser();

p.addOptional('n_colors', 10)
p.addOptional('start', 0)
p.addOptional('rot', 0.4)
p.addOptional('gamma', 1)
p.addOptional('hue', 0.8)
% p.addOptional('light', 0.85)
% p.addOptional('dark', 0.15)

p.parse(varargin{:})

n_colors = p.Results.n_colors;
start = p.Results.start;
rot = p.Results.rot;
gamma = p.Results.gamma;
hue = p.Results.hue;
% light = p.Results.light;
% dark = p.Results.dark;

%% Obtain the color map

map=zeros(n_colors,3);

A=[-0.14861,1.78277;-0.29227,-0.90649;1.97294,0];

for i=1:n_colors
    fract=(i-1)/(n_colors-1);
    angle=2*pi*(start/3+1+rot*fract);
    fract=fract^gamma;
    amp=hue*fract*(1-fract)/2;
    map(i,:)=fract+amp*(A*[cos(angle);sin(angle)])';
    for j=1:3
        if map(i,j)<0
            map(i,j)=0;
        elseif map(i,j)>1
            map(i,j)=1;
        end
    end
end

end