import java.util.*;  //now that you are doing java you have to do your own importing
import java.awt.*;
import TUIO.*;

TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
int redGoal = 2500;
int blueGoal = 400;
int redCounter = 10;
int blueCounter = 10;
color myColor;
int frameNumber = 30; // this determines when the bullet gets fired.
PFont font;
ArrayList<Shoot> shot = new ArrayList();
ArrayList<Spaceship> ship = new ArrayList();



void setup()
{

Spaceship newship1 = new Spaceship();
Spaceship newship2 = new Spaceship();
ship.add(newship1);
ship.add(newship2);
 
  //size(screen.width,screen.height);
  size(2500, 800);
  noStroke();
  fill(0);
  loop();
  frameRate(30);
  //noLoop();

  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Monospaced", 48);
  scale_factor = height/table_size;


  tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve a Vector (List) of TuioObject and TuioCursor (polling)
// from the TuioProcessing client and then loop over both lists to draw the graphical feedback.
void draw()
{
  background(255);


  fill(255, 0, 0);
  rect(0, 0, blueGoal, 1600); //goal1
  fill(0, 0, 255);
  rect(redGoal, 0, 400, 1600); //goal2
  
fill(0);
textSize(48);
text((10-blueCounter) + " | " + (10-redCounter), width/2-50, 50);

  textFont(font, 18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  Vector tuioObjectList = tuioClient.getTuioObjects();

  // println("objs: " + tuioObjectList.size() + "\tshots: " + shot.size());

  for (int i=0;i<tuioObjectList.size();i++) {

    TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);

    float dfm = tobj.getScreenX(width);//mirrors tuio object (distance from middle)
    float xship1 = width - dfm;
    
    float xship = map(xship1, 0, width, 0, width-500);
    
  
    
    //println(tobj.getScreenX(width));
    //println(xm);
    stroke(255);
    //fill(0);
    
    
    
    if (tobj.getSymbolID() % 2 == 1) { 
        
     pushMatrix();
  translate(xship, tobj.getScreenY(height)); //Changes 0,0 to tuio object location
 rotate(2*PI - tobj.getAngle()); 
 translate(-xship, -tobj.getScreenY(height)); 
      myColor = color(255,0,0);   
 Spaceship newship =  ship.get(0);     
      newship.display(xship, tobj.getScreenY(height), 2*PI - tobj.getAngle(), myColor);
       newship.shoot(xship, tobj.getScreenY(height), 2*PI - tobj.getAngle());
   
   if(tobj.getScreenY(height) > 550 && xship > width/2-50 && xship < width/2 +150 && (blueCounter <= 0 || redCounter <= 0)){
    
restart();
     
     
   }
    
          
    popMatrix();
      
    }

    else {//make it blue
    
     pushMatrix();
   translate(xship, tobj.getScreenY(height)); //Changes 0,0 to tuio object location
    rotate(2*PI - tobj.getAngle()); //if ID is even, make it red
       translate(-xship, -tobj.getScreenY(height)); //Changes 0,0 to tuio object location

      myColor = color(0,0,255);
      Spaceship newship =  ship.get(1); 
      newship.display(xship, tobj.getScreenY(height), 2*PI - tobj.getAngle(), myColor);
      newship.shoot(xship, tobj.getScreenY(height), 2*PI - tobj.getAngle());
   
   if(tobj.getScreenY(height) > 550 && xship > width/2-50 && xship < width/2 +150 && (blueCounter <= 0 || redCounter <= 0)){
    
  restart();
     
   }
    
    popMatrix(); 
    }
    
  
    //  text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
  }


for (int k = shot.size()-1; k > -1; k--) { 
      Shoot thisshot = shot.get(k); 
    
    // if (thisshot.moving == true) { 
        //     println("moving"); 
        thisshot.display(); //displaying --> problem with invader changing shape
        thisshot.mov(); //moving
   //   }
      if (thisshot.pos.x > redGoal-150 && thisshot.myColor == color(255, 0, 0)) {
       // println("remove");
      // println("GOAL RED TEAM!");
       thisshot.hit();
       blueCounter = blueCounter - 1;
        shot.remove(thisshot);
      }
      if (thisshot.pos.x < blueGoal-150 && thisshot.myColor == color(0, 0, 255)) {
       // println("remove");
       //println("GOAL BLUE TEAM!");
       redCounter = redCounter - 1;
       thisshot.hit();
        shot.remove(thisshot);
      }
            if (thisshot.pos.x > redGoal-150 && thisshot.myColor == color(0, 0, 255)) {
       // println("remove");
       //println("Wrong team jerkoff!");
       
        shot.remove(thisshot);
      }
      if (thisshot.pos.x < blueGoal-150 && thisshot.myColor == color(255, 0, 0)) {
      //  println("remove");
      // println("Wrong team jerkoff!");
       
        shot.remove(thisshot);
      }
     
      
       Spaceship thisship1 = ship.get(0);
       Spaceship thisship2 = ship.get(1);
        
        if((thisshot.isHitting(thisship1.rec) && thisshot.myColor == color(0, 0, 255))|| (thisshot.isHitting(thisship2.rec) && thisshot.myColor == color(255, 0, 0))) {
        println("bounce");
          thisshot.vel.x *= -1;
         thisshot.vel.y = tan(random(PI/2, 3*PI/2));
          
       }
        
      
      
      
 
      
    }
    
   //x,y,angle, ID#
    //    println("fc: " + frameCount + "\tfn: " + frameNumber + "\tmod: " + (frameCount % frameNumber));

   
    //  println(shot.size())

  if(redCounter <= 0){
      bluewinner();
      }
      
        if(blueCounter <= 0){
      redwinner();
        }   




  // Rest of this code comes with TUIO
  Vector tuioCursorList = tuioClient.getTuioCursors();
  for (int i=0;i<tuioCursorList.size();i++) {
    TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
    Vector pointList = tcur.getPath();

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = (TuioPoint)pointList.firstElement();

      for (int j=0;j<pointList.size();j++) {
        TuioPoint end_point = (TuioPoint)pointList.elementAt(j);
        line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
        start_point = end_point;
      }

      stroke(192, 192, 192);
      fill(192, 192, 192);
      ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
      fill(0);
      text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
    }
  }
}

