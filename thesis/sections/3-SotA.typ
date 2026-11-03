= State of the art in the literature <sec:literature>
The analytical treatment of low-frequency magnetic shielding by an infinite planar screen rests on a small and well-identified body of work, developed over roughly seven decades along two lines. The use of thin-shield eddy-current analyses and finding exact solutions for the field equations. This chapter reviews them chronologically and gives, for each, its expression for the SE. 
== Levy's thin-shield analysis
The earliest treatment relevant to this configuration is the thin-shield eddy-current analysis of Levy @levy1936. Levy considered an infinite conducting sheet placed between two coaxial circular coils, formulated the problem in terms of magnetic potentials and satisfied the boundary conditions by postulating moving images. To make the problem tractable, the eddy currents are assumed to be distributed such that the induced potential is identical on both sides of the sheet, which restricts the result to shields thinner than a skin depth.

As summarised by Moser @moser1988, combining the voltage induced in the receiving loop with and without the shield gives the insertion loss

$ S = 20 log_10 lr(|V''_2 / V_2|) = 10 log_10 [ ((a t sigma_r f) / 78.8)^2 + 1 ], $ <eq:levy>

in which $a$ is the radius of the source loop and $t$ the shield thickness, both in centimetres, $sigma_r$ the conductivity of the shield relative to that of copper, and $f$ the frequency in hertz. $V''_2$ and $V_2$ are the voltages induced in the receiving loop without and with the shield.

@eq:levy describes a single corner frequency $f_c = 78.8 \/ (a t sigma_r)$, below which the SE vanishes and above which it rises at $20$ dB per decade, as anticipated by @eq:tau. It is, however, not general. The expression is independent of the loop spacing $z$ and of the permeability of the shield, so it is restricted to thin, non-magnetic shields and to a limited frequency range. Moser reports that the omission of $z$ is acceptable within ten percent only for $0.15 < r_1 \/ a < 0.9$, with $r_1$ the distance from the source loop to the shield.

== Moser's exact solution of the coaxial configuration
The work that defines the problem in its modern form is that of Moser @moser1, who analysed the shielding of a circular loop source by a plane metal sheet of infinite extent in the coaxial configuration of @nsa656. Besides Levy's analysis, Moser derived a direct solution of the vector wave equation, and measured aluminium, copper and steel shields between $100$ Hz and $50$ kHz.

Moser starts from the vector wave equation for the magnetic vector potential,
 $ nabla^2 bold(A) + k_0^2 bold(A) = 0. $ For a loop of radius $a$ carrying a current $i$ the problem has cylindrical symmetry, so only the azimuthal component $A_phi$ remains and $nabla dot bold(A) = 0$. Using the Fourier--Bessel integral, the free-space potential of the loop is written as

$ A_phi = (mu_0 a i) / 2 integral_0^infinity lambda / tau_0 J_1 (lambda a) J_1 (lambda r) e^(-tau_0 |z|) d lambda, $ <eq:moser-a>

where $lambda$ is the radial wavenumber, denoted $k_rho$ in @sec:spectrum (not the wavelength), and

$ tau_0 = sqrt(lambda^2 - k_0^2), quad tau = sqrt(lambda^2 - k^2), quad k^2 = j omega mu sigma. $ <eq:moser-tau> @eq:moser-a is precisely the spectral decomposition of @eq:spectrum.

The shield, of thickness $t$, relative permeability $mu_r$ and conductivity $sigma$, occupies the region $b < z < c$, with $b$ the distance from the source loop to the shield and $t = c - b$. Since the eddy currents in the plate have the same azimuthal symmetry as the source, the induced potential in each of the three regions (source side, shield, observation side) has the same form as @eq:moser-a, multiplied by an unknown function of $lambda$. These functions follow from the continuity of $A_phi$ and of $(1 \/ mu) partial A_phi \/ partial z$ at $z = b$ and $z = c$. With $K = tau \/ tau_0$, the solution contains the common factor

$ C = [(K + mu_r)^2 - (K - mu_r)^2 e^(-2 t tau)]^(-1). $ <eq:moser-c>

Defining the SE as the ratio of the axial flux density without and with the shield, $S = 20 log_10 |B_z \/ B_z^((3))|$, consistent with @eq:se-h, and evaluating it on the axis ($r = 0$), Moser obtains

$
  S = 20 log_10 1 / (4 mu_r) lr(|
    (integral_0^infinity lambda^2 / tau_0 J_1 (lambda a) e^(-tau_0 z) d lambda)
    /
    (integral_0^infinity (C lambda^2 tau) / tau_0^2 J_1 (lambda a) e^(-tau_0 z - t (tau - tau_0)) d lambda)
  |),
$ <eq:moser-se>

with $z$ the distance between the source loop and the point of observation. The SE is thus a quotient of two Sommerfeld-type integrals over $J_1 (lambda a)$. The numerator is the field of the unshielded loop, the denominator contains the full interaction with the shield through $C$ and $tau$, and therefore both mechanisms of @sec:physics as eddy currents through $sigma$ and flux shunting through $mu_r$.

