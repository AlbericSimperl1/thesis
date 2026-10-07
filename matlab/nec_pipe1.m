clear; clc; close all;

%% ---------------- Parameters ----------------
p.rRX      = 0.0005;      % RX loop radius [m]
p.rTX      = 0.15;      % TX loop radius [m]
p.l        = 0.30;      % TX-RX plane separation [m]  (RX pivot height)
p.phi_deg  = -15;       % physical RX tilt about its own center, about X-axis [deg]
                         % (matches angle2.m convention: phi about x, positive per Rx())
p.ns       = 36;        % segments per loop
p.wireRad  = 0.00001;     % wire radius [m]
p.freq_MHz = 10;        % frequency [MHz]
p.exTag    = 2;         % TX = tag 2, excited
p.rxTag    = 1;         % RX = tag 1

p.gridLim  = 0.20;      % near-field scan half-extent [m], in RX's own X-Y plane
p.nGrid    = 201;        % grid points per axis

input_file  = fullfile('nec', 'models', 'StxLrx_tilted.nec');
output_file = fullfile('nec', 'out',    'StxLrx_tilted.out');
[in_dir, ~, ~]  = fileparts(input_file);
[out_dir, ~, ~] = fileparts(output_file);
if ~exist(in_dir,'dir');  mkdir(in_dir);  end
if ~exist(out_dir,'dir'); mkdir(out_dir); end

