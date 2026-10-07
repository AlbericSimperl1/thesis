clear; clc; close all;

%% 1. Parameters & Materiaaleigenschappen
p.R1 = 0.15;           % Straal zendlus [m]
p.I0 = 1.0;            % Stroom [A]
p.f = 10e6;            % Frequentie [Hz] (10 MHz)
p.sigma = 3.5e7;       % Geleidbaarheid schild [S/m]
p.mur = 1.0;           % Relatieve permeabiliteit schild
p.t = 1.5875e-3;       % Dikte schild [m]
p.uMax = 90;
p.uMin = 1e-6;
p.nLambda = 2200;
p.chunkSize = 700;
p.mu0 = 4*pi*1e-7;
p.eps0 = 8.854187817e-12;
p.omega = 2*pi*p.f;
p.muShield = p.mu0 * p.mur;

% Rotatiehoeken en positie ontvangst-vlak (Script 2)
xyzRX = [0; 0; 0.30];
phi_deg = 15;   % Rotatie om x-as
theta_deg = 0; % Rotatie om y-as

%% 2. Rotatiematrix & 3D Grid Opzet
phi = deg2rad(-phi_deg);
theta = deg2rad(-theta_deg);
Rx = [1, 0, 0;
      0, cos(phi), -sin(phi);
      0, sin(phi), cos(phi)];
Ry = [cos(theta), 0, sin(theta);
      0, 1, 0;
     -sin(theta), 0, cos(theta)];
R = Ry * Rx;

u_vec = R(:, 1);
v_vec = R(:, 2);

N_grid = 101;
grid_lim = 0.20;
u_vals = linspace(-grid_lim, grid_lim, N_grid);
v_vals = linspace(-grid_lim, grid_lim, N_grid);
[U, V] = meshgrid(u_vals, v_vals);

% Transformeer lokaal (U,V) grid naar globale 3D (X, Y, Z) coördinaten
X_grid = xyzRX(1) + U * u_vec(1) + V * v_vec(1);
Y_grid = xyzRX(2) + U * u_vec(2) + V * v_vec(2);
Z_grid = xyzRX(3) + U * u_vec(3) + V * v_vec(3);

%% 3. Veldberekening (Zonder Schild & Met Schild)
Hopen   = hfield_3d(X_grid, Y_grid, Z_grid, p, "open");
Hclosed = hfield_3d(X_grid, Y_grid, Z_grid, p, "closed");

% Omberekening H_tot naar mA/m
H_open_mAm   = Hopen.mag * 1000;
H_closed_mAm = Hclosed.mag * 1000;

% Shielding Effectiveness [dB]
SE = 20 * log10(max(Hopen.mag, realmin) ./ max(Hclosed.mag, realmin));

%% 4. Visualisatie (3 Figuren op een rij)
figure('Name', 'H-Veld en Shielding Effectiveness (SE)', 'Color', 'w', 'Position', [100, 200, 1400, 400]);
tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% 1. Zonder schild (Open)
nexttile;
pcolor(U, V, H_open_mAm);
shading interp; axis equal; grid on;
xlim([-grid_lim grid_lim]); ylim([-grid_lim grid_lim]);
title('1. Zonder schild (H_{tot} [mA/m])');
xlabel('u [m]'); ylabel('v [m]');
colorbar; colormap(gca, jet);

% 2. Met schild (Closed)
nexttile;
pcolor(U, V, H_closed_mAm);
shading interp; axis equal; grid on;
xlim([-grid_lim grid_lim]); ylim([-grid_lim grid_lim]);
title('2. Met schild (H_{tot} [mA/m])');
xlabel('u [m]'); ylabel('v [m]');
colorbar; colormap(gca, jet);

% 3. Shielding Effectiveness
nexttile;
pcolor(U, V, SE);
shading interp; axis equal; grid on;
xlim([-grid_lim grid_lim]); ylim([-grid_lim grid_lim]);
title('3. SE = 20 log_{10}(Open / Closed) [dB]');
xlabel('u [m]'); ylabel('v [m]');
colorbar; colormap(gca, turbo);

%% Lokale functie voor 3D Sommerfeld Veldberekening
function H = hfield_3d(X, Y, Z, p, caseName)
    originalSize = size(X);
    x = X(:).';
    y = Y(:).';
    z = Z(:).';
    r = hypot(x, y);
    nPoints = numel(r);

    u = linspace(p.uMin, p.uMax, p.nLambda);
    lambda = u / p.R1;
    tau0 = lambda;
    tau = sqrt(lambda.^2 - 1i*p.omega*p.muShield*p.sigma);
    K = tau ./ tau0;
    C = 1 ./ ((K + p.mur).^2 - (K - p.mur).^2 .* exp(-2*p.t*tau));
    J1a = besselj(1, lambda * p.R1);

    Hx = zeros(1, nPoints);
    Hy = zeros(1, nPoints);
    Hz = zeros(1, nPoints);

    for first = 1:p.chunkSize:nPoints
        last = min(first + p.chunkSize - 1, nPoints);
        rc = r(first:last);
        zc = z(first:last);

        lambdaR = lambda(:) * rc;
        J0r = besselj(0, lambdaR);
        J1r = besselj(1, lambdaR);

        expTerm = exp(-tau0(:) * zc);

        switch lower(caseName)
            case "open"
                brWeight = (lambda(:) .* J1a(:)) .* expTerm;
                bzWeight = ((lambda(:).^2 ./ tau0(:)) .* J1a(:)) .* expTerm;
                prefactor = p.mu0 * p.R1 * p.I0 / 2;
            case "closed"
                expTermClosed = expTerm .* exp(-p.t * (tau(:) - tau0(:)));
                brWeight = ((C(:) .* lambda(:) .* tau(:) ./ tau0(:)) .* J1a(:)) .* expTermClosed;
                bzWeight = ((C(:) .* lambda(:).^2 .* tau(:) ./ tau0(:).^2) .* J1a(:)) .* expTermClosed;
                prefactor = 2 * p.mu0 * p.mur * p.R1 * p.I0;
            otherwise
                error('caseName moet "open" of "closed" zijn.');
        end

        Br = prefactor * trapz(lambda, brWeight .* J1r, 1);
        Bz_val = prefactor * trapz(lambda, bzWeight .* J0r, 1);

        rSafe = max(rc, eps);
        Hr_val = Br / p.mu0;

        Hx(first:last) = Hr_val .* (x(first:last) ./ rSafe);
        Hy(first:last) = Hr_val .* (y(first:last) ./ rSafe);
        Hz(first:last) = Bz_val / p.mu0;
    end

    H.Hx = reshape(Hx, originalSize);
    H.Hy = reshape(Hy, originalSize);
    H.Hz = reshape(Hz, originalSize);
    H.mag = reshape(sqrt(abs(Hx).^2 + abs(Hy).^2 + abs(Hz).^2), originalSize);
end
