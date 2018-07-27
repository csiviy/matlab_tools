% Quick script to test a bunch of things I've changed

ax = subplots(2,2);

t = linspace(0, 1, 1001);

plot(ax(1,1), t, cos(2 * pi * t), ...
     'linewidth', 3)
trimAxes('ax', ax(1,1), 'grow', true)
ax(1,1).Box = 'off';

plot(ax(2,2), t, sin(2 * pi * t), ...
     'linewidth', 3)
trimAxes('ax', ax(2,2), 'grow', true)


[~, c] = contourf(ax(1,2), peaks(100), 25);
c.LineColor = 'none';
colormap(cubehelix(25))
hideaxs(ax(1,2))

contour(ax(2,1), peaks(100), 10, 'linewidth', 3)
hideaxs(ax(2,1))

set(ax, 'linewidth', 2)

psize = [11 8.5];
set(gcf, 'papersize', psize, 'paperposition', [0 0 psize])
% print(gcf, 'test.pdf', '-dpdf')
% print(gcf, 'test.eps', '-depsc')
matlab2tikz('test.tex', 'showinfo', false, 'standalone', true)