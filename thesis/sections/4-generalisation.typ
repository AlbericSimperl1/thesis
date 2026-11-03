= Generalisation to an arbitrarily placed receiving loop <sec:generalisation>

The closed-form results of @sec:literature give the field behind the shield only in the coaxial configuration, observed either in a point on the axis @moser1 @moser1988 or with a receiving loop that is coaxial with and parallel to the source @moser2. In this chapter the receiving loop is given an arbitrary position and orientation. No new boundary-value problem has to be solved for this: the axisymmetric solution behind the shield is retained, and only the receiving loop is moved by a rigid transformation. The flux it captures then follows from a single line integral.

The only result taken from the literature is Moser's axisymmetric vector potential behind the shield. Everything built on it in this chapter is the contribution of this thesis:

- the Cartesian and coordinate-free form of that potential, including its regular behaviour on the axis;
- the description of the receiving loop as a rigid transformation in $"SE"(3)$;
- the flux through a loop in an arbitrary pose, reduced via Stokes' theorem to one integral over the loop;
- the invariances that reduce the six pose parameters to four;
// - an orientation parametrisation based on unit quaternions, replacing Euler angles;
- the condition under which the result is valid;
- the SE for an arbitrary pose, and the poses for which it is not defined.

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

with $mu = mu_0 mu_r$, $tau$ and $tau_0$ from @eq:moser-tau and $C$ from @eq:moser-c. Without the shield, $A_phi$ is given by @eq:moser-a with $r$ replaced by $rho$. The derivation below only uses that $bold(A)$ is azimuthal and axisymmetric.

== Unit vector transform <sec:gen-unit-vectors>
To evaluate @eq:gen-a3 in a Carthesian point $(x, y, z)$, both the argument $rho$ and the unit vector $hat(bold(phi))$ have to be expressed in $x$ and $y$. The starting point is the radial unit vector, which points from the axis to the point under the angle $phi$ with the $x$-axis, see @fig:gen-unit-vectors. Since $cos phi = x \/ rho$ and $sin phi = y \/ rho$,

$
  hat(bold(rho)) & = cos phi thin hat(bold(x)) + sin phi thin hat(bold(y)) \
                 & = x / rho thin hat(bold(x)) + y / rho thin hat(bold(y)).
$ <eq:gen-rho-hat>

#figure(
  image("../images/gen-unit-vectors.svg", width: 55%),
  caption: [Carthesian and cylindrical unit vectors in a point in the xy-plane],
) <fig:gen-unit-vectors>

The azimuthal unit vector lies in the same plane and is orthogonal to the radial one, $hat(bold(rho)) perp hat(bold(phi))$, in the direction of increasing $phi$. It is therefore the radial unit vector rotated over $+pi / 2$,

$
  hat(bold(phi)) & = cos(phi + pi / 2) thin hat(bold(x)) + sin(phi + pi / 2) thin hat(bold(y)) \
                 & = -sin phi thin hat(bold(x)) + cos phi thin hat(bold(y)) \
                 & = -y / rho thin hat(bold(x)) + x / rho thin hat(bold(y)) \
                 & = (-y) / sqrt(x^2 + y^2) thin hat(bold(x)) + x / sqrt(x^2 + y^2) thin hat(bold(y)) \
                 & = 1 / sqrt(x^2 + y^2) thin (-y thin bold(hat(x)) + x thin bold(hat(y))).
$ <eq:gen-phi-hat>

The vector potential behind the shield is purely azimuthal, $bold(A)^((3)) = A_phi (rho, z) thin hat(bold(phi))$. By substituting $rho = sqrt(x^2 + y^2)$ in the argument we define

$ tilde(A)_phi (x, y, z) := A_phi (sqrt(x^2 + y^2), z). $ <eq:def-rho>
Using this substitution the argument will now represent the displacement to the source-axis.
This suffices because of the source axisymmetry, the field isn't dependent on the rotation about the $z$-axis, meaning $A_phi$ does not depend on $phi$.
Two points with the same distance $rho$ to the axis and the same height $z$ map onto
each other under a rotation by $phi$, and therefore have the same value of
$A_phi$. The only positional information that remains is the distance to the
axis, which is what $sqrt(x^2 + y^2)$ provides.
The angle $phi$ adds nothing for the scalar function $A_phi$.
The direction of the field is not contained in $tilde(A)_phi$ but in the basis
vector $hat(bold(phi))$, which does vary with position as shown in @eq:gen-phi-hat

