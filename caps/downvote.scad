include <../KeyV2/includes.scad>

$font_size=3;
rounded_cherry() front_legend("[dup]") key(inset=true)
{
    translate([0, 0, -0.5])
    linear_extrude(3)
    import("../Stacks-Icons/src/Icon/ArrowDown.svg", center=true);
};