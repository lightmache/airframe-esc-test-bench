//Proteus Flying Wing
//Copyright: Kit Adams, Dunedin, New Zealand
// October 2016
// commercial use prohibited
//Uses:
// Naca4_sweep.scad - sweep library
// Code: Rudolf Huttary, Berlin 
// June 2015
// commercial use prohibited

//To do:

use <Naca_sweep.scad>
use <tools.scad>
use <naca4.scad>

include <MH_45.scad> //Airfoil
/* [Hidden] */
thickPercent = 9.85;   //should calculate this from the airfoil!

/* [Global] */
partToGenerate = "FuselageRear"; //[ShellOnly,FuselageRear,FuselageNose,FuselageHatch,RootWing,TipWing,Fin,Elevon,ServoGuard]
//Set partToGenerate = "" for experiments, e.g. to check hatch fit.

/* [Printer] */
printerMaxZ = 230;
//printerMaxZ = 200;
printerMaxX = 200;
printerMaxY = 200;
printerMaxXYLen = 0.85*sqrt(printerMaxX*printerMaxX+printerMaxY*printerMaxY);


//partToGenerate = -1;  //Testing!
//partToGenerate = ShellOnly;//RootWing;//ShellOnly; //Elevon;//;

fuselage =  partToGenerate == "FuselageRear" ||
            partToGenerate == "FuselageNose" ||
            partToGenerate == "FuselageHatch";

/* [Wing] */
rootChord = 200;
rootThick = (thickPercent*rootChord)/100;
tipChord = 0.65*rootChord;
tipScale = tipChord/rootChord;
washout = 3.5;
//sweepAtQuarterChord = 24;
sweep = 22;
dihedral = 1;

/* [Fin] */
flatPlateTip = false;
NACAFinCamber = 0;//0.009;   //+ve to generate inwards and upwards lift
tipSectionCutAngle = flatPlateTip ? 0 : 45; //Make the NACA foil blended into wing tip FDM printable in one piece
NACAFinAngle = 70;  //For NACA profile fins only, from horizontal
NACAFinThick = 0.08;
NACAFinAspectRatio = 1.2;//1.4

finAngle = 4; //For flat plate fins only, from vertical
finSpan = 20;         //Span used to blend tip foil into fin

CGPercent = 18;//20; //percentc
CGDimples = true;
CGDimpleDia = 3;
CGDimpleDepth = 10;


airfoil = rootChord*MH_45;

/* [Fuselage] */

bodyWidth = 120;
bodyH = 50;
noseLen = 90;
noseFlatness = 1.7;

rootWingOnBodyWidth = 6; //Attach this length of wing to the body to easy using tape to attach wings to body

span = bodyWidth+2*rootWingOnBodyWidth+4*printerMaxZ; //1000;
echo("span=",span);

spanIncludingTips = span + 108;
echo("spanIncludingTips=",spanIncludingTips);

trayMaxLen = 0.7*rootChord;

/* [Fuselage space] */
trayBodyLen = 90;
trayHeight = 30;
trayWidth = 60;

trayNoseHeight = 27;
trayNoseWidth = 35;
noseWeightD = 12.5;

skinThick = 0.4;
finThick = 1.0;

/* [Hidden] */
elevonLen = printerMaxZ;
elevonDifferential = 12.5;
elevonHingeRound = 0;
maxElevonDown = 30;
elevonChord = 0.25; //fraction of chord
elevDAtRoot = 8.97;
elevDAtTip = elevDAtRoot*tipChord/rootChord;
elevonEndToTip = 12;  //Provide room between servo horn and root section end to allow tip section to be taped to root section.
hingeGap = 0.4;
hornTipR = 4;
hornHoleD = 1.5+0.5;
hornH = 20+hornTipR;
hornThick = 1.5;

servoTol = 0.8;
servoW = 23+servoTol;
servoH = 23+servoTol;
servoThick = 12+0.7;
servoHHornBottom = 27.4+servoTol;
servoHHornTop = 34+servoTol;
servoFlangeW = 32.6+servoTol;
servoFlangeThick =2.5+0.5;
servoFlangeHBottom =16.0;
servoTopW = 15+3;
servoHornCenterFomLeadSide = 6;
servoAngleRange = 110;
servoHornLen = 18;
servoHornR = 5;
servoLeadH = 9;
servoLeadSpace = 27+servoTol-servoW;
servoLeadW = 11;
servoLeadThick = 3.5;

fingerGrips = false;
gripD = 20;
gripDepth = 20;

antennaD = 2+0.4;
antennaLen = 130;

//sparD = 5.82+(fuselage?0.55:0.35);
sparD = 5.08+(fuselage?0.55:0.45);
maxSparLen = 505;
tipJoinerD = 3+(fuselage?0.45:0.3)-0.1;
tipJoinerLen = 70;
rootJoinerLen = 40;
fuseJoinerD = 2+0.3-0.1;
fuseJoinerLen = 16;

alignersD = 2;

$fn = 48;

thickFrac = thickPercent/100;

wingLen = 0.5*(span-bodyWidth);
//sweep = atan(tan(sweepAtQuarterChord)+0.25*rootChord/wingLen*(1-tipScale));
//echo("sweep at leading edge=", sweep);

sparLenLeadingEdge = 0.542*wingLen;

elevonStartSpan = wingLen-elevonEndToTip-elevonLen;//wingLen/2;  //distance from root of wing to inner end of elevon (measured perpendicular to the root of the wing)
elevonStartFraction = elevonStartSpan/wingLen;

wingChordAtElevonStart =elevonStartFraction*tipChord + (1-elevonStartFraction)*rootChord;
elevonRootPos = (1-elevonChord)*rootChord;
elevonRootLen = elevonChord*rootChord;
elevD = (1-elevonStartFraction)*elevDAtRoot + elevonStartFraction*elevDAtTip;//Diameter of front of elevon at elevonStartFraction along wing
echo("elevD=",elevD);
bodyLen = noseLen+rootChord;

noseCutX = 0.1*rootChord;//-(printerMaxXYLen-rootChord);

duoStripWidth = 25.8+0.4;
duoStripLen = 11;
duoStripsThick = 5+0.3;


fuseInnerShellOffset = 6;

HatchFrontX = -0.25*noseLen;

//Make the hatch fit as noseLen varies by linearly interpolating between measured body fractions at
//noseLen = 140 and noseLen = 90.
bodyFrac140 = 0.27;
bodyFrac90 = 0.37;
HatchLen = bodyLen*(noseLen*(bodyFrac140-bodyFrac90)/(140-90)+bodyFrac90-90*(bodyFrac140-bodyFrac90)/(140-90));

trayFloorY = -0.17*bodyH;
//HatchHeight = 0.33*bodyH;

hatchAngle = -1;
HatchHeight = trayFloorY+trayNoseHeight-HatchFrontX*sin(hatchAngle);
hollowHatch = 1;//not a flat bottom

