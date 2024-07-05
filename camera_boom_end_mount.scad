include <../OpenScadDesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

boomDia = 31;

bodyCylZ = 40;
bodyCylOD = 50;
bodyCylCZ = 4;

splitY = 10;

module mount()
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
        hull()
        {
            translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
        }
        doubleX() tcu([boomDia/2, -200, -200], 400);
    }
}

module boom()
{
    tcy([0,0,-100], d=boomDia, h=200);
}

module screws()
{
    
}

module top()
{
    difference()
    {
        mount();
        tcu([-200, -splitY/2, -200], 400);
    }
}

module bottom()
{
    difference()
    {
        mount();
        tcu([-200, splitY/2-400, -200], 400);
    }
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
}
else
{
	mount();
}

module boomGhost()
{
    tcy([0,0,-20], d=boomDia, h=100);
}