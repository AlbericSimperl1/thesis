= Introduction


== What is shielding?
Electromagnetic shielding is a means of improving electromagnetic compatibility (EMC) using an electromagnetic (EM) shield. Using this shield, it is possible to reduce the electromagnetic field intensity within a prescribed region @celozziBOEK. A shield's effectiveness is denoted by its shielding effectiveness (SE), defined as the ratio of the field at a point of observation without and with the shield in place,

$ "SE" = 20 log_10 lr(|frac(bold(F)_("open"), bold(F)_("closed"))|)," [dB]", $ <eq:se-def>

where $bold(F)$ stands for either the electric or the magnetic field. For the magnetic problem considered in this work this becomes

$ "SE"_H = 20 log_10 lr(|frac(H_("open"), H_("closed"))|)," [dB]". $ <eq:se-h>

Depending on the material used, a shield can reflect, absorb or redirect the incident field. Shielding is used whenever a field source and a sensitive region must be isolated from each other.
In military settings it can be used to guarantee communication security, protecting sensitive information transmitted using electromagnetic waves.
Medical use cases are found in the isolation of MRI and ECG/EEG units, which need to be strictly enclosed.
Furthermore, active implanted medical devices like pacemakers and cardioverters require an enclosure which protects these sensitive detection circuits.
Although shielding is used in virtually any field, and whether this happens through immunity, emission control, privacy or even human safety, the objective is always ensuring EMC.

== Low-frequency magnetic shielding
Not every field is equally easy to shield. At high frequencies, or far away from the source, the incident field behaves as a plane wave, in this case a thin metal sheet already provides a large attenuation. At low frequencies the situation is different. Sources such as transformers, motors and power cables produce a magnetic field that changes slowly in time, and the objects that need protection are usually located close to them. The shield is then placed in the near field of the source.

In the near field of a current loop, the magnetic field dominates over the electric field. Such a source is called a low-impedance source. It is precisely this type of field that is hardest to stop, a metal sheet reflects almost nothing of it, and at low frequencies the sheet is often thinner than the depth the field reaches. A shield that blocks an electric field almost completely can let a large part of a low-frequency magnetic field pass. For this reason the low-frequency, low-impedance case is regarded as the worst case. Which is why it is the case that measurement standards use to qualify shielded rooms and enclosures.

These standards prescribe two loop antennas, a transmitting (TX) and a receiving (RX) loop, placed on either side of the shield. NSA 65-6 @nsa656 places both loops on a common axis perpendicular to the shield (the coaxial configuration), while MIL-STD-285 @milstd285 and its successor IEEE Std 299 @ieee299 place them in a plane perpendicular to the shield (the coplanar configuration). The SE is obtained as the drop in the voltage induced in the RX loop when the shield is introduced. Because the RX loop has a finite size, this measured value is an average of the field over the loop area rather than the local field ratio of @eq:se-h. The SE that is measured and the SE that is defined are thus not the same quantity, and the difference depends on the dimensions of both loops and on their distance to the shield.

== Problem statement and objective
Predicting the SE of a planar screen in this configuration is not straightforward. The field of a loop close to a shield is not uniform, so the shield is not illuminated by a single wave but by a distribution that depends on the loop radius and on the setup geometry. The exact solutions that exist take the form of integrals over Bessel functions, which give little direct insight in how each parameter influences the result, and the published results do not fully agree on how the SE depends on the distance between the loops.

This thesis develops and evaluates an analytical formulation for the magnetic SE of an infinite planar screen under near-field conditions, excited by finite loop antennas, within the quasi-static regime. The infinite planar screen is the reference geometry of both the literature and the standards, as it isolates the shielding mechanism from the effect of seams, apertures and edges. The aim is a model in which the influence of the shield thickness, conductivity and permeability, the loop radius and the spacing can be read directly, validated against the exact solutions in the literature.

@sec:physics introduces the physics behind near-field magnetic shielding. @sec:literature reviews the existing analytical formulations together with the expression for the SE that each provides, and identifies the open points that this work addresses.
