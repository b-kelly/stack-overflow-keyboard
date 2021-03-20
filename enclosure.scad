$fn=100;

includePosts = false;
includeEnclosure = true;
includeSwitchInsert = true;
includeFaceplate = true;

// how many keys our keyboard has
keyCount = 3;

// measurements of a cherry mx switch / keycap
keycapWidth = 18;
switchHeight = 14;
switchWidth = 14.5;//15.6;
switchStemHeight = 4;

// post settings
postWidth = 4;

// how far apart to space the caps
spaceBetweenCaps = 1;

// distance from the keycaps to the walls
distanceFromWalls = 2;

// how thick the enclosure walls are
wallWidth = 2;

// the corner radius
cornerCurveRadius = 5;

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

facePlateWidth = encWidth - (wallWidth * 2) - cornerCurveRadius;

module rrect(r, x, y, h=1)
{
    d = r * 2;
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
        // flush fit means two posts, but... yeah
        //cube([x, y, h]);
        translate([xh - yh, yh - xh, 0]) cube([y, x, h]);
    }
    // reinforce the post base
    reinforcementWidth = postWidth * 1.5;
    cylinder(h - switchStemHeight, d=reinforcementWidth);
}

module microUsbCutout(depth = wallWidth)
{
    width = 7.40;
    height = 2.40;

    translate([width / -2, 0, 0])
        cube([width, depth, height]);
}

module facePlate(includeImage = true)
{
    translate([0, wallWidth / 2, 0]) {
        translate([0, wallWidth / -2, 0])
            #cube([wallWidth / 2, facePlateWidth + wallWidth, encHeight]);

        difference() {
            cube([wallWidth, facePlateWidth, encHeight]);
                
            if (includeImage)
            {
                imgDepth = 0.5;
                translate([imgDepth, facePlateWidth / 2, encHeight / 2])
                    rotate([90, 0, 90])
                    resize([facePlateWidth - wallWidth, 0, 0], auto=[true,true,false])
                    #linear_extrude(imgDepth + 1)
                    import("./Stacks-Icons/src/Icon/Logo.svg", center=true);
            }
        }
    }
}

// draw the enclosure
if (includeEnclosure)
difference()
{
    mod = wallWidth * 2;
    
    rrect(cornerCurveRadius, encLength, encWidth, encHeight);
    translate([wallWidth, wallWidth, wallWidth])
        rrect(cornerCurveRadius, encLength-mod, encWidth-mod, encHeight);

    pcbHeight = 1.6;
    translate([(encLength / 2), 0, wallWidth + pcbHeight])
        microUsbCutout();

    // cut out the front plate so we can print it separately
    if (includeFaceplate)
    translate([encLength - wallWidth, wallWidth * 2, 0])
        rotate([0, 0, 0])
        facePlate(false);
}

if (includePosts)
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
        %translate([x, y, postHeight - switchStemHeight / 2])
            cube([keycapWidth, keycapWidth, switchStemHeight], center=true);
    }
}

// create a structure inside the enclosure that the switches can attach to
if (includeSwitchInsert)
translate([encHeight * 2, 0, 0])
difference() {
    mod = wallWidth * 2;
    rrect(cornerCurveRadius, encLength - mod, encWidth - mod, 5);

    for (i = [0:(keyCount-1)])
    {
        x = distanceFromWalls + (keycapWidth / 2);
        y = (keycapWidth * i) + (keycapWidth / 2) + distanceFromWalls + (spaceBetweenCaps * i);

        translate([x, y, 0])
            cube([switchWidth, switchWidth, 10], center=true);
    }
}

// add the faceplate, rotated on its back for easy printing
if (includeFaceplate)
translate([encHeight * 5, 0, 0])
    rotate([0, -90, 0])
    facePlate();