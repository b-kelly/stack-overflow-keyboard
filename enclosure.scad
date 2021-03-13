$fn=100;

// how many keys our keyboard has
keyCount = 3;

// measurements of a cherry mx switch + keycap
keycapWidth = 18;
switchHeight = 14;
switchStemHeight = 4;
postWidth = 4;

// how far apart to space the caps
spaceBetweenCaps = 1;

// distance from the keycaps to the walls
distanceFromWalls = 2;

// how thick the enclosure walls are
wallWidth = 4;

// calculate the size of the enclosure based on the keycap widths
encWidth =
    (wallWidth * 2) // two walls
    + (keycapWidth * keyCount) // n keys that are w wide
    + (spaceBetweenCaps * (keyCount - 1)) // the space between each key, not including the end keys
    + (distanceFromWalls * 2); // distance between the walls and the caps on each end

encLength =
    (wallWidth * 2) // two walls
    + keycapWidth // the "height" of the square keycap
    + (distanceFromWalls * 2); // distance between the walls and the cap

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

module post(h)
{
    // these posts are decorational only, so don't design them to be a flush fit
    // if you do, you run the risk of the post breaking off inside the cap (ask me how I know...)

    x = postWidth;
    y = (postWidth / 4) - 0.2;

    xh = x / 2;
    yh = y / 2;
    translate([-xh, -yh, 0])
    {
        cube([x, y, h]);
        // flush fit means two posts, but... yeah
        //translate([xh - yh, yh - xh, 0]) cube([y, x, h]);
    }
    // reinforce the post base
    reinforcementWidth = postWidth * 1.5;
    cylinder(h - switchStemHeight, d=reinforcementWidth);
}

// draw the enclosure
difference()
{
    mod = wallWidth * 2;

    difference()
    {
        rrect(10, encLength, encWidth, encHeight);
        translate([wallWidth, wallWidth, wallWidth])
            rrect(10, encLength-mod, encWidth-mod, encHeight);
    }

    imgDepth = wallWidth / 2;
    translate([encLength - imgDepth, encWidth / 2, encHeight / 2])
        rotate([90, 0, 90])
        resize([encWidth - mod, 0, 0], auto=[true,true,false])
        linear_extrude(imgDepth + 1)
        import("./Stacks-Icons/src/Icon/Logo.svg", center=true);
}

// simplify the internal math a bit, account for the wall/floor heights
translate([wallWidth, wallWidth, 0])
{
    for (i = [0:(keyCount-1)])
    {
        x = distanceFromWalls + (keycapWidth / 2);
        y = (keycapWidth * i) + (keycapWidth / 2) + distanceFromWalls + (spaceBetweenCaps * i);

        postHeight =
            encHeight // the height of the enclosure
            + switchStemHeight; // the extra height that sticks into the cap

        translate([x, y, 0])
            post(postHeight);

        // add in a dummy keycap for visual debugging purposes
        %translate([x - keycapWidth / 2, y - keycapWidth / 2, postHeight - switchStemHeight])
            cube([keycapWidth, keycapWidth, switchStemHeight]);
    }
}