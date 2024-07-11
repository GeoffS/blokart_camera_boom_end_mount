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
caameraMountBoltHeadDia = 12; // 1/4-20 Button-Head hex


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
    cameraMountSurfaceXform() 
    {
        tcy([0,0,-50], d=cameraMountBoltDia-dOD, h=100);
        tcy([0,0,-100+cameraMountSurfaceY-6], d=caameraMountBoltHeadDia, h=100);
    }
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

// cameraMount() variables:
mr = 4.9;
md = 2*mr;
cameraMountOD = cameraAdapterDia + md;
echo("cameraMountOD = ", cameraMountOD);

module cameraMount()
{
    d1 = cameraAdapterDia;

    dh1 = cameraMountBoltDia;
    dh2 = caameraMountBoltHeadDia;

    difference()
    {
        minkowski() 
        {
            difference()
            {
                hull()
                {
                    translate([0,0,-d1/2]) cylinder(d=d1, h=d1);
                    translate([0,-d1/2,0]) rotate([-90,0,0]) cylinder(d=d1, h=d1);
                }

                translate([0,0,-10-mr]) cylinder(d=dh2+md, h=200);
                rotate([-90,0,0]) translate([0,0,-10-mr]) cylinder(d=dh2+md, h=200);

                rotate([45,0,0]) translate([-200,0,-200]) cube(400);
            }

            sphere(r=mr);
        }

        chamferOffsetZ = (cameraMountOD/2)/tan(45);
        // chamferOffsetZ = 20.92;
        echo("chamferOffsetZ = ", chamferOffsetZ);
        translate([0,0,-d1/2-10-chamferOffsetZ]) difference()
        {
            cylinder(d=100, h=50);
            translate([0,0,10]) cylinder(d1=0, d2=100, h=50);
        }

        translate([0,0,-100]) cylinder(d=dh1, h=200);
        translate([0,0,-10]) cylinder(d=dh2, h=200);
        rotate([-90,0,0])
        {
            translate([0,0,-100]) cylinder(d=dh1, h=200);
            translate([0,0,-10]) cylinder(d=dh2, h=200);
        }
    }
}

    // difference()
    // {
    //     hull()
    //     {
    //         simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylOD, cz=bodyCylCZ);
    //         cameraMountXform() simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylOD, cz=bodyCylCZ);
    //     }

    //     // Trim off the diagonal:
    //     rotate([-45,0,0]) tcu([-200, -15.55, -200], 400);

    //     // Camera adapter bolt hole:
    //     tcy([0,0,-10], d=cameraMountBoltDia, h=100);
    //     tcy([0,0,-100+bodyCylOD-8.5], d=caameraMountBoltHeadDia, h=100);

    //     // Camera mount bolt hole:
    //     cameraMountXform()
    //     {
    //         tcy([0,0,-10], d=cameraMountBoltDia, h=100);
    //         tcy([0,0,-100+bodyCylOD-8.5], d=caameraMountBoltHeadDia, h=100);
    //     }
    // }
// }

module cameraMountXform()
{
    translate([0, bodyCylOD/2, bodyCylOD/2]) rotate([90,0,0]) children();
}

module clip(d=0)
{
	// tcu([-200, -400-d, -200], 400);
    // tcu([-200, -200, 0+d], 400);
    tcu([0-d, -200, -200], 400);

    // tcu([-200, -d, -200], 400);
    // tcu([0+d, -200, -200], 400);
}

if(developmentRender)
{
    $fa = 20;
    $fs = 2;

    display() cameraMount();
    displayGhost() cameraMountGhost();

	// display() pipeClamp();
    // displayGhost() rightAngleCameraMountGhost();
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

module cameraMountGhost()
{
    translate([0,0,-cameraMountOD/2 - 2]) cylinder(d=cameraAdapterDia, h=2);
}