The 1967 paper did not evaluate @eq:moser-se: the denominator has no closed form solution, and a numerical evaluation was unsuccessful at the time. In the quasi-static regime the numerator does have a closed form though. For frequencies below $100$ kHz, loop radii below $5$ cm and $z < 10 a$, the product $k_0 sqrt(a^2 + z^2)$ is smaller than $10^(-3)$, and the axial field of the open case reduces to the magnetostatic result

$ B_z = (mu_0 a^2 i) / (2 (a^2 + z^2)^(3/2)). $ <eq:moser-bstatic>

Substituting @eq:moser-bstatic in @eq:moser-se gives

$
  S = -20 log_10 [ (4 mu_r) / a (a^2 + z^2)^(3/2) lr(|integral_0^infinity (C lambda^2 tau) / tau_0^2 J_1 (lambda a) e^(-tau_0 z - t (tau - tau_0)) d lambda|) ],
$ <eq:moser-se-qs>

which leaves a single numerical integral. A notable property of @eq:moser-se and @eq:moser-se-qs is that the source-to-shield distance $b$ does not appear: the SE depends only on the total spacing $z$, and not on where the shield is placed between source and observation point.

// In his 1988 treatment of the same geometry @moser1988, Moser reports that @eq:moser-se has meanwhile been evaluated numerically by Ryan, with very favourable agreement with measurement, and that the independence of the source-to-shield spacing is consistent with the measured data.

== Extension to loop-to-loop coupling
@eq:moser-se gives the SE at a point on the axis, whereas the standards measure the voltage induced in a finite receiving loop. Hansen and Moser @moser2 extended the formulation accordingly. Starting from Moser's off-axis result, the flux through a receiving loop of the same radius $a$ is obtained by integrating over the loop area. With the change of variable $y = 1 \/ lambda$, which gives the integration variable the dimension of a distance, their expression reads (as published)

$
  "SE" = (
    1 / (4 mu_r) integral_0^infinity integral_0^a
    (J_1 (a \/ y) J_0 (rho \/ y) exp(-zeta_0 z \/ y)) / (y^3 zeta_0) d rho d y
  ) / (
    integral_0^infinity integral_0^a
    (zeta J_1 (a \/ y) J_0 (rho \/ y) exp[-zeta_0 (z - t) \/ y - zeta t \/ y])
    / (y^3 [(zeta + mu_r zeta_0)^2 - (zeta - mu_r zeta_0)^2 exp(-2 zeta t \/ y)])
    d rho d y
  ),
$ <eq:hansen-se>

with the normalised wavenumbers

$ zeta^2 = 1 - j omega mu_0 mu_r sigma y^2, quad zeta_0^2 = 1 - k^2 y^2, $ <eq:hansen-zeta>

where here $k = 2 pi \/ lambda_0$ is the free-space wavenumber and $z$ the distance between the loops. Comparing with @eq:moser-se, the integration over the receiving loop introduces exactly one additional Bessel factor $J_0 (rho \/ y)$ in both integrands, as @eq:spectrum would suggest. The authors note that the quasi-static closed form of the numerator, @eq:moser-bstatic, may give large errors once the receiving loop is included and the spacing is comparable to or smaller than the loop radius, so that both integrals have to be evaluated numerically.

The consequence of this small change is substantial. The on-axis result @eq:moser-se, evaluated as a function of the spacing, shows a "bathtub" shape with a minimum of the SE for spacings comparable to the loop radius. With the receiving loop integration this anomaly disappears, the loop-to-loop SE varies monotonically with spacing and tends to $0$ dB as the spacing tends to zero. The on-axis and loop-to-loop results only coincide when the spacing exceeds the loop radius.

This is a genuine discrepancy within the literature rather than a refinement of it, and it bears directly on the independence of the SE of the source-to-shield spacing reported in @moser1 and @moser1988. It is one of the points against which the formulation developed in this work is tested.

== Exact treatment of the coplanar configuration
Araneo and Celozzi @araneo2002 addressed the coplanar loop configuration prescribed by @ieee299 and @milstd285. Exact solutions had previously been found only for the coaxial geometry of @nsa656. Their solution accounts for the finite size of both the TX and the RX antenna, rather than using a small-dipole approximation, and is validated experimentally.

Since the coplanar configuration lacks the rotational symmetry of the coaxial one, the problem is formulated in Cartesian coordinates with the magnetic vector potential of the second order $bold(U)$, defined by

$ nabla times bold(U) = bold(A), quad nabla times (nabla times bold(U)) = bold(B), $ <eq:araneo-u>

and gauged such that $nabla dot bold(U) = 0$, so that $nabla^2 bold(U) = 0$ in the quasi-static limit and the field component of interest follows as $B_y = partial^2 U_y \/ partial y^2$. Two assumptions are made explicit: again retardation is neglected, $e^(-j k r) approx 1$, which holds for the IEEE Std 299 loop of diameter $30.5$ cm up to $16$ MHz, and the current in the source loop is uniform along its circumference. In the absence of the shield, the potential of a TX loop of radius $R$, carrying an RMS current $I$ at a minimum distance $d$ from the shield, is

