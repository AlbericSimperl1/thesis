clear; clc; close all;

%% ---------------- Parameters ----------------
p.gridLim  = 0.20;      % near-field scan half-extent [m]
p.nGrid    = 401;       % grid points per axis
p.rRX      = 0.05;      % RX loop radius [m]
p.phi_deg  = -15;       % tilt angle for title reference
p.l        = 0.30;      % TX-RX plane separation [m]
mu0        = 4*pi*1e-7; % Permeabiliteit [H/m]

% Bepaal cel-oppervlakte voor de flux-integraal
step = 2 * p.gridLim / (p.nGrid - 1);
dA   = step^2;

% Paden naar de output files
file_open   = fullfile('nec', 'out', 'rot.out');
file_shield = fullfile('nec', 'out', 'rotS.out');

%% ---------------- Parse & Normalize Near-Field Data ----------------
disp('Bezig met inlezen en normaliseren open bestand (rot.out)...');
[x_o, y_o, Hz_o, H_tot_o, I_mag_o] = parse_and_normalize_nec(file_open);

disp('Bezig met inlezen en normaliseren shielded bestand (rotS.out)...');
[x_s, y_s, Hz_s, H_tot_s, I_mag_s] = parse_and_normalize_nec(file_shield);

fprintf('\nGeëxtraheerde Antennestromen:\n');
fprintf('  Open case   |I_input| : %.6e A\n', I_mag_o);
fprintf('  Shielded    |I_input| : %.6e A\n', I_mag_s);

%% ---------------- Bereken Totale Flux & Globale SE ----------------
% Vind alle gridpunten die binnen de RX lus vallen
in_loop_o = (x_o.^2 + y_o.^2) <= (p.rRX^2);
in_loop_s = (x_s.^2 + y_s.^2) <= (p.rRX^2);

% Oppervlakte-integraal van de genormaliseerde Hz component (complex)
Phi_open   = sum(mu0 .* Hz_o(in_loop_o) .* dA);
Phi_shield = sum(mu0 .* Hz_s(in_loop_s) .* dA);

% Globale SE gebaseerd op de genormaliseerde flux linkage
SE_flux_dB = 20 * log10(abs(Phi_open) / abs(Phi_shield));

fprintf('\n================ RESULTS (GENORMALISEERD) ================\n');
fprintf('Aantal gridpunten in RX lus : %d\n', sum(in_loop_o));
fprintf('Flux linkage open   |Phi/I| : %.6e Wb/A\n', abs(Phi_open));
fprintf('Flux linkage closed |Phi/I| : %.6e Wb/A\n', abs(Phi_shield));
fprintf('Shielding Effectiveness (SE): %.2f dB\n', SE_flux_dB);
fprintf('=========================================================\n\n');

%% ---------------- Reconstruct Grids voor Plots ----------------
expected_pts = p.nGrid * p.nGrid;

