include <../KeyV2/includes.scad>

difference()
{
    rounded_cherry() key(inset=true)
    {
        translate([0, 0, -0.5])
        linear_extrude(3)
        import("../Stacks-Icons/src/Icon/ArrowUp.svg", center=true);
    }

    front_placement()
    {
        translate([0, $inset_legend_depth, 0])
        rotate([90, 0, 0])
        linear_extrude(3)
        import("../Stacks-Icons/src/Icon/Bookmark.svg", center=true);
    }
}
