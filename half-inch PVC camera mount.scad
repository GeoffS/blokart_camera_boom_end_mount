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

bodyCylZ = cameraAdapterDia;
bodyCylOD = 50;
bodyCylCZ = 4;

clampBoltZ = 33;

module pipeClamp()
{
	difference()
    {
        union()
        {
            // Main body:
            translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);

            // Clamp-bolt:
            clampBoltXform() difference() 
            {
                cscz = 2;
                csd = max(clampBoltHeadDia, m6NutRecessOD+1) + 2*cscz;
                simpleChamferedCylinderDoubleEnded1(d=csd, h=clampBoltZ, cz=cscz);
            }
        }

        // Pipe:
        tcy([0,0,-100], d=pvcOD, h=200);

        // Clamping Split:
        tcu([0,-0.55,-100], [40, 1, 200]);

        // Clamp-Bolt hole:
        clampBoltXform() 
        {
            tcy([0,0,-100], d=clampBoltHoleDia, h=200);
            translate([0,0,clampBoltZ-m6NutRecessZ]) cylinder(d=m6NutRecessOD, h=20, $fn=6);
        }
    }
}

module clampBoltXform()
{
    translate([bodyCylOD/2, -clampBoltZ/2, 0]) rotate([-90,0,0]) children();
}

module cameraMount()
{
	
}

module clip(d=0)
{
	// tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	display() pipeClamp();
}
else
{
	if(makePipeClamp) pipeClamp();
    if(makeCameraMount) cameraMount();
}