hatchRearShearAngle = -45;
hatchRearXPos = HatchLen-1*tan(-hatchRearShearAngle)*duoStripsThick;

guardHeight = hornH+((thickPercent/100)*(rootChord+tipChord)/2)/4; //assumes the horn is halfway along the wing
guardThick = 0.5;
guardWidthOverFullLen = 0.08;

//FlyingWing()

//Servo();
//ServoAndSparCutouts();

//example1(); 
//rotate([80, 180, 130])
//example2(); 
//foil();
//guard();

//WingBlank();


//Fin(tipChord);
//Elevon();
//translate([50,0,0])
//mirror([0,1,0])
// rotate([0,0,170])
//  Elevon();

//rotate([90,0,0]) FlyingWing();
//WingTip();
//Wing();

//TestSection();

//Hatch();
//HatchCutout(1);
//HatchCutout(0);

//HatchHalf();
//%Fuselage();

//FlyingWingHalf();
//FlyingWingHalf(1);

//Nose();

rootSectionStart = bodyWidth/2+rootWingOnBodyWidth;
rootSectionEnd = rootSectionStart+printerMaxZ;
tipSectionEnd = rootSectionEnd+printerMaxZ-(flatPlateTip?elevonEndToTip:0.5*(thickPercent/100)*tipChord*sin(tipSectionCutAngle)+0.4*elevonEndToTip);

//Section(tipSectionEnd,3*printerMaxZ); //fin  
//Section(rootSectionEnd,tipSectionEnd); //tip section

if(partToGenerate == "FuselageRear")
   FuseRear();
else if(partToGenerate == "FuselageNose")
   Nose();
else if(partToGenerate == "FuselageHatch")
   Hatch();
else if(partToGenerate == "RootWing")
   Section(rootSectionStart,rootSectionEnd,1); //root
else if(partToGenerate == "TipWing")
   Section(rootSectionEnd,tipSectionEnd); //tip section
else if(partToGenerate == "Fin")
   Section(tipSectionEnd,4*printerMaxZ); //fin   
else if(partToGenerate == "ServoGuard")
   WingServoGuard();
else if(partToGenerate == "Elevon")
   Elevon();
else if(partToGenerate == "ShellOnly")
	{
   rotate([90,0,0])
      FlyingWingShell();
	}
else
   {
   %FuselageShell();
   EquipmentTray(1); //cutOutHatch = 1
   }

module FlyingWingShell()
{
	WingShell();
//As of 2017.01.20, need to mirror WingShell separately from FuselageShell to avoid: 
//"ERROR: CGAL error in CGALUtils::applyBinaryOperator union: CGAL ERROR: assertion violation! Expr: itl != it->second.end() File: /opt/mxe/usr/x86_64-w64-mingw32.static/include/CGAL/Nef_3/SNC_external_structure.h Line: 1102 "
   mirror([0,0,1])
      WingShell();
   FuselageShell();
   mirror([0,0,1])
      FuselageShell();
}

//FlyingWingShell();

//WingServoGuard();
//GuardNacelle(rootChord);
//nacelle();

//Fuselage();

//FuseLeftRear();

//EquipmentTray(0);

//Joiner(40,tipJoinerD);

//WingBlankHalf();  //includes root section of length bodyWidth/2
//WingBlankInner();

//CG calculation
//N.B. this assumes the fuselage (or at least nose of the fuselage) does not generate
//significant lift forward of the wing's Mean Aerodynamic Chord, which is probably not
//true. Still, it seems to work reasonably well in practise.
//Copied from http://rcwingcog.a0001.net/V3_testing/?i=1
// rcwingcog@gmail.com 
cgInfo = CalcCGPos(CGPercent, sweep,span, bodyWidth, rootChord, tipChord);

echo("cgInfo =",cgInfo);
cg_dist = cgInfo[0][0];
wing_area = cgInfo[0][1];
echo("cg_dist=",cg_dist);
echo("Wing area[dm^2]=",wing_area);
echo("Wing area[square feet]=",0.107639*wing_area);


module ServoAndSparCutouts()
{
   translate([0,0,bodyWidth/2])
      rotate([0,0,-90])
         {
         ServoCutout();
         }
   MainSpar(true);
   #WingBlankInner();
}

//Test(bodyWidth/2,printerMaxZ);

//TestFuse();

module TestFuse()
{
intersection()
   {
   difference()
      {
      FuseLeft();
      translate([0.75*rootChord,0,bodyWidth/2])
         rotate([0,0,-90])
         Joiner(tipJoinerLen,tipJoinerD);
      }
   translate([0.55*rootChord,-2*bodyH,0.2*bodyWidth])
      cube([2*rootChord,4*bodyH,bodyWidth]);
   }
}

module Test(h1,h2)
{
      intersection()
         {
         translate([0,0,bodyWidth/2])
            rotate([0,0,-90])
               WingBlank();
         //();
         union()
            {
            Joiners(h1);
            if(h2 < span/2)
               Joiners(h2);
            }
         }
      }

module WingServoGuardPos() //in Wing coordinate system
{
translate([elevonStartSpan*tan(-dihedral),elevonStartSpan*tan(sweep),elevonStartSpan])
      rotate([0,-dihedral-0,washout*elevonStartFraction+2])
      rotate([0,90,0])
         children();
}

module WingServoGuard(assemble = false) //in Wing coordinate system
{
guardFullLen = wingChordAtElevonStart;
guardFullH = guardHeight+(1-elevonStartFraction)*rootThick;
   //Servo cutout
//#translate([(servoThick+0.5)/2-0.007*(rootChord+tipChord)/2+elevonStartSpan*sin(-dihedral),
difference()
   {
//   translate([elevonStartSpan*tan(-dihedral),elevonStartSpan*tan(sweep),elevonStartSpan])
//         rotate([0,-dihedral-0,washout*elevonStartFraction+2])
//         rotate([0,90,0])
   WingServoGuardPos()
            intersection()
               {
               GuardNacelle(guardFullLen);
               translate([-rootChord/2,0,0])
                  cube([rootChord,0.28*guardFullLen,guardFullH]);
               }
   //WingServoGuardPos()
      if(!assemble)
         {
         #WingBlank();
         intersection()
            {
            translate([2*skinThick,0,0])
            WingBlank();            
            #WingServoGuardPos()
               GuardNacelleHoles(guardFullLen);
            }
         }
    }
}

module GuardNacelleHoles(fullLen) //Glue holes
{
translate([0,0.1*fullLen,0])
   #cylinder(d = 2,h = 10);
translate([0,0.05*fullLen,0])
   #cylinder(d = 2,h = 10);
translate([0,0.03*fullLen,0])
   {
   translate([0.25*guardWidthOverFullLen*fullLen,0.14*fullLen,0])
      #cylinder(d = 2,h = 10);
   translate([0.25*guardWidthOverFullLen*fullLen,0.2*fullLen,0])
      #cylinder(d = 2,h = 10);
   translate([-0.25*guardWidthOverFullLen*fullLen,0.165*fullLen,0])
      #cylinder(d = 2,h = 10);
   translate([-0.25*guardWidthOverFullLen*fullLen,0.21*fullLen,0])
      #cylinder(d = 2,h = 10);
   }
}

