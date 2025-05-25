# `bent_bar_with_holes.scad`

OpenSCAD library for modeling bent bars in the XZ plane with customizable drill holes along the X, Y, or Z axes.

---

## 📌 Features

* Compose a bar using a sequence of straight and bent segments
* Insert polygonal arcs at non-standard bend angles
* Define drill holes per segment using local XY references
* Parameterize width, thickness, bend radius, and arc resolution

---

## 📐 Usage

```scad
use <bent_bar_with_holes.scad>;

bend_sequence = [
  [30, 45],
  [40, -90],
  [30, 0]
];

holes = [
  [0, [5, 5], 2, "Z"],
  [1, [10, 0], 2, "Y"],
  [2, [15, 2], 2, "X"]
];

bent_bar(
  bend_sequence,
  holes,
  bar_width = 25,
  bar_thickness = 4,
  arc_radius = 4,
  arc_steps = 10
);
```

---

## 🔧 Parameters

### `bent_bar(sequence, holes=[], bar_width=20, bar_thickness=5, arc_radius=5, arc_steps=9)`

* `sequence`: list of `[length, angle]` segments (angle in XZ plane)
* `holes`: list of holes as `[segment_index, [x, y], diameter, axis]`
* `bar_width`: width of the bar (Y direction)
* `bar_thickness`: thickness of the bar (Z direction)
* `arc_radius`: radius used for simulated bends
* `arc_steps`: number of facets for polygonal arc

---

## 🧱 Module Details

### `segment(len, bar_width, bar_thickness)`

Draws a straight segment centered in Y.

### `arc_bridge(angle, radius, width, thickness, steps)`

Approximates a bend using stacked rotated cubes in XZ.

### `hole(d, pos, axis, bar_width, bar_thickness, len_seg)`

* `axis = "Y"`: drill across width
* `axis = "Z"`: drill vertically through thickness

### `holes_for_segment(holes, index)`

Returns all holes for the given segment index.

---

## 🗺 Coordinate System

* `[x, y]` is local to the segment before rotation
* Origin is the **bottom front-left** corner of the segment

---

## 🚧 Limitations

* No drills on "X" axis
* No flattening or layout view
* No text labels or dimensions
* No export to CSV/DXF for hole list

---
