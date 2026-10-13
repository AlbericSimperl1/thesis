= State of the Art

== What is shielding?
Electromagnetic shielding is a means of improving electromagnetic compatibility (EMC) using an electromagnetic (EM) shield. Using this shield, it is possible to reduce the electromagnetic field intensity within a prescribed region @celozziBOEK. A shield's effectiveness is denoted by it's shielding effectiveness (SE). The definition is analogous for magnetic and electric fields,
$ "SE" = 20 log_10 lr(|frac(H_("open"), H_("closed"))|)," [dB]". $
Depending on the material used, a shield can reflect, absorb or redirect the incident field. Shielding is used whenever a field source and/or a sensitive region must be isolated from each other.
In military settings it can be used to guarantee communication security, thus protecting sensitive information transmitted using electromagnetic waves.
Medically use cases are found isolating medical MRI and ECG/EEG units, which need to be strictly enclosed.
Furthermore, active implanted medical devices such as pacemakers and cardioverters require an enclosure which protects these sensitive detection circuits.
Although shielding is used is virtually any field and whether this happens through immunity, emission control, privacy or even human safety, the objective is always ensuring EMC.



== Physics behind near-field magnetic shielding
For electrical shielding, the situation is quite trivial compared to its magnetic counterpart. When using a good conductor for a shield, we find a low impedance surface off of which incoming electric fields get reflected. This mechanism is mainly caused by charge redistributions and reflections instead of diffusion.

=== Electrical and magnetic shields
As stated before, the behaviour of a shield is highly dependent on its material characteristics.
With the biggest distinction coming from it's EM behaviour, we find electrically and magnetically conducting shields.

When looking at electrically conductive shields, also called eddy-current shields, the behaviour at lower frequencies is heavily dependent on the wave impedance and diffusion.
In the lower frequency ranges this impedance will be low, meaning magnetic surface reflections will be weak.
The shields therefore rely on eddy-currents induced by the incident magnetic field. This follows directly from Faraday's Law,

$ nabla times bold(E) = - frac(partial bold(B), partial t) $
which states that a time-varying magnetic field induces an electric field. This field drives the free charges within the conductor, producing an induced current.
When a magnetic field line falls into a screen, the induced eddy-currents will form a closed loop around said field line.
This current's direction being such that the induced field will oppose that of the incident magnetic field, following Lenz' law.

#figure(
  image("../images/schildE.png", width: 50%),
  caption: [Eddy-current shielding principle.],
)

Magnetically conductive shields, known as flux-shunting shields, rely on the material's reluctance $cal(R)$. Materials with a high relative permeability $mu_r$ provide a low reluctance path for the magnetic field lines. This follows from
$ cal(R) = l / (mu_0 mu_r A). $

The relation between
reluctance, flux and its driving source is described by Hopkinson's law,

$ Theta = Phi cal(R), $ <eq:hopkinson>

where $Theta$ is the magnetomotive force and $Phi$ the magnetic flux. This is
the magnetic analogue of Ohm's law, with $Theta$, $Phi$ and $cal(R)$
corresponding to voltage, current and resistance, respectively.

Just as current divides over parallel resistors, the flux divides over parallel
magnetic paths. For a shield placed in the field, the flux through the air path
and through the shield path is related by

$ Phi_"shield" / Phi_"air" = cal(R)_"air" / cal(R)_"shield". $ <eq:flux-division>

Since $cal(R)_"shield" << cal(R)_"air"$ for $mu_r >> 1$, almost all flux
follows the shield: the field takes the path of least reluctance. This is observed as a deflection of the field lines into the shield material.

#figure(
  image("../images/schildM.png", width: 50%),
  caption: [Flux-shunting shielding principle.],
)