if length(H_tot_o) == expected_pts && length(H_tot_s) == expected_pts
    x_unique = linspace(-p.gridLim, p.gridLim, p.nGrid);
    y_unique = linspace(-p.gridLim, p.gridLim, p.nGrid);

    % NEC bouwt eerst X (kolommen) op en daarna Y (rijen).
    % Transponeren (.') zet dit direct om naar een strakke (Ny, Nx) matrix zonder strepen.
    H_grid_open   = reshape(H_tot_o, [p.nGrid, p.nGrid]).';
    H_grid_shield = reshape(H_tot_s, [p.nGrid, p.nGrid]).';
else
    error('Aantal ingelezen punten (%d) komt niet overeen met nGrid^2 (%d).', ...
        length(H_tot_o), expected_pts);
end

% Lokale SE op elk gridpunt berekenen
H_open_safe   = max(H_grid_open, realmin);
H_shield_safe = max(H_grid_shield, realmin);
SE_grid_local = 20 * log10(H_open_safe ./ H_shield_safe);

%% ---------------- Visualisatie (3 Subplots) ----------------
fig = figure('Name', 'Genormaliseerde TX/RX Shielding Vergelijking', ...
             'Color', 'w', 'Position', [50, 100, 1450, 480], 'Visible', 'off');
tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% 1. Open Field Plot (Genormaliseerd)
nexttile;
imagesc(x_unique, y_unique, H_grid_open);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--');
colormap(gca, jet);
cb1 = colorbar; ylabel(cb1, 'H_{tot} / |I| [(mA/m)/A]');
xlabel('X [m]'); ylabel('Y [m]');
title('1. Open Veld (Genormaliseerd)');
axis equal tight;

% 2. Shielded Field Plot (Genormaliseerd)
nexttile;
imagesc(x_unique, y_unique, H_grid_shield);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--');
colormap(gca, jet);
cb2 = colorbar; ylabel(cb2, 'H_{tot} / |I| [(mA/m)/A]');
xlabel('X [m]'); ylabel('Y [m]');
title('2. Shielded Veld (Genormaliseerd)');
axis equal tight;

% 3. Lokale Shielding Effectiveness Plot
nexttile;
imagesc(x_unique, y_unique, SE_grid_local);
set(gca, 'YDir', 'normal'); hold on;
plot_loop_projection(p.rRX, 'w--');
colormap(gca, turbo);
cb3 = colorbar; ylabel(cb3, 'SE [dB]');
xlabel('X [m]'); ylabel('Y [m]');
title('3. Lokale SE (Verhouding)');
axis equal tight;

sgtitle(sprintf('Genormaliseerd Open vs Shielded | \\phi = %g^\\circ | SE = %.2f dB', p.phi_deg, SE_flux_dB), ...
    'FontWeight', 'bold', 'FontSize', 12);

% Sla de figuur op als afbeelding
output_png = 'shielding_result.png';
exportgraphics(fig, output_png, 'Resolution', 300);
fprintf('Grafiek succesvol opgeslagen als: %s\n', output_png);

%% ======================= Helper Functies =======================
function [x, y, Hz_complex, H_tot, I_mag] = parse_and_normalize_nec(output_file)
    fid = fopen(output_file, 'r');
    if fid == -1
        error('Kan het bestand %s niet openen.', output_file);
    end

    I_real = []; I_imag = [];
    x = []; y = []; Hz_complex = []; H_tot = [];

    in_antenna_input = false;
    in_near_field = false;

    while ~feof(fid)
        line = fgetl(fid);
        if ~ischar(line), break; end

        % 1. Extraheer Antennestroom uit - ANTENNA INPUT PARAMETERS -
        if contains(line, 'ANTENNA INPUT PARAMETERS')
            in_antenna_input = true;
            continue;
        end
        if in_antenna_input
            data_I = sscanf(line, '%f');
            if length(data_I) >= 6 && isempty(I_real)
                I_real = data_I(5);
                I_imag = data_I(6);
                in_antenna_input = false;
            end
        end

        % 2. Extraheer Near-Field data
        if contains(line, 'NEAR MAGNETIC FIELD') || contains(line, 'NEAR FIELD')
            in_near_field = true;
            continue;
        end

        if in_near_field
            % Stoppen ALLEEN bij een nieuwe echte NEC-sectie (negeer '---' lijnen)
            if contains(line, 'RADIATION PATTERN') || contains(line, 'TIMING') || contains(line, 'NEXT DATA CARD')
                break;
            end

            data = sscanf(line, '%f');

            % Enkel regels verwerken die daadwerkelijk getallen bevatten
            if length(data) >= 7
                x(end+1) = data(1); %#ok<*SAGROW>
                y(end+1) = data(2);

                if length(data) >= 10
                    Hzm = data(8);
                    Hzp = data(9);
                    Hz  = Hzm * exp(1i * deg2rad(Hzp));

                    Hz_complex(end+1) = Hz;
                    H_tot(end+1)      = data(10) * 1000; % [mA/m]

                elseif length(data) == 9
                    Hzm = data(8);
                    Hzp = data(9);
                    Hz  = Hzm * exp(1i * deg2rad(Hzp));

                    Hxm = data(4); Hym = data(6);
                    Hz_complex(end+1) = Hz;
                    H_tot(end+1)      = sqrt(Hxm^2 + Hym^2 + Hzm^2) * 1000; % [mA/m]
                end
            end
        end
    end
    fclose(fid);

    % Controleer of er daadwerkelijk punten zijn ingelezen
    fprintf('   -> [%s] Ingelezen punten: %d\n', output_file, length(H_tot));

    % Bereken stroommagnitude
    if isempty(I_real) || isempty(I_imag)
        warning('Geen antennestroom gevonden in %s! Normalisatie niet toegepast (I_mag = 1).', output_file);
        I_mag = 1;
    else
        I_mag = sqrt(I_real^2 + I_imag^2);
    end

    % Normaliseer de velden
    Hz_complex = Hz_complex / I_mag;
    H_tot      = H_tot / I_mag;
end

function plot_loop_projection(r, styleSpec)
    th = linspace(0, 2*pi, 361);
    plot(r*cos(th), r*sin(th), styleSpec, 'LineWidth', 1.2);
end