By both of these characteristics, the vector potentials expressed using @eq:gen-phi-hat and @eq:def-rho are well-defined for all $(x, y) != (0,0)$.
Substituting @eq:gen-phi-hat for the unit vector $bold(hat(phi))$ yields

$
  bold(A)^((3)) (x, y, z) & = A_phi (rho, z) thin hat(bold(phi)) \
  & = ( tilde(A)_phi (x, y, z)) / sqrt(x^2 + y^2) thin (-y thin hat(bold(x)) + x thin hat(bold(y))).
$ <eq:gen-a-cart>

== Flux through a laterally displaced loop <sec:gen-displaced>
@eq:gen-a-cart is first applied to a receiving loop of radius $R$ that is parallel to the source but displaced from its axis, with centre $(x_c, y_c, z_c)$. The flux through the loop follows from Stokes' theorem,

$
  Phi = integral.double_S bold(B) dot d bold(S) = integral.double_S (nabla times bold(A)) dot d bold(S) = integral.cont_(partial S) bold(A) dot d bold(r).
$ <eq:gen-stokes>

The loop is parametrised by the angle $alpha in [0, 2 pi)$ around its own centre,

$
  bold(r)(alpha) & = x(alpha) thin hat(bold(x)) + y(alpha) thin hat(bold(y)) + z_0 hat(bold(z)) \
                 & = (x_0 + R cos alpha) thin hat(bold(x)) + (y_0 + R sin alpha) thin hat(bold(y)) + z_0 hat(bold(z)), \
       d bold(r) & = R (-sin alpha thin hat(bold(x)) + cos alpha thin hat(bold(y))) thin d alpha.
$ <RX-par>

On the loop, the distance to the axis of the source depends on $alpha$,

$ rho(alpha) = sqrt(x^2 (alpha) + y^2 (alpha)) = sqrt((x_0 + R cos alpha)^2 + (y_0 + R sin alpha)^2), $

and so does the azimuthal unit vector, $hat(bold(phi))(alpha) = 1 / rho(alpha) thin (-y(alpha) thin hat(bold(x)) + x(alpha) thin hat(bold(y)))$. Note that $hat(bold(phi))(alpha)$ differs from the direction $-sin alpha thin hat(bold(x)) + cos alpha thin hat(bold(y))$ of $d bold(r)$ as soon as the loop is displaced; only their dot product enters the flux. Working it out,

$
  bold(A)^((3)) dot d bold(r) & = A_phi (rho(alpha), z_0) thin hat(bold(phi))(alpha) dot d bold(r) \
  & = tilde(A)_phi (x (alpha), y (alpha), z_0) thin 1 / rho(alpha) thin (-y(alpha) thin hat(bold(x)) + x(alpha) thin hat(bold(y))) dot R (-sin alpha thin hat(bold(x)) + cos alpha thin hat(bold(y))) thin d alpha \
  & = tilde(A)_phi (x (alpha), y (alpha), z_0) thin R / rho(alpha) thin (y(alpha) sin alpha + x(alpha) cos alpha) thin d alpha \
  & = tilde(A)_phi (x (alpha), y (alpha), z_0) thin R / rho(alpha) thin ((y_0 + R sin alpha) sin alpha + (x_0 + R cos alpha) cos alpha) thin d alpha \
  & = tilde(A)_phi (x (alpha), y (alpha), z_0) thin R / rho(alpha) thin (y_0 sin alpha + R sin^2 alpha + x_0 cos alpha + R cos^2 alpha) thin d alpha \
  & = tilde(A)_phi (x (alpha), y (alpha), z_0) thin R / rho(alpha) thin (y_0 sin alpha + x_0 cos alpha + R) thin d alpha.
$

Substituting in @eq:gen-stokes gives the flux through the displaced loop,

$
  Phi = integral_0^(2 pi) tilde(A)_phi (x (alpha), y (alpha), z_0) thin (R thin (x_0 cos alpha + y_0 sin alpha + R)) / rho(alpha) thin d alpha.
