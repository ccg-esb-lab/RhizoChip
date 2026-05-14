// -----------------------------------------------------------------------------
// RhizoChip: Modular co-culture device generator
// -----------------------------------------------------------------------------
// Parametric OpenSCAD design for modular microbial co-culture devices.
// The model includes configurable module size, well layout, lateral ports,
// fastening features, lids, and label placement.
//
// Developed by ESB / Center for Genomic Sciences, UNAM
//
// This code is released under the MIT License.
// See the LICENSE file distributed with this source code for details.
//--------------------------------------------
// PRINTING / RENDER PARAMETERS
//--------------------------------------------

render_body = false;
render_lid  = true;

gap = 0.0;
fn  = 48;

//--------------------------------------------
// ARRAY / DEVICE CONFIGURATION
//--------------------------------------------

plate_length = 119.5;

// Version: Bimodule mini (2-cols, 3 rows)
/*
N = 2;      // Number of modules
nrows = 3;  // Number of rows
ncols = 2;  // Number of columns
module_length=plate_length/2;
module_width=plate_length/4/2;
label_margin_top  = 13.5;
*/

// Version: Bimodule (2-cols, 8 rows)

N = 2;      // Number of modules
nrows = 8;  // Number of rows
ncols = 2;  // Number of columns
module_length=plate_length;
module_width=plate_length/4/2;
label_margin_top  = 20;


// Version: Multimodule (2-cols, 8 rows)
/*
N = 6;      // Number of modules
nrows = 8;  // Number of rows
ncols = 2;  // Number of columns
module_length=plate_length;
module_width=18;
label_margin_top  = 20;
*/

// Version: Multimodule mini (2-cols, 3 rows)
/*
N = 4;      // Number of modules
nrows = 5;  // Number of rows
ncols = 2;  // Number of columns
module_length=18.4*4;
module_width=18.4;
label_margin_top  = 10;
*/

//--------------------------------------------
// MODULE DIMENSIONS
//--------------------------------------------


module_h   = 10;   // Body height (mm)
lid_h     = 3;    // Lid height (mm)
bottom_th = 1.2;  // Solid bottom thickness (mm)

//--------------------------------------------
// WELL GRID
//--------------------------------------------

pitch_x = 9.0;  // Well pitch along X (mm)
pitch_y = 9.0;  // Well pitch along Y (mm)

//--------------------------------------------
// WELL GEOMETRY
//--------------------------------------------

well_d = 6.6;       // Well diameter (mm)
well_r = well_d/2;  // Well radius (mm)

label_margin_left = 3.5;

//--------------------------------------------
// HARDWARE GEOMETRY
//--------------------------------------------

r_oring = 0.6;   // O-ring radius (mm)
r_screw = 1.55;  // Vertical screw hole radius (mm)
r_rod   = 2.55;  // Horizontal rod radius (mm)

h_bolt        = 12.5;   // Bolt head recess height (mm)
h_bolt_bottom = -0.01;  // Bottom bolt recess height (mm)
r_bolt_bottom = 3.2;    // Bottom bolt-hole radius (mm)

d_rod      = 8.0;   // Rod offset from edge (mm)
r_rod_bolt = 4.55;  // Rod bolt radius (mm)


//--------------------------------------------
// ROUNDING / CORNER GEOMETRY
//--------------------------------------------

corner_r = 14.75;
box_padding = 20.0;
diameter_round = (module_length + box_padding) / 3.372;
corner_d       = (module_length + box_padding) / 3.372;

//--------------------------------------------
// DEFAULT ALIASES FOR MODULE PARAMETERS
//--------------------------------------------

default_gap      = gap;
default_fn       = fn;

default_corner_d = corner_d;
default_corner_r = corner_r;

// DEFAULT HARDWARE PARAMETERS
default_r_rod     = r_rod;
default_d_rod     = d_rod;
default_r_bolt    = r_bolt_bottom;
default_h_bolt    = h_bolt;
default_r_screw   = r_screw;

default_slop      = 2;
default_fn_bolt   = 6;

// DEFAULT WELL GRID PARAMETERS
default_rows      = nrows;
default_cols      = ncols;
default_pitch_x   = pitch_x;
default_pitch_y   = pitch_y;
default_r_well    = well_r;
default_bottom_th = bottom_th;
default_lid_depth = 1;

