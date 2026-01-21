// ==============================================================================
// PROJECT: MODULAR UDSLA (High-Precision Optical Bench)
// AUTHOR: Seattle Data Recovery (Prototype Lab)
// DATE: 2026-01-20
//
// OPTICAL THEORY:
// Path: Primary Lens -> Aerial Image -> Microscope Obj -> Infinity Space -> Tube Lens -> Sensor
// Precision: <0.1mm alignment required for Nitrogen Gap stability.
// ==============================================================================

$fn = 120; // Master resolution for rendering

// ==============================================================================
// 1. OPTICAL PARAMETERS (INPUT YOUR EXACT LENS SPECS HERE)
// ==============================================================================

// --- Primary Collector (Telescope Lens) ---
primary_diam = 120;          // Aperture (mm)
primary_focal_len = 900;     // f/7.5 (Common for 120mm APO Triplet)
lens_edge_thick = 12;        // Thickness of the glass edge

// --- Secondary Magnifier (Microscope Objective) ---
// Based on Mitutoyo M Plan Apo 5x/10x Specs
micro_obj_thread = 26;       // M26 x 0.706 (Mitutoyo Standard)
micro_obj_length = 45;       // Physical length of objective body
micro_working_dist = 34;     // WD: Distance from tip to Aerial Image (Mitutoyo 5x is ~34mm)
micro_parfocal_len = 95;     // Parfocal distance

// --- Tube Lens (Focusing Element) ---
// Required to focus the infinity beam onto the sensor
tube_lens_focal_len = 200;   // Standard for Mitutoyo (MT-1, ITL200)
tube_lens_diam = 30;

// --- Camera (Canon EOS R5 Mark II) ---
sensor_flange_dist = 20;     // Canon RF Mount Flange Distance (approx 20mm)
sensor_width = 36;           // Full Frame width
sensor_height = 24;

// --- Chassis & Pressure ---
wall_thick = 5;              // Grade 5 Titanium (for 2.0 ATM)
nitrogen_gap_OD = primary_diam + (wall_thick * 4); 

// ==============================================================================
// 2. CALCULATED DIMENSIONS (DO NOT EDIT - AUTO-ALIGNMENT)
// ==============================================================================

// The "Aerial Image" forms exactly at primary_focal_len from the main lens.
aerial_image_pos = primary_focal_len;

// The Microscope Objective Tip must be placed 'Working Distance' AFTER the Aerial Image?
// NO. For an eyepiece/magnifier, it looks AT the aerial image.
// Distance from Primary Lens to Microscope Objective Tip = (Primary_Focal_Length + Working_Distance)
// Wait... if it's an objective, the "Object" (Aerial Image) is at WD in front of it.
// So, Objective Tip Position = Aerial_Image_Pos + Micro_Working_Dist.
obj_mount_pos = aerial_image_pos + micro_working_dist; 

// The Tube Lens is placed after the Objective (in the infinity space).
// Let's place it 50mm behind the objective mount for the Nitrogen Gap.
tube_lens_pos = obj_mount_pos + micro_obj_length + 40; 

// The Sensor is placed exactly at Tube_Lens_Focal_Length behind the Tube Lens.
sensor_plane_pos = tube_lens_pos + tube_lens_focal_len;

// Total Chassis Length
total_system_len = sensor_plane_pos + 10;

echo(">>> OPTICAL ALIGNMENT REPORT <<<");
echo("Primary Lens Position: 0mm");
echo("Aerial Image Forms at: ", aerial_image_pos, "mm");
echo("Microscope Objective Tip at: ", obj_mount_pos - micro_working_dist, "mm (Should match Aerial)");
echo("Tube Lens Position: ", tube_lens_pos, "mm");
echo("Sensor Plane (Focal Plane): ", sensor_plane_pos, "mm");
echo("Total Tube Length: ", total_system_len, "mm");


// ==============================================================================
// 3. GEOMETRY MODULES
// ==============================================================================

module primary_cell() {
    difference() {
        color("silver")
        cylinder(h=60, d=nitrogen_gap_OD);
        
        // Lens Cutout
        translate([0,0,-1])
        cylinder(h=62, d=primary_diam);
    }
    // The Glass (Visual)
    translate([0,0,10]) color("cyan", 0.3) cylinder(h=lens_edge_thick, d=primary_diam);
}

