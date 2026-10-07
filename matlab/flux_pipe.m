%/home/alberic/matlab/bin/matlab -batch "addpath('matlab'); flux_pipe"

clear; clc; close all;

%% ---------------- Parameters ----------------
p.gridLim  = 0.20;      % near-field scan half-extent [m]
p.nGrid    = 201;       % grid points per axis
p.rRX      = 0.05;      % RX loop radius [m] (Let op: moet groot genoeg zijn voor grid step)
p.phi_deg  = -15;       % tilt angle for title reference
p.l        = 0.30;      % TX-RX plane separation [m]
mu0        = 4*pi*1e-7; % Permeabiliteit [H/m]

% Bepaal cel-oppervlakte voor de flux-integraal
step = 2 * p.gridLim / (p.nGrid - 1);
dA   = step^2;

% Paden naar je output files
file_open   = fullfile('nec', 'out', 'rot.out');
file_shield = fullfile('nec', 'out', 'rotS.out');

%% ---------------- Parse Near-Field Data ----------------
disp('Bezig met inlezen open bestand (rot.out)...');
[x_o, y_o, Hz_o, H_tot_o] = parse_nec_nearfield(file_open);

disp('Bezig met inlezen shielded bestand (rotS.out)...');
[x_s, y_s, Hz_s, H_tot_s] = parse_nec_nearfield(file_shield);

%% ---------------- Bereken Totale Flux & Globale SE ----------------
% Vind alle gridpunten die binnen de RX lus vallen
in_loop_o = (x_o.^2 + y_o.^2) <= (p.rRX^2);
in_loop_s = (x_s.^2 + y_s.^2) <= (p.rRX^2);

% Oppervlakte-integraal (Stokes) via de normale component (Z-as)
Phi_open   = sum(mu0 .* Hz_o(in_loop_o) .* dA);
Phi_shield = sum(mu0 .* Hz_s(in_loop_s) .* dA);

% Globale SE gebaseerd op de flux linkage
SE_flux_dB = 20 * log10(abs(Phi_open) / abs(Phi_shield));

fprintf('\n================ RESULTS ================\n');
fprintf('Aantal gridpunten in RX lus : %d\n', sum(in_loop_o));
fprintf('Flux linkage open   |Phi|   : %.6e Wb\n', abs(Phi_open));
fprintf('Flux linkage closed |Phi|   : %.6e Wb\n', abs(Phi_shield));
fprintf('Shielding Effectiveness (SE): %.2f dB\n', SE_flux_dB);
fprintf('=========================================\n\n');

%% ---------------- Reconstruct Grids voor Plots ----------------
x_unique = unique(x_o);
y_unique = unique(y_o);
Nx = length(x_unique);
Ny = length(y_unique);

% Grid reconstructie voor H-total (in mA/m voor mooie plotwaardes)
[~, ix_o] = ismember(x_o, x_unique);
[~, iy_o] = ismember(y_o, y_unique);
H_grid_open = nan(Ny, Nx);
H_grid_open(sub2ind([Ny, Nx], iy_o, ix_o)) = H_tot_o;

[~, ix_s] = ismember(x_s, x_unique);
[~, iy_s] = ismember(y_s, y_unique);
H_grid_shield = nan(Ny, Nx);
H_grid_shield(sub2ind([Ny, Nx], iy_s, ix_s)) = H_tot_s;

% Lokale SE op elk gridpunt berekenen
H_open_safe   = max(H_grid_open, realmin);
H_shield_safe = max(H_grid_shield, realmin);
SE_grid_local = 20 * log10(H_open_safe ./ H_shield_safe);

%% ---------------- Visualisatie (3 Subplots) ----------------
figure('Name', 'TX/RX Shielding Vergelijking', 'Color', 'w', 'Position', [50, 100, 1450, 480]);
tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% 1. Open Field Plot
nexttile;
imagesc(x_unique, y_unique, H_grid_open);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--'); % Teken de RX lus
colormap(gca, jet);
cb1 = colorbar; ylabel(cb1, 'H_{tot} [mA/m]');
xlabel('X [m]'); ylabel('Y [m]');
title('1. Open Veld');
axis equal tight;

% 2. Shielded Field Plot
nexttile;
imagesc(x_unique, y_unique, H_grid_shield);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--'); % Teken de RX lus
colormap(gca, jet);
cb2 = colorbar; ylabel(cb2, 'H_{tot} [mA/m]');
xlabel('X [m]'); ylabel('Y [m]');
title('2. Shielded Veld');
axis equal tight;

% 3. Lokale Shielding Effectiveness Plot
nexttile;
imagesc(x_unique, y_unique, SE_grid_local);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--'); % Teken de RX lus
colormap(gca, turbo);
cb3 = colorbar; ylabel(cb3, 'SE [dB]');
xlabel('X [m]'); ylabel('Y [m]');
title('3. Lokale SE (H-veld verhouding)');
axis equal tight;

sgtitle(sprintf('Open vs Shielded | \\phi = %g^\\circ | Globale Flux SE = %.2f dB', p.phi_deg, SE_flux_dB), ...
    'FontWeight', 'bold', 'FontSize', 12);

disp('Figuren zijn succesvol gegenereerd!');

%% ======================= Helper Functies =======================
function [x, y, Hz_complex, H_tot] = parse_nec_nearfield(output_file)
    % Leest x, y, complexe Hz [A/m] en de magnitude van het totale veld [mA/m] uit.
    fid = fopen(output_file, 'r');
    if fid == -1
        error('Kan het bestand %s niet openen.', output_file);
    end

    x = []; y = []; Hz_complex = []; H_tot = [];
    in_near_field = false;

    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'NEAR MAGNETIC FIELD') || contains(line, 'NEAR FIELD')
            in_near_field = true;
            continue;
        end
        if in_near_field
            if contains(line, 'RADIATION') || contains(line, 'TIMING') || (contains(line, '---') && ~isempty(x))
                break;
            end
            data = sscanf(line, '%f');
            if length(data) >= 7
                x(end+1) = data(1);
                y(end+1) = data(2);

                if length(data) == 9
                    % nec2++ magnitude/phase formaat
                    Hxm = data(4); Hxp = data(5);
                    Hym = data(6); Hyp = data(7);
                    Hzm = data(8); Hzp = data(9);
                    Hx = Hxm * exp(1i * deg2rad(Hxp));
                    Hy = Hym * exp(1i * deg2rad(Hyp));
                    Hz = Hzm * exp(1i * deg2rad(Hzp));

                    Hz_complex(end+1) = Hz; % Blijft in A/m voor flux calculatie
                    H_tot(end+1) = sqrt(abs(Hx)^2 + abs(Hy)^2 + abs(Hz)^2) * 1000; % [mA/m]
                elseif length(data) >= 10
                    % Re/Im formaat
                    Hx = data(4) + 1i * data(5);
                    Hy = data(6) + 1i * data(7);
                    Hz = data(8) + 1i * data(9);

                    Hz_complex(end+1) = Hz; % Blijft in A/m voor flux calculatie
                    H_tot(end+1) = sqrt(abs(Hx)^2 + abs(Hy)^2 + abs(Hz)^2) * 1000; % [mA/m]
                else
                    Hz_complex(end+1) = data(8); % Fallback
                    H_tot(end+1) = data(4) * 1000;
                end
            end
        end
    end
    fclose(fid);
end

function plot_loop_projection(r, styleSpec)
    % Tekent een gestippelde cirkel om de RX positie aan te geven
    th = linspace(0, 2*pi, 361);
    plot(r*cos(th), r*sin(th), styleSpec, 'LineWidth', 1.2);
end
