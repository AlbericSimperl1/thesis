= Physics behind near-field magnetic shielding <sec:physics>

== The quasi-static near-field regime
The boundary between the near- and far-field region of a small radiator lies at

$ r = lambda / (2 pi) = 1 / k, quad k = omega sqrt(mu_0 epsilon_0), $ <eq:nf-boundary>

so that the near-field condition reads $k r << 1$. For frequencies from a few hundred hertz up to several tens of kilohertz this boundary lies between hundreds of kilometres and a few kilometres, so any laboratory set-up or practical enclosure operates deep inside the near field. Delay across the configuration is negligible, as the attenuation $e^(-j k r) approx 1$, and the field at the shield is set by the instantaneous source current and by the geometry, not by the wavelength.

Inside a shield of conductivity $sigma$ the ratio of displacement to conduction current is $omega epsilon \/ sigma$, which for aluminium at $10$ kHz is of the order of $10^(-18)$. Dropping the displacement term turns the Helmholtz equation into a diffusion equation,

$ nabla^2 bold(H) = j omega mu sigma bold(H), quad gamma = sqrt(j omega mu sigma) = (1 + j) / delta, quad delta = sqrt(2 / (omega mu sigma)), $ <eq:diffusion>

with $delta$ the skin depth. The field inside the shield does not propagate but diffuses, and the governing length scale is $delta$ rather than $lambda$.

The wave impedance of the source decides which kind of shielding is required. For a small loop and a short electric dipole the near-field wave impedances behave as

$ Z_w^("loop") approx eta_0 (k r), quad Z_w^("dipole") approx eta_0 / (k r), quad eta_0 approx 377 Omega. $ <eq:zw>

Since $k r << 1$, a loop presents a low-impedance field and a dipole a high-impedance field, whereas both tend to $eta_0$ in the far field.

== Electric versus magnetic shields <sec:e-vs-m>
For electric shielding the situation is comparatively trivial. The intrinsic impedance of a good conductor,

$ Z_s = sqrt((j omega mu) / sigma) = (1 + j) / (sigma delta), $ <eq:zs>

is of the order of micro-ohms at low frequency. Against the high-impedance field of @eq:zw this is an extreme mismatch, so an incident electric field is almost entirely reflected at the surface. Through charge redistribution in the conductor rather than diffusion through it, and the shield behaves as an equipotential surface.

The same mismatch is nearly absent for a low-impedance magnetic source, and reflection is weak. The shield must then act either by dissipating the field in induced currents or by offering the flux a low-reluctance path. These two mechanisms correspond to the two material classes discussed next.

== Eddy-current shields
Electrically conductive shields, also called eddy-current shields, rely on currents induced by the incident time-varying magnetic field. This follows directly from Faraday's law,

$ nabla times bold(E) = - frac(partial bold(B), partial t), $ <eq:faraday>

which states that a time-varying magnetic field induces an electric field. This field drives the free charges within the conductor, producing an induced current.
When a magnetic field line falls onto a screen, the induced eddy currents form a closed loop around that field line, with a direction such that the induced field opposes the incident one, in accordance with Lenz's law. The shielded field is therefore the superposition of the incident field and the reaction field of the induced current distribution.

#figure(
  image("../images/schildE.png", width: 50%),
  caption: [Eddy-current shielding principle.],
)

== Flux-shunting shields
Magnetically conductive shields, known as flux-shunting shields, are characterized by a high relative permeability $mu_r$ to divert the flux into the shielding material. For an infinite planar screen this is most rigorously obtained from the jump conditions rather than from a lumped argument. Continuity of the normal flux density and of the tangential magnetic field,

$ B_(1 n) = B_(2 n), quad H_(1 t) = H_(2 t), $ <eq:bc>

combined with $bold(B) = mu bold(H)$ in both media, gives the refraction law for the angles $theta_1$ and $theta_2$ measured from the interface normal,

$ frac(tan theta_2, tan theta_1) = frac(mu_2, mu_1) = mu_r. $ <eq:refraction>

For $mu_r >> 1$, a field incident at any appreciable angle is refracted to $theta_2 -> 90 degree$, meaning that the field inside the shield runs almost parallel to the sheet. Meaning the flux is drawn along the screen and guided away from the shielded region, which is what is observed macroscopically as a deflection of the field lines into the shield material.

#figure(
  image("../images/schildM.png", width: 50%),
  caption: [Flux-shunting shielding principle.],
)

For closed or finite geometries the same behaviour is often described by the lumped magnetic-circuit analogue. A path of length $l$ and cross-section $A$ has reluctance $cal(R) = l \/ (mu_0 mu_r A)$, and Hopkinson's law,

