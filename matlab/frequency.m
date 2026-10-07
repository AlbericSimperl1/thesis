clear; clc; close all;

%% ============================================================
%  PARAMETERS & GEOMETRY
%  ============================================================

p.R1 = 0.15;              % Straal TX-lus [m]
p.I0 = 1.0;               % TX-stroom [A]

% Schild
p.sigma = 3.5e7;          % Geleidbaarheid [S/m]
p.mur = 1.0;              % Relatieve permeabiliteit
p.t = 1.5875e-3;          % Schilddikte [m]

% Sommerfeld-integratie
p.uMax = 90;
p.uMin = 1e-6;
p.nLambda = 2200;
p.chunkSize = 700;

% Fysische constanten
p.mu0 = 4*pi*1e-7;
p.eps0 = 8.854187817e-12;
p.muShield = p.mu0 * p.mur;

%% RX-lus geometrie & positie

rRX = 0.05;               % Straal RX-lus [m]
xyzRX = [0; 0; 0.30];     % Centrum RX-lus [m]

theta_deg = 0;            % Rotatie rond y-as [graden]


%% ============================================================
%  FREQUENTIE- EN HOEKBEREIK
%  ============================================================

f_vec = logspace(log10(10e3), log10(5e6), 30);
phi_vec = linspace(0, 85, 25);

[F_grid, PHI_grid] = meshgrid(f_vec, phi_vec);

SE_matrix = zeros(size(F_grid));

nTotal = numel(SE_matrix);

fprintf('\n');
fprintf('===============================================\n');
fprintf('   SE(f, phi) berekening\n');
fprintf('===============================================\n');
fprintf('Frequenties : %d\n', numel(f_vec));
fprintf('Hoeken      : %d\n', numel(phi_vec));
fprintf('Totaal      : %d evaluaties\n', nTotal);
fprintf('===============================================\n\n');


%% ============================================================
%  RX-LUS INTEGRATIEGRID
%  ============================================================

N_grid = 35;

grid_lim = rRX;

u_vals = linspace(-grid_lim, grid_lim, N_grid);
v_vals = linspace(-grid_lim, grid_lim, N_grid);

[U, V] = meshgrid(u_vals, v_vals);

in_loop = (U.^2 + V.^2) <= rRX^2;

u_sub = U(in_loop).';
v_sub = V(in_loop).';

dA = (u_vals(2) - u_vals(1)) * ...
     (v_vals(2) - v_vals(1));

nRXpoints = numel(u_sub);

fprintf('RX-integratiepunten: %d\n', nRXpoints);
fprintf('Start berekening...\n\n');


%% ============================================================
%  START TIMER
%  ============================================================

totalTimer = tic;


%% ============================================================
%  MULTIVARIABELE BEREKENING
%  ============================================================

