% Constantenaannames
mu0 = 4*pi*1e-7;

% Geometrie & Materiaal
a = 0.1;       % Lusstraal [m]
r = 0.1;       % Observatieradius [m]
z = 0.05;      % Observatiehoogte [m] (afstand lus tot observatiepunt)
t = 0.001;     % Schilddikte [m]
sigma = 3.5e7; % Geleidbaarheid [S/m] (bijv. koper/aluminium)
mur = 1;       % Relatieve permeabiliteit schild
i = 1.0;       % Lusstroom [A]

% 1. Eenmalige berekening van het quasi-statische referentieveld
I_imp = @(L) besselj(1, L*a) .* besselj(1, L*r) .* exp(-L*z);
A_imp_static = (mu0 * a * i / 2) * integral(I_imp, 0, Inf, 'RelTol', 1e-7, 'AbsTol', 1e-12);

% 2. Frequentiesweep (10 Hz tot 10 MHz)
f_vec = logspace(1, 7, 200); % 200 punten tussen 10 Hz en 10 MHz
A3_vec = zeros(size(f_vec));

for k = 1:length(f_vec)
    f = f_vec(k);
    w = 2*pi*f;

    % Quasi-statische integrand voor A3
    I3 = @(L) (sqrt(L.^2 + 1i*w*mu0*mur*sigma) ./ L) .* ...
        (1 ./ ((sqrt(L.^2 + 1i*w*mu0*mur*sigma)./L + mur).^2 - ...
        (sqrt(L.^2 + 1i*w*mu0*mur*sigma)./L - mur).^2 .* ...
        exp(-2*t*sqrt(L.^2 + 1i*w*mu0*mur*sigma)))) .* ...
        besselj(1, L*a) .* besselj(1, L*r) .* ...
        exp(-L*z - t*(sqrt(L.^2 + 1i*w*mu0*mur*sigma) - L));

    A3_vec(k) = 2 * mu0 * mur * a * i * integral(I3, 0, Inf, 'RelTol', 1e-6, 'AbsTol', 1e-12);
end

% 3. Overdrachtsfunctie en Afschermingsrendement (SE)
H_f = A3_vec ./ A_imp_static;
SE_dB = -20 * log10(abs(H_f));

% Grafische weergave
figure;
subplot(2,1,1);
semilogx(f_vec, SE_dB, 'LineWidth', 2);
grid on; xlabel('Frequentie [Hz]'); ylabel('Shielding Effectiveness SE [dB]');
title('Afschermingsrendement vs. Frequentie (Quasi-statisch)');

subplot(2,1,2);
loglog(f_vec, abs(A3_vec), 'LineWidth', 2); hold on;
yline(abs(A_imp_static), '--r', 'A_{imp} (Referentie)');
grid on; xlabel('Frequentie [Hz]'); ylabel('|A_{\phi}| [Wb/m]');
legend('|A_{\phi}^{(3)}|', '|A_{\phi,imp}|');