module GuardNacelle(fullLen)
{
difference()
   {
   union()
   {
   difference()
      {
      difference()
         {
         nacelle(0,guardWidthOverFullLen,guardHeight,fullLen);
         //nacelle(guardThick,guardWidthOverFullLen,guardHeight,fullLen);
         }
//      extrudeBy = foilWidthRat*nacelleLen*2;
//      translate([extrudeBy/2,0,flatBottomY])
//      rotate([0,-90,0])
//      rotate([0,0,90])
//      linear_extrude(extrudeBy) polygon(innerRoot);
      }
   }
   }
//translate([-pressureSensorW/2,45,duolockThick+mountThick+1])
//   cube([pressureSensorW,pressureSensorLen,pressureSensorH]);
}


module nacelle(inset = 0,t = 0.25,guardHeight = 25, L = 100, N = 100)
{
outerPts = airfoil_data([0.0,0.0,t], L, N, false);
      
scale([1,1,2*(guardHeight/L)/t])
rotate([90,0,0])
rotate_extrude(convexity=10,$fn=100) 
rotate([0,0,-90])
   {
   intersection()
      {
//[Camber, Camber pos, thickness]
      //polygon(points = airfoil_data([0,0,t], L, N, open));
      offset(r=-inset)
         polygon(outerPts);
      square([L,t*L/2]);
      }
   }
}


module Nose()
{
difference()
   {
   union()
      {
      //FlyingWingHalf(0);
      FuseLeft();
      mirror([0,0,1])
         //FlyingWingHalf();
         FuseLeft();
      }

   //Section(0,bodyWidth/2);
   translate([noseCutX,-2*bodyH,-span])
      cube([2*rootChord,4*bodyH,span*2]);
   }
}

module FuseLeftRear()
{
intersection()
   {
   FuseLeft();
   translate([noseCutX,-2*bodyH,0])
      cube([2*rootChord,4*bodyH,bodyWidth]);
   }
}

module FuseRear()
{
FuseLeftRear();
mirror([0,0,1])
   FuseLeftRear();
}

module FuseLeft()
{
difference()
   {
   Section(0,bodyWidth/2+rootWingOnBodyWidth);
   #translate([noseCutX,0.1*bodyH,0.8*bodyWidth/2])
      rotate([60,0,0])
         rotate([0,90,0])
            FuseJoiner();  //cylinder(d=fuseJoinerD,h=fuseJoinerLen);

//Fix the joiner height as noseLen varies by linearly interpolating between measured height offsets at
//noseLen = 140 and noseLen = 90.
offset140 = 1;
offset90 = 1.5;
lambda = (noseLen-140)/(90-140);
offsetH = lambda*offset90 + (1-lambda)*offset140;

    #translate([noseCutX,trayFloorY-offsetH*fuseJoinerD,0])
      rotate([0,0,0])
         rotate([0,90,0])
            FuseJoiner();  //cylinder(d=fuseJoinerD,h=fuseJoinerLen);
  if(fingerGrips)
      #translate([0.33*rootChord,0,trayWidth/2+0.6])
         rotate([90,0,0])
            {
            intersection()
               {
               cylinder(d=gripD,h=gripDepth);
               translate([-gripD/2,0,0])
               cube([gripD,gripD/2,gripDepth]);
               }
            }
   if(CGDimples)
      difference()
         {
      #translate([cg_dist,0,bodyWidth/2-CGDimpleDia])
//      #translate([rootChord,0,bodyWidth/2]) testing!
         rotate([90,0,0])
            cylinder(d=CGDimpleDia,h=CGDimpleDepth);
         //FuseInner();
         blendFoils(offsetR = -1.5);
         }
   }
//anti-warp TE hold-down if printing on side
//#translate([rootChord-6,0,0]) scale([1.5,1,1]) cylinder(r=6,h=1);
}


module TestSectionMidJoin()
{
intersection()
   {
   //FlyingWingHalf();
   WingTip();
   //translate([])  cube([]);
   translate([-rootChord,-2*rootChord,wingLen/2+bodyWidth/2])
      cube([4*rootChord,4*rootChord,10]);
   }
}

module TestSectionFinJoin()
{
intersection()
   {
   //FlyingWingHalf();
   Section(rootSectionEnd,tipSectionEnd); //tip section
   //translate([])  cube([]);
   translate([-rootChord,-2*rootChord,wingLen+bodyWidth/2-21])  cube([4*rootChord,4*rootChord,17]);
   }
}


//TestSectionMidJoin();
//TestSectionFinJoin();


module WingBlankInner()
{
WingBlankHalf(-2*skinThick);
}

module Section(h1 , h2, TEHoldDown = 0)
{
h1wing = h1-bodyWidth/2;
h2wing = h2-bodyWidth/2;
h1wingfrac = h1wing/(wingLen);
h2wingfrac = h2wing/(wingLen);

h2Chord = h2wingfrac*tipChord+(1-h2wingfrac)*rootChord;
h1Chord = h1wingfrac*tipChord+(1-h1wingfrac)*rootChord;

fin = h1wing > 0.75*wingLen;

intersection()
   {
   FlyingWingHalf(0);
   difference()
      {
      if(tipSectionCutAngle==0 || h2wing < 0.75*wingLen)
         translate([-rootChord,-2*rootChord,h1])       
            cube([4*rootChord,4*rootChord,h2-h1]);
   
      else
         {
         if(fin)
            {
            hSheared = (h2-h1);
            translate([rootChord,h1*tan(dihedral),h1+0.5*hSheared])
            multmatrix(m = [ [1, 0, 0, 0],
                             [0, 1, 0, 0],                        
                             [0, tan(-tipSectionCutAngle), 1, 0],
                             [0, 0, 0,  1]
              ])
            //rotate([-35,0,0])
            cube([4*rootChord,4*rootChord,hSheared],true);
            }
         else
            union()
               {
               hSheared = 0.5*(h2-h1);
               translate([rootChord,h2*tan(dihedral),h1+1.5*hSheared])
               multmatrix(m = [ [1, 0, 0, 0],
                                [0, 1, 0, 0],                        
                                [0, tan(-tipSectionCutAngle), 1, 0],
                                [0, 0, 0,  1]
                 ])
               //rotate([-35,0,0])
               cube([4*rootChord,4*rootChord,hSheared],true);
               translate([-rootChord,-2*rootChord,h1])       
                  cube([4*rootChord,4*rootChord,0.75*(h2-h1)]);
      
               }
         }
      //if(h2 > 0.75*wingLen)
      intersection()
         {
         WingBlankInner();
         union()
            {
				MainSpar(true,h1,h2);
            if(h1 > 0 && h1wing < 0.75*wingLen)  //not needed unless printing fuselage on side
               Joiners(h1);
//            if(!flatPlateTip && h1wing > 0.75*wingLen)
//               {
//               //Aligners(
//               }
            if(h2wing < 0.75*wingLen)
               Joiners(h2);
            }
         }
      if(fin)
         Joiners(h1,-1,2); //bottom dimples
      }
   }
if(!fin && h2wing > 0.75*wingLen)
   #Joiners(h2,1,2); //top Bumps

if(TEHoldDown)
   {
//   translate([h1wing*sin(sweep),h1wing*sin(dihedral)+0.01*(rootChord+tipChord),h1])
   translate([h1wing*tan(sweep),h1wingfrac*h1Chord*sin(washout)+h1wing*tan(dihedral),h1])
      {
      #translate([1*h1Chord-6,0,0])
         scale([2,1,1])
         cylinder(r=6,h=0.6);
      }
   }
}