for i = 1:numel(phi_vec)

    phi_val = phi_vec(i);

    %% --------------------------------------------------------
    % Rotatiematrix
    % ---------------------------------------------------------

    phi = deg2rad(-phi_val);
    theta = deg2rad(-theta_deg);

    Rx = [1,       0,          0;
          0, cos(phi), -sin(phi);
          0, sin(phi),  cos(phi)];

    Ry = [ cos(theta), 0, sin(theta);
                 0,    1,      0;
          -sin(theta), 0, cos(theta)];

    R = Ry * Rx;

    % Basisvectoren van het RX-vlak
    u_vec = R(:,1);
    v_vec = R(:,2);

    % Normaalvector
    n_vec = R(:,3);


    %% --------------------------------------------------------
    % Transformeer RX-punten naar globale 3D-coördinaten
    % ---------------------------------------------------------

    X_sub = xyzRX(1) ...
        + u_sub * u_vec(1) ...
        + v_sub * v_vec(1);

    Y_sub = xyzRX(2) ...
        + u_sub * u_vec(2) ...
        + v_sub * v_vec(2);

    Z_sub = xyzRX(3) ...
        + u_sub * u_vec(3) ...
        + v_sub * v_vec(3);


    %% --------------------------------------------------------
    % Frequentielus
    % ---------------------------------------------------------

    for j = 1:numel(f_vec)

        p.f = f_vec(j);
        p.omega = 2*pi*p.f;


        % -----------------------------------------------------
        % Open veld
        % -----------------------------------------------------

        Hopen = hfield_3d_pts( ...
            X_sub, Y_sub, Z_sub, p, "open");


        % -----------------------------------------------------
        % Gesloten veld (met schild)
        % -----------------------------------------------------

        Hclosed = hfield_3d_pts( ...
            X_sub, Y_sub, Z_sub, p, "closed");


        % -----------------------------------------------------
        % Normale B-component
        % Bn = B . n
        % -----------------------------------------------------

        Bn_open = p.mu0 * ( ...
              Hopen.Hx * n_vec(1) ...
            + Hopen.Hy * n_vec(2) ...
            + Hopen.Hz * n_vec(3));


        Bn_closed = p.mu0 * ( ...
              Hclosed.Hx * n_vec(1) ...
            + Hclosed.Hy * n_vec(2) ...
            + Hclosed.Hz * n_vec(3));


        % -----------------------------------------------------
        % Magnetische flux door RX-lus
        % Phi = integral(Bn dA)
        % -----------------------------------------------------

        Phi_open = sum(Bn_open) * dA;
        Phi_closed = sum(Bn_closed) * dA;


        % -----------------------------------------------------
        % Shielding Effectiveness
        % -----------------------------------------------------

        SE_matrix(i,j) = ...
            20 * log10( ...
            abs(Phi_open) / ...
            max(abs(Phi_closed), eps));


        %% ----------------------------------------------------
        % Progress
        % -----------------------------------------------------

        current = (i-1)*numel(f_vec) + j;

        elapsed = toc(totalTimer);

        percent = 100 * current / nTotal;

        estimatedTotal = elapsed / current * nTotal;

        remaining = estimatedTotal - elapsed;

        fprintf( ...
            '\rProgress: %6.2f %% | %d/%d | elapsed: %6.1f s | resterend: %6.1f s', ...
            percent, ...
            current, ...
            nTotal, ...
            elapsed, ...
            remaining);

    end

end

fprintf('\n\n');
fprintf('===============================================\n');
fprintf('Berekening succesvol afgerond.\n');
fprintf('Totale tijd: %.2f minuten\n', toc(totalTimer)/60);
fprintf('===============================================\n\n');


%% ============================================================
%  ENIGE FIGUUR: 3D SE OPPERVLAK
%  ============================================================

figure( ...
    'Name', 'Shielding Effectiveness SE(f, phi)', ...
    'Color', 'w', ...
    'Position', [100, 100, 1000, 700]);


surf( ...
    F_grid, ...
    PHI_grid, ...
    SE_matrix, ...
    'EdgeColor', 'interp');


set(gca, 'XScale', 'log');

xlabel('Frequentie f [Hz]', 'FontSize', 12);
ylabel('Rotatiehoek \phi [graden]', 'FontSize', 12);
zlabel('Shielding Effectiveness SE [dB]', 'FontSize', 12);

title( ...
    'Shielding Effectiveness als functie van frequentie en hoek', ...
    'FontSize', 14);


colorbar;
colormap turbo;

grid on;
box on;

view(-35, 30);

xticks([10e3, 100e3, 1e6, 5e6]);
xticklabels({'10 kHz', '100 kHz', '1 MHz', '5 MHz'});

set(gca, 'FontSize', 11);


%% ============================================================
%  LOKALE FUNCTIE
%  Sommerfeld-integratie op 3D punten
%  ============================================================