// DEFAULT LABEL PARAMETERS
default_label_font  = "Liberation Sans";
default_label_size  = 0.5 * default_pitch_y;
default_label_depth = 0.6;
default_margin_left = label_margin_left; 
default_label_margin_top  = label_margin_top;

//--------------------------------------------
// MODEL ASSEMBLY
//--------------------------------------------

if (render_body) {

    stack_modules_with_cuts(
        n         = N,
        L         = module_width,
        W         = module_length,
        H         = module_h,
        gap       = default_gap,
        total_len = undef,

        corner_d  = default_corner_d,
        corner_r  = default_corner_r,

        // Subtractive features enabled for the body.
        cut_rods     = true,
        cut_vertical = true,
        cut_wells    = true,
        cut_lateral  = true,

        r_rod = default_r_rod,
        d_rod = default_d_rod,

        r_bolt = default_r_bolt,
        h_bolt = default_h_bolt,

        r_screw = default_r_screw,

        y_offsets = [
            0,
            module_length/2 - 7,
            -module_length/2 + 7
        ],

        rows    = default_rows,
        cols    = default_cols,
        pitch_x = default_pitch_x,
        pitch_y = default_pitch_y,

        r_well    = default_r_well,
        bottom_th = default_bottom_th,

        lateral_side = "both"
    );
}


if (render_lid) {

    translate([0, 0, module_h - lid_h + 10]) {

        stack_modules_with_cuts(
            n         = N,
            L         = module_width,
            W         = module_length,
            H         = lid_h,
            gap       = default_gap,
            total_len = undef,

            corner_d  = default_corner_d,
            corner_r  = default_corner_r,

            // Subtractive features enabled for the lid.
            cut_rods     = false,
            cut_vertical = true,
            cut_wells    = true,
            cut_lateral  = false,

            lid        = true,
            cut_labels = true,
            start_col  = 1,

            r_rod = default_r_rod,
            d_rod = default_d_rod,

            r_bolt = default_r_bolt,
            h_bolt = default_h_bolt,

            r_screw = default_r_screw,

            rows    = default_rows,
            cols    = default_cols,
            pitch_x = default_pitch_x,
            pitch_y = default_pitch_y,

            r_well    = default_r_well,
            bottom_th = -1,

            lateral_side = "both",

            label_font  = default_label_font,
            label_size  = default_label_size,
            label_depth = default_label_depth,

            margin_left = default_margin_left,
            label_margin_top  = default_label_margin_top
        );
    }
}


//--------------------------------------------
// GEOMETRY HELPERS
//--------------------------------------------

// Torus using rotate_extrude.
// R: major radius; r: tube radius.
module torus(R = 30, r = 10, $fn = 20) {
    if (R <= r) {
        echo("Warning: Use R > r to avoid self-intersection.");
    }

    rotate_extrude($fn = $fn)
        translate([R, 0, 0])
            circle(r = r, $fn = $fn);
}

// Shift wells so the edge nearest the flat side is half a pitch from the edge.
// round_side: "left", "right", or "none".
function well_shift_half_pitch(L, cols, pitch_x, r_well, round_side) =
    let(
        grid_w     = (cols - 1)*pitch_x + 2*r_well,
        x0         = -grid_w/2 + r_well,
        x_last     = x0 + (cols - 1)*pitch_x,
        want_left  = -L/2 + pitch_x/2,
        want_right =  L/2 - pitch_x/2,
        s_left     = want_left - x0,
        s_right    = want_right - x_last
    )
    (round_side == "right") ? s_left :
    (round_side == "left")  ? s_right :
                               (s_left + s_right)/2;

// Shift used for each slice in the stacked assembly.
function dx_for_slice(side, L, cols_i, pitch_x, r_well) =
    let(
        grid_w = (cols_i - 1)*pitch_x + 2*r_well,
        x0     = -grid_w/2 + r_well,
        xlast  = x0 + (cols_i - 1)*pitch_x
    )
    (side == "right") ? (-L/2 + pitch_x/2 - x0) :
    (side == "left")  ? ( L/2 - pitch_x/2 - xlast) :
                         0;


//--------------------------------------------
// MODULE BODY
//--------------------------------------------

