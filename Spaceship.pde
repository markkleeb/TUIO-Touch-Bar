class Spaceship {
  float x; //location
  float y; //location
  float a;
   int id;  //chrisk
   boolean isActive = true;  //determines whether tuio object is being sensed
color myColor;
Rectangle rec;


  Spaceship() {
     rec = new Rectangle(0,0,100,50);
  
  }

  void display(float x, float y, float a, color myColor) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.myColor = myColor;
    
    this.rec.x = int(x-50);
    this.rec.y = int(y);
   // println("x: " + x + " y: " + y);    


    smooth();
    noStroke();
    rectMode(CENTER); 
    //println(id);

fill(myColor);  

    ellipse(x, y, 100, 50);
  }


void shoot(float x, int y, float a){
 
 this.x = x;
 this.y = y;
 this.a = a;
 this.myColor = myColor;

 
 
  if (frameCount % frameNumber == 1) // dividing framecount by 30, whenever framecount = 30, fire 1 bullet
    {
      // println("here\nhere\nhere\nhere\nhere\nhere\nhere\nhere");
      Shoot newshot = new Shoot(x, y, a, myColor); // location of origin of the bullet and direction
      //   println("angle: " + tobj.getAngle());
      shot.add(newshot); //adding a new shot
     
      newshot.start(myColor);
    
      
    }
    
    
  
  // gets all the shots on the screen


     //println("x: " + thisshot.pos.x + "\ty: " +  thisshot.pos.y);
  

}
  
}

