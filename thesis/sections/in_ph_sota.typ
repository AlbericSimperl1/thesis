// NOTE: this `set` rule gives the equations chapter-relative numbers, which the
// @eq:... cross-references in this section need. It mirrors the figure numbering
// in src/lib.typ. It is placed here so this file compiles on its own; the proper
// home for it is thesis.typ (or src/lib.typ), next to the figure rule.
#set math.equation(numbering: it => context {
  let count = counter(heading).get()
  numbering("(1.1)", count.at(0), it)
})

= State of the Art

== What is shielding?
Electromagnetic shielding is a means of improving electromagnetic compatibility (EMC) using an electromagnetic (EM) shield. Using this shield, it is possible to reduce the electromagnetic field intensity within a prescribed region @celozziBOEK. A shield's effectiveness is denoted by its shielding effectiveness (SE), defined as the ratio of the field at a point of observation without and with the shield in place,

$ "SE" = 20 log_10 lr(|frac(bold(F)_("open"), bold(F)_("closed"))|)," [dB]", $ <eq:se-def>

where $bold(F)$ stands for either the electric or the magnetic field. For the magnetic problem considered in this work this becomes

$ "SE"_H = 20 log_10 lr(|frac(H_("open"), H_("closed"))|)," [dB]". $ <eq:se-h>

Depending on the material used, a shield can reflect, absorb or redirect the incident field. Shielding is used whenever a field source and a sensitive region must be isolated from each other.
In military settings it can be used to guarantee communication security, thus protecting sensitive information transmitted using electromagnetic waves.
Medical use cases are found in the isolation of MRI and ECG/EEG units, which need to be strictly enclosed.
Furthermore, active implanted medical devices such as pacemakers and cardioverters require an enclosure which protects these sensitive detection circuits.
Although shielding is used in virtually any field, and whether this happens through immunity, emission control, privacy or even human safety, the objective is always ensuring EMC.

== The quasi-static near-field regime
The analysis in this work is restricted to a regime that must be delimited before any shielding mechanism can be discussed, because it is this regime that decides which terms of Maxwell's equations survive and, consequently, which analytical tools are admissible.

=== Electrical size and the near-field condition
Two distances govern the problem: the free-space wavelength $lambda = c\/f$ and the geometrical dimensions of the configuration, being the loop radius $a$ and the source-to-shield and shield-to-observer spacings. The boundary between the near- and far-field region of a small radiator lies at

$ r = lambda / (2 pi) = 1 / k, quad k = omega sqrt(mu_0 epsilon_0), $ <eq:nf-boundary>

so that the near-field condition reads $k r << 1$. For the frequency range of interest in low-frequency shielding, from a few hundred hertz up to several tens of kilohertz, this boundary lies between hundreds of kilometres and a few kilometres. Any laboratory-scale measurement set-up, and indeed any enclosure of practical interest, therefore operates deep inside the near-field region. The consequence is that retardation across the configuration is negligible: the phase factor $e^(-j k r) approx 1$, and the field at the shield is determined by the instantaneous source current rather than by a propagating wave.

This also means that the source cannot be described by a plane wave. The field illuminating the shield is a non-uniform, geometry-dependent distribution whose spatial variation is set by $a$ and by the source-to-shield distance $d$, not by the wavelength. This observation is developed further in @sec:spectrum and is the central reason why the classical transmission-line theory of shielding, discussed in @sec:schelkunoff, is not directly applicable here.

=== Negligible displacement current and the diffusion equation
Inside a conductive shield of conductivity $sigma$ and permittivity $epsilon$, Ampère's law reads

$ nabla times bold(H) = sigma bold(E) + j omega epsilon bold(E). $ <eq:ampere>

The ratio of displacement to conduction current is $omega epsilon \/ sigma$. For a good conductor such as aluminium ($sigma approx 3.5 dot 10^7$ S/m) this ratio is of the order of $10^(-18)$ at $10$ kHz, so the displacement term may be dropped without any practical loss of accuracy. Combining @eq:ampere in this form with Faraday's law and the constitutive relations yields, for a linear homogeneous medium,