module Aligner(h, l = 0.5*thickFrac*tipChord,female = false)
{
//   linear_extrude(height = wingLen+0.07*tipChord*tan(finAngle), convexity = 5,twist = -washout, scale=[tipScale,tipScale], $fn=100)
tol = female?0.2:0;
hTol = female?0.75:0;
taper = 0.8;
translate([0,0,0.05*tipChord*thickFrac*tan(-tipSectionCutAngle)])
            multmatrix(m = [ [1, 0, 0, 0],
                             [0, 1, (1-taper)/2+tan(0.75*tipSectionCutAngle), 0],                        
                             [0, tan(-tipSectionCutAngle), 1, 0],
                             [0, 0, 0,  1]
              ])
linear_extrude(height = h+hTol,scale=[taper,taper],convexity = 5,$fn=100)
   square([3.5+tol,l+tol],true);
}

module Joiner(length , dia)
{
cylinder(d=dia,h=length,center=true);
difference()
   {
   cube([0.1,30,length+3],true);
   cube([30,30,1.2],true);
   }
}

module FuseJoiner(length=fuseJoinerLen , dia=fuseJoinerD)
{
cylinder(d=dia,h=length,center=true);
difference()
   {
   cube([11,0.1,length+3],true);
   cube([30,30,1.2],true);
   }
}

module Joiners(h,topBumps=0,aligners = 0)
{
alignersR = topBumps>0?alignersD/2:alignersD/2+0.15;
hwing = h-bodyWidth/2;
hRootJoin = bodyWidth/2+rootWingOnBodyWidth;
hwingfrac = hwing/(wingLen);
hChord = hwingfrac*tipChord+(1-hwingfrac)*rootChord;

function yCenterScaling(chordFrac) = chordFrac*hChord*hwingfrac*sin(washout)-0.25*elevD;
   
function zOffset(chordFrac) = tan(-tipSectionCutAngle)*chordFrac*hChord*hwingfrac*sin(washout);

translate([hwing*tan(sweep),hwing*tan(dihedral)+0.01*(rootChord+tipChord),h])
   {
   if(!topBumps)
      {
      joinerLen = (h > hRootJoin) ? tipJoinerLen : rootJoinerLen;
      if(h > hRootJoin)
         {
         translate([0.62*hChord,yCenterScaling(0.62),0])
            Joiner(tipJoinerLen,tipJoinerD);
         }
      #translate([0.2*hChord,yCenterScaling(0.2),0])
         Joiner(joinerLen,tipJoinerD);
      }
   if(topBumps!=0)
      {
      if(h > 0 && aligners==1)
         {
         translate([0.1*hChord,yCenterScaling(0.1),0]) sphere(alignersR);
         translate([0.32*hChord,yCenterScaling(0.32),0]) sphere(alignersR);
         translate([0.72*hChord,yCenterScaling(0.70),0]) sphere(alignersR);
         }
      if(h > 0 && aligners==2)
         {
         //translate([0.1*hChord,yCenterScaling(0.1),0]) sphere(alignersR);
         posFrac1 = 0.2;
         translate([posFrac1*hChord,yCenterScaling(posFrac1),zOffset(posFrac1)]) Aligner(h=2.5,l=0.5*thickFrac*tipChord,female = topBumps<0);
         posFrac2 = 0.5;
         translate([posFrac2*hChord,yCenterScaling(posFrac2),zOffset(posFrac2)]) Aligner(h=2.5,l=0.4*thickFrac*tipChord,female = topBumps<0);
         }
      }
   }
//Only needed if printing on side
//if(h <= 0)
//   {//Fuselage join
//   //translate([-0.85*noseLen,0,0]) FuseJoiner();//cylinder(d=fuseJoinerD,h=fuseJoinerLen);
//   translate([0.8*rootChord,0,0]) FuseJoiner();//cylinder(d=fuseJoinerD,h=fuseJoinerLen);
//   translate([0.8*noseCutX-1,-0.25*bodyH,0]) FuseJoiner();//cylinder(d=fuseJoinerD,h=fuseJoinerLen);
//   translate([0.8*noseCutX-1,0.52*bodyH,0]) FuseJoiner();;//cylinder(d=fuseJoinerD,h=fuseJoinerLen);
//   }  

}

module Hatch()
{
rotate([90,0,0])
rotate([0,0,-1*hatchAngle])
   {
   HatchHalf();
   mirror([0,0,1]) HatchHalf();
   }
}

module HatchHalf()
{
intersection()
   {
   if(hollowHatch)
      Fuselage(0);
   else
      blendFoils();
   HatchCutout(0);
   }
}