// L, W, H in mm.
// round_side: "none", "left", or "right".
module module_body(
    L,
    W,
    H,
    corner_d   = 0,
    corner_r   = 0,
    round_side = "none",
    fn         = fn
) {
    plate_padding = 0;

    d = min(corner_d, min(L, W) - 0.1);
    r = corner_r;

    module _slab(x, y, z) {
        cube([x, y, z], center = true);
    }

    module _bridge_right() {
        band = max(W - 2*r, 0);

        if (band > 0) {
            translate([L/2 - r/2, 0, 0])
                _slab(r, band + plate_padding, H);
        }
    }

    module _bridge_left() {
        band = max(W - 2*r, 0);

        if (band > 0) {
            translate([-L/2 + r/2, 0, 0])
                _slab(r, band + plate_padding, H);
        }
    }

    if (d <= 0 || round_side == "none") {
        _slab(L, W + plate_padding, H);

    } else if (round_side == "right") {
        union() {
            translate([-r/2, 0, 0])
                _slab(L - r, W + plate_padding, H);

            translate([L/2 - r, (W + plate_padding)/2 - r, 0]) {
                intersection() {
                    cylinder(h = H, r = r, center = true, $fn = fn);
                    translate([0, 0, -H/2])
                        cube([2*r, 2*r, H]);
                }
            }

            translate([L/2 - r, -(W + plate_padding)/2 + r, 0]) {
                intersection() {
                    cylinder(h = H, r = r, center = true, $fn = fn);
                    translate([0, -2*r, -H/2])
                        cube([2*r, 2*r, H]);
                }
            }

            _bridge_right();
        }

    } else if (round_side == "left") {
        union() {
            translate([r/2, 0, 0])
                _slab(L - r, W + plate_padding, H);

            translate([-L/2 + r, (W + plate_padding)/2 - r, 0]) {
                intersection() {
                    cylinder(h = H, r = r, center = true, $fn = fn);
                    translate([-2*r, 0, -H/2])
                        cube([2*r, 2*r, H]);
                }
            }

            translate([-L/2 + r, -(W + plate_padding)/2 + r, 0]) {
                intersection() {
                    cylinder(h = H, r = r, center = true, $fn = fn);
                    translate([-2*r, -2*r, -H/2])
                        cube([2*r, 2*r, H]);
                }
            }

            _bridge_left();
        }
    }
}


//--------------------------------------------
// HORIZONTAL ROD CUTS
//--------------------------------------------

// Cylindrical pass-through cuts for horizontal rods along X.
// Optional bolt recesses are added only on rounded module edges.
// round_side: "none", "left", "right", or "both".
module horizontal_rod_cuts(
    L,
    W,
    H,
    r_rod,
    d_rod,
    h_bolt    = 0.5,
    slop      = 1,
    round_side = "none"
) {
    y_top =  W/2 - d_rod;
    y_bot = -W/2 + d_rod;

    do_left  = (round_side == "left"  || round_side == "both");
    do_right = (round_side == "right" || round_side == "both");

    rotate([0, 90, 0]) {
        translate([-H/2, y_top, -L/2 - slop])
            cylinder(h = L + 2*slop, r = r_rod, $fn = fn);

        translate([-H/2, y_bot, -L/2 - slop])
            cylinder(h = L + 2*slop, r = r_rod, $fn = fn);
    }

    if (do_left) {
        for (ypos = [y_bot, y_top]) {
            translate([-L/2 - slop, ypos, H/2])
                rotate([0, 90, 0])
                    rotate([0, 0, 90])
                        cylinder(
                            h   = h_bolt + slop,
                            r   = r_rod_bolt,
                            $fn = 6
                        );
        }
    }

    if (do_right) {
        for (ypos = [y_bot, y_top]) {
            translate([L/2 - h_bolt, ypos, H/2])
                rotate([0, 90, 0])
                    cylinder(
                        h   = h_bolt + slop,
                        r   = r_rod_bolt,
                        $fn = 80
                    );
        }
    }
}



//--------------------------------------------
// VERTICAL SCREW CUTS ALONG CENTERLINE
//--------------------------------------------

