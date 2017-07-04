function draw_theory_bayesS(bayesS, signs_ellipses, signs_center)

if nargin<2 | length(signs_ellipses)==0,
  signs_ellipses = {'k-','r--'};
end;
if nargin<3 | length(signs_center)==0,
  signs_center = {'k+','rx'};
end;

for k=1:length(bayesS),
  for comp=1:size(bayesS(k).weight,1),
    hC = my_plot_ellipses(bayesS(k).mu(:,comp), bayesS(k).sigma(:,:,comp), bayesS(k).weight(comp), signs_ellipses{k});
    plot3(bayesS(k).mu(1,comp), bayesS(k).mu(2,comp), bayesS(k).weight(comp), signs_center{k}, 'MarkerSize', 20, 'LineWidth', 3);
  end;
end;

grid on;

function [x,y] = rotate_circle(x0,y0, sigma, angle, n_samples)

	theta=linspace(0,2*pi,n_samples);
	x=sigma(1)*sin(theta);
	y=sigma(2)*cos(theta);
	%rotation matrix
	R=[cos(angle) -sin(angle); sin(angle) cos(angle)];
	out = R' * ([x; y] );
	x = out(1,:) + x0;
	y = out(2,:) + y0;



function h = my_plot_ellipses(mu, sigma, weight, signs);

D = size(mu, 1);

if D ~= 2
	error('Can plot only 2D objects.');
end

[x,y,z] = cylinder([2 2], 40);
xy = [ x(1,:) ; y(1,:) ];

%plot(data(:,1), data(:,2), 'rx');

hold on
C = size(mu, 2);
for c = 1:C
	mxy = chol(sigma(:,:,c))' * xy;
	x = mxy(1,:) + mu(1,c);
	y = mxy(2,:) + mu(2,c);
	z = ones(size(x))*weight(c);
	h(c) = plot3(x,y,z, signs);
end;
%drawnow;
%hold off