$ <eq:gen-flux-xy>

With $A_phi$ from @eq:gen-a3, written as $A_phi (rho, z) = integral_0^infinity F(lambda, z) J_1 (lambda rho) thin d lambda$ with $F(lambda, z) = 2 mu a i C lambda tau \/ tau_0^2 thin J_1 (lambda a) e^(-tau_0 z - t (tau - tau_0))$, this becomes the double integral

$
  Phi = integral_0^(2 pi) integral_0^infinity F(lambda, z_c) thin J_1 (lambda rho(alpha)) thin (R (x_0 cos alpha + y_0 sin alpha + R)) / rho(alpha) thin d lambda thin d alpha,
$ <eq:gen-flux-xy-double>


== Pose of the receiving loop as a rigid transformation
#figure(
  image("../images/RX.png", width: 55%),
  caption: [Receiving loop in $bold(c) = (0, 0, z_0)$ with its local frame tilted over $psi$.],
) <fig:gen-loop-pose>

A local frame $(bold(c); hat(bold(u)), hat(bold(v)), hat(bold(n)))$ is attached to the receiving loop, with $bold(c) = (x_0, y_0, z_0)$ its centre and $hat(bold(u)), hat(bold(v)), hat(bold(n)) = hat(bold(u)) times hat(bold(v))$ a right-handed orthonormal basis, $hat(bold(n))$ being the loop normal, see @fig:gen-loop-pose. In this frame the loop is the circle

$ bold(p)(alpha) = R (cos alpha, sin alpha, 0)^T, quad alpha in [0, 2 pi), $

whose sense of traversal fixes, by the right-hand rule, the positive direction of $hat(bold(n))$ and therefore the sign of $Phi$ and $V$.
The local frame is mapped onto the global one by the affine transformation
$
  T: RR^3 -> RR^3: bold(p) |-> bold(r) = bold(c) + bold(Q) bold(p), quad
  bold(Q) = mat(hat(bold(u)), hat(bold(v)), hat(bold(n))),
$ <eq:gen-affine>
where $bold(p)$ is a point in local coordinates and $bold(r)$ that same point in
global coordinates.
Since $bold(Q)^T bold(Q) = bold(I)$ and $det bold(Q) = 1$, $T$ is a rigid motion. It preserves lengths, angles and orientation, the circle is again a circle of radius $R$. Only the linear part $bold(Q)$ acts on vectors such as $d bold(r)$; the translation $bold(c)$ acts on points only. In global coordinates the loop becomes

$
  bold(r)(alpha) = bold(c) + R hat(bold(e))(alpha), quad (d bold(r)) / (d alpha) = R thin (d bold(hat(e))) / (d alpha) = R hat(bold(t))(alpha),
$ <eq:gen-loop>

with the radial and tangential unit vectors

$
  hat(bold(e))(alpha) = cos alpha thin hat(bold(u)) + sin alpha thin hat(bold(v)), quad
  hat(bold(t))(alpha) = -sin alpha thin hat(bold(u)) + cos alpha thin hat(bold(v)), quad
  hat(bold(e)) times hat(bold(t)) = hat(bold(n)).
$ <eq:gen-et>

== Flux through the receiving loop
The flux through the receiving loop again follows from Stokes' theorem, @eq:gen-stokes, where $S$ may be taken as the flat disc bounded by the loop. Region 3 is a half-space and therefore convex, so the disc lies in region 3 together with its boundary, and @eq:gen-a3 is valid on all of $S$. Because $nabla dot bold(B) = 0$, the result does not depend on the chosen spanning surface, nor on the gauge of $bold(A)$.

Written out in components, @eq:gen-loop and @eq:gen-et give

$
  x(alpha) & = x_0 + R (u_x cos alpha + v_x sin alpha), \
  y(alpha) & = y_0 + R (u_y cos alpha + v_y sin alpha), \
  z(alpha) & = z_0 + R (u_z cos alpha + v_z sin alpha), \
  d bold(r) & = R vec(-u_x sin alpha + v_x cos alpha, -u_y sin alpha + v_y cos alpha, -u_z sin alpha + v_z cos alpha) d alpha,
$ <eq:gen-rhoz>