%% ---------------- Build .nec file ----------------
% System-swap trick: RX stays FLAT (no rotation) at z = l, since we scan
% the near field in the plane parallel to RX's own plane. The relative
% RX tilt is instead applied to TX, rotated about the pivot (0,0,l)
% (= RX's own center) by the OPPOSITE angle, so the relative geometry
% between TX and RX is physically identical to tilting RX directly.
tx_tilt_deg = -p.phi_deg;                 % opposite rotation applied to TX
[y_mov, z_mov] = gm_pivot_offset(p.l, tx_tilt_deg);

lines = {};
lines{end+1} = 'CM Coaxial TX/RX loops, RX kept flat for near-field scan';
lines{end+1} = 'CE';

% RX loop (tag 1): align GA (X-Z plane) into X-Y plane, lift to z = l. No tilt.
lines{end+1} = sprintf('GA    %d    %d    %.6f    0    360    %.6f', p.rxTag, p.ns, p.rRX, p.wireRad);
lines{end+1} = sprintf('GM    0    0    90.0000    0.0    0.0    0.0000    0.0000    %.4f    %d', p.l, p.rxTag);

% TX loop (tag 2): align GA into X-Y plane, then tilt about pivot (0,0,l).
lines{end+1} = sprintf('GA    %d    %d    %.6f    0    360    %.6f', p.exTag, p.ns, p.rTX, p.wireRad);
lines{end+1} = sprintf('GM    0    0    90.0000    0.0    0.0    0.0000    0.0000    0.0000    %d', p.exTag);
lines{end+1} = sprintf('GM    0    0    %.4f    0.0    0.0    0.0000    %.4f    %.4f    %d', ...
                        tx_tilt_deg, y_mov, z_mov, p.exTag);

lines{end+1} = 'GE    0';
lines{end+1} = 'LD    0    1    1    1    60   0   0';
lines{end+1} = 'GN    -1';
lines{end+1} = 'EK';
lines{end+1} = sprintf('EX    0    %d    1    0    1    0    0', p.exTag);
lines{end+1} = sprintf('FR    0    0    0    0    %.4f    0', p.freq_MHz);

% Near-field H scan: flat X-Y plane at z = l (= RX's own plane)
step = 2*p.gridLim / (p.nGrid - 1);
lines{end+1} = sprintf('NH    0    %d    %d    1    %.4f    %.4f    %.4f    %.6f    %.6f    0', ...
                        p.nGrid, p.nGrid, -p.gridLim, -p.gridLim, p.l, step, step);
lines{end+1} = 'EN';

fid = fopen(input_file, 'w');
fprintf(fid, '%s\n', lines{:});
fclose(fid);

%% ---------------- Run nec2++ ----------------
cmd = sprintf('LD_PRELOAD=/usr/lib/libstdc++.so.6 nec2++ -i %s -o %s', input_file, output_file);
[status, cmdout] = system(cmd);
if status ~= 0
    error('Fout bij uitvoeren nec2++:\n%s', cmdout);
end

%% ---------------- Parse Near-Field Data ----------------
fid = fopen(output_file, 'r');
if fid == -1
    error('Kan %s niet openen.', output_file);
end

x = []; y = []; z = [];
H_tot = [];
in_near_field = false;

while ~feof(fid)
    line = fgetl(fid);

    if contains(line, 'NEAR MAGNETIC FIELD') || contains(line, 'NEAR FIELD')
        in_near_field = true;
        continue;
    end

    if in_near_field
        % Stop parsing bij volgende sectie
        if contains(line, 'RADIATION') || contains(line, 'TIMING') || (contains(line, '---') && ~isempty(x))
            break;
        end

        data = sscanf(line, '%f');

        % Standard nec2++ NH output (10 kolommen):
        % 1:X  2:Y  3:Z  4:|Hx|  5:PhX  6:|Hy|  7:PhY  8:|Hz|  9:PhZ  10:|Htot|
        if length(data) >= 10
            x(end+1)     = data(1);
            y(end+1)     = data(2);
            z(end+1)     = data(3);
            H_tot(end+1) = data(10) * 1000; % Kolom 10 is H_tot in A/m -> omzetten naar mA/m
        elseif length(data) == 9
            % Alternatieve builds zonder H_tot kolom
            x(end+1)     = data(1);
            y(end+1)     = data(2);
            z(end+1)     = data(3);
            Hxm = data(4); Hym = data(6); Hzm = data(8);
            H_tot(end+1) = sqrt(Hxm^2 + Hym^2 + Hzm^2) * 1000; % mA/m
        end
    end
end
fclose(fid);

%1.4557e-08 -8.6917e-03
I_real = 1.4557e-08;
I_imag = -8.6917e-03;
I_mag  = sqrt(I_real^2 + I_imag^2); % Berekent |I| (~0.016552 A)

H_tot  = H_tot / I_mag;
%% ---------------- Plot (robust grid reconstruction) ----------------
if isempty(H_tot)
    disp('Geen data gevonden.');
    return;
end

x_unique = unique(x);
y_unique = unique(y);
Nx = length(x_unique);
Ny = length(y_unique);

[~, ix] = ismember(x, x_unique);
[~, iy] = ismember(y, y_unique);
H_grid = nan(Ny, Nx);
H_grid(sub2ind([Ny, Nx], iy, ix)) = H_tot;

figure('Name', 'Near-Field H-total in RX-plane', 'Color', 'w');
imagesc(x_unique, y_unique, H_grid);
set(gca, 'YDir', 'normal');
colormap(jet); cb = colorbar; ylabel(cb, 'H tot [mA/m]');
xlabel('X_{RX-plane} [m]'); ylabel('Y_{RX-plane} [m]');
title(sprintf('Near Field H-total in RX-plane (\\phi = %g^\\circ, z = %.2f m)', p.phi_deg, p.l));
axis equal tight;
saveas(gcf, fullfile(out_dir, 'near_field_H3.png'));
disp('Heatmap succesvol opgeslagen!');

%% ---------------- Helper ----------------
function [y_mov, z_mov] = gm_pivot_offset(l, phi_deg)
    % Translation needed so that a GM rotation about the global origin
    % (by phi_deg about X) is equivalent to rotating a structure
    % currently centered at the origin about the external pivot (0,0,l).
    phi_rad = deg2rad(phi_deg);
    y_mov = l * sin(phi_rad);
    z_mov = l * (1 - cos(phi_rad));
end
