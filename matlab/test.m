fc = 1e3;                          % corner frequency (Hz), from tau
f  = logspace(0, 6, 500);          % 1 Hz to 1 MHz
r  = f / fc;
SE = 20*log10(r ./ sqrt(1 + r.^2));

figure; 
semilogx(f, SE, 'LineWidth', 2); hold on;
semilogx(f, 20*log10(max(r,1e-12)), '--', 'LineWidth', 1);   % asymptote
yline(0, ':');                                              % 0 dB plateau
xline(fc, '--k');                                           % corner
plot(fc, -3, 'o', 'MarkerFaceColor', 'r');
text(fc*1.4, -12, 'f_c \approx 1/(2\pi\tau)');

xlabel('Frequency (Hz)');
ylabel('Shielding effectiveness, SE (dB)');
ylim([-25 45]);
grid on; grid minor;
legend({'SE(f)','20 dB/decade asymptote'}, 'Location','southeast');
title('SE vs frequency: high-pass corner at f_c');