function H = hfield_3d_pts(X, Y, Z, p, caseName)

    x = X(:).';
    y = Y(:).';
    z = Z(:).';

    r = hypot(x, y);

    nPoints = numel(r);


    %% Sommerfeld-integratievariabele

    u = linspace( ...
        p.uMin, ...
        p.uMax, ...
        p.nLambda);

    lambda = u / p.R1;

    tau0 = lambda;

    tau = sqrt( ...
        lambda.^2 ...
        - 1i * p.omega * p.muShield * p.sigma);


    %% Shield parameter

    K = tau ./ tau0;


    C = 1 ./ ( ...
        (K + p.mur).^2 ...
        - (K - p.mur).^2 ...
        .* exp(-2*p.t*tau));


    %% Besselterm TX-lus

    J1a = besselj( ...
        1, ...
        lambda * p.R1);


    %% Output arrays

    Hx = zeros(1, nPoints);
    Hy = zeros(1, nPoints);
    Hz = zeros(1, nPoints);


    %% ========================================================
    %  Bereken in chunks
    %  ========================================================

    for first = 1:p.chunkSize:nPoints

        last = min( ...
            first + p.chunkSize - 1, ...
            nPoints);


        rc = r(first:last);
        zc = z(first:last);


        %% Bessel functies op RX-punten

        lambdaR = lambda(:) * rc;

        J0r = besselj(0, lambdaR);
        J1r = besselj(1, lambdaR);


        %% Exponentieel verval buiten TX-lus

        expTerm = exp( ...
            -tau0(:) * zc);


        %% ====================================================
        %  OPEN GEVAL
        %  ====================================================

        switch lower(caseName)

            case "open"

                brWeight = ...
                    (lambda(:) .* J1a(:)) ...
                    .* expTerm;


                bzWeight = ...
                    ((lambda(:).^2 ./ tau0(:)) ...
                    .* J1a(:)) ...
                    .* expTerm;


                prefactor = ...
                    p.mu0 * p.R1 * p.I0 / 2;


            %% =================================================
            %  CLOSED GEVAL
            %  =================================================

            case "closed"

                expTermClosed = ...
                    expTerm ...
                    .* exp( ...
                    -p.t * ...
                    (tau(:) - tau0(:)));


                brWeight = ...
                    ((C(:) ...
                    .* lambda(:) ...
                    .* tau(:) ...
                    ./ tau0(:)) ...
                    .* J1a(:)) ...
                    .* expTermClosed;


                bzWeight = ...
                    ((C(:) ...
                    .* lambda(:).^2 ...
                    .* tau(:) ...
                    ./ tau0(:).^2) ...
                    .* J1a(:)) ...
                    .* expTermClosed;


                prefactor = ...
                    2 * p.mu0 ...
                    * p.mur ...
                    * p.R1 ...
                    * p.I0;


            otherwise

                error( ...
                    'Onbekende caseName: %s', ...
                    caseName);

        end


        %% ====================================================
        %  Sommerfeld-integratie
        %  ====================================================

        Br = prefactor * ...
            trapz( ...
            lambda, ...
            brWeight .* J1r, ...
            1);


        Bz_val = prefactor * ...
            trapz( ...
            lambda, ...
            bzWeight .* J0r, ...
            1);


        %% ====================================================
        %  Cylindrisch -> Cartesisch
        %  ====================================================

        rSafe = max(rc, eps);

        Hr_val = Br / p.mu0;


        Hx(first:last) = ...
            Hr_val ...
            .* (x(first:last) ./ rSafe);


        Hy(first:last) = ...
            Hr_val ...
            .* (y(first:last) ./ rSafe);


        Hz(first:last) = ...
            Bz_val / p.mu0;

    end


    %% Output

    H.Hx = Hx;
    H.Hy = Hy;
    H.Hz = Hz;

    H.mag = sqrt( ...
        abs(Hx).^2 ...
        + abs(Hy).^2 ...
        + abs(Hz).^2);

end