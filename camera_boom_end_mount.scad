include <../OpenScadDesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

bodyScrewOD = 6;

outhaulClearanceX = 3;
outhaulClearanceY = 25;

boomDia = 31;

bodyCylZ = 40;
bodyCylOD = 50;
bodyCylCZ = 4;

bodySplitY = 10;
screwSplitY = outhaulClearanceY;

bodyScrewHoleDia = bodyScrewOD + 0.2;

screwCylCY = 1;
screwCylOD = bodyScrewHoleDia + 6 + 2*screwCylCY;
screwCylY = bodyCylOD;

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

    difference()
    {
        bodyScrewXform() simpleChamferedCylinderDoubleEnded1(d=screwCylOD, h=screwCylY, cz=screwCylCY);
        tcu([-200, -outhaulClearanceY/2, -200], 400);
    }
}

module bodyScrewXform()
{
    x = boomDia/2 + bodyScrewHoleDia/2 + outhaulClearanceX;
    doubleX() translate([x, -screwCylY/2, 0]) rotate([-90,0,0]) children();
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
    bodyCore();
}

module bottom()
{
    mirror([0,1,0]) bodyCore();
}

module clip(d=0)
{
	//tc([-200, -400, -10], 400);
}

if(developmentRender)
{
	display() top();
    display() bottom();

    displayGhost() boomGhost();
    displayGhost() outhaulGhost();
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