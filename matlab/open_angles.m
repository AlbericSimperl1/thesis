clear; clc; close all;

%% 1. constants, geometry and material
mu0 = 4*pi*1e-7;
I_tx = 1.0;
rTX = 0.15;
nTX = 250;
rRX = 0.000005;
xyzRX = [0; 0; 0.30];

% rotation angles
phi_deg = 15; % about x
theta_deg =25; % about y

%% 2. matrix composition and unit vectors
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
n_vec = R(:, 3);

%% 3. discrete tx loop
t_tx = linspace(0, 2*pi, nTX + 1);
t_tx(end) = []; % no double end
dt_tx = 2*pi / nTX;

r_tx = [rTX * cos(t_tx); rTX * sin(t_tx); zeros(1, nTX)];
dl_tx = [-rTX * sin(t_tx) * dt_tx; rTX * cos(t_tx) * dt_tx; zeros(1, nTX)];

%% 4. rx gridf
N_grid = 101;
grid_lim = 0.20;
u_vals = linspace(-grid_lim, grid_lim, N_grid);
v_vals = linspace(-grid_lim, grid_lim, N_grid);
[U, V] = meshgrid(u_vals, v_vals);

% Transformeer 2D u,v grid naar globale 3D (X,Y,Z) coördinaten
X_grid = xyzRX(1) + U * u_vec(1) + V * v_vec(1);
Y_grid = xyzRX(2) + U * u_vec(2) + V * v_vec(2);
Z_grid = xyzRX(3) + U * u_vec(3) + V * v_vec(3);

% Initialiseer veld-matrices
Bx = zeros(size(U)); By = zeros(size(U)); Bz = zeros(size(U));

%% 5. Veld-berekening via Numerieke Integratie (Biot-Savart)
for i = 1:size(U, 1)
    for j = 1:size(U, 2)
        p = [X_grid(i,j); Y_grid(i,j); Z_grid(i,j)]; % Observatiepunt

        R_mat = p - r_tx;                      % [3 x nTX]
        dist = sqrt(sum(R_mat.^2, 1));         % [1 x nTX]

        % Magnetisch veld B (Biot-Savart)
        dB = (mu0 * I_tx / (4*pi)) * (cross(dl_tx, R_mat, 1) ./ (dist.^3));
        B_tot = sum(dB, 2);
        Bx(i,j) = B_tot(1); By(i,j) = B_tot(2); Bz(i,j) = B_tot(3);
    end
end

% Normale component van B loodrecht op het RX-vlak
Bn = Bx * n_vec(1) + By * n_vec(2) + Bz * n_vec(3);

% Omberekening naar H-veldsterkte [A/m] en [mA/m] voor 4nec2 vergelijking
Hn_Am = Bn / mu0;             % Hn in A/m
Hn_mAm = Hn_Am * 1000;         % Hn in mA/m

%% 6. Exacte Magnetische Flux Berekening
N_rx = 200;
t_rx = linspace(0, 2*pi, N_rx + 1); t_rx(end) = [];
dt_rx = 2*pi / N_rx;
rx_local_pos = [rRX * cos(t_rx); rRX * sin(t_rx); zeros(1, N_rx)];
rx_global_pos = xyzRX + R * rx_local_pos;
dl_rx_local = [-rRX * sin(t_rx) * dt_rx; rRX * cos(t_rx) * dt_rx; zeros(1, N_rx)];
dl_rx_global = R * dl_rx_local;

Phi_Stokes = 0;
for k = 1:N_rx
    p_rx = rx_global_pos(:, k);
    R_mat = p_rx - r_tx;
    dist = sqrt(sum(R_mat.^2, 1));
    A_k = sum((mu0 * I_tx / (4*pi)) * (dl_tx ./ dist), 2);

    Phi_Stokes = Phi_Stokes + dot(A_k, dl_rx_global(:, k));
end

% 7. Visualisatie (3D Geometrie + H-Veld in mA/m)
figure('Color', 'w', 'Position', [80, 80, 1200, 500]);

% geometry
subplot(1, 2, 1);
plot3(r_tx(1, [1:end,1]), r_tx(2, [1:end,1]), r_tx(3, [1:end,1]), 'b-', 'LineWidth', 2.5); hold on;
plot3(rx_global_pos(1, [1:end,1]), rx_global_pos(2, [1:end,1]), rx_global_pos(3, [1:end,1]), 'r-', 'LineWidth', 2.5);
surf(X_grid, Y_grid, Z_grid, Hn_mAm, 'EdgeColor', 'none', 'FaceAlpha', 0.85);

grid on; axis equal; xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
title('3D Opstelling Geometrie');
legend('TX Loop', 'RX Loop', 'H_n Evalueervlak');
colormap jet; view(35, 20);


% Magnitude in loop plane
H_tot_mAm = (sqrt(Bx.^2 + By.^2 + Bz.^2) / mu0) * 1000;
subplot(1, 2, 2);

pcolor(U, V, H_tot_mAm);
% plot(rRX * cos(t_rx), rRX * sin(t_rx), 'r--', 'LineWidth', 2)
shading interp; axis equal; grid on;

xlim([-0.20 0.20]); ylim([-0.20 0.20]);
title('H_{tot} Veldverdeling in [mA/m]');
colorbar; colormap jet;

%% 7. Console Output (Uitlezen van H-veldwaarden)
fprintf('================ BEREKENINGSRESULTATEN ================\n');
fprintf('Total flux via stokes A: %.8e Wb\n', Phi_Stokes);
fprintf('-------------------------------------------------------\n');
fprintf('Max H_n:   %.2f mA/m (%.4f A/m)\n', max(Hn_mAm(:)), max(Hn_Am(:)));
fprintf('Min H_n:  %.2f mA/m\n', min(H_tot_mAm(:)));
fprintf('=======================================================\n');