with, as in @sec:gen-displaced, $rho(alpha) = sqrt(x^2 (alpha) + y^2 (alpha))$. In contrast with the parallel loop, $z$ now also varies along the loop. Since $hat(bold(phi))$ of @eq:gen-phi-hat has no $z$-component, only the $x$- and $y$-components of $d bold(r)$ contribute. Working out the dot product, with $A_phi$ short for $A_phi (rho(alpha), z(alpha))$,

$
  bold(A)^((3)) dot d bold(r) & = A_phi (rho(alpha), z(alpha)) thin ((-y(alpha)) / rho(alpha) thin hat(bold(x)) + x(alpha) / rho(alpha) thin hat(bold(y))) dot d bold(r) \
  & = A_phi thin R / rho(alpha) thin [-y(alpha) (-u_x sin alpha + v_x cos alpha) + x(alpha) (-u_y sin alpha + v_y cos alpha)] thin d alpha \
  & = A_phi thin R / rho(alpha) thin [-(y_0 + R u_y cos alpha + R v_y sin alpha) (-u_x sin alpha + v_x cos alpha) \
    & quad + (x_0 + R u_x cos alpha + R v_x sin alpha) (-u_y sin alpha + v_y cos alpha)] thin d alpha \
  & = A_phi thin R / rho(alpha) thin [y_0 (u_x sin alpha - v_x cos alpha) - x_0 (u_y sin alpha - v_y cos alpha) \
    & quad + R (u_x v_y - u_y v_x) (cos^2 alpha + sin^2 alpha)] thin d alpha \
  & = A_phi thin R / rho(alpha) thin [y_0 (u_x sin alpha - v_x cos alpha) - x_0 (u_y sin alpha - v_y cos alpha) + R n_z] thin d alpha,
$ <eq:gen-adr>

where $u_x v_y - u_y v_x = n_z$ is the $z$-component of $hat(bold(n)) = hat(bold(u)) times hat(bold(v))$. Substituting in @eq:gen-stokes gives the flux through the receiving loop,

$
  Phi = & integral_0^(2 pi) A_phi (rho(alpha), z(alpha)) thin R / rho(alpha) thin [R n_z + y_0 (u_x sin alpha - v_x cos alpha) \
    & - x_0 (u_y sin alpha - v_y cos alpha)] thin d alpha,
$ <eq:gen-flux>

@eq:gen-flux separates the two ways in which the pose manifests. The term $R n_z$ follows from the projection of the loop onto the shield plane. The terms in $x_0$ and $y_0$ equal $hat(bold(z)) dot (bold(c) times hat(bold(t)))$ together , are a consequence of the loop offset to the axis of the source. For a uniform field $bold(B) = B_0 hat(bold(z))$, the offset terms then integrate to zero over a period, and @eq:gen-flux returns $Phi = pi R^2 B_0 n_z$, as it should.

== Reduction to known configurations <sec:gen-special>
The configurations treated in the literature are special cases of @eq:gen-flux, which provides a first check of the formulation.

_Coaxial, parallel loops._ For $bold(c) = z_0 hat(bold(z))$ and $bold(Q) = bold(I)$, one has $rho(alpha) = R$ and $z(alpha) = z_c$, while $bold(c) times hat(bold(t))$ is perpendicular to $hat(bold(z))$. @eq:gen-flux becomes $Phi = 2 pi R A_phi (R, z_c)$, the loop-to-loop coupling of @moser2.

_Parallel, laterally displaced loops._ For $bold(Q) = bold(I)$, so that $hat(bold(u)) = hat(bold(x))$, $hat(bold(v)) = hat(bold(y))$ and $n_z = 1$, the offset terms become $x_0 cos alpha + y_0 sin alpha$ and @eq:gen-flux reduces to exactly @eq:gen-flux-xy of @sec:gen-displaced.

_Small receiving loop._ For $R -> 0$ the flux density is uniform over the disc and $Phi -> pi R^2 thin hat(bold(n)) dot bold(B)^((3)) (bold(c))$. On the axis and with $hat(bold(n)) = hat(bold(z))$, the ratio of the open and shielded flux reduces to the point-wise SE of Moser, @eq:moser-se.

