include <jl_scad/box.scad>
include <jl_scad/parts.scad>

$fa = 1;
$fn = 48;

module my_box(size) {
    // a test box with one piece per side

    // left, right, front, back, bot, top
    walls = [0.5,0.5,1,1,3,2];

    size = scalar_vec3(size);

    base_height = size.z / 2;

    halves = BOX_ALL;

    _box_shell(size, base_height, walls, false, halves) {
        for(i = idx(halves)) { // implicit union
            h = halves[i];
            w = walls[i];
            sz = [h.x!=0?w:size.x, h.y!=0?w:size.y, h.z!=0?w:size.z];
            box_half(h) position(h) cube(sz, anchor=h);
        }
        // parts
        children();
    }
}

module txt(t) text3d(t, h=0.5, size=5, atype="ycenter", anchor=BOTTOM);

sz = [50,40,30];

//halves = [BOT,TOP,LEFT,RIGHT,FRONT,BACK];
//halves = [BOT,TOP,LEFT,RIGHT,BACK];
//halves = [TOP];
halves = BOX_ALL;
box_make(halves, print=true, top_pos=BACK, explode=0)
my_box(sz)
{

    box_half(BOX_ALL) {
        box_pos() txt(vector_name($box_half));
        box_pos() move([0,8]) box_hole(5, chamfer=0.5);
    }

    box_cut()
        box_half(BOX_ALL, inside=false)
            position(LEFT+FRONT)
                cube([15,15,sz.z*0.75],anchor=CENTER,spin=45);
}