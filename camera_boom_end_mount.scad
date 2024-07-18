include <../OpenScadDesigns/MakeInclude.scad>
include <../OpenScadDesigns/chamferedCylinders.scad>

firstLayerZ = 0.3;
upperLayersZ = 0.2;

bodyScrewOD = 6;
m6NutRecessOD = 11.5;
m6NutRecessZ = 6.2;

outhaulClearanceX = 2;
outhaulClearanceY = 27;

makeTop = false;
makeBottom = false;
// Commented-out because they take forever to render:
// makeDrillGuide = false;
// makeDrillSupport = false;

boomDia = 31;

pvcOD = 21.8;

bodyCylZ = 40;
bodyCylOD = 50;
bodyCylCZ = 4;

bodySplitY = 11;
screwSplitY = outhaulClearanceY;

bodyScrewHoleDia = bodyScrewOD + 0.4;

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
    doubleX() bodyScrewXform() simpleChamferedCylinderDoubleEnded1(d=screwCylOD, h=screwCylY, cz=screwCylCY);

    difference()
    {
        translate([0,0,-bodyCylZ/2]) simpleChamferedCylinderDoubleEnded1(d=bodyCylOD, h=bodyCylZ, cz=bodyCylCZ);
        tcu([-200, -screwSplitY/2, -200], 400);
    }
}

module bodyScrewXform()
{
    translate([screwCtrsOffsetX, -screwTotalCylY/2, 0]) rotate([-90,0,0]) children();
}

module boom()
{
    tcy([0,0,-100], d=boomDia, h=200);
}

module screws()
{
    doubleX() bodyScrewXform() tcy([0,0,-10], d=bodyScrewHoleDia, h=200);
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
        doubleX() bodyScrewXform() translate([0,0,-20+m6NutRecessZ]) rotate([0,0,30]) cylinder(d=m6NutRecessOD, h=20, $fn=6);

        // PVC m6 set-screw:
        translate([0,0,0]) rotate([90,0,0]) cylinder(d=5.5, h=30);
    }

    // Sacrificial layer in nut recess:
    bodyScrewXform() tcy([0,0,m6NutRecessZ], d=8, h=upperLayersZ);
}

module angledTop()
{
    difference()
    {
        union()
        {
            boomPart();
            hull()
            {
                screwPart();
                pvcX = 65; //2*screwCtrsOffsetX + screwCylOD;
                echo(str("pvcX (angled) = ", pvcX));
                pcvOffsetX = -pvcX/2 - 16.45;
                pvcCylOD = min(pvcOD+14, bodyCylZ * (1/cos(22.5)));
                echo(str("pvcCylOD = ", pvcCylOD));
                angledPvcXform() translate([0,0,pcvOffsetX]) rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded1fn(d=pvcCylOD, h=pvcX, cz=4, fn=8);
            }
        }

        // PVC tube opening with flat to make it printable:
        angledPvcXform() translate([0,0,-100]) hull()
        {
            cylinder(d=pvcOD, h=200);
            x = 8; //m6NutRecessOD + 1;
            tcu([-x/2, 0, 0], [x, pvcOD/2, 200]);
        }

        boom();
        screws();

        // Nut recesses:
        shortNutRecessH = 20;
        longNutRecessH = 35;
        // bodyScrewXform() translate([0,0,-shortNutRecessH+m6NutRecessZ]) rotate([0,0,30]) cylinder(d=m6NutRecessOD, h=shortNutRecessH, $fn=6);
        nutRecess(shortNutRecessH);
        mirror([1,0,0]) nutRecess(longNutRecessH);

        // PVC m6 set-screw:
        translate([0,0,0]) rotate([90,0,0]) cylinder(d=5.5, h=30);
    }

    // Sacrificial layer in nut recess:
    bodyScrewXform() tcy([0,0,m6NutRecessZ], d=8, h=upperLayersZ);
}

module nutRecess(nutRecessH)
{
    bodyScrewXform() translate([0,0,-nutRecessH+m6NutRecessZ]) rotate([0,0,30]) 
    {
        // Nut recess:
        cylinder(d=m6NutRecessOD, h=nutRecessH, $fn=6);
        hull()
        {
            extraOffset = 6;
            // Tapered nut "starter" section:
            tcy([0,0,nutRecessH-extraOffset], d=m6NutRecessOD, h=1, $fn=6);
            tcy([0,0,0], d=m6NutRecessOD+1, h=nutRecessH-extraOffset-4);
        }
    }
}

pvcAngle = 25;

module angledPvcXform()
{
    pvcOffsetY = bodyCylOD/2 + pvcOD/2 + 11;
    echo(str("pvcOffsetY-pvcOD/2-boomDia/2 = ", pvcOffsetY-pvcOD/2-boomDia/2));
    rotate([0,0,pvcAngle]) translate([0, -pvcOffsetY, 0]) rotate([0,90,0]) children();
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

module drillGuideBottom()
{
    difference()
    {
        doMink = true;

        drillDia = 6.4;

        minkDia = 6;

        x = pvcOD + minkDia;
        y = pvcOD/2 + 5;
        z = 2*screwCtrsOffsetX + drillDia + 10 - minkDia;
        minkowski() 
        {
            difference()
            {
                tcu([-x/2,0,-z/2], [x, y, z]);
                // PVC Tube:
                tcy([0,0,-100], d=pvcOD+minkDia, h=400);

                
            }
            if(doMink) sphere(d=minkDia);
        }

        // Trim top and botttom "roundness":
        tcu([-200, -400, -200], 400);
        tcu([-200, y, -200], 400);
    }
}

module drillGuideTop()
{
    difference()
    {
        drillGuideBottom();
        // Drill guides:
        doubleZ() translate([0,0,screwCtrsOffsetX]) rotate([-90,0,0]) cylinder(d=6.4, h=100);
    }
}

module roundedCornerBox(x, y, z, r)
{
    x1 = r;
    y1 = r;

    x2 = x - r;
    y2 = y - r;

    hull()
    {
        tcy([x1, y1, 0], d=2*r, h=z);
        tcy([x1, y2, 0], d=2*r, h=z);
        tcy([x2, y1, 0], d=2*r, h=z);
        tcy([x2, y2, 0], d=2*r, h=z);
    }
}

module clip(d=0)
{
	tc([-200, -200, -d], 400);
}

if(developmentRender)
{
    // display() drillGuideBottom();


    // display() drillGuideTop();
    // displayGhost() mirror([0,1,0]) drillGuideBottom();
    // displayGhost() drillGuidePvcGhost();


	display() angledTop();
    // display() top();
    // display() bottom();

    displayGhost() boomGhost();
    displayGhost() outhaulGhost();
    displayGhost() bodyScrewGhost();
    // displayGhost() pvcGhost();
    displayGhost() angledPvcGhost();
}
else
{
	if(makeTop) rotate([90,0,0]) top();
    if(makeBottom) rotate([-90,0,0]) bottom();
    if(makeDrillGuide) rotate([-90,0,0]) drillGuideTop();
    if(makeDrillSupport) rotate([-90,0,0]) drillGuideBottom();
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
    doubleX() bodyScrewXform() tcy([0,0,-10], d=bodyScrewOD, h=100);
}

module angledPvcGhost()
{
    angledPvcXform() tcy([0,0,-50], d=pvcOD, h=200);
}

module pvcGhost()
{
    rotate([0,0,0]) pvcXform() tcy([0,0,-35], d=pvcOD, h=200);
}

module drillGuidePvcGhost()
{
    tcy([0,0,-100], d=pvcOD, h=200);
}