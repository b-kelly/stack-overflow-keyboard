$fn=100;

includePosts = false;
includeEnclosure = true;
includeSwitchInsert = true;
includeFaceplate = true;
cutOutFaceplate = true;

// number of keys are in a single row
columnCount = 3;

// number of rows of keys to add
rowCount = 1;

// measurements of a cherry mx switch / keycap
keycapWidth = 18;
switchHeight = 14;
switchWidth = 14.5;//15.6;
switchStemHeight = 4;

// how far apart to space the caps
spaceBetweenCaps = 1;

// distance from the keycaps to the walls
distanceFromWalls = 2;

// how thick the enclosure walls are
wallWidth = 2;

// the corner radius
cornerCurveRadius = 5;

// the path to the faceplate image
logoPath = "./Stacks-Icons/src/Icon/Logo.svg";

// TODO there's probably a better way to detect and constrain dynamically, but I'm being lazy here
// whether to fit the logo to the width or to the height
fitLogoToLength = true;

// additional height to add to the enclosure to account for electronics, etc
additionalEnclosureHeight = 5;

// calculate the size of the enclosure based on the keycap widths
encLength =
    (wallWidth * 2) // two walls
    + (keycapWidth * columnCount) // n keys that are w wide
    + (spaceBetweenCaps * (columnCount - 1)) // the space between each key, not including the end keys
    + (distanceFromWalls * 2); // distance between the walls and the caps on each end

encWidth =
    (wallWidth * 2) // two walls
    + (keycapWidth * rowCount) // n keys that are w wide
    + (spaceBetweenCaps * (rowCount - 1)) // the space between each key, not including the end keys
    + (distanceFromWalls * 2); // distance between the walls and the cap

encHeight = switchHeight + wallWidth + additionalEnclosureHeight;

facePlateLength = encLength - (wallWidth * 2) - cornerCurveRadius;

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
    postWidth = 4;

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
            #cube([wallWidth / 2, facePlateLength + wallWidth, encHeight]);

        difference() {
            cube([wallWidth, facePlateLength, encHeight]);
                
            if (includeImage)
            {
                lengthResize = fitLogoToLength ? facePlateLength - wallWidth : 0;
                heightResize = fitLogoToLength ? 0 : encHeight - wallWidth;

                imgDepth = 0.5;
                translate([imgDepth, facePlateLength / 2, encHeight / 2])
                    rotate([90, 0, 90])
                    resize([lengthResize, heightResize, 0], auto=[true,true,false])
                    linear_extrude(imgDepth + 1)
                    import(logoPath, center=true);
            }
        }
    }
}

// draw the enclosure
if (includeEnclosure)
difference()
{
    mod = wallWidth * 2;
    
    rrect(cornerCurveRadius, encWidth, encLength, encHeight);
    translate([wallWidth, wallWidth, wallWidth])
        rrect(cornerCurveRadius, encWidth - mod, encLength-mod, encHeight);

    pcbHeight = 1.6;
    translate([(encWidth / 2), 0, wallWidth + pcbHeight])
        microUsbCutout();

    // cut out the front plate so we can print it separately
    if (includeFaceplate || cutOutFaceplate)
    translate([encWidth - wallWidth, wallWidth * 2, 0])
        rotate([0, 0, 0])
        facePlate(false);
}

if (includePosts)
// simplify the internal math a bit, account for the wall/floor heights
translate([wallWidth, wallWidth, 0])
{
    for (i = [0:(columnCount-1)])
    {
        for (j = [0:(rowCount-1)])
        {
            x = (keycapWidth * j) + (keycapWidth / 2) + distanceFromWalls + (spaceBetweenCaps * j);
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
}

// create a structure inside the enclosure that the switches can attach to
if (includeSwitchInsert)
translate([encWidth + 5, 0, 0])
difference() {
    mod = wallWidth * 2;
    rrect(cornerCurveRadius, encWidth - mod, encLength - mod, 5);

    for (i = [0:(columnCount-1)])
    {
        for (j = [0:(rowCount-1)])
        {
            x = (keycapWidth * j) + (keycapWidth / 2) + distanceFromWalls + (spaceBetweenCaps * j);
            y = (keycapWidth * i) + (keycapWidth / 2) + distanceFromWalls + (spaceBetweenCaps * i);

            translate([x, y, 0])
                cube([switchWidth, switchWidth, 10], center=true);
        }
    }
}

// add the faceplate, rotated on its back for easy printing
if (includeFaceplate)
translate([(encWidth * 2) + 5 + encHeight, 0, 0])
    rotate([0, -90, 0])
    facePlate();