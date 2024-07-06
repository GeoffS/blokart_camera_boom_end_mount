include <../OpenScadDesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

bodyScrewOD = 6;
m6NutRecessOD = 11.4;
m6NutRecessZ = 6;

outhaulClearanceX = 3;
outhaulClearanceY = 25;

makeTop = false;
makeBottom = false;

boomDia = 31;

pvcOD = 21.8;

bodyCylZ = 40;
bodyCylOD = 50;
bodyCylCZ = 4;

bodySplitY = 11;
screwSplitY = outhaulClearanceY;

bodyScrewHoleDia = bodyScrewOD + 0.2;

screwCylCY = 2;
screwCylOD = bodyScrewHoleDia + 8 + 2*screwCylCY;
screwTotalCylY = bodyCylOD;
screwCylY = screwTotalCylY/2 - outhaulClearanceY/2;

screwCtrsOffsetX = boomDia/2 + bodyScrewHoleDia/2 + outhaulClearanceX;
    
module bodyCore()
{
    difference()
    {
        exterior();
        boom();
        screws();
    }
}

module exterior()
{
    boomPart();
    hull() screwPart();
}

module boomPart()
{
    difference()
    {
        union()
        {
            translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
        }
        doubleX() tcu([boomDia/2, -200, -200], 400);
        tcu([-200, -bodySplitY/2, -200], 400);
    }
}

module screwPart()
{
    bodyScrewXform() simpleChamferedCylinderDoubleEnded1(d=screwCylOD, h=screwCylY, cz=screwCylCY);

    difference()
    {
        translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
        tcu([-200, -screwSplitY/2, -200], 400);
    }
}

module bodyScrewXform()
{
    doubleX() translate([screwCtrsOffsetX, -screwTotalCylY/2, 0]) rotate([-90,0,0]) children();
}

module boom()
{
    tcy([0,0,-100], d=boomDia, h=200);
}

module screws()
{
    bodyScrewXform() tcy([0,0,-10], d=bodyScrewHoleDia, h=200);
}

module top()
{
    difference()
    {
        union()
        {
            boomPart();
            hull()
            {
                screwPart();
                pvcX = 2*screwCtrsOffsetX + screwCylOD;
                pvcCylOD = min(pvcOD+14, bodyCylZ * (1/cos(22.5)));
                echo(str("pvcCylOD = ", pvcCylOD));
                pvcXform() translate([0,0,-pvcX/2]) rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded1fn(d=pvcCylOD, h=pvcX, cz=4, fn=8);
            }
        }

        // PVC tube opening with flat to make it printable:
        pvcXform() translate([0,0,-100]) hull()
        {
            cylinder(d=pvcOD, h=200);
            x = 8; //m6NutRecessOD + 1;
            tcu([-x/2, 0, 0], [x, pvcOD/2, 200]);
        }

        boom();
        screws();

        // Nut recesses:
        bodyScrewXform() translate([0,0,-20+m6NutRecessZ]) rotate([0,0,30]) cylinder(d=m6NutRecessOD, h=20, $fn=6);

        // PVC m6 set-screw:
        translate([0,0,0]) rotate([90,0,0]) cylinder(d=5.6, h=30);
    }

    // Sacrificial layer in nut recess:
    bodyScrewXform() tcy([0,0,m6NutRecessZ], d=8, h=upperLayersZ);
}

module pvcXform()
{
    pvcOffsetY = bodyCylOD/2 + pvcOD/2 + 1;
    echo(str("pvcOffsetY-pvcOD/2-boomDia/2 = ", pvcOffsetY-pvcOD/2-boomDia/2));
    translate([0, -pvcOffsetY, 0]) rotate([0,90,0]) children();
}

module bottom()
{
    mirror([0,1,0]) difference()
    {
        union()
        {
            boomPart();
            hull() screwPart();
        }
        boom();
        screws();
    }
}

module clip(d=0)
{
	tc([-200, -200, -d], 400);
}

if(developmentRender)
{
	display() top();
    display() bottom();

    displayGhost() boomGhost();
    displayGhost() outhaulGhost();
    // displayGhost() bodyScrewGhost();
    // displayGhost() pvcGhost();
}
else
{
	if(makeTop) rotate([90,0,0]) top();
    if(makeBottom) rotate([-90,0,0]) bottom();
}

module boomGhost()
{
    tcy([0,0,-20], d=boomDia, h=100);
}

module outhaulGhost()
{
    doubleX() tcu([boomDia/2,-12,-20], [2, 24, 100]);
}

module bodyScrewGhost()
{
    bodyScrewXform() tcy([0,0,-10], d=bodyScrewOD, h=100);
}

module pvcGhost()
{
    mirror([0,1,0]) pvcXform() tcy([0,0,-35], d=pvcOD, h=200);
}