$ nabla^2 bold(H) = j omega mu sigma bold(H), $ <eq:diffusion>

which is a diffusion equation rather than a wave equation. The full Helmholtz propagation constant $gamma^2 = j omega mu sigma - omega^2 mu epsilon$ degenerates into

$ gamma = sqrt(j omega mu sigma) = (1 + j) / delta, quad delta = sqrt(2 / (omega mu sigma)), $ <eq:gamma>

with $delta$ the skin depth. The field inside the shield therefore does not propagate; it diffuses, and the governing length scale is $delta$ rather than $lambda$.

=== Decoupling of the electric and magnetic problem
Because retardation is negligible in the surrounding air, the induced electric field in the air region is small compared to what a propagating wave of the same magnetic amplitude would carry. The problem may then be treated in the magneto-quasi-static (MQS) approximation, in which the magnetic field is computed from the source current and the induced currents alone, and the electric field follows afterwards from Faraday's law as a derived quantity. This is what justifies solving the magnetic shielding problem in isolation, and it is the approximation under which the vector-potential formulations used in @sec:literature are derived.

=== Source wave impedance
The distinction between electric and magnetic shielding in the near field follows from the wave impedance of the source. For a small loop (magnetic dipole) and for a short dipole (electric dipole) the near-field wave impedances behave as

$ Z_w^("loop") approx eta_0 (k r), quad Z_w^("dipole") approx eta_0 / (k r), quad eta_0 approx 377 Omega. $ <eq:zw>

Since $k r << 1$, a loop source presents a low-impedance field and a short dipole a high-impedance field, whereas in the far field both tend to $eta_0$. As shown in @sec:e-vs-m, reflection at the shield surface is governed by the mismatch between $Z_w$ and the shield's intrinsic impedance, which is itself very low. A low-impedance magnetic source is therefore the worst case: there is almost no mismatch, hence almost no reflection, and the shield must rely on dissipation or on flux diversion. This is the configuration prescribed by the relevant measurement standards and the one treated in this work.

== Physics behind near-field magnetic shielding

=== Electric versus magnetic shields <sec:e-vs-m>
For electric shielding the situation is comparatively trivial. The intrinsic impedance of a good conductor,

$ Z_s = sqrt((j omega mu) / sigma) = (1 + j) / (sigma delta), $ <eq:zs>

is of the order of micro-ohms at low frequency. Against the high-impedance field of @eq:zw this is an extreme mismatch, so an incident electric field is almost entirely reflected at the surface. The mechanism is charge redistribution in the conductor rather than diffusion through it, and the shield behaves essentially as an equipotential surface.

For a low-impedance magnetic source the same mismatch is nearly absent, and reflection is weak. The shield must then act either by dissipating the field in induced currents or by offering the flux a preferential path. These two mechanisms correspond to the two material classes discussed next.

=== Eddy-current shields
Electrically conductive shields, also called eddy-current shields, rely on currents induced by the incident time-varying magnetic field. This follows directly from Faraday's law,

$ nabla times bold(E) = - frac(partial bold(B), partial t), $ <eq:faraday>

which states that a time-varying magnetic field induces an electric field. This field drives the free charges within the conductor, producing an induced current.
When a magnetic field line falls onto a screen, the induced eddy currents form a closed loop around that field line, with a direction such that the induced field opposes the incident one, in accordance with Lenz's law. The shielded field is therefore the superposition of the incident field and the reaction field of the induced current distribution.

// #figure(
//   image("../images/schildE.png", width: 50%),
//   caption: [Eddy-current shielding principle.],
// )

=== Flux-shunting shields
Magnetically conductive shields, known as flux-shunting shields, exploit a high relative permeability $mu_r$ to divert the flux into the shield material. For an infinite planar screen this is most rigorously obtained from the interface conditions rather than from a lumped argument. Continuity of the normal flux density and of the tangential magnetic field,

$ B_(1 n) = B_(2 n), quad H_(1 t) = H_(2 t), $ <eq:bc>

combined with $bold(B) = mu bold(H)$ in both media, gives the refraction law for the angles $theta_1$ and $theta_2$ measured from the interface normal,

