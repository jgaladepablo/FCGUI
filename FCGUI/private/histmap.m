function  [xi,yi,z] = histmap(xd,yd,xbin,ybin)
xi = linspace(min(xd(:)),max(xd(:)),xbin);
yi = linspace(min(yd(:)),max(yd(:)),ybin);

xr = interp1(xi, 0.5:numel(xi)-0.5, xd, 'nearest');
yr = interp1(yi, 0.5:numel(yi)-0.5, yd, 'nearest');

z = accumarray([xr yr] + 0.5, 1, [xbin ybin])';