module HatchCutout(cutout = 1)
{
//cutout = 0; testing!
tol = cutout?0.15:0; //make sure the hatch is not too tight


//lenFrac = 0.4;
widthFrac = 0.6;
//backChamferFrac =1.1;
//linear_extrude(height = 0.3*bodyWidth/2, convexity = 5, $fn=100)
//   polygon([[0-0.1*noseLen,0],[lenFrac*(rootChord+noseLen),-0.05*bodyH],[backChamferFrac*lenFrac*(rootChord+noseLen),0.35*bodyH],[-0.04*(noseLen),0.35*bodyH]]);

//Shear 
length = HatchLen;
//Ensure the angle of the "V" in the fuselage is larger than in the hatch so that the
//front and tongue of the hatch make contact before the tip of the "V"
lenAngle = cutout?-45:-49;//-46;//-50:-53; //-25;//-52;
catchAngle = cutout?45:45;;//52;//-lenAngle; from vertical
widthAngle = 40;
//Testing
translate([-0*tol,0,0])
multmatrix(m = [ [1, 0, 0, 0],
                 [tan(hatchAngle), 1, 0, 0],
                 [0, 0, 1, 0],
                 [0, 0, 0,  1]
                 ])
translate([HatchFrontX-tol,HatchHeight-tol,0])
   {
   difference()
      {
      union()
         {
         multmatrix(m = [ [1, tan(lenAngle), 0, 0],
                          [0, 1, 0, 0],
                          [0, tan(widthAngle), 1, 0],
                          [0, 0, 0,  1]
                          ])
            {
            translate([0,0,-(widthFrac*bodyWidth/2)/2])
               cube([2*length,0.35*bodyH,widthFrac*bodyWidth/2]);
            //translate([length/2,0,-bodyWidth/4])
            //   cube([length,0.35*bodyH,bodyWidth/2]);
            }
         //Projecting hatch tongue
         multmatrix(m = [ [1, tan(catchAngle), 0, 0],
                          [0, 1, 0, 0],
                          [0, 0, 1, 0],
                          [0, 0, 0,  1]
                          ])
            {
  translate([-(0.2*bodyH),-0.35*bodyH*tan(lenAngle)*tan(hatchAngle),0])
            //translate([0.25*bodyH*sin(lenAngle)+0.25,-0.35*bodyH*sin(lenAngle)*sin(hatchAngle),0]) //hack hatch for first nose printed without 2*tol above!
               cube([length,0.35*bodyH,0.2*widthFrac*bodyWidth/2+tol]);
            //translate([length/2,0,-bodyWidth/4])
            //   cube([length,0.35*bodyH,bodyWidth/2]);
            }
         if(cutout)
            {
            //Platorm at rear for DuoStrip to stick on fuselage
            translate([-HatchFrontX,-duoStripsThick,0])
            multmatrix(m = [ [1, tan(-hatchRearShearAngle), 0, 0],
                             [0, 1, 0, 0],
                             [0, 0, 1, 0],
                             [0, 0, 0,  1]
                             ])
               cube([hatchRearXPos,duoStripsThick,duoStripWidth/2]);
            }
         }
      }
   }
}

module Fuselage(cutoutHatch = 1)
{
//trayLen = 0.7*bodyLen;
//trayHeight = 0.6*bodyH;
//trayWidth = 0.4*bodyWidth;

difference()
   {
   blendFoils();
   EquipmentTray(cutoutHatch);
   }

}

module FuseInner()
{
translate([0,0.2*fuseInnerShellOffset,0])
   blendFoils(offsetR = -fuseInnerShellOffset);
}

module EquipmentTray(cutoutHatch)
{
hatchLen = HatchLen;
noseJoinThick = 0.6;
intersection()
   {
	FuseInner();
   union()
      {
      translate([-0.75*noseLen,trayFloorY,0])
         {
         hull()
            {
            cube([trayBodyLen,trayNoseHeight,trayNoseWidth/2]);
            translate([-noseWeightD/2,0.4*trayNoseHeight,0])
                 {
                 sphere(d=noseWeightD);
                 //rotate([0,90,0]) cylinder(d=noseWeightD,h= noseWeightD/2+0.5);
                 }
            }
         }
      //intersection()
         {
         union()
            {
            hull()
               {
               translate([-0.33*0.75*noseLen,trayFloorY,0])
                   cube([noseLen/2-20,trayNoseHeight,trayNoseWidth/2]);
               translate([noseCutX+noseJoinThick,trayFloorY,0])
                  #cube([noseLen/2-20,trayNoseHeight,trayNoseWidth/2]);
               //translate([-0.6*noseLen,-0.17*bodyH,0])
               translate([-0.0*noseLen,trayFloorY,0])
                  cube([0.7*trayBodyLen,trayHeight,trayWidth/2]);
               translate([0,trayFloorY,0])
                  cube([hatchRearXPos-duoStripLen,trayHeight,duoStripWidth/2]);
               }
            hull()
               {
               translate([0.7*trayBodyLen,trayFloorY,0])
                  cube([0.1,0.6*trayHeight,trayWidth/2]);

               translate([0.85*trayMaxLen,trayFloorY,0])
                  cube([0.1,0.55*trayHeight,0.8*trayWidth/2]);
               translate([trayMaxLen,0,0])
                  cylinder(d=servoLeadThick,h=0.8*trayWidth/2);
               }
            //#translate([HatchFrontX,trayFloorY,0]) cube([hatchLen,1.0*trayHeight,1.0*trayWidth/2]);
            }
         //translate([noseCutX+noseJoinThick,-bodyH,-bodyWidth]) cube([bodyLen,2*bodyH,2*bodyWidth]);
         }
      }
   }
if(cutoutHatch)
   {
   HatchCutout(cutoutHatch);
   }

}


module FlyingWing()
{
FlyingWingHalf();
mirror([0,0,1])
   FlyingWingHalf();
}

module WingTip() //testing only
{
intersection()
   {
   difference()
      {
      union()
         {
         translate([0,0,bodyWidth/2])
         rotate([0,0,-90])
            {
            Wing();
   //         Elevon();
            }

   //      blendFoils();
         }
      MainSpar(true);
      }

   difference()
      {
      translate([-rootChord,-2*rootChord,wingLen/2+bodyWidth/2])
         cube([4*rootChord,4*rootChord,wingLen/2+finThick+2*tipChord*tan(finAngle)]);
  // translate([wingLen*sin(-dihedral),wingLen*sin(sweep),wingLen])
      translate([wingLen/2*tan(sweep),wingLen/2*tan(dihedral)+0.01*(rootChord+tipChord),wingLen/2+bodyWidth/2])
         {
         translate([0.1*(rootChord+tipChord)/2,0,0]) sphere(alignersD/2);
         translate([0.32*(rootChord+tipChord)/2,0,0]) sphere(alignersD/2);
         translate([0.66*(rootChord+tipChord)/2,0,0]) sphere(alignersD/2);
         #translate([0.56*(rootChord+tipChord)/2,0.28*(rootChord+tipChord)/2*sin(washout)-0.18*elevD,-tipJoinerLen/2])
            cylinder(d=tipJoinerD,h=tipJoinerLen);
         #translate([0.2*(rootChord+tipChord)/2,0.2*(rootChord+tipChord)/2*sin(washout)-0.18*elevD,-tipJoinerLen/2])
            cylinder(d=tipJoinerD,h=tipJoinerLen);
         }
      }
   }
}

module WingShell()
{
translate([0,0,bodyWidth/2])
rotate([0,0,-90])
	{
   Wing();
   Elevon();
   WingServoGuard(true);
	}
}

module FlyingWingHalf(assemble = 1)
{
difference()
   {
   union()
      {
      translate([0,0,bodyWidth/2])
      rotate([0,0,-90])
         {
         Wing();
         if(assemble)
            {
            Elevon();
            WingServoGuard(true);
            }
         }

      Fuselage();
      }
   translate([0,0,bodyWidth/2])
      rotate([0,0,-90])
         ServoCutout();
   //MainSpar(true);
   //Antenna tubes
   translate([0.07*rootChord,0,bodyWidth/2])
      rotate([0,0.7*sweep,0])
      #cylinder(d=antennaD,h=antennaLen,center=true);
   translate([0,-0.5*antennaD-0.8,0.3*bodyWidth/2])
      rotate([0,82,0])
      #cylinder(d=antennaD,h=rootChord);
   }
}

