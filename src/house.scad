// scad code for modular minidrawer -- house part
// code originally by zeropage. rewritten by ofloveandhate sep2017

include <Chamfer.scad>; // https://github.com/SebiTimeWaster/Chamfers-for-OpenSCAD/
$fn = 50;
house_wall_thickness_b = 1;
house_depth = 56; // in millimeters. this is the depth of the unit against the wall, front to back, including walls.

// ======= EDIT ================
num_x = 2;  // width
num_y = 2;  // height
use_magnet = false; // true to use magnets
//magnet_is_droppedin = true; // true to get drop-in slot for the magnet
//house_wall_thickness_b = 2; // MUST uncomment if drop-in magnets used, else the backwall will be too thin
//house_depth = 57; // MUST uncomment if drop-in magnets used, else the drawers will stand out by 1mm
magnet_r = 4.15;
magnet_h = 1.25; // the back wall should be at least this thick if using dropped in magnet
// ===============================

house_wall_thickness_s = 1;

interior_unit_width = 35.9;
interior_unit_height = 17.9;

chamfer_runners = 0.5;
runnersDiameter = 2.85;
runner_joincube_width = 1;

slot_thickness = 2.8;
slot_width = 5;
slot_gap = 0.25 ; // extra space between the runner cylinder, and the slot receiver. this number is a difference in diameters, so this difference is NOT the total gap all around, that's half this number.
slot_cylinder_inset = 0.1;
slot_inset_from_box_x = 1.5;
slot_inset_from_box_y = 1;

runner_offset_x = 25;
runner_offset_y = 8;

stopper_height = 2;  // how far off the top wall the stopper should project
stopper_length = 10;
stopper_width = 10;
stopper_inset = 2;
stopper_faces_front = false;  // which side the flat face of the stoppers should be on.  if true, the flat face is toward the front of the housing.


eps = 0.01;

to_print = true;




///////////utility computations

inter_house_offset = house_wall_thickness_s*2 + runnersDiameter; // 4.9 is old version
house_box_height = num_y*interior_unit_height - inter_house_offset;
house_box_width = num_x*interior_unit_width - inter_house_offset;
inter_drawer_offset = (runnersDiameter+slot_gap/2);

////////////  end utility computations


if (to_print)
  house();
else
{
//  house(); // display mode in the assembly

//  translate([-house_box_width - inter_house_offset,0,0])
//    house();
//
//  translate([house_box_width + inter_house_offset,0,0])
//    house();
//
//  translate([0,-house_box_height - inter_house_offset,0])
//    house();
//
//  translate([0,+house_box_height + inter_house_offset,0])
//    house();
}

module house()
{
  difference() {
    house_positive();
    house_negative();
  }
}


module house_negative()
{
  q = house_wall_thickness_s*2 + runnersDiameter; // 4.9 for 100% compatibility w old versions
  difference(){
    translate([house_wall_thickness_s,house_wall_thickness_s,house_wall_thickness_b])
      cube([interior_unit_width*num_x-q, interior_unit_height*num_y-q, house_depth]);
    stoppers();
  }
  if (use_magnet)
    house_magnet_cutouts();
}


module house_magnet_cutouts()
{
  if (magnet_h >= 1*house_wall_thickness_b && magnet_is_droppedin)
  {
    echo("magnet thickness very near to back wall thickness.  things probably not as desired");
  }

  for (ii = [0:num_x-1])
  {
    if (magnet_is_droppedin)
    {
      translate([ii*interior_unit_width+16,0,house_wall_thickness_b/2-magnet_h/2])
        magnet_cutout_single();
    }
    else
    {
      translate([ii*interior_unit_width+16,0,house_wall_thickness_b-magnet_h])
        magnet_cutout_single();
    }
  }
}



module magnet_cutout_single()
{
  translate([0,house_box_height/2, 0 ])
  {
    magnet();
    if (magnet_is_droppedin)
    {
      magnet_cutout_slot();
    }
  }
}

module magnet()
{
  translate([0,0,0])
    rotate([0,0,0]) cylinder(h=magnet_h+eps,r=magnet_r,$fn=100);
}

