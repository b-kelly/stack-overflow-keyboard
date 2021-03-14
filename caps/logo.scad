include <../KeyV2/includes.scad>

rounded_cherry() key(inset=true) {
    translate([0, 0, -0.5])
    linear_extrude(3)
    import("../Stacks-Icons/src/Icon/LogoGlyph.svg", center=true);
};