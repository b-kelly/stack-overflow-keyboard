# Stack Overflow Keyboard

## Building the stl files

Initialize the project recursively to pull in the required submodules.

```
> git clone --recurse-submodules
```

Open each `.scad` file with [OpenSCAD](https://www.openscad.org/), then:

1. Prerender the design and check for errors
   * `Design > Render`
2. Export the design as an stl
   * `File > Export > Export as stl...`