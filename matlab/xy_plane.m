clear; close all; clc;

% parameters
p.R1 = 0.15;
p.I0 = 1.0;
p.f = 10e6;
p.sigma = 3.5e7;
p.mur = 1.0;
p.t = 1.5875e-3;
p.uMax = 90;
p.uMin = 1e-6;
p.nLambda = 2200;
p.chunkSize = 700;
p.seComponent = "magnitude";
zList = [p.R1/2, p.R1, 2*p.R1];
p.mu0 = 4*pi*1e-7;
p.eps0 = 8.854187817e-12;
p.omega = 2*pi*p.f;
p.muShield = p.mu0*p.mur;

% generate points
rPts = linspace(0, 2.5*p.R1, 10).';
thetaPts = linspace(0, 1.65*pi, 10).';
xyPts = [rPts.*cos(thetaPts), rPts.*sin(thetaPts)];
sePts = zeros(size(xyPts,1), numel(zList));
hOpenPts = zeros(size(xyPts,1), numel(zList));
hClosedPts = zeros(size(xyPts,1), numel(zList));

for iz = 1:numel(zList)
    z = zList(iz);
    Hopen = hfield_xy(xyPts(:,1), xyPts(:,2), z, p, "open");
    Hclosed = hfield_xy(xyPts(:,1), xyPts(:,2), z, p, "closed");
    sePts(:,iz) = se_db(Hopen, Hclosed, p.seComponent);
    hOpenPts(:,iz) = Hopen.mag(:);
    hClosedPts(:,iz) = Hclosed.mag(:);
end