$ frac(tan theta_2, tan theta_1) = frac(mu_2, mu_1) = mu_r. $ <eq:refraction>

For $mu_r >> 1$, a field incident at any appreciable angle is refracted to $theta_2 -> 90 degree$, meaning that the field inside the shield runs almost parallel to the sheet. The flux is thus drawn along the screen and guided away from the shielded region, which is what is observed macroscopically as a deflection of the field lines into the shield material.

// #figure(
//   image("../images/schildM.png", width: 50%),
//   caption: [Flux-shunting shielding principle.],
// )

For closed or finite geometries the same behaviour is often described by the lumped magnetic-circuit analogue. A path of length $l$ and cross-section $A$ has reluctance

$ cal(R) = l / (mu_0 mu_r A), $ <eq:reluctance>

and the relation between reluctance, flux and its driving source is described by Hopkinson's law,

$ Theta = Phi cal(R), $ <eq:hopkinson>

where $Theta$ is the magnetomotive force and $Phi$ the magnetic flux. This is the magnetic analogue of Ohm's law, with $Theta$, $Phi$ and $cal(R)$ corresponding to voltage, current and resistance, respectively. Just as current divides over parallel resistors, the flux divides over parallel magnetic paths,

$ Phi_"shield" / Phi_"air" = cal(R)_"air" / cal(R)_"shield", $ <eq:flux-division>

so that for $cal(R)_"shield" << cal(R)_"air"$ almost all flux follows the shield. It should be stressed that this description presupposes a well-defined flux path, which an infinite planar screen does not possess: @eq:reluctance has neither a unique $l$ nor a unique $A$ in that geometry. The magnetic-circuit picture is retained here as physical intuition only, while @eq:refraction is the formulation used in the analysis.

=== Characteristic length and time scales
Skin depth alone is not sufficient to predict the behaviour of a shield. For a screen of thickness $t$ the governing dimensionless parameter is the ratio $t \/ delta$, which separates two distinct regimes.

For $t >> delta$ the field is attenuated exponentially inside the material and absorption dominates. For $t << delta$ the field is essentially uniform across the thickness, absorption vanishes, and the shielding is produced entirely by the reaction field of the induced sheet current. This thin-shield regime is the one in which thin metal sheets at low frequency operate, and it is the regime addressed by the classical eddy-current analyses discussed in @sec:literature.

In the thin-shield regime the shield has a characteristic diffusion time, which for a screen of thickness $t$ at a distance $d$ from the source scales as

$ tau tilde mu sigma t d, $ <eq:tau>

with the associated corner frequency $f_c tilde 1 \/ (2 pi tau)$. Below $f_c$ the induced currents are too weak to react appreciably and the SE tends to $0$ dB; above it the SE rises at approximately $20$ dB per decade. Equivalently, the behaviour is governed by the dimensionless shielding parameter $omega mu sigma t d$, which plays the role of a magnetic Reynolds number for the configuration. The proportionality in @eq:tau is a scaling relation; the exact prefactor depends on the geometry and follows from the closed-form solutions of @sec:literature.

Two consequences are worth noting. First, the corner frequency depends on the geometry through $d$, so the SE of a planar screen is not a material property alone. Second, since $f_c$ scales inversely with $mu sigma t$, high-permeability and high-conductivity shields reach their useful range at lower frequencies, which is precisely why material choice is frequency-dependent.

=== Limits of the linear description
The analysis above assumes a linear, homogeneous and isotropic medium with constant $mu_r$ and $sigma$. For ferromagnetic shields this holds only over a limited range.

The permeability is a function of the field amplitude, $mu_r = mu_r (H)$, and collapses towards unity as the material approaches saturation; a high-permeability shield exposed to a strong field therefore loses most of its effectiveness. The permeability is also a function of frequency and rolls off above a material-dependent limit, so a shield that performs well at mains frequencies need not perform well in the kilohertz range. Finally, hysteresis contributes an additional loss mechanism not captured by a real-valued $mu_r$. Any closed-form result derived under the linear assumption, including those used in this work, is therefore valid for small-signal excitation and below the permeability roll-off of the material.