module main_baffle_tube() {
    // The main tube holding the Nitrogen pressure
    // Features internal baffles to kill stray light (critical for deep space)
    
    length = obj_mount_pos - 40; // Stop before the objective mount
    
    difference() {
        color("dimgray")
        cylinder(h=length, d=nitrogen_gap_OD);
        
        // Hollow interior
        translate([0,0,-1])
        cylinder(h=length+2, d=primary_diam + 5);
    }
    
    // Internal Baffles (Knife-edge)
    for(i = [100 : 100 : length-50]) {
        translate([0,0,i])
        color("black")
        difference() {
            cylinder(h=2, d=primary_diam + 4);
            translate([0,0,-1])
            cylinder(h=4, d=primary_diam - 10); // Aperture constricts slightly
        }
    }
}

module microscope_stage_block() {
    // This heavy block holds the Microscope Objective and seals the pressure
    translate([0,0,obj_mount_pos])
    union() {
        difference() {
            color("gold") // Titanium/Brass Interface
            cylinder(h=40, d=nitrogen_gap_OD);
            
            // Hole for Objective Thread
            translate([0,0,-1])
            cylinder(h=42, d=micro_obj_thread); // M26 Thread
        }
        
        // The Objective Lens (Visual)
        translate([0,0,5])
        color("silver")
        cylinder(h=micro_obj_length, d=24);
    }
}

module tube_lens_assembly() {
    // Holds the ITL200 Tube Lens
    translate([0,0,tube_lens_pos])
    difference() {
        color("darkslategray")
        cylinder(h=20, d=nitrogen_gap_OD * 0.6);
        
        translate([0,0,-1])
        cylinder(h=22, d=tube_lens_diam);
    }
    // Glass
    translate([0,0,tube_lens_pos+5]) color("cyan", 0.4) cylinder(h=5, d=tube_lens_diam);
}

module rear_camera_mount() {
    // Canon RF Mount Interface
    // Positioned so the sensor plane lands exactly at 'sensor_plane_pos'
    // Camera flange is 'sensor_flange_dist' in front of sensor.
    
    mount_face_pos = sensor_plane_pos - sensor_flange_dist;
    
    translate([0,0, tube_lens_pos + 10]) // Connects from tube lens
    difference() {
        color("red")
        cylinder(h=mount_face_pos - (tube_lens_pos + 10), d1=nitrogen_gap_OD*0.6, d2=54); // Taper to Canon mount
        
        translate([0,0,-1])
        cylinder(h=1000, d=40); // Light path
    }
    
    // The Flange Ring
    translate([0,0,mount_face_pos - 5])
    color("silver")
    difference() {
        cylinder(h=5, d=60);
        translate([0,0,-1])
        cylinder(h=7, d=54);
    }
}

module samsung_s25_controller() {
    // Mounted on the side for pressure control
    translate([nitrogen_gap_OD/2, 0, obj_mount_pos])
    rotate([0,90,0])
    color("black")
    cube([160, 75, 8], center=true); // Approx phone dims
}

// ==============================================================================
// 4. FINAL ASSEMBLY
// ==============================================================================

union() {
    primary_cell();
    main_baffle_tube();
    microscope_stage_block();
    tube_lens_assembly();
    rear_camera_mount();
    samsung_s25_controller();
}

// --- VISUALIZATION AIDS ---
// Aerial Image Plane (Ghost)
translate([0,0,aerial_image_pos]) 
    color("red", 0.2) cylinder(h=0.5, d=primary_diam);

// Sensor Plane (Ghost)
translate([0,0,sensor_plane_pos]) 
    color("green", 0.5) cube([sensor_width, sensor_height, 1], center=true);

// Ray Tracing Lines (Visual only)
color("yellow")
for(r = [0:45:360]) {
    rotate([0,0,r]) {
        // Primary to Aerial
        polygon([[primary_diam/2, 0], [0, aerial_image_pos], [-primary_diam/2, 0]]);
        // Infinity Space (Parallel)
        translate([0,0,obj_mount_pos + micro_obj_length])
            cube([2, 0.5, tube_lens_pos - (obj_mount_pos + micro_obj_length)]);
    }
}
