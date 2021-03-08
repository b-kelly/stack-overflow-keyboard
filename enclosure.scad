include <./includes.scad>

module post(h)
{
    x = postWidth;
    y = postWidth / 4;
    xh = x / 2;
    yh = y / 2;
    translate([-xh, -yh, 0])
    {
        cube([x, y, h]);
        translate([xh - yh, yh - xh, 0]) cube([y, x, h]);
    }
}

// draw the enclosure

difference()
{
    difference()
    {
        mod = wallWidth * 2;

        rrect(10, encLength, encWidth, encHeight);
        translate([wallWidth, wallWidth, wallWidth])
            rrect(10, encLength-mod, encWidth-mod, encHeight);
    }

    imgDepth = wallWidth / 2;
    translate([encLength - imgDepth, encWidth / 2, encHeight / 2])
        rotate([90, 0, 90])
        scale([1, 1, encHeight / 2])
        linear_extrude(imgDepth)
        import("./Stacks-Icons/src/Icon/Logo.svg", center=true);
}

// keep the math simple inside, center the posts here
translate([wallWidth + postWidth, wallWidth + postWidth, wallWidth])
{
    for (i = [0:(keyCount-1)])
    {
        x = (keycapWidth / 2);
        y = (keycapWidth * i) + (keycapWidth / 2);
        translate([x, y, 0])
            post(encHeight + switchStemHeight + lidHeight);
    }
}