=== Superposition of mechanisms
In practice the two mechanisms are not exclusive. A ferromagnetic shield of finite conductivity, such as steel, supports both induced eddy currents and flux shunting simultaneously. At low frequency the flux-shunting contribution dominates, since the induced currents are still weak; as frequency rises, the eddy-current contribution grows and eventually becomes the principal mechanism, while the effective permeability simultaneously decreases. There is consequently a crossover frequency, set by the same parameter $omega mu sigma t d$, at which the dominant mechanism changes. A complete description must retain both effects, which is why the formulations treated in @sec:literature are written for general complex $mu$ and $sigma$ rather than for one mechanism at a time.

=== The plane-wave spectrum of a loop source <sec:spectrum>
The decisive structural difference between near-field and far-field shielding lies in the spatial spectrum of the illuminating field. A plane wave contains a single transverse wavenumber; the near field of a finite loop contains a continuum of them.

Expanding the field of a circular loop of radius $a$ in cylindrical coordinates yields a Sommerfeld-type integral over the transverse wavenumber $k_rho$, in which each spectral component carries a Bessel factor $J_1 (k_rho a)$ set by the loop geometry and decays away from the source plane as $e^(-k_rho |z|)$. In the quasi-static regime $k_rho >> k$ for all components that carry appreciable energy, so the spectrum is essentially entirely evanescent. The dominant transverse wavenumbers are determined by the geometry, $k_rho tilde 1 \/ a$ and $k_rho tilde 1 \/ d$, and not by the frequency.

Each spectral component sees the shield at its own effective angle of incidence and is therefore transmitted with its own transmission coefficient $T(k_rho)$. The total shielded field is the superposition

$
  bold(H)_"closed" (bold(r)) = integral_0^infinity T(k_rho) thin tilde(bold(H))(k_rho) thin e^(-k_rho |z|) thin d k_rho,
$ <eq:spectrum>

so that the SE is an integral quantity weighted by the geometry of the source. Three conclusions follow directly, and they shape the remainder of this work. The SE of a planar screen necessarily depends on the loop radius $a$ and on the spacings, since these set the spectral content. The Bessel-function integrands appearing in all of the closed-form solutions reviewed in @sec:literature are the direct expression of this decomposition. And a model built on a single normally incident plane wave cannot be expected to reproduce the result, since it replaces a continuum of evanescent components by one propagating one.


=== What shielding effectiveness means in practice
@eq:se-def defines the SE as a local field ratio at a single point of observation. The standardised measurement, however, does not measure a local field. The relevant standards, NSA 65-6 @nsa656 for coaxial loop antennas and MIL-STD-285 @milstd285 with its successor IEEE Std 299 @ieee299 for coplanar loops, prescribe a set-up in which the SE is obtained as the voltage insertion loss of a finite receiving loop introduced by the presence of the shield.

A finite receiving loop integrates the flux density over its own area, so the measured quantity is an averaged field rather than a point value, and it depends on the radius of the receiving loop as well as on that of the transmitting loop. The discrepancy between the local definition and the measured insertion loss is not a measurement artefact but a property of the configuration, and reconciling the two is the problem around which much of the literature discussed next is organised.

== State of the art in the literature <sec:literature>
The analytical treatment of low-frequency magnetic shielding by an infinite planar screen rests on a small and well-identified body of work, developed over roughly seven decades along three parallel lines: eddy-current image methods, exact solutions of the field equations, and adaptations of transmission-line theory.

=== Eddy-current and thin-shield analyses
The earliest treatment relevant to this configuration is the thin-shield eddy-current analysis of Levy @levy1936, who formulated the problem of an infinite conducting sheet placed between coaxial circular coils in terms of magnetic potentials and satisfied the boundary conditions by postulating moving images. The resulting closed-form expression for the induced voltage is attractively simple but, as later authors noted, it is not general: it is restricted to thin shields, to non-magnetic materials and to a limited frequency range, and the limits of its applicability are not evident from the formulation itself.


=== Moser's analysis of the coaxial configuration
The work that defines the problem in its modern form is that of Moser @moser1, who analysed the shielding of a circular loop source by a thin plane metal sheet of infinite extent in the coaxial configuration of @nsa656, and did so by three independent routes: Levy's thin-shield analysis, a direct solution of the vector wave equation, and an adaptation of Schelkunoff's theory. Measurements were obtained between $100$ Hz and $50$ kHz for aluminium, copper and steel shields of two thicknesses.