$
  U_y (x, y, z) = integral_0^infinity integral_0^infinity G_0 (alpha, beta) cos(alpha x) cos(beta y) e^(-D_1 |z + d|) d alpha d beta,
$ <eq:araneo-u0>

$ G_0 = - (mu_0 I R) / pi 1 / (beta D_1) I_1 (beta R), quad D_1 = sqrt(alpha^2 + beta^2), $ <eq:araneo-g0>

where $I_1 (dot)$ is the modified Bessel function of the first kind and order one. When the shield of thickness $t$ is applied, $G_0$ is replaced by

$ G_1 = - (4 mu_0 I R) / pi (D_3 e^(-(D_2 - D_1) t)) / (D_4 beta) I_1 (beta R), $ <eq:araneo-g1>

with

$ D_2 = sqrt(alpha^2 + beta^2 + j omega mu sigma), quad D_3 = D_2 / mu_r, quad D_4 = (D_3 + D_1)^2 - (D_3 - D_1)^2 e^(-2 D_2 t). $ <eq:araneo-d>

The ratio $G_1 \/ G_0 = 4 D_1 D_3 e^(-(D_2 - D_1) t) \/ D_4$ plays the same role as the factor $C$ in @eq:moser-c. It is the transmission coefficient of the shield for a single spectral component $(alpha, beta)$.

The SE at a point of observation becomes

$
  "SE" = 20 log_10 lr(|H_y^i / H_y^t|)
  = 20 log_10 lr(|
    (integral_0^infinity integral_0^infinity beta^2 G_0 (alpha, beta) cos(alpha x) cos(beta y) e^(-D_1 |z + d|) d alpha d beta)
    /
    (integral_0^infinity integral_0^infinity beta^2 G_1 (alpha, beta) cos(alpha x) cos(beta y) e^(-D_1 |z + d|) d alpha d beta)
  |),
$ <eq:araneo-se>

where the superscripts $i$ and $t$ denote the field without and with the screen. The integrands are smooth, and the double integrals are readily computed numerically. Unlike @eq:moser-se, the result depends on the position of the shield between the two loops, since it depends on both $d$ and the distance $z$ from the RX antenna.

Since the meter reading is proportional to the flux linked with the RX loop, IEEE Std 299 defines the SE as $20 log_10 (Phi^i \/ Phi^t)$. Araneo and Celozzi approximate the flux integral over the RX surface by a seven-point quadrature of $B_y$, and find that it differs by less than $5$% from the SE at the centre of the loop for the cases analysed. They further show that the small-dipole approximation, assumed without proof in several textbooks and handbooks, is not justified when the loop dimensions are comparable to the spacings, as in the standardised set-ups.

// The monograph of Celozzi, Araneo and Lovat @celozziBOEK subsequently consolidated this material, and is used throughout this work as the general reference frame rather than as a primary source.

== Overview of the formulations
@tab:formulations summarises the formulations reviewed above. All exact solutions share the same structure: the SE is a quotient of spectral integrals in which the shield enters only through a transmission factor per spectral component, while the geometry of the loops enters through Bessel factors.

#figure(
  table(
    columns: 5,
    align: (left, left, left, left, left),
    table.header([*Work*], [*Config.*], [*Observation*], [*Shield*], [*Form of SE*]),
    [Levy @levy1936], [coaxial], [loop voltage], [thin, $mu_r = 1$], [closed form, @eq:levy],
    [Moser @moser1 @moser1988], [coaxial], [point on axis], [general $mu_r$, $sigma$, $t$], [single integral, @eq:moser-se],
    [Hansen & Moser @moser2], [coaxial], [RX loop flux], [general $mu_r$, $sigma$, $t$], [double integral, @eq:hansen-se],
    [Araneo & Celozzi @araneo2002], [coplanar], [point / RX loop], [general $mu_r$, $sigma$, $t$], [double integral, @eq:araneo-se],
  ),
  caption: [Overview of the analytical SE formulations of an infinite planar screen using loop sources.],
) <tab:formulations>

== Open points and position of this work
Taken together, the literature establishes exact solutions for the coplanar configuration with finite antennas @araneo2002, an evaluated exact solution for the coaxial configuration with a point of observation @moser1988, and an extension of the latter to loop-to-loop coupling @moser2 that contradicts the earlier result on its dependence on spacing. Three gaps remain.

The dependence of the SE on the loop spacing in the coaxial configuration is reported differently in @moser1988 and @moser2, and the two results have not been reconciled.

The small-dipole assumption, whose limits were quantified for the coplanar configuration in @araneo2002, has not been assessed to the same degree for the coaxial configuration with finite loops.

Finally, the available exact formulations are presented as evaluated integrals for specific material and geometry combinations, rather than as a parametrised model from which the dependence on each geometrical and material parameter can be extracted directly.

This work addresses these points by developing and evaluating an analytical formulation for the magnetic SE of an infinite planar screen under near-field conditions, with finite loop antennas, within the quasi-static regime delimited by @eq:nf-boundary and @eq:zw, and by comparing it against the published results above.
