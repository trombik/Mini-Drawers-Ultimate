WRKSRC= src
OPENSCADPATH=   src/lib/Chamfers-for-OpenSCAD
MAGNET_R?=	5.15
MAGNET_FLAGS?=	-D use_magnet=true -D magnet_is_droppedin=true -D magnet_r=${MAGNET_R}
XY_FLAGS?=	-D num_x=1 -D num_y=1

OPENSCAD_DRAWER_FLAGS?= ${XY_FLAGS} ${MAGNET_FLAGS} -D use_label=false -D use_num_x_handles=false -D slot_partition='[1]'
OPENSCAD_HOUSE_FLAGS?=  ${XY_FLAGS} ${MAGNET_FLAGS} -D house_wall_thickness_b=2 -D house_depth=57 -D stopper_height=1.5
OPENSCAD_BIN?=   openscad

TARGETS=	drawer.stl drawer.png house.stl house.png

all:	${TARGETS}

drawer.stl drawer.png: ${WRKSRC}/drawer.scad
	env OPENSCADPATH=${OPENSCADPATH} ${OPENSCAD_BIN} --render ${OPENSCAD_DRAWER_FLAGS} -o ${.TARGET} ${WRKSRC}/drawer.scad

house.stl house.png: ${WRKSRC}/house.scad
	env OPENSCADPATH=${OPENSCADPATH} ${OPENSCAD_BIN} --render ${OPENSCAD_HOUSE_FLAGS} -o ${.TARGET} ${WRKSRC}/house.scad

clean:
	rm -f ${TARGETS}

# vim: noexpandtab
