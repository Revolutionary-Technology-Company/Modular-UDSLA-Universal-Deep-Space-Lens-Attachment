// ==============================================================================
// PROJECT: MODULAR UDSLA - FULL INTEGRATION
// AUTHOR: Seattle Data Recovery (Prototype Lab)
// DATE: 2026-01-20
// COMPONENTS: Primary Lens + N2 Chassis + Turret + Canon Mount
// ==============================================================================

$fn = 150; // High resolution for precise bayonet lugs

// --- OPTICAL & CHASSIS CONSTANTS ---
primary_diam = 120;
tube_wall_thick = 4;
chassis_OD = primary_diam + (tube_wall_thick * 2);
tube_length = 350; // Main baffle tube length
turret_diam = 110;
turret_thick = 15;

// --- CANON MOUNT CONSTANTS (EF/RF Compatible Geometry) ---
mount_flange_dist = 44.0; // EF Flange Distance (Sensor to Mount)
mount_inner_diam = 54.0;  // Throat diameter
bayonet_lug_height = 2.5;

// ==============================================================================
// 1. CANON MOUNT MODULE (Parametric Recreation)
// ==============================================================================
module canon_ef_mount_geometry() {
    // This recreates the geometry of the .STEP file functionality
    difference() {
        // Base Flange Ring
        color("silver")
        union() {
            cylinder(h=6, d=65); // Outer grip ring
            translate([0,0,6])
            cylinder(h=5, d=mount_inner_diam - 0.5); // Inner mating collar
        }
        
        // Central Light Path
        translate([0,0,-1])
        cylinder(h=20, d=48); // Clear aperture
        
        // M3 Nut Wells (from your uploaded file spec)
        for(i=[0:90:360]) {
            rotate([0,0,i])
            translate([29, 0, 0]) // Bolt circle radius
            cylinder(h=10, d=3.2, center=true); // M3 Clearance
        }
    }
    
    // The 3 Bayonet Lugs (EF Standard)
    color("silver")
    translate([0,0,5]) // Top of flange
    intersection() {
        cylinder(h=bayonet_lug_height, d=mount_inner_diam + 4); // Lug Extent
        
        // Cut out the gaps between lugs
        union() {
            for(r = [0, 120, 240]) {
                rotate([0,0,r])
                wedge(60, 40, 10); // 60-degree lugs
            }
        }
    }
}

// Helper for Bayonet Lugs
module wedge(angle, radius, height) {
    rotate([0,0,-angle/2])
    linear_extrude(height)
    polygon([[0,0], [radius,0], [radius*cos(angle), radius*sin(angle)]]);
}

// ==============================================================================
// 2. MAIN CHASSIS MODULES
// ==============================================================================

module primary_lens_assembly() {
    difference() {
        // Titanium Housing
        color("dimgray")
        cylinder(h=80, d=chassis_OD);
        // Interior
        translate([0,0,-1])
        cylinder(h=82, d=primary_diam);
    }
    // The 120mm Glass
    translate([0,0,20]) color("cyan", 0.4) cylinder(h=15, d=primary_diam);
    // Retaining Ring
    translate([0,0,75]) color("black") 
        difference() { cylinder(h=5, d=chassis_OD); translate([0,0,-1]) cylinder(h=7, d=110); }
}

module nitrogen_tube_body() {
    translate([0,0,80])
    difference() {
        // Kevlar Wrapped Tube
        color("gold") // Kevlar/Titanium
        cylinder(h=tube_length, d=chassis_OD);
        
        // Hollow
        translate([0,0,-1])
        cylinder(h=tube_length+2, d=primary_diam);
    }
    
    // Pressure Valve
    translate([chassis_OD/2, 0, 150])
    rotate([0,90,0])
    color("red") cylinder(h=15, d=8);
}

module turret_assembly() {
    // Mounted at rear of tube
    translate([0,0, 80 + tube_length]) 
    union() {
        // Backplate (Stator)
        color("darkslategray")
        cylinder(h=10, d=chassis_OD);
        
        // Turret Disk (Rotor)
        translate([0,10,12]) // Offset pivot
        rotate([0,0,20])     // Rotated to show clearance
        difference() {
            color("silver")
            cylinder(h=turret_thick, d=turret_diam);
            
            // 3 Objective Holes
            for(i=[0:120:360]) {
                rotate([0,0,i])
                translate([turret_diam/3, 0, -1])
                cylinder(h=20, d=26); // M26 threads
            }
        }
    }
}

module camera_interface_tube() {
    // Connects Turret to Canon Mount
    // Contains the Tube Lens (ITL200)
    
    start_z = 80 + tube_length + 25; // After turret
    
    translate([0,0,start_z])
    difference() {
        color("black")
        cylinder(h=40, d1=80, d2=65); // Taper to mount
        translate([0,0,-1])
        cylinder(h=42, d=50);
    }
    
    // INTEGRATE THE CANON MOUNT HERE
    translate([0,0, start_z + 40])
    rotate([180,0,0]) // Face mount outwards
    canon_ef_mount_geometry();
}

// ==============================================================================
// 3. FINAL ASSEMBLY RENDER
// ==============================================================================

union() {
    primary_lens_assembly();
    nitrogen_tube_body();
    turret_assembly();
    camera_interface_tube();
}

// --- Labels ---
color("white")
translate([0, -80, 200])
rotate([90,0,0])
text("UDSLA - INTEGRATED PROTO", size=10, halign="center");
