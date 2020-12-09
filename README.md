# Mini Drawers Ultimate

This repository contains OpenSCAD files from [Mini Drawers Ultimate](https://www.thingiverse.com/thing:1889761).

## Rationale

Thingiverse does not encourage designers to share original code or files.
Often, designers uploads STL files only. Some, the author of the original
design, upload original files so that others can re-mix the original, fix bugs,
adopt the design. However, it is really difficult to track changes, report
bugs, etc. I tried to rebuild STL files without success. The code uses an
external library, but the author did not include the library, nor mention the
version.  The code should be managed in Version Management System.

## Requirements

- openscad
- BSD make (optional, not GNU make)
- X server (optional)

## Usage

```console
git clone https://github.com/trombik/Mini-Drawers-Ultimate.git
cd Mini-Drawers-Ultimate
env OPENSCADPATH=src/lib/Chamfers-for-OpenSCAD openscad src/drawer.scad
env OPENSCADPATH=src/lib/Chamfers-for-OpenSCAD openscad src/house.scad
```

Or simply:

```console
make
```

If you want 2x1 version, then:

```console
make XY_FLAGS="-D num_x=2 -D num_y=1"
```

The command above creates `house.stl`, `house.png`, `drawer.stl`, and
`drawer.png`. As `OpenSCAD` cannot export images, X server is required.