module WingBlankHalf(offsetr = 0)
{
rotate([0,0,-90])
   {
   RootWingBlank(offsetr);
   translate([0,0,bodyWidth/2])
         WingBlank(offsetr);
   }
}

sparChordPos = 1.45*tan(sweep)*rootChord;

module MainSpar(webbing = false,sectionWebbing1 = -1, sectionWebbing2 = -1)
{
sparLenInWing = sparLenLeadingEdge*cos(sweep);
sparLenO2 = min(sparLenInWing+bodyWidth/2,maxSparLen/2);
echo("SparLen = ",2*sparLenO2);
webbingGapAtSectionJoin = 1.2; //3 layers each side
webbingIntoFuse = 0.1*bodyWidth;
webbingBeyondSparEnd = 4;
webbingLen = sparLenO2+webbingBeyondSparEnd;
//intersection()
	{
	//#WingBlankInner();
	#translate([sparChordPos,0.5*tan(dihedral)*sparLenInWing+0.0072*rootChord-0,0])
		{
		cylinder(d=sparD, h= sparLenO2);
		if(webbing)
			difference()
				{
				translate([0,0,webbingLen/2])
					cube([0.1,30,webbingLen],true);
				union()
					{
					cube([30,30,bodyWidth-webbingIntoFuse],true);
					if(sectionWebbing1 >= 0)
						translate([0,0,sectionWebbing1])
							cube([30,30,webbingGapAtSectionJoin],true);
					if(sectionWebbing2 >= 0)
						translate([0,0,sectionWebbing2])
							cube([30,30,webbingGapAtSectionJoin],true);
					}
				}
			}
	}
}

module FuselageShell()
{
blendFoils();
}

module blendFoils(H = bodyWidth/2, yMax = bodyH, offsetR = 0)
{
airfoil = rootChord*MH_45;

//v1 = S_(2,3,1,airfoil);
//v1 = 2*airfoil;
xScale = (noseLen+rootChord)/rootChord;
yScale = yMax/rootThick;//2.2;
//echo(yScale);
ms = [[xScale,0],[0,yScale]];

profile1 = airfoil*ms;  //Profile at centre of fuselage
profile2 = airfoil;     //Profile at wing root

//This scale is a hack because I don't know how to achieve the effect of using offset() on a vector!
scale([1+4*offsetR/(noseLen+rootChord),1+2*offsetR/yMax,1+offsetR/H])
   translate([-noseLen,0,0])
      poly3dFromVectors(interp());

//function shape(z) = -pow(z,noseFlatness)*(pow(z,noseFlatness)-2);
function shapeFunc(z) = pow((sin((z-0.5)*(180-sweep/noseFlatness))+1)/2,noseFlatness);
function shape(z) = (shapeFunc(z)-shapeFunc(0))/(shapeFunc(1)-shapeFunc(0)); //normalise output to [0,1)
//function shape(z) = z; 

//Interpolate between 2 profiles using the shape function
function interp() = 
   [
   for (i=[0: 0.02 : 1+0.001])
      let(h = i*(H))
      let(f = shape(i))
      let(x = f*noseLen)
      T_(x,0,h, vec3D(vecInterp(profile1,profile2,f),0))
   ];
}

function FinNACA(chord = 100,N = len(airfoil), thick = NACAFinThick) = 
   airfoil_data([-NACAFinCamber,0.33,thick], chord, N, false);


finTopChordFrac = 0.65;  //fraction of chord at fin base
finFracTipChord = 0.63; //increasing this above 0.63 can cause CGAL errors
finBaseChord = finFracTipChord*tipChord;
finHeightFrac =  NACAFinAspectRatio;
finHeight = finBaseChord*finHeightFrac;

module BlendedFinTip(H = finSpan, NACAfin = true, endFlattener = false)
{
//xScale = tipChord/rootChord;
//yScale = xScale;//yMax/rootThick;//2.2;
//echo(yScale);
//ms = [[xScale,0],[0,yScale]];
   
finRaise = 0.1*tipChord;
finSweep = 22;
finSweepExtraForPrinting = 10; //S3D does not print the full TE. Stops when it gets too thin. This compensates somewhat.
finBlendAngle = 48;
finLEAngle = 60;
   

   
profile1 = (tipChord/rootChord)*airfoil;  //Profile at tip of wing
//profile2a = finFracTipChord*profile1;     //Profile at base of fin
ms = [[1,0],[0,-1]]; //make it go anti-clockwise like airfoil
//profile2 = profile2a*ms;
profile2 = FinNACA(finBaseChord)*ms;
//echo("len(airfoil)=",len(airfoil));
//echo("len(profile2)=",len(profile2));
//echo("profile2 =",profile2);
interpLen = tipChord-finFracTipChord*tipChord;

//This scale is a hack because I don't know how to achieve the effect of using offset() on a vector!
//scale([1+4*offsetR/(noseLen+rootChord),1+2*offsetR/yMax,1+offsetR/H])
//   translate([-noseLen,0,0])
      //rotate([NACAFinAngle,0,0])
      //hull()
      //{
      //poly3dFromVectors(interp(H));
      //poly3dFromVectors(interp(H+1.25*finThick));
      //}
//function shapeFunc(z) = -pow(z,noseFlatness)*(pow(z,noseFlatness)-2);
//function shapeFunc(z) = pow(1-sqrt(1-pow(z,2)),1);
function shapeFunc(z) = pow(z,3);
//function shapeFunc(z) = pow((sin((z-0.5)*(180-sweep/noseFlatness))+1)/2,noseFlatness);
function shape(z) = (shapeFunc(z)-shapeFunc(0))/(shapeFunc(1)-shapeFunc(0)); //normalise output to [0,1)
//function shape(z) = z; 

//Interpolate between 2 profiles using the shape function
function interp(hz) = 
   [
   for (i=[0: 1/20 : 1+0.001])
      let(f = shape(i))
      let(h = i*(hz))
      let(x = f*interpLen+h*tan(finSweep))
      let(y = f*finRaise)
      T_(x,y,h, Rx_(-i*NACAFinAngle,vec3D(vecInterp(profile1,profile2,f),0)))
//      T_(x,y,h, vec3D(vecInterp(profile1,profile2,f),0))
   ];

finVec = [[0,0],[1,0],[finHeightFrac*tan(finSweep)+finTopChordFrac,finHeightFrac],[finHeightFrac*tan(finSweep),finHeightFrac]];
//intersection()
   {
if(NACAfin)
   {
   //rotate([NACAFinAngle,0,0])
   poly3dFromVectors(interp(H));
   //NACA fin foil
   translate([interpLen+H*tan(finSweep),1*finRaise,H])      
   rotate([-NACAFinAngle,0,0])
   //Shear to get sweep
      multmatrix(m = [ [1,0 , tan(finSweep+finSweepExtraForPrinting), 0],
                    [0, 1,0 , 0],
                    [0, 0, 1, 0],
                    [0, 0, 0,  1]
                           ])
         {
         linear_extrude(height = finHeight, convexity = 5, scale=[finTopChordFrac,finTopChordFrac],$fn=100)
            polygon(profile2);
            
         //tip of fin
         //N.B. using rotate_extrude() here only works properly if
         #translate([0,0,finHeight])
         if(NACAFinCamber==0)
            {
            //if(partToGenerate == "Fin") //prevents CGAL assertion in pre-2017 versions of OpenSCAD when rendering TipWing
               FinTipUncambered(profile = profile2*[[finTopChordFrac,0],[0,finTopChordFrac]],chord = finBaseChord*finTopChordFrac);
            }
         else
            FinTipCambered(profile = profile2*[[finTopChordFrac,0],[0,finTopChordFrac]],chord = finBaseChord*finTopChordFrac);
         }
   }
else //Semi-blended flat plate fin
   {   
   ro = 0.042*tipChord;
   //translate([interpLen+H*tan(finSweep),0.6*finRaise,H-finThick-tan(NACAFinAngle)*finBaseChord*thickPercent/100*0.6])
   //rotate([NACAFinAngle,0,0])
   translate([interpLen+H*tan(finSweep),1*finRaise,H])
   multmatrix(m = [ [1, 0, tan(finLEAngle), 0],
                    [0, 1, tan(finBlendAngle), 0],
                    [0, tan(NACAFinAngle), 1, 0],
                    [0, 0, 0,  1]
                    ])
   linear_extrude(height = endFlattener?10*finThick:finThick, convexity = 5,$fn=100)
      hull()
         {
         offset(ro)
            offset(-ro)
               polygon(finBaseChord*finVec);
         polygon(profile2);
         }
//   cube([finBaseChord,finHeightFrac*finBaseChord,finThick]);
      }
   }
}

