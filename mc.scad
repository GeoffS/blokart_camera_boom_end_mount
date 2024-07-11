// $fa = 20;
// $fs = 3;

// $fa = 6;
// $fs = 1;

cameraAdapterDia = 31;

mr = 4.9;
md = 2*mr;
d = cameraAdapterDia + md;
echo("d = ", d);

d1 = d - md;

dh1 = 6.6;
dh2 = 12;

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

    chamferOffsetZ = (d/2)/tan(45);
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

    echo("-d/2 - 2 = ", -d/2 - 2);
    %translate([0,0,-d/2 - 2]) cylinder(d=cameraAdapterDia, h=2);
}