Two aspects of that paper are important here. First, the exact solution of the vector wave equation was derived in full, yielding expressions for the total electric and magnetic fields on both sides of and within the shield, but the resulting SE expression was not evaluated, owing to the complexity of the integrals involved. The practical predictions of the 1967 paper therefore rest on the adapted transmission-line theory rather than on the exact formulation. Second, the transmission-line results were found to agree with measurement only when the shield was placed, for calculation purposes, at one third of the distance from the source to the point of observation. This empirical placement rule has no basis in the derivation of @eq:rab and is best understood as a symptom of the mismatch described in @sec:schelkunoff.

Moser returned to the problem two decades later @moser1988, in a treatment of the same geometry under explicitly low-frequency, low-impedance conditions. There the exact vector-wave solution is evaluated numerically and compared with measurement, and is shown to agree accurately, while the one-third placement rule for the Schelkunoff formulation is confirmed as a necessary condition for its accuracy. A further result of that paper is that the SE is found to be independent of the source-to-shield spacing, a conclusion reported as consistent with the measured data.

=== Extension to loop-to-loop coupling
Hansen and Moser @moser2 extended the 1967 formulation from a point of observation to a finite receiving loop, that is, from a field ratio to the loop-to-loop coupling that is actually measured. In spectral terms the extension is remarkably economical: integrating the flux through the receiving loop introduces one additional Bessel factor in the integrands, exactly as @eq:spectrum would suggest. The consequence is not economical at all. The resulting coupling varies monotonically with loop spacing, in contrast to the non-monotonic behaviour of the original point-observation result.

This is a genuine discrepancy within the literature rather than a refinement of it, and it bears directly on the independence of SE from source-to-shield spacing reported in @moser1988. It is one of the points against which the formulation developed in this work is tested.

=== Exact treatment of the coplanar configuration
Araneo and Celozzi @araneo2002 addressed the coplanar loop configuration prescribed by @ieee299 and @milstd285, for which no exact solution had previously been available, earlier formulations having been restricted to the coaxial geometry. Their contribution is a closed-form solution in which the finite size of both the transmitting and the receiving antenna is accounted for rigorously, rather than through a small-dipole approximation, together with an experimental validation and an explicit discussion of the underlying hypotheses.

Of particular relevance here is their assessment of the approximations in common use. They quantify the error incurred by the transmission-line approach and by the small-dipole approximation across a range of configurations, and note that the tables and graphs of several textbooks and handbooks assume the applicability of both without proof. Their results delimit the conditions under which the handbook approach may be used and, by implication, those under which an exact treatment is required.

The monograph of Celozzi, Araneo and Lovat @celozziBOEK subsequently consolidated this material, and is used throughout this work as the general reference frame rather than as a primary source.

=== Open points and position of this work
Taken together, the literature establishes exact closed-form solutions for the coplanar configuration with finite antennas @araneo2002, an evaluated exact solution for the coaxial configuration with a point of observation @moser1988, and an extension of the latter to loop-to-loop coupling @moser2 that contradicts the earlier result on its dependence on spacing. Three gaps remain.

The dependence of the SE on the source-to-shield spacing in the coaxial configuration is reported differently in @moser1988 and @moser2, and the two results have not been reconciled.

The approximations whose limits were quantified for the coplanar configuration in @araneo2002, namely the transmission-line decomposition and the small-dipole assumption, have not been assessed to the same degree for the coaxial configuration with finite loops.

Finally, the available exact formulations are presented as evaluated integrals for specific material and geometry combinations, rather than as a parametrised model from which the dependence on each geometrical and material parameter can be extracted directly.

This work addresses these points by developing and evaluating an analytical formulation for the magnetic shielding effectiveness of an infinite planar screen under near-field conditions, with finite loop antennas, within the quasi-static regime delimited in @eq:nf-boundary through @eq:zw, and by comparing it against both the transmission-line approximation and the published results above.