// Z-axis screw cuts along a module centerline.
// x_center: X coordinate of the screw centerline.
module vertical_screw_cuts_centerline(
    L,
    W,
    H,
    rows,
    pitch_x,
    pitch_y,
    r_screw  = default_r_screw,
    x_center = 0,
    r_bolt   = default_r_bolt,
    h_bolt   = default_h_bolt,
    slop     = default_slop,
    fn_bolt  = default_fn_bolt,
    lid      = false
) {
    y0 = -((rows - 1) * pitch_y) / 2;

    y_out_bottom = y0 - pitch_y/2;
    y_out_top    = y0 + (rows - 1)*pitch_y + pitch_y/2;

    module _zscrew_at(ypos) {
        translate([x_center, ypos, -H/2 - slop])
            cylinder(
                h   = H + 2*slop,
                r   = r_screw,
                $fn = fn
            );
    }

    module _bolt_recess_at(ypos, h_bottom) {
        translate([x_center, ypos, h_bottom])
            cylinder(
                h   = h_bolt + 0.02,
                r   = r_bolt_bottom,
                $fn = fn_bolt
            );
    }

    module _screw_with_recess_at(ypos) {
        _zscrew_at(ypos);

        if (lid) {
            _bolt_recess_at(ypos, 0);
        } else {
            _bolt_recess_at(ypos, -H/2 - 0.01);
        }
    }

    _screw_with_recess_at(y_out_bottom);

    for (j = [0 : 1 : rows - 1]) {
        y_mid = y0 + j*pitch_y + pitch_y/2;
        _screw_with_recess_at(y_mid);
    }

    _screw_with_recess_at(y_out_top);
}


//--------------------------------------------
// LATERAL WELL CUTS
//--------------------------------------------

// Lateral cuts connecting well centers to the side-face lid plane.
// Assumes two well columns centered at x_offset ± pitch_x/2.
// side: "left", "right", or "both".
// round_side: "none", "left", or "right".
module lateral_well_cuts(
    L,
    W,
    H,
    rows,
    pitch_y,
    r_well,
    pitch_x,
    x_offset   = 0,
    side       = "both",
    round_side = "none",
    lid_depth  = 1,
    slop       = 0.2
) {
    do_left  = (side == "left"  || side == "both") && (round_side != "left");
    do_right = (side == "right" || side == "both") && (round_side != "right");

    d1 = (round_side == "right") ? 0 :
         (round_side == "left")  ? 0 :
         (do_right)              ? 1 :
         (do_left)               ? 1 :
                                    0;

    grid_h = (rows - 1)*pitch_y + 2*r_well;
    y0     = -grid_h/2 + r_well;

    x_left_well  = x_offset - pitch_x/2;
    x_right_well = x_offset + pitch_x/2;

    depth_left_main  = max((L/2 + x_left_well) - lid_depth, 0);
    depth_right_main = max((L/2 - lid_depth) - x_right_well, 0);

    for (j = [0 : rows - 1]) {
        y = y0 + j*pitch_y;

        if (do_left) {
            rotate([0, 90, 0])
                translate([0, y, -d1 - L/2 + lid_depth - slop])
                    cylinder(
                        h   = depth_left_main + 2*slop,
                        r   = r_well,
                        $fn = fn
                    );

            if (lid_depth > 0) {
                rotate([0, 90, 0])
                    translate([0, y, -d1 - L/2 - slop + 2*r_oring])
                        torus(
                            R   = well_r,
                            r   = r_oring,
                            $fn = fn
                        );
            }
        }

        if (do_right) {
            rotate([0, 90, 0])
                translate([0, y, d1 + x_right_well - slop])
                    cylinder(
                        h   = depth_right_main + 2*slop,
                        r   = r_well,
                        $fn = fn
                    );

            if (lid_depth > 0) {
                rotate([0, 90, 0])
                    translate([0, y, d1 + L/2 - (lid_depth + 2*slop) + r_oring/2])
                        torus(
                            R   = well_r,
                            r   = r_oring,
                            $fn = fn
                        );
            }
        }
    }
}


//--------------------------------------------
// WELL CUTS
//--------------------------------------------

// Vertical well bores on a centered grid.
// For rounded modules, the outermost well column can be skipped on the rounded side.
// round_side: "", "left", or "right".
module well_cuts(
    L,
    W,
    H,
    rows,
    cols,
    pitch_x,
    pitch_y,
    r_well,
    bottom_th,
    slop      = 0.1,
    lid_depth = 1,
    lid       = false,
    round_side = ""
) {
    grid_w = (cols - 1)*pitch_x + 2*r_well;
    grid_h = (rows - 1)*pitch_y + 2*r_well;

    x0 = -grid_w/2 + r_well;
    y0 = -grid_h/2 + r_well;

    depth = max(H - bottom_th, 0);

    for (i = [0 : cols - 1]) {
        skip_col =
            (i == cols - 1 && round_side == "right") ||
            (i == 0        && round_side == "left");

        if (!skip_col) {
            for (j = [0 : rows - 1]) {
                x = x0 + i*pitch_x;
                y = y0 + j*pitch_y;

                translate([x, y, H/2 - depth - slop])
                    cylinder(
                        h   = depth + 2*slop,
                        r   = r_well,
                        $fn = 80
                    );

                if (!lid && lid_depth > 0) {
                    translate([x, y, 2*r_oring + H/2 - lid_depth - slop])
                        torus(
                            R   = well_r,
                            r   = r_oring,
                            $fn = fn
                        );
                }
            }
        }
    }
}


