Copy the code below, paste it into the free [OpenSCAD](https://openscad.org/) software, and it will render a precise 3D model of your **Modular UDSLA** based on the specs you provided (120mm Primary Lens, Titanium/Kevlar Chassis, and Samsung S25 Mount). You can then export it as an **.STL** or **.3MF** file for 3D printing or CNC machining.

### **OpenSCAD Script: Modular UDSLA Prototype**

OpenSCAD

// UDSLA Modular Design \- "The Hofstad Prototype"  
// Specs: 120mm Primary, Nitrogen Gap, Titanium/Kevlar Chassis, S25 Mount  
// Units: Millimeters

$fn \= 100; // High resolution rendering

// \--- DIMENSIONS & VARIABLES \---  
primary\_lens\_diam \= 120;  
tube\_wall\_thick \= 3; // Titanium Grade 5  
kevlar\_thick \= 2; // Kevlar Shield wrapping  
tube\_length \= 350;   
nitrogen\_gap\_len \= 50;   
microscope\_obj\_len \= 45;  
mount\_flange\_thick \= 5;

// \--- MODULES \---

module main\_chassis() {  
    difference() {  
        // Outer Titanium Shell  
        color("silver")   
        cylinder(h=tube\_length, d=primary\_lens\_diam \+ (tube\_wall\_thick\*2), center=false);  
          
        // Inner Hollow (Optical Path)  
        translate(\[0,0,-1\])  
        cylinder(h=tube\_length+2, d=primary\_lens\_diam, center=false);  
    }  
}

module kevlar\_shield() {  
    // Outer Kevlar Wrap for impact protection  
    translate(\[0,0,10\]) // Offset from front slightly  
    color("black")  
    difference() {  
        cylinder(h=tube\_length-20, d=primary\_lens\_diam \+ (tube\_wall\_thick\*2) \+ (kevlar\_thick\*2));  
        translate(\[0,0,-1\])  
        cylinder(h=tube\_length+20, d=primary\_lens\_diam \+ (tube\_wall\_thick\*2));  
    }  
}

module primary\_lens\_housing() {  
    // Front Element Holder  
    translate(\[0,0,tube\_length-20\])  
    color("blue", 0.3) // Glass representation  
    cylinder(h=15, d=primary\_lens\_diam-2);  
      
    // Retaining Ring  
    translate(\[0,0,tube\_length-5\])  
    color("gray")  
    difference() {  
        cylinder(h=5, d=primary\_lens\_diam \+ (tube\_wall\_thick\*2));  
        translate(\[0,0,-1\])  
        cylinder(h=7, d=primary\_lens\_diam \- 10); // Aperture opening  
    }  
}

module pressure\_valve\_port() {  
    // Port for Nitrogen Pressurization (1.5 \- 2.0 ATM)  
    translate(\[(primary\_lens\_diam/2)+2, 0, 50\])  
    rotate(\[0,90,0\])  
    color("gold")  
    union() {  
        cylinder(h=10, d=8); // Valve Stem  
        translate(\[0,0,10\])  
        cylinder(h=3, d=12); // Valve Cap  
    }  
}

module samsung\_s25\_mount() {  
    // Mount for Samsung Galaxy S25 (Flight Computer)  
    // Mounted dorsally for easy access  
    translate(\[0, (primary\_lens\_diam/2) \+ 5, 100\])  
    rotate(\[0,0,0\])   
    color("darkslategray")  
    difference() {  
        // Mount Block  
        cube(\[80, 15, 160\], center=true);  
        // Phone cutout (Approx S25 dims)  
        translate(\[0, 2, 0\])  
        cube(\[75, 10, 150\], center=true);  
        // USB-C Cable Path to Chassis  
        translate(\[0, 0, \-70\])  
        rotate(\[90,0,0\])  
        cylinder(h=20, d=6);  
    }  
}

module microscope\_magnifier\_stage() {  
    // The internal "Microscope Objective" housing  
    // Located near the rear focal plane  
    translate(\[0,0,50\])  
    color("darkgrey")  
    difference() {  
        cylinder(h=nitrogen\_gap\_len, d=primary\_lens\_diam);  
        translate(\[0,0,-1\])  
        cylinder(h=nitrogen\_gap\_len+2, d=primary\_lens\_diam-10);  
    }  
      
    // The Objective Lens itself  
    translate(\[0,0,60\])  
    color("silver")  
    cylinder(h=microscope\_obj\_len, d1=20, d2=25);  
}

module canon\_rf\_mount() {  
    // Rear Mount for NASA-supplied Camera  
    translate(\[0,0,0\])  
    rotate(\[180,0,0\]) // Facing rear  
    color("red")  
    difference() {  
        cylinder(h=15, d=54); // Approx RF Mount diameter  
        translate(\[0,0,-1\])  
        cylinder(h=17, d=45);  
    }  
}

// \--- ASSEMBLY \---

// 1\. Main Pressure Hull  
main\_chassis();

// 2\. Protective Layer  
kevlar\_shield();

// 3\. Optics  
primary\_lens\_housing();  
microscope\_magnifier\_stage();

// 4\. Systems  
pressure\_valve\_port();  
samsung\_s25\_mount();

// 5\. Rear Interface  
translate(\[0,0,-15\])  
canon\_rf\_mount();

// \--- TEXT LABELS (For 3D View) \---  
color("white")  
translate(\[0, \-80, tube\_length/2\])  
rotate(\[90,0,0\])  
text("UDSLA \- TITANIUM/KEVLAR", size=8, halign="center");

### **How to Use This:**

1. Download and install **OpenSCAD** (it is free and open-source).  
2. Copy the code block above.  
3. Paste it into the editor on the left side of the OpenSCAD window.  
4. Press **F5** to Preview or **F6** to Render.  
5. Go to **File \> Export \> Export as STL** to get your 3D print file.