module FinTipCambered(profile, chord)
{
maxTipHeight = 1.5*NACAFinThick*chord/2;
xTipFrac = 0.1;
function shapeFunc(z) = 0.5*tan(88*z)+10*pow(z,3);//pow(z,5);
//function shapeFunc(z) = pow((sin((z-0.5)*(180-sweep/noseFlatness))+1)/2,noseFlatness);
function shape(z) = (shapeFunc(z)-shapeFunc(0))/(shapeFunc(1)-shapeFunc(0)); //normalise output to [0,1)
//function shape(z) = z; 
maxXShift = 0.67*chord*(1-xTipFrac)/2;
   
profileChordAtMaxTipHeight = chord+(maxTipHeight)*(chord-(chord/finTopChordFrac))/finHeight;
echo("profileChordAtMaxTipHeight=",profileChordAtMaxTipHeight);
echo("chord=",chord);
//Interpolate between 2 profiles using the shape function
function interp(hz,profile1,profile2) = 
   [
   for (i=[0: 1/50 : 1+0.001])
      let(f = shape(i))
      let(h = i*(hz))
      let(x = f*maxXShift)
      T_(x,0,h, vec3D(vecInterp(profile1,profile2,f)*[[(i*profileChordAtMaxTipHeight+(1-i)*chord)/chord,0],[0,1]],0))
   ];
profile2 = profile*[[xTipFrac,0],[0,xTipFrac/1]];
scale([1,1,2])
   poly3dFromVectors(interp(maxTipHeight,profile,profile2));
}

module FinTipUncambered(profile, chord)
{
scale([1,1,4])
rotate([90,0,-90])
rotate_extrude(angle=180, convexity=4,$fn=64)
rotate([0,0,-90])
intersection()
   {
   polygon(profile);
   square([chord,3*NACAFinThick*chord/2]);
   }
}

//   for (i=[0: 1/20 : 1+0.001])
//      echo("i=",i);

//BlendedFinTip(NACAfin=false,fin = false);
//translate([0,0,-0.4]) NACAfin(NACAfin=false,tip=false);

//polygon(FinNACA());
//polygon(airfoil);

//BlendedFinTip();

module Wing()
{
if(flatPlateTip)
   translate([wingLen*tan(-dihedral),wingLen*tan(sweep),wingLen-finThick])
      Fin(tipChord);
else
   translate([wingLen*tan(-dihedral),wingLen*tan(sweep),wingLen])
      rotate([0,0,90+washout])
         BlendedFinTip();

difference()
   {
   WingBlank();
//   #translate([-0.0072*rootChord,0.65*rootChord,])
//      cylinder(d=sparD, h= 0.60*wingLen);
   Elevon(1);

   if(flatPlateTip)
      translate([wingLen*tan(-dihedral),wingLen*tan(sweep),wingLen])
      //Flatten the tip of the wing for printing purposes
         Fin(tipChord,1);
   //ServoCutout();
   }
}

servoChordPos = 0.32*wingChordAtElevonStart+elevonStartSpan*tan(sweep);

module ServoCutout() //in Wing coordinate system
{
   //Servo cutout
#translate([(servoThick+0.5)/2-0.011*wingChordAtElevonStart+elevonStartSpan*tan(-dihedral),
         servoChordPos,
         elevonStartSpan-servoHHornTop+(servoHHornTop-servoHHornBottom)/2])
      rotate([0,-dihedral,washout/2+2])
      rotate([0,0,90])
         Servo();
}

module Fin(tipChord,endFlattener = 0)
{
ro = 0.042*tipChord;
inner = 0.65*tipChord - ro;

rotate([0,0,90])
translate([tipChord-inner,0.04*tipChord,0])
rotate([0,0,washout])
//Shear to get sweep
multmatrix(m = [ [1, 0,0 , 0],
                 [0, 1, 0, 0],
                 [0, tan(finAngle), 1, 0],
                 [0, 0, 0,  1]
                 ])

linear_extrude(height = endFlattener?10*finThick:finThick, convexity = 5,$fn=100)
   if(endFlattener)
      {
      polygon([[-tipChord,-tipChord],[-tipChord,tipChord],[tipChord,tipChord],[tipChord,-tipChord]]);
      }
   else
      {
intersection()
   {
      offset(r=-ro)
      {
      offset(r=ro)
      offset(r = ro)
      polygon([[-0.3*inner,-0.00*inner],[0.57*inner,0.00*inner],[0.9*inner,0.0*inner],[0.94*inner,0.0*inner],[1.3*inner,(0.8+0.15)*inner],
         [0.6*inner,(0.7+0.15)*inner],[0.1*inner,0.015*inner]]);
      }
   //polygon([[-inner,0],[2*inner,0],[2*inner,3*inner],[-inner,3*inner]]);
   //WingBlank();
   }

   }
}

