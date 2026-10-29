= Generalisation to an arbitrarily placed receiving loop <sec:generalisation>

The closed-form results of @sec:literature give the field behind the shield only in the coaxial configuration, observed either in a point on the axis @moser1 @moser1988 or with a receiving loop that is coaxial with and parallel to the source @moser2. In this chapter the receiving loop is given an arbitrary position and orientation. No new boundary-value problem has to be solved for this: the axisymmetric solution behind the shield is retained, and only the receiving loop is moved by a rigid transformation. The flux it captures then follows from a single line integral.

== Assumptions and geometry <sec:gen-geometry>
The global frame $(O; hat(bold(x)), hat(bold(y)), hat(bold(z)))$ is attached to the transmitting loop, a filamentary circular loop of radius $a$ carrying a current $i$, centred in $O$ in the plane $z = 0$. The shield is the slab $b <= z <= c$ of @sec:literature, of thickness $t = c - b$, so that region 3 is the half-space $z > c$. The receiving loop is a filamentary circular loop of radius $R$. The analysis rests on four assumptions.

+ The quasi-static conditions of @sec:physics hold, so that $tau_0 = lambda$ in @eq:moser-tau.
+ The receiving loop is open-circuited, or loaded by a high impedance, so that its own current perturbs neither the source nor the eddy currents in the shield. Its open-circuit voltage is then $V = -j omega Phi$, with $Phi$ the flux through the loop.
+ The receiving loop lies entirely in region 3.
+ The shield is of infinite transverse extent, so that source and shield together remain axisymmetric about the $z$-axis.

== Vector potential behind the shield
Under these assumptions the field in region 3 is the one derived by Moser @moser1. Denoting the cylindrical radius by $rho$, to keep $bold(r)$ free for the position vector, it reads

$
  bold(A)^((3)) = A_phi (rho, z) thin hat(bold(phi)), quad
  A_phi (rho, z) = 2 mu a i integral_0^infinity (C lambda tau) / tau_0^2 J_1 (lambda a) J_1 (lambda rho) e^(-tau_0 z - t (tau - tau_0)) d lambda,
$ <eq:gen-a3>

with $mu = mu_0 mu_r$, $tau$ and $tau_0$ from @eq:moser-tau and $C$ from @eq:moser-c. Without the shield, $A_phi$ is given by @eq:moser-a with $r$ replaced by $rho$. The derivation below only uses that $bold(A)$ is azimuthal and axisymmetric, and therefore holds for both cases.

To evaluate @eq:gen-a3 in a Cartesian point $(x, y, z)$, both the argument and the unit vector are transformed, see @fig:gen-unit-vectors. The argument becomes $rho = sqrt(x^2 + y^2)$, and with $cos phi = x \/ rho$ and $sin phi = y \/ rho$ the azimuthal unit vector is $hat(bold(phi)) = -sin phi thin hat(bold(x)) + cos phi thin hat(bold(y))$, so that

$ bold(A)^((3)) (x, y, z) = A_phi (sqrt(x^2 + y^2), z) thin (-y hat(bold(x)) + x hat(bold(y))) / sqrt(x^2 + y^2). $ <eq:gen-a-cart>

#figure(
  image("../images/gen-unit-vectors.svg", width: 55%),
  caption: [Cartesian unit vectors $hat(bold(x)), hat(bold(y))$ and cylindrical unit vectors $hat(bold(rho)), hat(bold(phi))$ in a point of the $x y$-plane.],
) <fig:gen-unit-vectors>

Since $-y hat(bold(x)) + x hat(bold(y)) = hat(bold(z)) times bold(r)$, with $bold(r) = x hat(bold(x)) + y hat(bold(y)) + z hat(bold(z))$ and $rho = |hat(bold(z)) times bold(r)|$, the potential can be written without reference to a coordinate system as

$ bold(A)(bold(r)) = g(rho, z) thin hat(bold(z)) times bold(r), quad g(rho, z) = (A_phi (rho, z)) / rho. $ <eq:gen-a-free>

The apparent singularity of $g$ on the axis is removable. Since $J_1 (lambda rho) tilde lambda rho \/ 2$ for $rho -> 0$,

$ g(0, z) = lim_(rho -> 0) (A_phi (rho, z)) / rho = 1 / 2 B_z (0, z), $ <eq:gen-g0>

which is the familiar potential $A_phi = B_z rho \/ 2$ of a locally uniform axial field. A numerical implementation must use this limit whenever the receiving loop passes through or close to the axis.

