class Shoot {


  PGraphics invader;

PImage explosion = loadImage("explosion.jpg");

  PVector pos;
  PVector vel;
  float a;
  float x1;
  float y1;
  float x;
  float y;
 color myColor;
  boolean moving = false;
  Rectangle bulletrec;
  
  Spaceship ship;

  Shoot(float x1, float y1, float a, color myColor) {
   this.x1 = x1;
   this.y1 = y1;
    this.myColor = myColor;
    this.ship = ship;
    this.a = a;
   
  
    
    if (a > PI/2 && a < 3*PI/2) {
      x = -5;
    }
    else {
      x = 5;
    }

    pos = new PVector(x1, y1);
    println(pos.x + " "+ pos.y);
    vel = new PVector(x, x*tan(a));
   // println("bullet velocity="+vel);
    invader = generateInvader(myColor);
    bulletrec = new Rectangle(int(pos.x),int(pos.y),24,40);
   fill(0);
    
    /*
   println(pos.x);
     println(pos.y);
     println(vel.x);
     println(vel.y);
     */
  }

  void start(color myColor) {
this.myColor = myColor;
   //generateInvader(myColor);
   // println(myColor);
    moving = true;
  }


  void mov() {

    pos.x = pos.x+vel.x;
    pos.y = pos.y+vel.y;
    bulletrec.x = int(pos.x);
    bulletrec.y = int(pos.y);
       


    if (pos.y > height-20 || pos.y < 0) {
      vel.y = vel.y*(-1);
    }
    if (pos.x > width || pos.x < 0) {
      moving = false;
    }
  }
  
  boolean isHitting(Rectangle _targetRect){
      //before rectangles: return (dropPos.xpos  < _targetMaxXPos && dropPos.xpos  > _targetMInXPos &&  dropPos.Ypos  < _targetMaxYPos && dropPos.ypos  > _targetMinXPos);
      return (bulletrec.intersects(_targetRect)); //finally we don't have to have that terrible if statement
    }
  
  void hit(){
    
    explosion.resize(50, 50);
    
    fill(myColor);
    image(explosion, pos.x-24, pos.y-10);
    
  }

  void display() {
    // Display the circle

    image(invader, pos.x, pos.y);
  }

  PGraphics generateInvader(color myColor) {
    //this.myColor = myColor;
    
    int pixelSize = 4;
  //  println("bullet color" + myColor);

    PGraphics p = createGraphics(pixelSize * 6, pixelSize * 10, P2D);
    p.beginDraw();

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 5; j++) {
        int a = int(random(0, 2));
        //aa.add(a);
        if (a == 1) {
          p.noStroke();
          p.noFill();
        } 
        else {
          p.noStroke();
          p.fill(myColor);
        }

        p.pushMatrix();

        int x1 = i*pixelSize;
        int y1 = j*pixelSize;


        p.translate(pixelSize * 3, 0);
        p.rect(x1, y1, pixelSize, pixelSize);
        p.rect(-x1, y1, pixelSize, pixelSize);

        p.popMatrix();
      }
    }
    //  p.fill(255);
    //p.rect(0,0, pixelSize, pixelSize);

    p.endDraw();

    return p;
  }
}


