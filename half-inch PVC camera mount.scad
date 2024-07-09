include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

makePipeClamp = false;
makeCameraMount = false;

pvcOD = 21.8;

clampBoltHeadDia = 11;
clampBoltOD = 6;
clampBoltHoleDia = clampBoltOD + 0.4;
m6NutRecessOD = 11.5;
m6NutRecessZ = 6.2;

cameraAdapterDia = 34;
cameraMountBoltDia = 6.5;


bodyCylCZ = 3;
bodyCylZ = (cameraAdapterDia + 2*bodyCylCZ); // * (1/cos(22.5));
bodyCylOD = 50;

clampBoltCylZ = 32.2;
clampBoltCylCZ = 2;
clampBoldFaceDia = max(clampBoltHeadDia, m6NutRecessOD+1);
clampBoltCylDia = clampBoldFaceDia + 2*clampBoltCylCZ;
clampBoltCylCtr = bodyCylOD/2 - clampBoltCylDia/2 - 0.5;


cameraMountSurfaceY = 20;

cameraMountSurfaceOffsetX = -pvcOD/2 - cameraMountBoltDia/2 - 3.5;
cameraMountSurfaceOffsetY = -bodyCylOD/2 + cameraMountSurfaceY; // -bodyCylZ/2; // + cameraMountSurfaceY;

module pipeClamp()
{
	difference()
    {
        union()
        {
            mainBody();

            // Clamp-bolt:
            clampBoltXform() difference() 
            {
                hull()
                {
                    simpleChamferedCylinderDoubleEnded1(d=clampBoltCylDia, h=clampBoltCylZ, cz=clampBoltCylCZ);
                    translate([-12.4,0,0]) difference()
                    {
                        simpleChamferedCylinderDoubleEnded1(d=bodyCylZ, h=clampBoltCylZ, cz=clampBoltCylCZ);
                        tcu([-400,-200,-200], 400);
                    }
                }
                doubleY() tcu([-200,bodyCylZ/2-bodyCylCZ,-200], 400);

                // // Check on 45 degree angle of the clamp-cylinder extension:
                // xy = 13;
                // %rotate([0,0,45]) tcu([-xy/2, -xy/2, 0], [xy, xy, 80]);
            }

            // Rotating camera-mount surface:
            hull()
            {
                cameraMountSurfaceXform() rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded1(d=bodyCylZ * (1/cos(22.5)), h=cameraMountSurfaceY, cz=bodyCylCZ, $fn=8);
                difference()
                {
                    mainBody();
                    tcu([0,-200,-200], 400);
                }
            }
        }

        // Pipe:
        tcy([0,0,-100], d=pvcOD, h=200);

        // Clamping Split:
        tcu([0,-0.55,-100], [40, 1, 200]);

        // Clamp-Bolt hole:
        clampBoltXform() 
        {
            // Bolt:
            tcy([0,0,-100], d=clampBoltHoleDia, h=200);
            // Nut:
            translate([0,0,clampBoltCylZ]) rotate([0,0,0]) 
            {
                tcy([0, 0, -m6NutRecessZ], d=m6NutRecessOD, h=20, $fn=6);
            }
            // Both faces:
            clampBoltFaceChamfer();
            translate([0,0,clampBoltCylZ]) mirror([0,0,1]) clampBoltFaceChamfer();
        }

        cameraMountSurfaceBoltHole();
    }
}

module cameraMountSurfaceBoltHole(dOD=0)
{
    cameraMountSurfaceXform() tcy([0,0,-50], d=cameraMountBoltDia-dOD, h=100);
}

module mainBody()
{
    translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
}

module cameraMountSurfaceXform()
{
    translate([cameraMountSurfaceOffsetX, cameraMountSurfaceOffsetY, 0]) rotate([90,0,0]) children();
}

module clampBoltFaceChamfer()
{
    translate([0,0,-20]) simpleChamferedCylinderDoubleEnded1(d=clampBoldFaceDia+20+0.8, h=20, cz=10); 
}

module clampBoltXform()
{
    translate([clampBoltCylCtr, -clampBoltCylZ/2, 0]) rotate([-90,0,0]) children();
}

module cameraMount()
{
	
}

module clip(d=0)
{
	// tc([-200, -400-d, -200], 400);
    // tcu([-200, -200, 0+d], 400);
}

if(developmentRender)
{
	display() pipeClamp();
    displayGhost() rightAngleCameraMountGhost();
}
else
{
	if(makePipeClamp) pipeClamp();
    if(makeCameraMount) cameraMount();
}

module rightAngleCameraMountGhost()
{
    difference() 
    {
        cameraMountSurfaceXform() tcy([0,0,cameraMountSurfaceY], d=cameraAdapterDia, h=2);
        cameraMountSurfaceBoltHole(dOD=-0.01);
    }
}