== Pose of the receiving loop as a rigid transformation
#figure(
  image("../images/gen-loop-pose.svg", width: 85%),
  caption: [Transmitting loop of radius $a$ in the plane $z = 0$ and receiving loop of radius $R$ with centre $bold(c) = z_c hat(bold(z))$ and local frame $(hat(bold(u)), hat(bold(v)), hat(bold(n)))$, tilted over $theta$ with respect to $hat(bold(z))$.],
) <fig:gen-loop-pose>

A local frame $(bold(c); hat(bold(u)), hat(bold(v)), hat(bold(n)))$ is attached to the receiving loop, with $bold(c) = (x_c, y_c, z_c)$ its centre and $hat(bold(u)), hat(bold(v)), hat(bold(n)) = hat(bold(u)) times hat(bold(v))$ a right-handed orthonormal basis, $hat(bold(n))$ being the loop normal, see @fig:gen-loop-pose. In this frame the loop is the circle

$ bold(p)(alpha) = R (cos alpha, sin alpha, 0)^T, quad alpha in [0, 2 pi), $

whose sense of traversal fixes, by the right-hand rule, the positive direction of $hat(bold(n))$ and therefore the sign of $Phi$ and $V$. The local frame is mapped onto the global one by the affine transformation

$
  T: RR^3 -> RR^3: bold(p) |-> bold(c) + bold(Q) bold(p), quad
  bold(Q) = mat(hat(bold(u)), hat(bold(v)), hat(bold(n))) in "SO"(3),
$ <eq:gen-affine>

or, in homogeneous coordinates,

$ vec(bold(r), 1) = mat(bold(Q), bold(c); bold(0)^T, 1) vec(bold(p), 1). $

Since $bold(Q)^T bold(Q) = bold(I)$ and $det bold(Q) = 1$, $T$ is a proper rigid motion, an element of the special Euclidean group $"SE"(3)$. It preserves lengths, angles and orientation, so the image of the circle is again a circle of radius $R$, traversed in the same sense with respect to its normal. Only the linear part $bold(Q)$ acts on vectors such as $d bold(r)$; the translation $bold(c)$ acts on points only. In global coordinates the loop becomes

$ bold(r)(alpha) = bold(c) + R hat(bold(e))(alpha), quad (d bold(r)) / (d alpha) = R hat(bold(t))(alpha), $ <eq:gen-loop>

with the radial and tangential unit vectors

$
  hat(bold(e))(alpha) = cos alpha thin hat(bold(u)) + sin alpha thin hat(bold(v)), quad
  hat(bold(t))(alpha) = -sin alpha thin hat(bold(u)) + cos alpha thin hat(bold(v)), quad
  hat(bold(e)) times hat(bold(t)) = hat(bold(n)).
$ <eq:gen-et>

== Flux through the receiving loop
The flux through the receiving loop follows from Stokes' theorem,

$
  Phi = integral.double_S bold(B) dot d bold(S) = integral.double_S (nabla times bold(A)) dot d bold(S) = integral.cont_(partial S) bold(A) dot d bold(r),
$ <eq:gen-stokes>

where $S$ may be taken as the flat disc bounded by the loop. Region 3 is a half-space and therefore convex, so the disc lies in region 3 together with its boundary, and @eq:gen-a3 is valid on all of $S$. Because $nabla dot bold(B) = 0$, the result does not depend on the chosen spanning surface, nor on the gauge of $bold(A)$.

Substituting @eq:gen-a-free and using the cyclic property of the scalar triple product, $(hat(bold(z)) times bold(r)) dot d bold(r) = hat(bold(z)) dot (bold(r) times d bold(r))$. With @eq:gen-loop and @eq:gen-et,

$ bold(r) times d bold(r) = (bold(c) + R hat(bold(e))) times R hat(bold(t)) thin d alpha = R (bold(c) times hat(bold(t)) + R hat(bold(n))) thin d alpha, $

so that the flux reduces to the single integral

$
  Phi = R integral_0^(2 pi) g(rho(alpha), z(alpha)) [R n_z + hat(bold(z)) dot (bold(c) times hat(bold(t))(alpha))] d alpha,
$ <eq:gen-flux>

with $n_z = hat(bold(z)) dot hat(bold(n))$ and