== Invariances and degrees of freedom <sec:gen-invariance>
A rigid motion has six degrees of freedom, three in $bold(c)$ and three in $bold(Q)$. Because of the setup geometry two of these will have no effect on the flux $Phi$.

=== Rotation about the loop normal
Replacing $bold(Q)$ by $bold(Q) bold(R)_n (delta)$, with $bold(R)_n (delta)$ a rotation over $delta$ about the local $z$-axis, maps $hat(bold(e))(alpha) -> hat(bold(e))(alpha + delta)$ and $hat(bold(t))(alpha) -> hat(bold(t))(alpha + delta)$ and, most importantly, leaves $hat(bold(n))$ unchanged. This new parametrisation is only a reparametrisation of the original curve. It describes the same closed curve in the same sense, shifted only in $alpha$, and since @eq:gen-flux is a circle and thus $2 pi$-periodic, $Phi$ remains the same. The flux depends on $bold(Q)$ only through $hat(bold(n)) = bold(Q) hat(bold(z))$.

=== Rotation about the axis of the source
Since source and shield are axisymmetric, $bold(A)(bold(R)_z (gamma) bold(r)) = bold(R)_z (gamma) bold(A)(bold(r))$ for every rotation about the $z$-axis. Rotating the RX loop, $bold(c) -> bold(R)_z (gamma) bold(c)$ and $bold(Q) -> bold(R)_z (gamma) bold(Q)$, leaves $n_z$, $rho(alpha)$, $z(alpha)$ and $hat(bold(z)) dot (bold(c) times hat(bold(t)))$ invariant. Hence $Phi$ will remain the same as well.

=== Notable parameters
As a result the flux is a function of only four geometrical parameters. The radial offset $rho_0 = sqrt(x_c^2 + y_c^2)$ and the height $z_c$ of the centre, and the two angles that fix $hat(bold(n))$ relative to the plane through the axis and $bold(c)$. Without loss of generality the centre may be placed in the $x z$-plane, $y_0 = 0$. The same reduction applies to the SE, since the vector potentials in the open and shielded configurations share the same symmetries.

Where @sec:gen-displaced handled the radial offset, @sec:gen-orientation will extend the existing model to allow for said angles which rotate the RX loop in 3D-space.

== Orientation of the RX loop <sec:gen-orientation>
The loop is oriented by composing two elementary rotations about the global axes: first a rotation $psi$ about the $x$-axis, then a rotation $theta$ about the $y$-axis, with

$
  bold(R)_x (psi) = mat(1, 0, 0; 0, cos psi, -sin psi; 0, sin psi, cos psi), quad
  bold(R)_y (theta) = mat(cos theta, 0, sin theta; 0, 1, 0; -sin theta, 0, cos theta).
$

The rotation applied first stands on the right, so that

$
  bold(Q) = bold(R)_y (theta) bold(R)_x (psi) = mat(
    cos theta, sin theta sin psi, sin theta cos psi;
    0, cos psi, -sin psi;
    -sin theta, cos theta sin psi, cos theta cos psi
  ).
$ <eq:gen-q-euler>

Per @eq:gen-affine, the columns of @eq:gen-q-euler are the axes of the local frame,

$
  hat(bold(u)) = vec(cos theta, 0, -sin theta), quad
  hat(bold(v)) = vec(sin theta sin psi, cos psi, cos theta sin psi), quad
  hat(bold(n)) = vec(sin theta cos psi, -sin psi, cos theta cos psi).
$ <eq:gen-n-euler>

The order matters, since $bold(R)_y bold(R)_x != bold(R)_x bold(R)_y$. The tilt $beta$ of the loop with respect to the shield normal follows from
$cos beta = n_z = cos psi cos theta$. Substituting @eq:gen-n-euler in @eq:gen-rhoz gives

$
  x(alpha) & = x_0 + R (cos theta cos alpha + sin theta sin psi sin alpha), \
  y(alpha) & = y_0 + R cos psi sin alpha, \
  z(alpha) & = z_0 + R (cos theta sin psi sin alpha - sin theta cos alpha),
$

and substituting it in @eq:gen-flux gives the flux in terms of the two angles,

