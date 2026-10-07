%% near_field_H.m  --  Parse nec2++ NH-output en plot |H|-totaal als heatmap
clear; close all; clc;

%% 1. Voer nec2++ uit vanuit de huidige map 'matlab/'
input_file  = fullfile('nec', 'models', 'StxLrx.nec');
output_file = fullfile('nec', 'out',    'StxLrx.out');

cmd = sprintf('LD_PRELOAD=/usr/lib/libstdc++.so.6 nec2++ -i %s -o %s', ...
              input_file, output_file);
[status, cmdout] = system(cmd);
if status ~= 0
    error('Fout bij uitvoeren nec2++:\n%s', cmdout);
end

%% 2. Parse Near-Field (NH) data
fid = fopen(output_file, 'r');
if fid == -1
    error('Kan %s niet openen.', output_file);
end

x = []; y = []; z = [];
H_tot = [];
in_near_field = false;

while ~feof(fid)
    line = fgetl(fid);
    if ~ischar(line), continue; end

    % Start van de magnetische nabije-veld sectie
    if contains(line, 'NEAR MAGNETIC FIELD') || contains(line, 'NEAR FIELD')
        in_near_field = true;
        continue;
    end

    if in_near_field
        % Stop zodra een nieuwe sectie begint
        if contains(line, 'RADIATION') || contains(line, 'TIMING') || ...
           (contains(line, '---') && ~isempty(x))
            break;
        end

        data = sscanf(line, '%f');

        if numel(data) == 9
            % NH-sectie: X Y Z  HXr HXi  HYr HYi  HZr HZi
            x(end+1) = data(1); y(end+1) = data(2); z(end+1) = data(3);
            Hx = data(4) + 1i*data(5);
            Hy = data(6) + 1i*data(7);
            Hz = data(8) + 1i*data(9);
            H_tot(end+1) = sqrt(abs(Hx)^2 + abs(Hy)^2 + abs(Hz)^2) * 1000; % mA/m

        elseif numel(data) >= 15
            % Mocht jouw nec2++ E+H printen: X Y Z EX..EZ HX..HZ
            x(end+1) = data(1); y(end+1) = data(2); z(end+1) = data(3);
            Hx = data(10) + 1i*data(11);
            Hy = data(12) + 1i*data(13);
            Hz = data(14) + 1i*data(15);
            H_tot(end+1) = sqrt(abs(Hx)^2 + abs(Hy)^2 + abs(Hz)^2) * 1000; % mA/m
        end
        % regels met <9 getallen (kopregels/lege regels) worden genegeerd
    end
end
fclose(fid);

%% 3. Bouw het 2D-rooster (volgorde-onafhankelijk via ismember)
if isempty(H_tot)
    disp('Geen near-field data gevonden.');
    return;
end

x_unique = unique(x);
y_unique = unique(y);
Nx = numel(x_unique);
Ny = numel(y_unique);

fprintf('Rooster: Nx=%d, Ny=%d, punten=%d\n', Nx, Ny, numel(H_tot));
assert(numel(H_tot) == Nx*Ny, ...
       'Puntental (%d) komt niet overeen met Nx*Ny (%d). Controleer de NH-card / parsing.', ...
       numel(H_tot), Nx*Ny);

[~, ix] = ismember(x, x_unique);   % kolom-index per punt
[~, iy] = ismember(y, y_unique);   % rij-index per punt

H_grid = zeros(Ny, Nx);
H_grid(sub2ind([Ny, Nx], iy, ix)) = H_tot;

%% 4. Sanity-check vs. xnec2c
[Hmax, linIdx] = max(H_grid(:));
[iyMax, ixMax] = ind2sub([Ny, Nx], linIdx);
fprintf('Max |H| = %.1f mA/m op (X=%.4f, Y=%.4f)\n', ...
        Hmax, x_unique(ixMax), y_unique(iyMax));
% Verwacht (uit xnec2c): ~326 mA/m op (X=0, Y=0.1)

%% 5. Plot als 2D heatmap
figure('Name', 'Near-Field H-total', 'Color', 'w');
imagesc(x_unique, y_unique, H_grid);
set(gca, 'YDir', 'normal');          % Y-as niet ondersteboven

colormap(jet);
cb = colorbar;
ylabel(cb, 'H tot [mA/m]');

xlabel('X [m]');
ylabel('Y [m]');
title('Near Field H-total');
axis equal tight;

out_png = fullfile('..', 'nec', 'out', 'near_field_H.png');
saveas(gcf, out_png);
fprintf('Heatmap opgeslagen: %s\n', out_png);