void restart(){
 
     noLoop();
   
   redCounter = 10;
  blueCounter = 10;
 redraw(); 
  
}

void bluewinner(){
 
  fill(0);
       textSize(32);
       text("WINNER!", redGoal-300, 400);
       text("GAME OVER!", blueGoal-150, 400); 
    
        stroke(0);
        strokeWeight(2);
        fill(255);
         rect(width/2  + 40, 600, 150, 50);
         fill(0);
         textSize(24);
          text("Restart?", width/2, 600);
       for (int u = shot.size()-1; u > -1; u--) { 
     Shoot allshots = (Shoot) shot.get(u); 
      shot.remove(allshots);
      }
  
}

void redwinner(){
  fill(0);
       textSize(32);
       text("WINNER!", blueGoal-150, 400);
       text("GAME OVER!", redGoal-350, 400); 
      stroke(0);
        strokeWeight(2);
        fill(255);
         rect(width/2 + 40, 600, 150, 50);
         fill(0);
         textSize(24);
          text("Restart?", width/2, 600);
       for (int v = shot.size()-1; v > -1; v--) { 
      Shoot allshots = (Shoot) shot.get(v); 
      shot.remove(allshots);
      } 
}

// these callback methods are called whenever a TUIO event occurs

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  //if id != the id of a spaceship, then make new spaceship with that id
  //if id == an already existing spaceship then set spaceship.isActive to true
  
   //println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  // println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  // set spaceship.isActive to false to remove it from the draw loop.
  // keep spaceship in arraylist in case player comes back
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
 //   println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
  //   +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  // println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  // println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
  //   +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  // println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}

