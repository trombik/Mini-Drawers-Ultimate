// scad code to render the house and drawer together, either for fit preview, or together for printing
//
// code originally by zeropage. rewritten by ofloveandhate sep2017

include <house.scad>;
include <drawer.scad>;

// ====== EDIT ==========================
// these will override the values set in the drawer and house files.
num_x = 4;
num_y = 4;
use_label = true;
drawer_label = ["printer parts",7,"Liberation Sans:style=Bold",0.5];
use_magnet = true;
magnet_is_droppedin = true; // NOTE: if you use drop-in magnets you must uncomment lines in the house.scad file
// ======================================

to_print = true;
cut = true;

slot_partition = [1]; // partition of the unit interval into slots.  valid partitions add up to something ≤ 1

if (!to_print)
{
  if (cut)
    cut_to_display();
  else
    assembled_unit();
}

module assembled_unit()
{
  drawer_slideout = 10;
  union()
  {
    translate([interior_unit_width*(num_x)-runnersDiameter,house_depth,(num_y)*interior_unit_height-runnersDiameter])
      rotate([-90,0,180])
        house();

    translate([house_wall_thickness_s+inset_width,-drawer_slideout+inset_depth/2,house_wall_thickness_s + inset_height/2])
      drawer();
  }
}

module cut_to_display()
{
  difference()
  {
    assembled_unit();
    cutting_object();
  }
}


module cutting_object()
{
  translate([-10,50,40])
    rotate([45,45,0])
      cube([100,100,100]);
}