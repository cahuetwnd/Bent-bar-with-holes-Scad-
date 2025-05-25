use <bent_bar_with_holes.scad>
// === AFFICHAGE
bend_sequence = [
  [20, 45],
  [55, -90],
  [90, -90],
  [55, 45],
  [20, 0]
];
holes = [
  [0, [10, 20], 6.01, "Z"],
  [4, [10, 20], 6.01, "Z"],
  [2, [12.5, 20], 4.01, "Z"],
  [2, [78, 20], 4.01, "Z"]
];
$fn = 30;
bent_bar(
  bend_sequence,
  holes,
  bar_width = 40,
  bar_thickness = 7,
  arc_radius = 7,
  arc_steps = 5
);