$ rho(alpha) = |hat(bold(z)) times bold(r)(alpha)|, quad z(alpha) = hat(bold(z)) dot bold(r)(alpha) = z_c + R (u_z cos alpha + v_z sin alpha). $ <eq:gen-rhoz>

In terms of the components of $bold(c)$ and of the columns of $bold(Q)$,

$
  hat(bold(z)) dot (bold(c) times hat(bold(t))) & = x_c (v_y cos alpha - u_y sin alpha) - y_c (v_x cos alpha - u_x sin alpha), \
  rho^2 (alpha) & = (x_c + R thin e_x (alpha))^2 + (y_c + R thin e_y (alpha))^2, quad e_k (alpha) = u_k cos alpha + v_k sin alpha.
$

@eq:gen-flux separates the two ways in which the pose enters. The term $R n_z$ stems from the projection of the loop onto the plane of the shield, the term in $bold(c)$ from the offset of the loop with respect to the axis of the source. For a uniform field $bold(B) = B_0 hat(bold(z))$, $g = B_0 \/ 2$ is constant, the offset term integrates to zero because $integral_0^(2 pi) hat(bold(t)) thin d alpha = bold(0)$, and @eq:gen-flux returns $Phi = pi R^2 B_0 n_z$, as it should.

== Reduction to known configurations <sec:gen-special>
The configurations treated in the literature are special cases of @eq:gen-flux, which provides a first check of the formulation.

_Coaxial, parallel loops._ For $bold(c) = z_c hat(bold(z))$ and $bold(Q) = bold(I)$, one has $rho(alpha) = R$ and $z(alpha) = z_c$, while $bold(c) times hat(bold(t))$ is perpendicular to $hat(bold(z))$. @eq:gen-flux becomes $Phi = 2 pi R A_phi (R, z_c)$, the loop-to-loop coupling of @moser2.

_Parallel, laterally displaced loops._ For $bold(Q) = bold(I)$, so that $hat(bold(u)) = hat(bold(x))$, $hat(bold(v)) = hat(bold(y))$ and $n_z = 1$,

$
  Phi = R integral_0^(2 pi) g(rho(alpha), z_c) (R + x_c cos alpha + y_c sin alpha) thin d alpha,
$ <eq:gen-flux-xy>

with $rho^2 (alpha) = (x_c + R cos alpha)^2 + (y_c + R sin alpha)^2$. The same result follows directly from @eq:gen-a-cart: with $x = x_c + R cos alpha$, $y = y_c + R sin alpha$ and $d bold(r) = R (-sin alpha thin hat(bold(x)) + cos alpha thin hat(bold(y))) thin d alpha$, one has $bold(A) dot d bold(r) = g R (x cos alpha + y sin alpha) thin d alpha = g R (R + x_c cos alpha + y_c sin alpha) thin d alpha$.

_Small receiving loop._ For $R -> 0$ the flux density is uniform over the disc and $Phi -> pi R^2 thin hat(bold(n)) dot bold(B)^((3)) (bold(c))$. On the axis and with $hat(bold(n)) = hat(bold(z))$, the ratio of the open and shielded flux reduces to the point-wise SE of Moser, @eq:moser-se.

== Invariances and degrees of freedom <sec:gen-invariance>
A rigid motion has six degrees of freedom, three in $bold(c)$ and three in $bold(Q)$. Not all of them affect $Phi$.

_Rotation about the loop normal._ Replacing $bold(Q)$ by $bold(Q) bold(R)_z (delta)$, with $bold(R)_z (delta)$ a rotation over $delta$ about the local $z$-axis, maps $hat(bold(e))(alpha) -> hat(bold(e))(alpha + delta)$ and $hat(bold(t))(alpha) -> hat(bold(t))(alpha + delta)$ and leaves $hat(bold(n))$ unchanged. The new parametrisation describes the same closed curve in the same sense, shifted in $alpha$, and since the integrand of @eq:gen-flux is $2 pi$-periodic, $Phi$ is unchanged. The flux therefore depends on $bold(Q)$ only through $hat(bold(n)) = bold(Q) hat(bold(z))$: the relevant orientations form the quotient $"SO"(3) \/ "SO"(2) tilde.equiv S^2$, the unit sphere of loop normals.