module Elevon(cutOut = 0)
{
difference()
   {
   intersection()
      {
      //Shear to get sweep
      multmatrix(m = [ [1, 0, tan(-dihedral), 0],
                       [0, 1, tan(sweep), 0],
                       [0, 0, 1, 0],
                       [0, 0, 0,  1]
                       ])
      linear_extrude(height = wingLen, convexity = 5,twist = -washout, scale=[tipScale,tipScale], $fn=100)
         intersection()
         {
         if(!cutOut)
            {
            rotate([0,0,90])
               polygon(airfoil);
            }

         translate([-0.15*elevD,elevonRootPos])
         offset(r=cutOut?hingeGap:0)
         union()
            {
            if(elevonHingeRound)
               {
               circle(d=elevD);
               translate([-elevD/2,0])
               square([elevD,2*elevonRootLen]);
               }
            else
               {
               translate([-elevD/2,0])
                  polygon([[0,0],[elevD,cutOut?0:elevD*sin(maxElevonDown)],[elevD,2*elevonRootLen],[0,2*elevonRootLen]]);
               }
            }
         }
      elevonEndsGap = 2*hingeGap;
      translate([-rootChord/2,0,elevonStartSpan + (cutOut?0:elevonEndsGap)])
         cube([rootChord,8*rootChord,elevonLen-(cutOut?0:2*elevonEndsGap)]);
      }
   if(!cutOut)
      translate([wingLen*tan(-dihedral),wingLen*tan(sweep),wingLen-1.5*hingeGap-0.01*rootChord*tan(finAngle)-finThick])
         Fin(tipChord,1);
   }
//horn
if(!cutOut)
   {
   intersection()
      {
      multmatrix(m = [ [1, 0, tan(-dihedral), 0],
                       [0, 1, tan(sweep), 0],
                       [0, 0, 1, 0],
                       [0, 0, 0,  1]
                       ])
      linear_extrude(height = wingLen, convexity = 5,twist = -washout, scale=[tipScale,tipScale], $fn=100)
      union()
         {
         difference()
            {
            offset(r=0)
            union()
               {
               polygon([[0,elevonRootPos+(elevonHingeRound?0:1.1*elevD*sin(maxElevonDown))],[0.0,0.98*rootChord],
                  [0.55*hornH,0.84*rootChord],
                  [hornH-hornTipR,elevonRootPos+2*hornTipR],
                  [hornH-hornTipR,elevonRootPos]]
                  );
               translate([hornH-hornTipR,elevonRootPos+hornTipR])
                     circle(r = hornTipR);
               }
            translate([hornH-hornTipR,elevonRootPos+hornTipR])
               circle(d = hornHoleD);               
            }
         }
      translate([-rootChord/2,0,elevonStartSpan + (2*hingeGap)])
         cube([rootChord,4*rootChord,hornThick]);
     }
   }
   
}

module RootWingBlank(offsetr = 0)
{
linear_extrude(height = bodyWidth/2, convexity = 5,twist = 0, $fn=100)
   rotate([0,0,90])
      offset(r= offsetr)
         polygon(airfoil);
}


module WingBlank(offsetr = 0)
{
//Shear to get sweep
multmatrix(m = [ [1, 0, tan(-dihedral), 0],
                 		  [0, 1, tan(sweep), 0],
                        [0, 0, 1, 0],
                        [0, 0, 0,  1]
                        ])
linear_extrude(height = wingLen+0.07*tipChord*tan(finAngle), convexity = 5,twist = -washout, scale=[tipScale,tipScale], $fn=100)
   rotate([0,0,90])
      offset(r= offsetr)
         polygon(airfoil);
}


module Servo(leadLen = elevonStartSpan+bodyWidth/2-servoHHornTop)
{
servoLeadDepth = servoThick-servoLeadThick-2;
servoToSpar = servoChordPos-sparChordPos;
bendPosFromServo = servoToSpar/tan(sweep);
bendFrac = bendPosFromServo/leadLen;
//echo("bendPosFromServo=",bendPosFromServo);
//echo("bendFrac=",bendFrac);
overSparAngle = atan((servoLeadDepth-sparD+bendPosFromServo*tan(dihedral)+1.5)/bendPosFromServo);
innerOverSparAngle = overSparAngle;
forwardSparAngle = 0;//sweep/4;
servoCutLen = servoHornLen-servoHornR;
cube([servoW,servoThick,servoH]);

translate([-servoLeadSpace,0,0])
   cube([servoLeadSpace,servoThick,servoLeadH]);

//space for inserting connector
translate([-servoLeadSpace,servoLeadDepth,-1.2*servoLeadH])
         multmatrix(m = [ [1, 0, tan(30), 0],
                          [0, 1, 0, 0], 
                          [0, 0, 1, 0],
                          [0, 0, 0,  1]
                       ])
    cube([1.0*servoLeadW,1*servoLeadThick,1.2*servoLeadH]);

translate([-(servoFlangeW-servoW)/2,0,servoFlangeHBottom])
   cube([servoFlangeW,servoThick,servoFlangeThick]);

translate([0,0,servoH])
   cube([servoTopW,servoThick,servoHHornBottom-servoH]);

translate([servoHornCenterFomLeadSide,servoThick/2,servoHHornBottom-servoTol])
   rotate([0,0,-elevonDifferential])
      {
      linear_extrude(height = servoHHornTop-servoHHornBottom+servoTol, convexity = 5,$fn=100)
      offset(r = servoHornR)
      polygon([[0,0],
         [-servoCutLen*sin(servoAngleRange/2),-servoCutLen*cos(servoAngleRange/2)],
         [servoCutLen*sin(servoAngleRange/2),-servoCutLen*cos(servoAngleRange/2)]]);
      }
//-(0.05*rootChord-((servoThick-servoLeadThick)-2))/leadLen

//echo(servoCutLen*sin(servoAngleRange/2));
         multmatrix(m = [ [1, 0, tan(sweep), 0],
                          [0, 1, tan(0*dihedral-overSparAngle), 0],                       [0, 0, 1, 0],
                          [0, 0, 0,  1]
                       ])
   {
   translate([-servoLeadSpace,servoLeadDepth,-bendFrac*leadLen])
       cube([servoLeadW,servoLeadThick,bendFrac*leadLen]);
   translate([-servoLeadSpace-(1-bendFrac)*leadLen*tan(-forwardSparAngle),(1-bendFrac)*leadLen*tan(-innerOverSparAngle)+servoLeadDepth,-1*leadLen])
   multmatrix(m = [ [1, 0,tan(-forwardSparAngle), 0],
                    [0, 1, tan(innerOverSparAngle), 0], //bring lead conduit to center of profile at wing root
                    [0, 0, 1, 0],
                    [0, 0, 0,  1]
                 ])
       cube([servoLeadW,servoLeadThick,(1-bendFrac)*leadLen]);
   }
}



 
 