fprintf(' R1 = %.4g m.\n\n', p.R1);
seColumnNames = compose('SE_plane_%gR1_dB', zList/p.R1);
seColumnNames = cellstr(reshape(matlab.lang.makeValidName(seColumnNames), 1, []));
disp(array2table([(1:10).', xyPts/p.R1, sePts], ...
    'VariableNames', [{'Point','x_over_R1','y_over_R1'}, seColumnNames]));

% plane
gridLimit = 2.5*p.R1;
nGrid = 81;
xv = linspace(-gridLimit, gridLimit, nGrid);
yv = linspace(-gridLimit, gridLimit, nGrid);
[X, Y] = meshgrid(xv, yv);

HopenPlanes  = cell(1, numel(zList));
HclosedPlanes = cell(1, numel(zList));
SEplanes      = cell(1, numel(zList));

hrefPlanes = 0;
for iz = 1:numel(zList)
    z = zList(iz);
    HopenPlanes{iz}  = hfield_xy(X, Y, z, p, "open");
    HclosedPlanes{iz} = hfield_xy(X, Y, z, p, "closed");
    SEplanes{iz}     = se_db(HopenPlanes{iz}, HclosedPlanes{iz}, p.seComponent);
    hrefPlanes = max(hrefPlanes, max(HopenPlanes{iz}.mag(:)));
end

% open & closed
hOpenDb   = cell(1, numel(zList));
hClosedDb = cell(1, numel(zList));
climLowPlanes = 0;
for iz = 1:numel(zList)
    hOpenDb{iz}   = 20*log10(max(HopenPlanes{iz}.mag, realmin) / hrefPlanes);
    hClosedDb{iz} = 20*log10(max(HclosedPlanes{iz}.mag, realmin) / hrefPlanes);
    climLowPlanes = min([climLowPlanes, min(hOpenDb{iz}(:)), min(hClosedDb{iz}(:))]);
end
climLowPlanes = max(-120, floor(climLowPlanes/10)*10);

% 3x3 figuer
figure('Name', 'H-field and SE – combined', 'Color', 'w');
tiledlayout(3, numel(zList), 'TileSpacing', 'compact', 'Padding', 'compact');

% open
for iz = 1:numel(zList)
    nexttile;
    imagesc(xv/p.R1, yv/p.R1, hOpenDb{iz});
    axis image xy;
    hold on;
    plot_loop_projection(p.R1, 'w--');
    colorbar;
    colormap(gca, parula);
    caxis([climLowPlanes, 0]);
    xlabel('x/R_1'); ylabel('y/R_1');
    title(sprintf('Open, z = %.2g R_1', zList(iz)/p.R1));
end

% closed
for iz = 1:numel(zList)
    nexttile;
    imagesc(xv/p.R1, yv/p.R1, hClosedDb{iz});
    axis image xy;
    hold on;
    plot_loop_projection(p.R1, 'w--');
    colorbar;
    colormap(gca, parula);
    caxis([climLowPlanes, 0]);
    xlabel('x/R_1'); ylabel('y/R_1');
    title(sprintf('Closed, z = %.2g R_1', zList(iz)/p.R1));
end

% se
for iz = 1:numel(zList)
    nexttile;
    imagesc(xv/p.R1, yv/p.R1, SEplanes{iz});
    axis image xy;
    hold on;
    plot_loop_projection(p.R1, 'w--');
    plot(xyPts(:,1)/p.R1, xyPts(:,2)/p.R1, 'wo', ...
        'MarkerFaceColor', 'k', 'MarkerSize', 4);
    colorbar;
    colormap(gca, turbo);
    xlabel('x/R_1'); ylabel('y/R_1');
    title(sprintf('SE, z = %.2g R_1', zList(iz)/p.R1));
end

% H
function H = hfield_xy(X, Y, z, p, caseName)
    originalSize = size(X);
    x = X(:).';
    y = Y(:).';
    r = hypot(x, y);
    nPoints = numel(r);
    u = linspace(p.uMin, p.uMax, p.nLambda);
    lambda = u/p.R1;
    tau0 = lambda;
    tau = sqrt(lambda.^2 - 1i*p.omega*p.muShield*p.sigma);
    K = tau./tau0;
    C = 1./((K + p.mur).^2 - (K - p.mur).^2.*exp(-2*p.t*tau));
    J1a = besselj(1, lambda*p.R1);
    Hr = zeros(1, nPoints);
    Hz = zeros(1, nPoints);
    for first = 1:p.chunkSize:nPoints
        last = min(first + p.chunkSize - 1, nPoints);
        rc = r(first:last);
        lambdaR = lambda(:)*rc;
        J0r = besselj(0, lambdaR);
        J1r = besselj(1, lambdaR);
        switch lower(caseName)
            case "open"
                expTerm = exp(-tau0*z);
                brWeight = lambda .* J1a .* expTerm;
                bzWeight = (lambda.^2 ./ tau0) .* J1a .* expTerm;
                prefactor = p.mu0*p.R1*p.I0/2;
            case "closed"
                expTerm = exp(-tau0*z - p.t*(tau - tau0));
                brWeight = (C .* lambda .* tau ./ tau0) .* J1a .* expTerm;
                bzWeight = (C .* lambda.^2 .* tau ./ tau0.^2) .* J1a .* expTerm;
                prefactor = 2*p.mu0*p.mur*p.R1*p.I0;
            otherwise
                error('caseName must be "open" or "closed".');
        end
        Br = prefactor * trapz(lambda, brWeight(:).*J1r, 1);
        Bz = prefactor * trapz(lambda, bzWeight(:).*J0r, 1);
        Hr(first:last) = Br/p.mu0;
        Hz(first:last) = Bz/p.mu0;
    end
    H.Hr = reshape(Hr, originalSize);
    H.Hz = reshape(Hz, originalSize);
    H.mag = reshape(sqrt(abs(Hr).^2 + abs(Hz).^2), originalSize);
end

% vector potential
function A = a3_phi_xy(X, Y, z, p)
    originalSize = size(X);
    x = X(:).';
    y = Y(:).';
    r = hypot(x, y);
    nPoints = numel(r);
    u = linspace(p.uMin, p.uMax, p.nLambda);
    lambda = u/p.R1;
    tau0 = lambda;
    tau = sqrt(lambda.^2 - 1i*p.omega*p.muShield*p.sigma);
    K = tau./tau0;
    C = 1./((K + p.mur).^2 - (K - p.mur).^2.*exp(-2*p.t*tau));
    J1a = besselj(1, lambda*p.R1);
    expTerm = exp(-tau0*z - p.t*(tau - tau0));
    aWeight = (C .* lambda .* tau ./ tau0.^2) .* J1a .* expTerm;
    prefactor = 2*p.mu0*p.mur*p.R1*p.I0;
    Aphi = zeros(1, nPoints);
    for first = 1:p.chunkSize:nPoints
        last = min(first + p.chunkSize - 1, nPoints);
        rc = r(first:last);
        J1r = besselj(1, lambda(:)*rc);
        Aphi(first:last) = prefactor * trapz(lambda, aWeight(:).*J1r, 1);
    end
    rSafe = max(r, eps);
    Ax = -Aphi.*y./rSafe;
    Ay =  Aphi.*x./rSafe;
    Ax(r < eps) = 0;
    Ay(r < eps) = 0;
    A.phi = reshape(Aphi, originalSize);
    A.x   = reshape(Ax, originalSize);
    A.y   = reshape(Ay, originalSize);
end

% SE
function SE = se_db(Hopen, Hclosed, component)
    switch lower(component)
        case "z"
            openStrength   = abs(Hopen.Hz);
            closedStrength = abs(Hclosed.Hz);
        case "magnitude"
            openStrength   = Hopen.mag;
            closedStrength = Hclosed.mag;
        otherwise
            error('component must be "magnitude" or "z".');
    end
    SE = 20*log10(max(openStrength, realmin)./max(closedStrength, realmin));
end

function plot_loop_projection(R1, styleSpec)
    th = linspace(0, 2*pi, 361);
    plot(cos(th), sin(th), styleSpec, 'LineWidth', 1.1);
    text(1.05, 0, 'R_1', 'Color', styleSpec(1), 'FontWeight', 'bold');
end

% points
function plot_h_quiver(X, Y, H, R1)
    stride = max(1, round(size(X,1)/16));
    Xq = X(1:stride:end, 1:stride:end);
    Yq = Y(1:stride:end, 1:stride:end);
    rq = hypot(Xq, Yq);
    rqSafe = max(rq, eps);
    Hrq = H.Hr(1:stride:end, 1:stride:end);
    Hx = real(Hrq).*Xq./rqSafe;
    Hy = real(Hrq).*Yq./rqSafe;
    Hx(rq < eps) = 0;
    Hy(rq < eps) = 0;
    quiver(Xq/R1, Yq/R1, Hx, Hy, 'k', ...
        'AutoScale', 'on', 'AutoScaleFactor', 0.75, 'LineWidth', 0.7);
end