_Rotation about the axis of the source._ Since source and shield are axisymmetric, $bold(A)(bold(R)_z (gamma) bold(r)) = bold(R)_z (gamma) bold(A)(bold(r))$ for every rotation about the global $z$-axis. Rotating the complete receiving loop, $bold(c) -> bold(R)_z (gamma) bold(c)$ and $bold(Q) -> bold(R)_z (gamma) bold(Q)$, leaves $n_z$, $rho(alpha)$, $z(alpha)$ and $hat(bold(z)) dot (bold(c) times hat(bold(t)))$ invariant, and hence $Phi$.

The flux is therefore a function of four parameters only: the radial offset $rho_c = sqrt(x_c^2 + y_c^2)$ and the height $z_c$ of the centre, and the two angles that fix $hat(bold(n))$ relative to the plane through the axis and $bold(c)$. Without loss of generality the centre may be placed in the $x z$-plane, $y_c = 0$. The same reduction applies to the SE, since the open and shielded fluxes share these symmetries.

== Orientation: from Euler angles to unit quaternions <sec:gen-quaternions>
A straightforward way to orient the receiving loop is to compose elementary rotations, for instance a rotation $beta_x$ about the $x$-axis followed by a rotation $beta_y$ about the $y$-axis, $bold(Q) = bold(R)_y (beta_y) bold(R)_x (beta_x)$, which yields the normal

$ hat(bold(n)) = bold(R)_y (beta_y) bold(R)_x (beta_x) hat(bold(z)) = (sin beta_y cos beta_x, thin -sin beta_x, thin cos beta_y cos beta_x). $ <eq:gen-n-euler>

This parametrisation has three drawbacks. Neither angle has a direct physical meaning, since the tilt of the loop with respect to the shield normal is $arccos(cos beta_x cos beta_y)$. The result depends on the order of the elementary rotations, as $bold(R)_y bold(R)_x != bold(R)_x bold(R)_y$, so the convention must be fixed and carried through consistently. And the parametrisation is singular: for $beta_x = plus.minus pi \/ 2$ the normal equals $minus.plus hat(bold(y))$ whatever the value of $beta_y$, the so-called gimbal lock.

A unit quaternion $q = q_0 + q_1 bold(i) + q_2 bold(j) + q_3 bold(k)$, with $|q| = 1$ and $bold(i)^2 = bold(j)^2 = bold(k)^2 = bold(i) bold(j) bold(k) = -1$, represents the rotation over an angle $kappa$ about a unit axis $hat(bold(m))$ as

$ q = cos(kappa / 2) + sin(kappa / 2) (m_x bold(i) + m_y bold(j) + m_z bold(k)), $ <eq:gen-q>

acting on a vector $bold(p)$, identified with the pure quaternion $p_x bold(i) + p_y bold(j) + p_z bold(k)$, as $bold(p) |-> q bold(p) q^*$ @kuipers1999. The corresponding rotation matrix is

$
  bold(Q)(q) = mat(
    1 - 2 (q_2^2 + q_3^2), 2 (q_1 q_2 - q_0 q_3), 2 (q_1 q_3 + q_0 q_2);
    2 (q_1 q_2 + q_0 q_3), 1 - 2 (q_1^2 + q_3^2), 2 (q_2 q_3 - q_0 q_1);
    2 (q_1 q_3 - q_0 q_2), 2 (q_2 q_3 + q_0 q_1), 1 - 2 (q_1^2 + q_2^2)
  ).
$ <eq:gen-qmat>

The map $q |-> bold(Q)(q)$ is a smooth two-to-one covering of $"SO"(3)$ by the unit sphere $S^3$, with $q$ and $-q$ representing the same rotation. Unlike any three-angle parametrisation it has no singular points, and the composition of rotations is the quaternion product, $bold(Q)(q_2 q_1) = bold(Q)(q_2) bold(Q)(q_1)$.

Combined with the invariance of @sec:gen-invariance, quaternions yield a natural parametrisation of the loop orientation. Since only $hat(bold(n))$ matters, it suffices to take, for each normal, the shortest rotation that carries $hat(bold(z))$ onto $hat(bold(n))$. Its axis $hat(bold(m)) = (hat(bold(z)) times hat(bold(n))) \/ |hat(bold(z)) times hat(bold(n))|$ lies in the plane of the shield, and its angle is the tilt of the loop with respect to the shield normal. With the normal in spherical coordinates,

$ hat(bold(n)) = (sin theta cos psi, sin theta sin psi, cos theta), quad 0 <= theta <= pi, $ <eq:gen-n-sph>

with $theta$ the tilt and $psi$ the azimuth of the tilt direction, this rotation is

