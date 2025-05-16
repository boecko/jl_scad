module esp32_wroom_32(pcb_zofs = 3,anchor=CENTER,spin=0,orient=UP) {
    h = $parent_size.z;
    gap_hole_y=47;
    gap_hole_x=23.5;
    d_hole=3;
    pcb = [28.5,51.8,1.5];
    usb = [7.5,6.5,2.3];
    hole_gap_y=(pcb.y-gap_hole_y)/2;
    hole_gap_x=(pcb.x-gap_hole_x)/2;
    hole_pos = [
                [hole_gap_x, pcb.y-hole_gap_y],
                [pcb.x-hole_gap_x, pcb.y-hole_gap_y],
                [pcb.x-hole_gap_x, hole_gap_y],
                [hole_gap_x, hole_gap_y]
                ];
    module esp32_preview() {
        box_preview("#44ba")
        diff() cuboid(pcb,rounding=3.4,edges=[BACK+LEFT,BACK+RIGHT],anchor=FRONT+BOTTOM+LEFT) {
            up(0.001) recolor("#aaba") tag("keep") {
                position(FRONT+CENTER+TOP) cube(usb,anchor=BOT+CENTER+FRONT);
            }
            tag("remove") {
                for(p = hole_pos)
                    move(p) position(FRONT+LEFT) #cyl(d=2.3,h=pcb.z*2);

            }
        }
    }

    module esp32_standoff(pin=true) box_standoff_clamp(h=pcb_zofs,id=d_hole-0.1,od=4,pin_h=pin?3:false,fillet=1.5,gap=pcb.z) children();

    sz = [pcb.x,pcb.y,h];
    attachable(anchor,spin,orient,size=sz,cp=[sz.x/2,sz.y/2,0]) {
        union() {
            for(p = hole_pos)
                move(p) esp32_standoff();
            
            //move([7,2.9]) #esp32_standoff(false);
            //move([pcb.x-3.2,pcb.y-3.2]) esp32_standoff(false);
        }

        union() {
            up(pcb_zofs+0.001) box_part(BOT,FRONT+LEFT) esp32_preview();

            //move([13.75,-0.002,pcb_zofs+usb.z/2+pcb.z]) 
            up(pcb_zofs+usb.z/2+pcb.z) position(BOT+FRONT+CENTER) box_part(FRONT,undef) box_cutout(rect([12,8],rounding=0.7));

            children();
        }
    }
}