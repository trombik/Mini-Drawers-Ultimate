// scad code for modular minidrawer -- drawer part
// code originally by zeropage. rewritten by ofloveandhate sep2017

include <Chamfer.scad>; // https://github.com/SebiTimeWaster/Chamfers-for-OpenSCAD/

drawer_label = ["test",4,"Liberation Sans:style=Bold",0.5];
use_label = true;

$fn = 50;
ang = 25;

// ======= EDIT ======================
num_x = 1;
num_y = 2;
slot_partition = [.33,.33, .34];//[0.4,0.6]; // partition of 1 into slots
use_magnet = false;
magnet_is_droppedin = false;
// ===================================

// ideally these numbers come directly from the house parameters.
house_wall_thickness_s = 1;
house_wall_thickness_b = 1;
house_depth = 56;
unit_height = 17.9;
unit_width = 35.9;
space_width = 4.9;
space_height = 4.9;


// thicknesses of things
drawer_wall_thickness_x = 1.2;
drawer_wall_thickness_f = 1.2;
drawer_wall_thickness_b = 3; // shoule be thicker than magnet_h plus extrusions, if using slot for magnet
drawer_wall_thickness_s = 1.2; // thickness of walls between slots
drawer_floor_thickness = 1;

// space to leave between the walls of the drawer and house
inset_width = 0.5;
inset_height = 0.6;
inset_depth = 0.5;



chamfer_interior = 0.8;
chamfer_exterior = 0.6;
should_chamfer_top = 0; // a boolean 1 or 0

magnet_r = 4.15;
magnet_h = 1.25;

use_num_x_handles = true; // false generates a single handles in the middle

eps = 0.01;





to_print = true;

if (to_print)
{
  translate([0,-drawer_depth-10,0])
  drawer();
}
else
  ;


module drawer()
{
  difference()
  {
    drawer_positive();
    drawer_negative();
  }

  handles();
}

drawer_depth = house_depth - 1*house_wall_thickness_b - inset_depth;// including walls
drawer_width = unit_width*num_x -space_width - 2*inset_width;
drawer_height = unit_height*num_y - space_height+0.8 - inset_height;

module drawer_positive()
{
  usable_height = drawer_height - drawer_floor_thickness;
  chamferCube(drawer_width,drawer_depth,usable_height,chamfer_exterior,[1,1,should_chamfer_top,should_chamfer_top],[1,should_chamfer_top,should_chamfer_top,1],[1,1,1,1]);
  if ( use_label ) label();
}

module drawer_negative()
{

  num_slots = len(slot_partition);

  interior_w = drawer_width - 2*drawer_wall_thickness_x;

  x = drawer_wall_thickness_f;

  usable_depth = drawer_depth - drawer_wall_thickness_f - drawer_wall_thickness_b - (
  num_slots-1)*drawer_wall_thickness_s;

  usable_height = drawer_height - drawer_floor_thickness;

  for (ii = [0:num_slots-1])
  {
    depth_this = slot_partition[ii]*usable_depth;
    y_this = 0;
    used_prev = add(slot_partition, 0, num_slots-ii);
    bla = used_prev*usable_depth+ii*drawer_wall_thickness_s + drawer_wall_thickness_f;

    translate([drawer_wall_thickness_x,bla,drawer_floor_thickness])
      chamferCube(interior_w,depth_this,usable_height,chamfer_interior,[1,1,0,0],[1,0,0,1],[1,1,1,1]);
  }

  if (num_slots>1)
  {
    for (jj = [0:num_x-1]){
      for (ii = [1:num_slots-1])
      {
        depth_this = slot_partition[ii]*usable_depth;
        y_this = 0;
        used_prev = add(slot_partition, 0, num_slots-ii);
        //		echo(used_prev);
        bla = used_prev*usable_depth+ii*drawer_wall_thickness_s + drawer_wall_thickness_f - drawer_wall_thickness_s*1.5;
        //drawer_width/(num_x)*(jj) + 14/2
        translate([8 +jj*35.9,bla,usable_height-1.29])
        {
          chamferCube(14,2,1.3,1.5,[],[1,0,0,1],[]);
        }
      } // for ii
    } // jj
  } // if
  if (use_magnet)
    drawer_magnet_cutouts();
}

function add(cont, ii=0, off_b=0, val=0) = ii<len(cont)-off_b ? add(cont, ii+1, off_b, val+cont[ii]) : val;

module drawer_magnet_cutouts()
{
  for (ii = [0:num_x-1])
  {
    if (magnet_is_droppedin)
      translate([ii*35.9+15,drawer_depth - drawer_wall_thickness_b/2-magnet_h/2,0])
        drawer_magnet_cutout_single();
    else
      translate([ii*35.9+15,drawer_depth-magnet_h+eps,0])
        drawer_magnet_cutout_single();
  }
}



module drawer_magnet_cutout_single()
{
  translate([0,0,drawer_height/2])
  {
    translate([0,0,0])
      rotate([-90,0,0]) cylinder(h=magnet_h+eps,r=magnet_r,$fn=100); // top hole for magnet
    if (magnet_is_droppedin)
      translate([-magnet_r,-eps,0])
        cube([magnet_r*2, magnet_h+2*eps, drawer_height/2]); // top hole for magnet
  }

}

module handles()
{
  if (use_num_x_handles)
  for (ii=[0:num_x-1])
    translate([ii*35.9+15,0,0])
      handle();

  else
     translate([drawer_width/2,0,0])
      handle();
}


module handle()
{
  difference() {
    translate([0,8,0]) chamferOval(11,18,3);
    translate([0,8,-0.1]) oval(9,16,3.2);
    translate([-11-2,0.1,-0.1])	cube([29.8,30,3.2]);
  }
}

module oval(w,h, height, center = false) {
  scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

module chamferOval(w,h, height) {
  scale([1, h/w, 1]) chamferCylinder(height, w, w, .4, 360,1);
}


module label()
{
/* original code from dani      translate([drawer_width/2-len(drawer_label[0])/2*drawer_label[1]*0.6,0,drawer_height/2])
    rotate([90,0,0])
      linear_extrude(height=drawer_label[3])
        text(drawer_label[0], font=drawer_label[2], size=drawer_label[1]);
*/
/* as suggested by Bolukan */
translate([drawer_width/2,0,drawer_height/2+0.75])
rotate([90,0,0])
linear_extrude(height=drawer_label[3])
text(drawer_label[0], font=drawer_label[2], size=drawer_label[1], halign="center", valign="center");
}
