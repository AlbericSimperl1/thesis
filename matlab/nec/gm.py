#!/usr/bin/env python3
import argparse
import math


def gm2(l, phi_deg, theta_deg):
    phi_rad = math.radians(phi_deg)
    theta_rad = math.radians(theta_deg)

    # Correcte verschuiving van de TX-lus zodat de normaal-as door de RX-lus op (0,0,l) blijft snijden
    x_mov = -l * math.sin(theta_rad) * math.cos(phi_rad)
    y_mov = l * math.sin(phi_rad)
    z_mov = l * (1 - math.cos(theta_rad) * math.cos(phi_rad))

    # De 0.0000 uit je originele code is vervangen door {x_mov:.4f}
    return f"GM    0    0    {phi_deg:.4f}    {theta_deg:.4f}    0    {x_mov:.4f}    {y_mov:.4f}    {z_mov:.4f}    2"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="tx position for angles phi and theta")
    parser.add_argument(
        "-r",
        "--radius",
        type=float,
        required=True,
        help="radius or length (l)",
    )
    parser.add_argument(
        "-p",
        "--phi",
        type=float,
        required=True,
        help="angle phi in degrees (rotation about x)",
    )
    parser.add_argument(
        "-t",
        "--theta",
        type=float,
        required=True,
        help="angle theta in degrees (rotation about y)",
    )

    args = parser.parse_args()
    print(gm2(args.radius, args.phi, args.theta))