//--------------------------------------------
// MODULE WITH CUTS
//--------------------------------------------

// Base module with optional subtractive features.
module module_with_cuts(
    L,
    W,
    H,
    corner_d   = default_corner_d,
    corner_r   = default_corner_r,
    round_side = "none",

    // Feature toggles.
    cut_rods            = false,
    cut_wells           = false,
    cut_lateral         = false,
    cut_vertical_edges  = false,
    cut_vertical_center = false,
    cut_labels          = false,
    lid                 = false,

    // Rods and bolt recesses.
    r_rod  = default_r_rod,
    d_rod  = default_d_rod,
    r_bolt = default_r_bolt,
    h_bolt = default_h_bolt,

    // Screws.
    r_screw = default_r_screw,

    // Well grid.
    rows      = default_rows,
    cols      = default_cols,
    pitch_x   = default_pitch_x,
    pitch_y   = default_pitch_y,
    r_well    = default_r_well,
    bottom_th = default_bottom_th,

    // Lateral ports.
    lateral_side = "both",
    lid_depth    = default_lid_depth,

    // Labels.
    x_offset    = 0,
    show_rows   = true,
    start_col   = 1,
    label_font  = default_label_font,
    label_size  = default_label_size,
    label_depth = default_label_depth,
    margin_left = default_margin_left,
    label_margin_top  = default_label_margin_top,

    fn_bolt = default_fn_bolt,
    fn      = default_fn
) {
    difference() {
        module_body(
            L,
            W,
            H,
            corner_d   = corner_d,
            corner_r   = corner_r,
            round_side = round_side,
            fn         = fn
        );

        grid_w = (cols - 1)*pitch_x + 2*r_well;
        x0     = -grid_w/2 + r_well;
        xlast  = x0 + (cols - 1)*pitch_x;

        dx = (round_side == "right") ? (-L/2 + pitch_x/2 - x0) :
             (round_side == "left")  ? ( L/2 - pitch_x/2 - xlast) :
                                        0;

        d1 = (round_side == "right") ? -1 :
             (round_side == "left")  ?  1 :
                                         0;

        if (cut_rods && !lid) {
            translate([0, 0, -H/2])
                horizontal_rod_cuts(
                    L,
                    W,
                    H,
                    r_rod,
                    d_rod,
                    h_bolt    = h_bolt,
                    round_side = round_side
                );
        }

        if (cut_wells) {
            translate([dx, 0, 0])
                well_cuts(
                    L,
                    W,
                    H,
                    rows,
                    cols,
                    pitch_x,
                    pitch_y,
                    r_well,
                    bottom_th  = bottom_th,
                    lid_depth  = 1,
                    lid        = lid,
                    round_side = round_side
                );
        }

        if (cut_vertical_center) {
            translate([dx, 0, 0])
                vertical_screw_cuts_centerline(
                    L,
                    W,
                    H,
                    rows     = rows,
                    pitch_x  = pitch_x,
                    pitch_y  = pitch_y,
                    r_screw  = r_screw,
                    x_center = 0,
                    h_bolt   = h_bolt_bottom,
                    fn_bolt  = lid ? fn : 6,
                    lid      = lid
                );
        }

        if (cut_lateral && !lid) {
            translate([d1, 0, 0])
                lateral_well_cuts(
                    L,
                    W,
                    H,
                    rows       = rows,
                    pitch_y    = pitch_y,
                    r_well     = r_well,
                    pitch_x    = pitch_x,
                    x_offset   = dx,
                    side       = lateral_side,
                    round_side = round_side,
                    lid_depth  = lid_depth
                );
        }

        if (cut_labels) {
            well_label_marks(
                L,
                W,
                lid_h,
                rows,
                cols,
                pitch_x,
                pitch_y,
                r_well,
                x_offset    = x_offset,
                show_rows   = show_rows,
                start_col   = start_col,
                font        = label_font,
                size        = label_size,
                depth       = label_depth,
                margin_left = margin_left,
                label_margin_top  = label_margin_top
            );
        }

        if ($children > 0) {
            children();
        }
    }
}