$
  Phi = & integral_0^(2 pi) A_phi (rho(alpha), z(alpha)) thin R / rho(alpha) thin [R cos psi cos theta + x_0 cos psi cos alpha \
    & + y_0 (cos theta sin alpha - sin theta sin psi cos alpha)] thin d alpha.
$ <eq:gen-flux-euler>

For $psi = theta = 0$ this reduces to @eq:gen-flux-xy.

// == Orientation: from Euler angles to unit quaternions <sec:gen-quaternions>
// A straightforward way to orient the receiving loop is to compose elementary rotations, for instance a rotation $phi$ about the $x$-axis followed by a rotation $theta$ about the $y$-axis, $bold(Q) = bold(R)_y (theta) bold(R)_x (phi)$, which yields the normal

// $ hat(bold(n)) = bold(R)_y (theta) bold(R)_x (phi) hat(bold(z)) = (sin theta cos phi, thin -sin phi, thin cos theta cos phi). $ <eq:gen-n-euler>

// This parametrisation has three drawbacks. Neither angle has a direct physical meaning, since the tilt of the loop with respect to the shield normal is $arccos(cos phi cos theta)$. The result depends on the order of the elementary rotations, as $bold(R)_y bold(R)_x != bold(R)_x bold(R)_y$, so the convention must be fixed and carried through consistently. And the parametrisation is singular: for $phi = plus.minus pi \/ 2$ the normal equals $minus.plus hat(bold(y))$ whatever the value of $theta$, the so-called gimbal lock.

// A unit quaternion $q = q_0 + q_1 bold(i) + q_2 bold(j) + q_3 bold(k)$, with $|q| = 1$ and $bold(i)^2 = bold(j)^2 = bold(k)^2 = bold(i) bold(j) bold(k) = -1$, represents the rotation over an angle $kappa$ about a unit axis $hat(bold(m))$ as

// $ q = cos(kappa / 2) + sin(kappa / 2) (m_x bold(i) + m_y bold(j) + m_z bold(k)), $ <eq:gen-q>

// acting on a vector $bold(p)$, identified with the pure quaternion $p_x bold(i) + p_y bold(j) + p_z bold(k)$, as $bold(p) |-> q bold(p) q^*$ @kuipers1999. The corresponding rotation matrix is

// $
//   bold(Q)(q) = mat(
//     1 - 2 (q_2^2 + q_3^2), 2 (q_1 q_2 - q_0 q_3), 2 (q_1 q_3 + q_0 q_2);
//     2 (q_1 q_2 + q_0 q_3), 1 - 2 (q_1^2 + q_3^2), 2 (q_2 q_3 - q_0 q_1);
//     2 (q_1 q_3 - q_0 q_2), 2 (q_2 q_3 + q_0 q_1), 1 - 2 (q_1^2 + q_2^2)
//   ).
// $ <eq:gen-qmat>

// The map $q |-> bold(Q)(q)$ is a smooth two-to-one covering of $"SO"(3)$ by the unit sphere $S^3$, with $q$ and $-q$ representing the same rotation. Unlike any three-angle parametrisation it has no singular points, and the composition of rotations is the quaternion product, $bold(Q)(q_2 q_1) = bold(Q)(q_2) bold(Q)(q_1)$.

// Combined with the invariance of @sec:gen-invariance, quaternions yield a natural parametrisation of the loop orientation. Since only $hat(bold(n))$ matters, it suffices to take, for each normal, the shortest rotation that carries $hat(bold(z))$ onto $hat(bold(n))$. Its axis $hat(bold(m)) = (hat(bold(z)) times hat(bold(n))) \/ |hat(bold(z)) times hat(bold(n))|$ lies in the plane of the shield, and its angle is the tilt of the loop with respect to the shield normal. With the normal in spherical coordinates,

// $ hat(bold(n)) = (sin theta cos psi, sin theta sin psi, cos theta), quad 0 <= theta <= pi, $ <eq:gen-n-sph>

// with $theta$ the tilt and $psi$ the azimuth of the tilt direction, this rotation is

// $ q(theta, psi) = cos(theta / 2) + sin(theta / 2) (-sin psi thin bold(i) + cos psi thin bold(j)), $ <eq:gen-q-swing>

// or, directly in terms of the normal and free of trigonometric functions,

