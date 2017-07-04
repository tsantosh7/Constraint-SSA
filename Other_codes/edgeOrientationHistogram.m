%
% [eoh] = edgeOrientationHistogram(im)
%
% Extract the MPEG-7 "Edge Orientation Histogram" descriptor
% 
% Input image should be a single-band image, but if it's a multiband (e.g. RGB) image
% only the 1st band will be used.
% Compute 4 directional edges and 1 non-directional edge
% The output "eoh" is a 4x4x5 matrix
%
% The image is split into 4x4 non-overlapping rectangular regions
% In each region, a 1x5 edge orientation histogram is computed (horizontal, vertical,
% 2 diagonals and 1 non-directional)
%
function [eoh] = edgeOrientationHistogram(im)

% define the filters for the 5 types of edges
f2 = zeros(3,3,5);
f2(:,:,1) = [1 2 1;0 0 0;-1 -2 -1];
f2(:,:,2) = [-1 0 1;-2 0 2;-1 0 1];
f2(:,:,3) = [2 2 -1;2 -1 -1; -1 -1 -1];
f2(:,:,4) = [-1 2 2; -1 -1 2; -1 -1 -1];
f2(:,:,5) = [-1 0 1;0 0 0;1 0 -1];

ys = size(im,1);
xs = size(im,2);


gf = gaussianFilter(11,1.5);
im = filter2(gf, im(:,:,1));
im2 = zeros(ys,xs,5);
for i = 1:5
    im2(:,:,i) = abs(filter2(f2(:,:,i), im));
end

[mmax, maxp] = max(im2,[],3);

im2 = maxp;

ime = edge(im, 'canny', [], 1.5)+0;
im2 = im2.*ime;

eoh = zeros(4,4,6);
for j = 1:4
    for i = 1:4
        clip = im2(round((j-1)*ys/4+1):round(j*ys/4),round((i-1)*xs/4+1):round(i*xs/4));
        eoh(j,i,:) = permute(hist(makelinear(clip), 0:5), [1 3 2]);
    end
end

eoh = eoh(:,:,2:6);