//--------------------------------------------
// STACKED MODULE ASSEMBLY
//--------------------------------------------

// Places n modules in a linear stack along X.
// End modules receive rounded sides.
module stack_modules_with_cuts(
    n,
    L,
    W,
    H,
    gap       = default_gap,
    total_len = undef,

    corner_d = default_corner_d,
    corner_r = default_corner_r,

    // Feature toggles.
    cut_rods     = false,
    cut_vertical = false,
    cut_wells    = false,
    cut_lateral  = false,

    lid        = false,
    cut_labels = false,

    // Rods and bolts.
    r_rod  = default_r_rod,
    d_rod  = default_d_rod,
    r_bolt = default_r_bolt,
    h_bolt = default_h_bolt,

    // Screws.
    r_screw  = default_r_screw,
    y_offsets = [],

    // Well grid.
    rows      = default_rows,
    cols      = default_cols,
    pitch_x   = default_pitch_x,
    pitch_y   = default_pitch_y,
    r_well    = default_r_well,
    bottom_th = default_bottom_th,

    // Lateral ports.
    lateral_side = "both",

    // Labels.
    start_col   = 1,
    label_font  = default_label_font,
    label_size  = default_label_size,
    label_depth = default_label_depth,
    margin_left = default_margin_left,
    label_margin_top  = default_label_margin_top
) {
    g = is_undef(total_len)
        ? gap
        : max(0, (total_len - n*L) / max(1, n - 1));

    span = n*L + (n - 1)*g;

    translate([-span/2 + L/2, 0, 0]) {
        for (i = [0 : n - 1]) {
            side = (i == 0)     ? "left"  :
                   (i == n - 1) ? "right" :
                                  "none";

            dx = dx_for_slice(side, L, cols, pitch_x, r_well);

            start_i        = start_col + i*cols;
            show_rows_here = lid && cut_labels && (i == 0);

            translate([i*(L + g), 0, 0]) {
                module_with_cuts(
                    L,
                    W,
                    H,
                    corner_d   = corner_d,
                    corner_r   = corner_r,
                    round_side = side,

                    cut_rods            = cut_rods,
                    cut_wells           = cut_wells,
                    cut_lateral         = cut_lateral,
                    cut_vertical_edges  = cut_vertical,
                    cut_vertical_center = cut_vertical,

                    r_rod  = r_rod,
                    d_rod  = d_rod,
                    r_bolt = r_bolt,
                    h_bolt = h_bolt,

                    r_screw = r_screw,
                    lid     = lid,

                    rows      = rows,
                    cols      = cols,
                    pitch_x   = pitch_x,
                    pitch_y   = pitch_y,
                    r_well    = r_well,
                    bottom_th = bottom_th,

                    lateral_side = lateral_side,

                    fn = fn
                );

                if (lid && cut_labels) {
                    grid_w = (cols - 1)*pitch_x + 2*r_well;
                    grid_h = (rows - 1)*pitch_y + 2*r_well;

                    x0 = -grid_w/2 + r_well + dx;
                    y0 = -grid_h/2 + r_well;

                    eps      = 0.01;
                    z_rel    = H/2 + eps;
                    h_relief = label_depth;

                    if (show_rows_here) {
                        x_left = -L/2 + margin_left;

                        for (j = [0 : rows - 1]) {
                            y = y0 + j*pitch_y;

                            translate([x_left, y, z_rel])
                                linear_extrude(height = h_relief)
                                    text(
                                        text   = chr(65 + (rows - 1 - j)),
                                        size   = label_size,
                                        font   = label_font,
                                        halign = "center",
                                        valign = "center"
                                    );
                        }
                    }

                    y_top = W/2 - label_margin_top;

                    let(
                        col0 = (side == "left")  ? 1      : 0,
                        colN = (side == "right") ? cols-2 : cols-1
                    ) {
                        for (c = [col0 : colN]) {
                            x = x0 + c*pitch_x;

                            translate([x, y_top, z_rel])
                                linear_extrude(height = h_relief)
                                    text(
                                        text   = str(start_i + c - 1),
                                        size   = label_size,
                                        font   = label_font,
                                        halign = "center",
                                        valign = "center"
                                    );
                        }
                    }
                }
            }
        }
    }
}
