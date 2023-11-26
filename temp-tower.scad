/** Small temperature tower.

©2023 Neale Pickett <neale@woozle.org>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software. The software is provided "as
is", without warranty of any kind, express or implied, including but not limited
to the warranties of merchantability, fitness for a particular purpose and
noninfringement. In no event shall the authors or copyright holders be liable
for any claim, damages or other liability, whether in an action of contract,
tort or otherwise, arising from, out of or in connection with the software or
the use or other dealings in the software.

*/

/* [Main Options] */

// Temperature at the bottom
TempBase = 220; // [100:300]

// Temperature increase at each tier
TempIncrease = -10; // [-20:20]

// How many tiers
Tiers = 7;

// Print a full tower? If false, you just get two poles.
FullTower = true;

// Text to engrave on the side
SideText = "PLA";

/* [Hidden] */
PlateHeight = 0.8;
Font = "Liberation Sans:style=bold";
EngraveDepth = 0.3;
$fn = 90;

module FullTier(temperature) {
    difference() {
        cube([25, 5, 5]);
        translate([12, -1, 0]) cube([12, 10, 5 - PlateHeight]); // Inner cavity
        translate([0, 2.5, 0]) rotate([0, 45, 0]) rotate([0, 0, 90]) cube(5*sqrt(2), center=true); // Overhang
        translate([2.5, 2.5, 0.1]) cylinder(r=1, h=5); // Overhang hole
        translate([4.4, EngraveDepth, 0.8])
            rotate([90, 0, 0])
                linear_extrude(EngraveDepth + 0.1)
                    text(str(temperature), size=3.2, font=Font);
    }
    translate([22, 2.5, 0]) cylinder(r=1, h=3); // Cylinder
    translate([14, 2.5, 0]) cylinder(r1=1, r2=0.2, h=3); // Cone
    translate([5, 0.5, 0.4]) cube([6, 5, 0.2]); // Rear protrusion: y translate = protrusion depth
}

module Posts(temperature) {
    difference() {
        translate([4, 0, 0]) cube([8, 5, 5]);
        translate([4.4, EngraveDepth, 0.8])
            rotate([90, 0, 0])
                linear_extrude(EngraveDepth + 0.1)
                    text(str(temperature), size=3.2, font=Font);
    }
    translate([22, 2.5, 0]) cylinder(r=2, h=5);

}

module Tier(temperature) {
    if (FullTower) {
        FullTier(temperature);
    } else {
        Posts(temperature);
    }
}

module EngraveText(text) {
    linear_extrude(EngraveDepth + 0.1)
        text(text, size=3.2, valign="center", font=Font);
}

module Custom(text) {
    echo(str("CUSTOM##", text));
}

difference() {
    union() {
        cube([25, 5, PlateHeight]); // Floor plate
        for (tier = [0 : 1 : Tiers-1]) {
            z = PlateHeight + (5 * tier);
            temp = TempBase + (TempIncrease * tier);
            Custom(str(
                "<code print_z=\"", z, "\"",
                    " type=\"4\"",
                    " extruder=\"1\"", 
                    " color=\"\"",
                    " extra=\"M104 S", temp, "\"",
                    " gcode=\"M104 S", temp, "\"/>",
                ""
            ));
            translate([0, 0, z]) Tier(temp);
        }
    }
    if (FullTower) {
        translate([25 - EngraveDepth, 2.5, 1+PlateHeight])
            rotate([90, -90, 90])
                EngraveText(SideText);
    } else {
        translate([4 + EngraveDepth, 2.5, 1+PlateHeight])
            rotate([90, -90, -90])
                EngraveText(SideText);
    }
}
