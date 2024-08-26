clear all
clc

colors = viridis(5);
s1 = [0.7 0.7 0.7];
s2 = 'b';
rng(2)
%% Geometric and Spinner Parameters
dist =28; %inital center to center distance of two spinners
M = .078; %in g (grams)
I = 0.64; %in g*mm^2
l = 5.7;
n = 8; %number of particles per wedge/arm
rs = constructspinnerskel(n,1);
npoints = size(rs,2);
xs  = rs(1,:);
ys = rs(2,:);
m = I ./ sum( xs.^2 + ys.^2);
R = l/n; % in mm, effective radius of disk of point source for cheerios
%% Fluid and Forcing Parameters
fr = 90; % in 1/s
g = 9810; % in mm/s^2
gamma = 1.6*g; %in gravitational acceleration
omega = 2*pi*fr; % in rad/s
rho = 0.0011495; % g/mm^3
sigma = 67; % in g/s^2 
eta = 0.01;
nu = eta ./ rho; %kinematic viscocity
scalefactor = 0.15;
zeta = scalefactor.*gamma ./ omega.^2; %approximate wave amplitude
lc = sqrt( sigma ./ (rho.*g) ); %in mm
kc = ( rho.*omega.^2 ./ sigma ).^( 1/3 ); %in 1/mm
lambdac = 2.*pi ./ kc; %wavelength in mm
%% Dimensionless Parameters
eps = 2.*nu.*kc.^2 ./ omega;
beta = 1 ./ (kc.*lc).^2;
Bo = rho.*g.*(l/5).^2 / sigma; %bond number
poly = [eps^2, 1, 2*1i*eps,beta,-1]; %polynomial in wave force
kjvec = roots(poly); %roots of polynomial in wave force
%% Force Parameters
that = 0.53; %viscous timescale measured in seconds.
F_wave = m.^2.*zeta.^2.*omega.^4 ./ (24.*sigma).*kc ; %wave force coeff
alpha = sqrt(beta)./ (pi*(Bo*besselk(0,sqrt(Bo))+2*sqrt(Bo)*besselk(1,sqrt(Bo))));
%F_cap = m.^2.*g.^2 / (sigma).*kc.*alpha; %cap force coeff
%Given the distances, we can just set the capillary force to zero.
F_cap = 0;
%% Simulation setup
t0 = 0.0; %inital time
t1 = 2*pi/0.19*6; %end time

speed = 0.19;
speed2 = 0.19;

omegaset = speed*ones(2,1);
omegaset(2) = speed2;
omegainit = omegaset;

%

angles = [0.0; 0.8];
initcon = [angles omegainit]';

xloc = linspace(0,dist,2);
yloc = 0;
[X,Y] = meshgrid(xloc,yloc);
loc = [X(:) Y(:)]';

[t,th] = ode45(@(t,th) oscillator_onlywave_dimensional(t,th,loc,kc,eps,beta,F_wave,that,omegaset,I,kjvec,n,lc,Bo,F_cap),[t0 t1],initcon);

subplot(2,1,1)

plot(t /(2*pi).*speed ,(th(:,2)),'Color', s1,'Linewidth',2.5) 
hold on 
for kk = 2:length(omegaset)
    plot(t/(2*pi).*speed ,th(:,2*kk),'Color',s2,'Linewidth',2.5)

end
box on
grid on
hold off
set(gca,'linewidth',2.0)
set(gcf,'color','w');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis
ylabel('$$\Omega$$ (rad/s)', 'Interpreter', 'Latex', 'FontSize', 20)
buffer = 1;
ylim([.08,0.28])
xlim([0,6])

phase = th(:,3)-sign(omegaset(2))*th(:,1);

subplot(2,1,2)

plot(t /(2*pi).*speed ,phase,'Color','k','Linewidth',2.5)
box on
grid on
hold off
set(gca,'linewidth',2.0)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20)
xlabel('$$t\Omega_0/2\pi$$', 'Interpreter', 'Latex', 'FontSize', 20)
ylabel('$$\phi$$', 'Interpreter', 'Latex', 'FontSize', 20)
yaxisproperties= get(gca, 'YAxis');
yaxisproperties.TickLabelInterpreter = 'latex';   % tex for y-axis
xlim([0,3])
ylim([-0.2,pi/3+0.2])