module magnet_cutout_slot()
{
  c = house_box_height/2+2*eps;
  translate([-magnet_r,-house_box_height/2-eps,0])
    cube([magnet_r*2, c , magnet_h+eps ]); // top hole for magnet
  // the eps here are to ensure the cube protrudes from the top of the house
}



module stoppers()
{
for (ii = [0:num_x-1])
  translate([ii*interior_unit_width,0,0])
    stopper();
}

module stopper()
{
  translate([stopper_width,stopper_height+house_wall_thickness_s-eps,house_depth-stopper_inset])
    rotate( [0,180,180] )
      prism(l=stopper_length+stopper_height,w=stopper_height,h=stopper_length);
}



module house_positive()
{
  q = runnersDiameter; // 2.9 for 100% compatibility with old versions, though the difference is quite small (0.05)

  overall_x = interior_unit_width*num_x-q;
  overall_y = interior_unit_height*num_y-q;
  cube([overall_x, overall_y,house_depth]);

  radius = runnersDiameter/2;

  for (ii=[0:num_x-1])
    translate([interior_unit_width*ii,0,0])
    {
      runner_bottom();
      translate([runner_offset_x, 0, 0])
        runner_bottom();

      translate([0,overall_y-interior_unit_height+q,0])
      {
        slot_top();
        translate([runner_offset_x,0,0])
          slot_top();
      }
    }

  for (jj=[0:num_y-1])
    translate([0,interior_unit_height*jj,0])
    {
      translate([overall_x-(interior_unit_width-runnersDiameter),0,0])
      {
        runner_right();
        translate([0,8,0])
          runner_right();
      }
      translate([0,0,0])
      {
        slot_left();
        translate([0,runner_offset_y,0])
          slot_left();
      }
    } // for jj's translate

}




module slot_top()
{
  slot_diameter = runnersDiameter + slot_gap;
  difference()
  {
    translate([ slot_inset_from_box_x,  15-slot_cylinder_inset, 0]) cube([slot_width,slot_thickness,house_depth]);
    translate([ (slot_width/2+slot_inset_from_box_x),  16.5, -eps]) cylinder(d=slot_diameter,h=house_depth+2*eps);
  }
}

module runner_bottom()
{
  runner_cylinder_inset_bottom = 0.025;
  radius = runnersDiameter/2;

  x = slot_width/2+slot_inset_from_box_x;
  y = radius-runner_cylinder_inset_bottom;

  translate([ x,  -y, 0]) chamferCylinder(house_depth,radius,radius,chamfer_runners);
  translate([x-runner_joincube_width/2,-(y-eps), 0]) cube([runner_joincube_width,radius,house_depth]);
}


module slot_left()
{
  slot_diameter = runnersDiameter + slot_gap;
  translate([0,0,0])
  difference()
  {
    q = runnersDiameter/2+slot_cylinder_inset;
    translate([- (slot_thickness - slot_cylinder_inset),   slot_inset_from_box_y,   0]) cube([slot_thickness,slot_width,house_depth]);
    translate([-q, slot_inset_from_box_y + slot_width/2, -eps]) cylinder(d=slot_diameter,h=house_depth+2*eps);
  }

}


module runner_right()
{

  radius = runnersDiameter/2;
  translate([(interior_unit_width-runnersDiameter/2), slot_inset_from_box_y + slot_width/2,0]) chamferCylinder(house_depth,radius,radius,chamfer_runners);

  x = (interior_unit_width-runnersDiameter)-eps;
  y = slot_inset_from_box_y + slot_width/2-runner_joincube_width/2;
  translate([x, y,  0]) cube([radius,runner_joincube_width,house_depth]);
}







module prism(l, w, h)
{
  p_front = [[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]];
  p_back = [[0,0,h], [l,0,h], [l,w,0], [0,w,0], [0,w,h], [l,w,h]];

  f = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]];

  if (stopper_faces_front)
  {
    polyhedron(
      points=p_front,
      faces=f
    ); 
  }
  else
  {
    polyhedron(
      points=p_back,
      faces=f
    ); 
  }

}