$ Theta = Phi cal(R), $ <eq:hopkinson>

relates the magnetomotive force $Theta$ to the flux $Phi$, analogous to Ohm's law. As current over parallel resistors, the flux divides over parallel paths in inverse proportion to their reluctance, so that for $cal(R)_"shield" << cal(R)_"air"$ almost all flux follows the shield. It should be stressed that this description presupposes a well-defined flux path, which does not exist within an infinite planar sccreen. The reluctance has neither a unique $l$ nor a unique $A$ in that geometry. The magnetic-circuit picture is retained here as physical intuition only, while @eq:refraction is the formulation used in the analysis.


== Combined mechanisms and limits of the linear description
In practice the two mechanisms are not exclusive. A ferromagnetic shield of finite conductivity, such as steel, supports eddy currents and flux shunting simultaneously. At low frequency flux shunting dominates; as frequency rises the eddy-current contribution grows and takes over, so that a complete description must retain both effects through general $mu$ and $sigma$.

All of the above assumes a linear, homogeneous and isotropic medium. For ferromagnetic shields this holds only over a limited range: $mu_r$ collapses towards unity near saturation, rolls off above a material-dependent frequency, and hysteresis adds a loss not captured by a real-valued $mu_r$. Closed-form results, including those used in this work, are therefore valid for small-signal excitation and below the permeability roll-off.



== Characteristic length and time scales
Skin depth alone is not sufficient to predict the behaviour of a shield. For a screen of thickness $t$ the governing dimensionless parameter is the ratio $t \/ delta$, which separates two distinct regimes.

For $t >> delta$ the field is attenuated exponentially inside of the material and absorption dominates. For $t << delta$ the field is essentially uniform across the thickness, absorption vanishes, and the shielding is produced entirely by the field of the induced current. This thin-shield regime is the one in which thin metal sheets at low frequency operate, and it is the regime addressed by the classical eddy-current analyses discussed in @sec:literature.

In the thin-shield regime the shield has a characteristic diffusion time, which for a screen of thickness $t$ at a distance $d$ from the source scales as

$ tau tilde mu sigma t d, $ <eq:tau>

with the associated corner frequency $f_c tilde 1 \/ (2 pi tau)$. Below $f_c$ the induced currents are too weak to react appreciably and the SE tends to $0$ dB; above it the SE rises at approximately $20$ dB per decade. Equivalently, the behaviour is governed by the dimensionless shielding parameter $omega mu sigma t d$, which plays the role of a magnetic Reynolds number for the configuration. The proportionality in @eq:tau is a scaling relation; the exact prefactor depends on the geometry and follows from the closed-form solutions of @sec:literature.

Two consequences are worth noting. First, the corner frequency depends on the geometry through $d$, so the SE of a planar screen is not a material property alone. Second, since $f_c$ scales inversely with $mu sigma t$, high-permeability and high-conductivity shields reach their useful range at lower frequencies, which is precisely why material choice is frequency-dependent.

== The plane-wave spectrum of a loop source <sec:spectrum>
The difference between near-field and far-field shielding lies in the spatial spectrum of the emitted field. As stated in the introduction, within the near field, we find the incident field to behave as a plane wave. This wave contains a single transverse wavenumber, whereas the near field of a finite loop contains a continuum of them.

Expanding the field of a circular loop of radius $a$ in cylindrical coordinates yields a Sommerfeld-type integral over the transverse wavenumber $lambda$, in which each spectral component carries a Bessel factor $J_1 (lambda a)$ set by the loop geometry and decays away from the source plane as $e^(lambda |z|)$. In the quasi-static regime $lambda >> k$ for all components that carry appreciable energy, so the spectrum is essentially entirely evanescent. The dominant transverse wavenumbers are determined by the geometry, $lambda tilde 1 \/ a$ and $lambda tilde 1 \/ d$, and not by the frequency.

Each spectral component sees the shield at its own effective angle of incidence and is therefore transmitted with its own transmission coefficient $T(lambda)$. The total shielded field is the superposition

$
  bold(H)_"closed" (bold(r)) = integral_0^infinity T(lambda) thin tilde(bold(H))(lambda) thin e^(lambda |z|) thin d lambda,
$ <eq:spectrum>

so that the SE is an integral quantity weighted by the geometry of the source. Three conclusions follow directly, and they shape the remainder of this work. The SE of a planar screen necessarily depends on the loop radius $a$ and on the spacings, since these set the spectral content. The Bessel-function integrands appearing in all of the closed-form solutions reviewed in @sec:literature are the direct expression of this decomposition. And a model built on a single normally incident plane wave cannot be expected to reproduce the result, since it replaces a continuum of evanescent components by one propagating one.