// $
//   q = (1 + hat(bold(z)) dot hat(bold(n)) + (hat(bold(z)) times hat(bold(n)))_x bold(i) + (hat(bold(z)) times hat(bold(n)))_y bold(j)) / sqrt(2 (1 + hat(bold(z)) dot hat(bold(n)))), quad hat(bold(n)) != -hat(bold(z)).
// $ <eq:gen-q-n>

// Substitution in @eq:gen-qmat gives the in-plane axes of the receiving loop, the third column being $hat(bold(n))$ of @eq:gen-n-sph,

// $
//   hat(bold(u)) = vec(1 - (1 - cos theta) cos^2 psi, -(1 - cos theta) sin psi cos psi, -sin theta cos psi), quad
//   hat(bold(v)) = vec(-(1 - cos theta) sin psi cos psi, 1 - (1 - cos theta) sin^2 psi, -sin theta sin psi).
// $ <eq:gen-frame>

// Compared with @eq:gen-n-euler, this parametrisation has three advantages. Both parameters have a direct physical meaning: $theta$ is the angle between the loop normal and the shield normal, so that $n_z = cos theta$ enters @eq:gen-flux directly, and $psi$ is the direction in which the loop is tilted. The construction does not depend on an order of elementary rotations. And the only remaining degeneracy, at $theta = 0$ where $psi$ is undefined, is harmless, since @eq:gen-q-swing then gives $q = 1$ for every $psi$ and the pose itself is well defined. This pole is the unavoidable coordinate singularity of any two-parameter chart of $S^2$. When the pose is specified by $hat(bold(n))$ directly through @eq:gen-q-n it does not occur at all, and the single excluded normal $hat(bold(n)) = -hat(bold(z))$ corresponds to a loop turned over, for which any axis in the plane of the shield may be taken, for instance $q = bold(i)$.

// Whenever @eq:gen-n-euler and @eq:gen-frame describe the same normal, the two frames differ only by a rotation about $hat(bold(n))$, so by @sec:gen-invariance they yield the same flux. The quaternion form changes the parametrisation, not the results.

== Range of validity <sec:gen-validity>
The third assumption of @sec:gen-geometry constrains the pose. By @eq:gen-rhoz, $z(alpha)$ attains its minimum $z_0 - R sqrt(u_z^2 + v_z^2)$, and since the rows of $bold(Q)$ are unit vectors, $u_z^2 + v_z^2 = 1 - n_z^2 = sin^2 theta$. The receiving loop lies entirely in region 3 if and only if

$ z_0 - R sin theta > c. $ <eq:gen-validity>

== Shielding effectiveness of an arbitrarily placed loop
With the open-circuit voltage proportional to the flux, the SE of a receiving loop in an arbitrary pose is defined as the insertion loss

$ "SE"(bold(c), psi, theta) = 20 log_10 lr(|Phi^"open" / Phi^"shield"|), $ <eq:gen-se>

where both fluxes follow from @eq:gen-flux for the same pose, with $A_phi$ from @eq:moser-a and @eq:gen-a3 respectively. In contrast with @eq:moser-se, the SE is no longer a single value per frequency but a function on the four-dimensional pose space of @sec:gen-invariance.

This definition breaks down for poses in which $Phi^"open"$ vanishes. A clear example follows from @eq:gen-flux: for a loop centred on the axis, $bold(c) = z_0 hat(bold(z))$, the offset terms vanish and $Phi = R^2 n_z integral_0^(2 pi) A_phi \/ rho thin d alpha$, so both fluxes vanish identically when the loop is tilted to $theta = pi \/ 2$. Close to such poses the SE is a ratio of two small quantities and reflects the orientation of the loop rather than the performance of the shield. Such poses are therefore reported separately rather than interpreted as high or low shielding.

== Numerical evaluation
@eq:gen-flux is a double integral, over the loop parameter $alpha$ and over the spectral variable $lambda$ of @eq:gen-a3. The inner integral is evaluated for every point of the discretised loop. For the outer integral the trapezoidal rule is used, which for a smooth $2 pi$-periodic integrand converges exponentially in the number of points, so that a modest number of points along the loop suffices.
// TODO: NEC-vergelijking toevoegen (figuur + max. afwijking in dB), configuraties: coaxiaal, verschoven, gekanteld.
