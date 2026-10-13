
clear; clc; close all;

% parameters
f = 10e6;
omega = 2 * pi * f;
mu0 = 4 * pi * 1e-7;
eps0 = 8.8541878128e-12;

R = 0.15;
a = R;
b = R;

sigma = 4.5e5;
t = 0.2e-3; % thickness
mu_r = 1;
eps_r = 1;

% wave number k
k0 = omega * sqrt(mu0 * eps0);
k_m = sqrt(omega^2 * mu0 * eps0 * eps_r - 1j * omega * mu0 * mu_r * sigma);

% distances
d_scales = [0.1, 0.5, 1.0, 2.0];
d_vec = d_scales * R;

% angles
theta_deg = 0:1:89;
theta_rad = deg2rad(theta_deg);

% matrix: SE(aantal_afstanden, aantal_hoeken)
SE_dB = zeros(length(d_vec), length(theta_deg));

% numeric approximation
for i = 1:length(d_vec)
    z0 = d_vec(i);
    fprintf('d = %.1f * R (z0 = %.4f m)...\n', d_ratios(i), z0);

    % upperbound e^(-lambda*z0) damping
    lambda_max = 60 / z0;

    for j = 1:length(theta_rad)
        th = theta_rad(j);

        % zone 1: free space
        flux_open = calculate_flux(a, b, z0, th, k0, k0, 1, 0, lambda_max, mu0);

        % zone 3: after shield
        flux_shield = calculate_flux(a, b, z0, th, k0, k_m, mu_r, t, lambda_max, mu0);

        % SE as flux linkage ratio
        SE_dB(i, j) = 20 * log10(abs(flux_open / flux_shield));
    end
end

% plotting
figure('Color', 'w', 'Position', [150, 150, 850, 520]);
plot(theta_deg, SE_dB(1, :), 'r-',  'LineWidth', 2, 'DisplayName', 'd = 0.1 R'); hold on;
plot(theta_deg, SE_dB(2, :), 'b--', 'LineWidth', 2, 'DisplayName', 'd = 0.5 R');
plot(theta_deg, SE_dB(3, :), 'g-.', 'LineWidth', 2, 'DisplayName', 'd = 1.0 R');
plot(theta_deg, SE_dB(4, :), 'm:',  'LineWidth', 2, 'DisplayName', 'd = 2.0 R');

grid on;
xlabel('Rx angle \theta (°)', 'FontSize', 12);
ylabel('SE (dB)', 'FontSize', 12);
title('SE vs \theta', 'FontSize', 13);
legend('Location', 'northeast', 'FontSize', 11);
xlim([0 89]);

% fucntions

function Phi = calculate_flux(a, b, z0, theta, k0, k_mat, mu_r, t, lambda_max, mu0)
    % z-component van de normaalvector bij rotatie om y-as
    % n_z by rotating about y
    R33 = cos(theta);
    if abs(R33) < 1e-12
        Phi = 0;
        return;
    end

    % f(lambda, alpha)
    integrand = @(lambda, alpha) flux_integrand(lambda, alpha, a, b, z0, theta, k0, k_mat, mu_r, t);

    % 2d integral over lambda and alpha
    int_val = integral2(integrand, 0, lambda_max, 0, 2*pi, 'RelTol', 1e-5, 'AbsTol', 1e-8);

    % total flux
    Phi = (mu0 * a * b^2 * R33 / 2) * int_val;
end

function val = flux_integrand(lambda, alpha, a, b, z0, theta, k0, k_mat, mu_r, t)
    % rotation about y "scales" to an ellips
    Lam = lambda .* b .* sqrt((cos(theta).*cos(alpha)).^2 + (sin(alpha)).^2);

    % Bessel evaluations
    J1_Lam_over_Lam = zeros(size(Lam));
    idx_zero = (Lam < 1e-10);
    J1_Lam_over_Lam(idx_zero) = 0.5; % taylor limit
    J1_Lam_over_Lam(~idx_zero) = besselj(1, Lam(~idx_zero)) ./ Lam(~idx_zero);

    % propagation constants
    % free space transmission
    tau0 = sqrt(lambda.^2 - k0^2);

    if t == 0
        % transmission factor
        F_tilde = exp(-tau0 .* z0);
    else
        % material transmission
        tau = sqrt(lambda.^2 - k_mat^2);
        K = tau ./ (mu_r .* tau0);

        num = 2 .* K .* exp(-tau0 .* (z0 - t) - tau .* t);
        den = (K + 1).^2 - (K - 1).^2 .* exp(-2 .* tau .* t);
        F_tilde = num ./ den;
    end
    % ==   sommerfeld weight   * transmission factor/distance traveled * tx geometry (static)     * rx loop surface integral
    val = (lambda.^2 ./ tau0) .* F_tilde                              .* besselj(1, lambda .* a) .* J1_Lam_over_Lam;
end
