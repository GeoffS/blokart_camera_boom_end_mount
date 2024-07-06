include <../OpenScadDesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

bodyScrewOD = 6;
m6NutRecessOD = 11.4;
m6NutRecessZ = 6;

outhaulClearanceX = 3;
outhaulClearanceY = 25;

boomDia = 31;

bodyCylZ = 40;
bodyCylOD = 50;
bodyCylCZ = 4;

bodySplitY = 11;
screwSplitY = outhaulClearanceY;

bodyScrewHoleDia = bodyScrewOD + 0.2;

screwCylCY = 2;
screwCylOD = bodyScrewHoleDia + 6 + 2*screwCylCY;
screwTotalCylY = bodyCylOD;
screwCylY = screwTotalCylY/2 - outhaulClearanceY/2;

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
    difference()
    {
        translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
        doubleX() tcu([boomDia/2, -200, -200], 400);
        tcu([-200, -bodySplitY/2, -200], 400);
    }

    hull()
    {
        bodyScrewXform() simpleChamferedCylinderDoubleEnded1(d=screwCylOD, h=screwCylY, cz=screwCylCY);

        difference()
        {
            translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
            tcu([-200, -screwSplitY/2, -200], 400);
        }
    }
}

module bodyScrewXform()
{
    x = boomDia/2 + bodyScrewHoleDia/2 + outhaulClearanceX;
    doubleX() translate([x, -screwTotalCylY/2, 0]) rotate([-90,0,0]) children();
}

module boom()
{
    tcy([0,0,-100], d=boomDia, h=200);
}

module screws()
{
    bodyScrewXform() tcy([0,0,-100], d=bodyScrewHoleDia, h=200);
}

module top()
{
    difference()
    {
        bodyCore();
        bodyScrewXform() translate([0,0,-20+m6NutRecessZ]) cylinder(d=m6NutRecessOD, h=20, $fn=6);
    }
}

module bottom()
{
    mirror([0,1,0]) bodyCore();
}

module clip(d=0)
{
	tc([-200, -200, 0], 400);
}

if(developmentRender)
{
	display() top();
    display() bottom();

    displayGhost() boomGhost();
    displayGhost() outhaulGhost();
    displayGhost() bodyScrewGhost();
}
else
{
	bodyCore();
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