// UDSLA Modular Design - "The Hofstad Prototype"
// Specs: 120mm Primary, Nitrogen Gap, Titanium/Kevlar Chassis, S25 Mount
// Units: Millimeters

$fn = 100; // High resolution rendering

// --- DIMENSIONS & VARIABLES ---
primary_lens_diam = 120;
tube_wall_thick = 3; // Titanium Grade 5
kevlar_thick = 2; // Kevlar Shield wrapping
tube_length = 350; 
nitrogen_gap_len = 50; 
microscope_obj_len = 45;
mount_flange_thick = 5;

// --- MODULES ---

module main_chassis() {
    difference() {
        // Outer Titanium Shell
        color("silver") 
        cylinder(h=tube_length, d=primary_lens_diam + (tube_wall_thick*2), center=false);
        
        // Inner Hollow (Optical Path)
        translate([0,0,-1])
        cylinder(h=tube_length+2, d=primary_lens_diam, center=false);
    }
}

module kevlar_shield() {
    // Outer Kevlar Wrap for impact protection
    translate([0,0,10]) // Offset from front slightly
    color("black")
    difference() {
        cylinder(h=tube_length-20, d=primary_lens_diam + (tube_wall_thick*2) + (kevlar_thick*2));
        translate([0,0,-1])
        cylinder(h=tube_length+20, d=primary_lens_diam + (tube_wall_thick*2));
    }
}

module primary_lens_housing() {
    // Front Element Holder
    translate([0,0,tube_length-20])
    color("blue", 0.3) // Glass representation
    cylinder(h=15, d=primary_lens_diam-2);
    
    // Retaining Ring
    translate([0,0,tube_length-5])
    color("gray")
    difference() {
        cylinder(h=5, d=primary_lens_diam + (tube_wall_thick*2));
        translate([0,0,-1])
        cylinder(h=7, d=primary_lens_diam - 10); // Aperture opening
    }
}

module pressure_valve_port() {
    // Port for Nitrogen Pressurization (1.5 - 2.0 ATM)
    translate([(primary_lens_diam/2)+2, 0, 50])
    rotate([0,90,0])
    color("gold")
    union() {
        cylinder(h=10, d=8); // Valve Stem
        translate([0,0,10])
        cylinder(h=3, d=12); // Valve Cap
    }
}

module samsung_s25_mount() {
    // Mount for Samsung Galaxy S25 (Flight Computer)
    // Mounted dorsally for easy access
    translate([0, (primary_lens_diam/2) + 5, 100])
    rotate([0,0,0]) 
    color("darkslategray")
    difference() {
        // Mount Block
        cube([80, 15, 160], center=true);
        // Phone cutout (Approx S25 dims)
        translate([0, 2, 0])
        cube([75, 10, 150], center=true);
        // USB-C Cable Path to Chassis
        translate([0, 0, -70])
        rotate([90,0,0])
        cylinder(h=20, d=6);
    }
}

module microscope_magnifier_stage() {
    // The internal "Microscope Objective" housing
    // Located near the rear focal plane
    translate([0,0,50])
    color("darkgrey")
    difference() {
        cylinder(h=nitrogen_gap_len, d=primary_lens_diam);
        translate([0,0,-1])
        cylinder(h=nitrogen_gap_len+2, d=primary_lens_diam-10);
    }
    
    // The Objective Lens itself
    translate([0,0,60])
    color("silver")
    cylinder(h=microscope_obj_len, d1=20, d2=25);
}

module canon_rf_mount() {
    // Rear Mount for NASA-supplied Camera
    translate([0,0,0])
    rotate([180,0,0]) // Facing rear
    color("red")
    difference() {
        cylinder(h=15, d=54); // Approx RF Mount diameter
        translate([0,0,-1])
        cylinder(h=17, d=45);
    }
}

// --- ASSEMBLY ---

// 1. Main Pressure Hull
main_chassis();

// 2. Protective Layer
kevlar_shield();

// 3. Optics
primary_lens_housing();
microscope_magnifier_stage();

// 4. Systems
pressure_valve_port();
samsung_s25_mount();

// 5. Rear Interface
translate([0,0,-15])
canon_rf_mount();

// --- TEXT LABELS (For 3D View) ---
color("white")
translate([0, -80, tube_length/2])
rotate([90,0,0])
text("UDSLA - TITANIUM/KEVLAR", size=8, halign="center");
