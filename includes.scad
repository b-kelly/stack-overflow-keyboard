$fn=100;

// how many keys our keyboard has
keyCount = 3;

// measurements of a cherry mx switch + keycap
keycapWidth = 18;
switchHeight = 14;
switchStemHeight = 4;
postWidth = 4;

// how thick the enclosure walls are
wallWidth = 4;
lidHeight = 0; // TODO design the lid

// calculate the size of the enclosure based on the keycap widths
encWidth = (wallWidth * 2) + (keycapWidth * keyCount) + (wallWidth * 2);
encLength = (wallWidth * 2) + keycapWidth + (wallWidth * 2);
encHeight = switchHeight + wallWidth;

module rrect(d, x, y, h=1)
{
    r = d / 2;
    tl = x - d;
    tw = y - d;
    translate([r, r, 0]) {
        hull()
        {
            cylinder(h=h, r=r);
            translate([tl, 0, 0]) cylinder(h=h, r=r);
            translate([0, tw, 0]) cylinder(h=h, r=r);
            translate([tl, tw, 0]) cylinder(h=h, r=r);
        }
    }
}