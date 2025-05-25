// === bent_bar_with_holes.scad ===
// Librairie OpenSCAD modulaire pour modéliser une barre pliée avec perçages personnalisés

// === MODULE SEGMENT ===
module segment(len, bar_width, bar_thickness) {
    translate([0, -bar_width / 2, 0])
        cube([len, bar_width, bar_thickness]);
}

// === MODULE ARC POLYGONAL ===
module arc_bridge(angle_total, radius, width, thickness, steps) {
    angle_step = angle_total / steps;
    arc_len = radius * angle_step * PI / 180;

    for (i = [0 : steps - 1]) {
        rot = angle_step * i;
        translate([radius * sin(rot * PI / 180), 0, radius * (1 - cos(rot * PI / 180))])
            rotate([0, rot, 0])
                translate([0, -width / 2, 0])
                    cube([arc_len, width, thickness]);
    }
}

// === MODULE TROU GÉNÉRIQUE ===
// pos = [x, y] relatif au coin inférieur avant gauche du segment
module hole(d, pos, axis, bar_width, bar_thickness, len_seg) {
    if (axis == "Y") {
        translate([pos[0], 0, pos[1]])
            rotate([90, 0, 0])
                cylinder(d=d, h=bar_width + 1, center=true);
    }
    else if (axis == "Z") {
        translate([pos[0], pos[1] - bar_width / 2, -0.01])
            cylinder(d=d, h=bar_thickness + 0.02, center=false);
    }
}

// === FONCTION POUR EXTRAIRE LES TROUS CIBLÉS D'UN SEGMENT ===
function holes_for_segment(holes, index) = [ for (h = holes) if (h[0] == index) h ];

// === MODULE PRINCIPAL DE CONSTRUCTION ===
module bent_bar(sequence, holes = [], bar_width=20, bar_thickness=5, arc_radius=5, arc_steps=9) {
    bent_bar_internal(sequence, holes, bar_width, bar_thickness, arc_radius, arc_steps, 0);
}

module bent_bar_internal(seq, holes, bar_width, bar_thickness, arc_radius, arc_steps, i = 0) {
    if (i < len(seq)) {
        len_seg = seq[i][0];
        bend_angle = seq[i][1];

        union() {
            let (segment_holes = holes_for_segment(holes, i))
                if (len(segment_holes) > 0) {
                    difference() {
                        segment(len_seg, bar_width, bar_thickness);
                        for (h = segment_holes)
                            hole(h[2], h[1], h[3], bar_width, bar_thickness, len_seg);
                    }
                } else {
                    segment(len_seg, bar_width, bar_thickness);
                }

            if (bend_angle != 0 &&
                abs(bend_angle) % 90 != 0 &&
                abs(bend_angle) % 180 != 0) {
                translate([len_seg, 0, 0])
                    rotate([0, bend_angle > 0 ? 0 : 180, 0])
                        arc_bridge(abs(bend_angle), arc_radius, bar_width, bar_thickness, arc_steps);
            }

            translate([len_seg, 0, 0])
                rotate([0, bend_angle, 0])
                    bent_bar_internal(seq, holes, bar_width, bar_thickness, arc_radius, arc_steps, i + 1);
        }
    }
}
bend_sequence = [
  [30, 45],
  [40, -90],
  [30, 0]
];

holes = [
  [0, [5, 5], 2, "Z"],
  [1, [10, 0], 2, "Y"],
  [2, [5, 5], 2, "Z"]
];

bent_bar(
  bend_sequence,
  holes,
  bar_width = 25,
  bar_thickness = 4,
  arc_radius = 4,
  arc_steps = 10
);