$ q(theta, psi) = cos(theta / 2) + sin(theta / 2) (-sin psi thin bold(i) + cos psi thin bold(j)), $ <eq:gen-q-swing>

or, directly in terms of the normal and free of trigonometric functions,

$
  q = (1 + hat(bold(z)) dot hat(bold(n)) + (hat(bold(z)) times hat(bold(n)))_x bold(i) + (hat(bold(z)) times hat(bold(n)))_y bold(j)) / sqrt(2 (1 + hat(bold(z)) dot hat(bold(n)))), quad hat(bold(n)) != -hat(bold(z)).
$ <eq:gen-q-n>

Substitution in @eq:gen-qmat gives the in-plane axes of the receiving loop, the third column being $hat(bold(n))$ of @eq:gen-n-sph,

$
  hat(bold(u)) = vec(1 - (1 - cos theta) cos^2 psi, -(1 - cos theta) sin psi cos psi, -sin theta cos psi), quad
  hat(bold(v)) = vec(-(1 - cos theta) sin psi cos psi, 1 - (1 - cos theta) sin^2 psi, -sin theta sin psi).
$ <eq:gen-frame>

Compared with @eq:gen-n-euler, this parametrisation has three advantages. Both parameters have a direct physical meaning: $theta$ is the angle between the loop normal and the shield normal, so that $n_z = cos theta$ enters @eq:gen-flux directly, and $psi$ is the direction in which the loop is tilted. The construction does not depend on an order of elementary rotations. And the only remaining degeneracy, at $theta = 0$ where $psi$ is undefined, is harmless, since @eq:gen-q-swing then gives $q = 1$ for every $psi$ and the pose itself is well defined. This pole is the unavoidable coordinate singularity of any two-parameter chart of $S^2$. When the pose is specified by $hat(bold(n))$ directly through @eq:gen-q-n it does not occur at all, and the single excluded normal $hat(bold(n)) = -hat(bold(z))$ corresponds to a loop turned over, for which any axis in the plane of the shield may be taken, for instance $q = bold(i)$.

Whenever @eq:gen-n-euler and @eq:gen-frame describe the same normal, the two frames differ only by a rotation about $hat(bold(n))$, so by @sec:gen-invariance they yield the same flux. The quaternion form changes the parametrisation, not the results.

== Range of validity <sec:gen-validity>
The third assumption of @sec:gen-geometry constrains the pose. By @eq:gen-rhoz, $z(alpha)$ attains its minimum $z_c - R sqrt(u_z^2 + v_z^2)$, and since the rows of $bold(Q)$ are unit vectors, $u_z^2 + v_z^2 = 1 - n_z^2 = sin^2 theta$. The receiving loop lies entirely in region 3 if and only if

$ z_c - R sin theta > c. $ <eq:gen-validity>

== Shielding effectiveness of an arbitrarily placed loop
With the open-circuit voltage proportional to the flux, the SE of a receiving loop in an arbitrary pose is defined as the insertion loss

$ "SE"(bold(c), hat(bold(n))) = 20 log_10 lr(|Phi^"open" / Phi^"shield"|), $ <eq:gen-se>

where both fluxes follow from @eq:gen-flux for the same pose, with $A_phi$ from @eq:moser-a and @eq:gen-a3 respectively. In contrast with @eq:moser-se, the SE is no longer a single value per frequency but a function on the four-dimensional pose space of @sec:gen-invariance.

This definition breaks down for poses in which $Phi^"open"$ vanishes. A clear example follows from @eq:gen-flux: for a loop centred on the axis, $bold(c) = z_c hat(bold(z))$, the offset term vanishes and $Phi = R^2 n_z integral_0^(2 pi) g thin d alpha$, so both fluxes vanish identically when the loop is tilted to $theta = pi \/ 2$. Close to such poses the SE is a ratio of two small quantities and reflects the orientation of the loop rather than the performance of the shield. Such poses are therefore reported separately rather than interpreted as high or low shielding.

== Numerical evaluation
@eq:gen-flux is a double integral, over the loop parameter $alpha$ and over the spectral variable $lambda$ of @eq:gen-a3. The inner integral is evaluated for every point of the discretised loop. For the outer integral the trapezoidal rule is used, which for a smooth $2 pi$-periodic integrand converges exponentially in the number of points, so that a modest number of points along the loop suffices.
// TODO: NEC-vergelijking toevoegen (figuur + max. afwijking in dB), configuraties: coaxiaal, verschoven, gekanteld.
