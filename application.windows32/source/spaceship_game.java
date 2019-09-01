import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class spaceship_game extends PApplet {

//import ddf.minim.*;
//Minim minim;
//AudioPlayer laser;
//AudioPlayer minigun;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
Ship ship;
ArrayList<AI> enemies = new ArrayList<AI>();
ArrayList<Star> stars = new ArrayList<Star>();
float arenaWidth, arenaHeight;
float tick = 1;
float zoom = 1;
public void setup() {
  noCursor();
  arenaHeight=20000;
  arenaWidth=20000;
  // minim = new Minim(this);
  // laser = minim.loadFile("laser.wav");
  // minigun = minim.loadFile("laser2.wav");
  ship = new Ship(width/2, height/2);
  //fullScreen(OPENGL);
  
  frame.setResizable(true);
  for (int i=0; i<=5000; i++) {
    stars.add(new Star(random(0, arenaWidth), random(0, arenaHeight), random(-20, 120)));
  }
  //enemies.add(new AI(random(0, width), random(0, height)));
  //frameRate(99999);
}
int frames =0;
float delta, t1, t2;
;
public void draw() {
  pushMatrix();
  pushMatrix();
  translate(zoom*-ship.position.x+width/2, zoom*-ship.position.y+height/2);
  scale(zoom);
  background(0);
  for (int i=0; i<stars.size(); i++) {
    Star star = stars.get(i);
    star.display();
  }
  stroke(255);
  noFill();
  strokeWeight(2);
    colorMode(RGB, 255);
  stroke(0,64,64,128);
  rect(0, 0, arenaWidth, arenaHeight);
  strokeWeight(1);
  stroke(0, 255, 255, 48);
  /*for(int i=0;i<=arenaWidth;i+=32){
   line(i,0,i,arenaHeight);
   }
   for(int j=0;j<=arenaHeight;j+=32){
   line(0,j,arenaWidth,j);
   }*/
  for (int i=0; i<bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.velocity.mag()<1) {
      bullets.remove(i);
    }
  }
  ship.update();
  ship.display();
  for (int i=0; i<enemies.size(); i++) {
    AI enemy = enemies.get(i);
    enemy.update();
    enemy.display();
  }
  if (random(100)<1 && enemies.size() < 1024) {
    enemies.add(new AI(random(0, arenaWidth), random(0, arenaHeight), random(6, 100)));
  }
  if (ship.health<=0) {
    ship = new Ship(arenaWidth/2, arenaHeight/2);
  }
  sparkfx.update();
  popMatrix();
  popMatrix();
  retical();
  frames++;
}
public float smoothing(float start, float end, float change) {
  float dy = end-start;
  if (abs(dy)>0) {
    start+=dy*change;
  }
  return start;
}

boolean up, down, left, right;
boolean [] keys = new boolean [128];
public void keyPressed() {
  key = Character.toLowerCase(key);
  if (key == 'w') {
    up = true;
  }
  if (key == 's') {
    down = true;
  }
  if (key == 'a') {
    left = true;
  }
  if (key == 'd') {
    right = true;
  }
  if (key == ' ') {
    keys[' '] = true;
  }
  if (keyCode == SHIFT) {
    ship.newtonian = !ship.newtonian;
  }
}
public void keyReleased() {
  key = Character.toLowerCase(key);
  if (key == 'w') {
    up = false;
  }
  if (key == 's') {
    down = false;
  }
  if (key == 'a') {
    left = false;
  }
  if (key == 'd') {
    right = false;
  }
  if (key == ' ') {
    keys[' '] = false;
  }
}
boolean leftgun, rightgun;
public void mousePressed() {
  if (mouseButton == LEFT) {
    leftgun = true;
  }
  if (mouseButton == RIGHT) {
    rightgun = true;
  }
}
public void mouseReleased() {
  if (mouseButton == LEFT) {
    leftgun = false;
  }
  if (mouseButton == RIGHT) {
    rightgun = false;
  }
}
public void mouseWheel(MouseEvent e) {
  zoom = smoothing(zoom, zoom*pow(2, -e.getCount()), 0.2f);
}
class AI {
  int a;
  PVector position, velocity, acceleration;
  PVector difference;
  float diam, health, sat;
  Bullet B;
  AI(float x, float y, float D_) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    diam = D_;
    health = sq(diam);
    sat=0;
    colorMode(HSB, 255);
    a = color(100, 255, 255);
  }
    public float targetBearing(Ship target, float pV) {
    PVector d = PVector.sub(target.position, position);
    float t = PVector.div(d, pV).mag();
    PVector h = PVector.add(target.position, PVector.mult(PVector.sub(target.velocity, velocity), t));
    h = PVector.sub(h, position);
    return h.heading();
  }
  public void update() {
    float dist = PVector.dist(ship.position, this.position);
    if (dist<200*diam) {
      difference = PVector.sub(ship.position, this.position);
      acceleration = PVector.fromAngle(difference.heading());
      acceleration.setMag(1/(0.2f*diam));
      //this.velocity.limit(2);
      if (dist>50) {
        velocity.add(acceleration);
        velocity.limit(map(diam, 0, 64, 64, 1));
        //position.add(this.velocity);
      }
    }
    position.add(velocity);
    if (position.x>arenaWidth) {
      position.x=0;
    }
    if (position.x<0) {
      position.x=arenaWidth;
    }
    if (position.y>arenaHeight) {
      position.y=0;
    }
    if (position.y<0) {
      position.y=arenaHeight;
    }
    if ((frames%PApplet.parseInt(map(diam, 64, 2, 24, 1)) == 0)&&(dist<200*diam)&&difference.heading()-velocity.heading()<0.002f*diam) {
      float pV = map(diam, 0, 64, 100, 20)+velocity.mag();
      bullets.add(new Bullet(pV, velocity.x, velocity.y, diam/2, targetBearing(ship, pV) +random(-PI/diam/10, PI/diam/10), position.x, position.y, true, 1, this));
    }
    float distBullet;
    for (int i=0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      for (int j=0; j<96; j++) {
        distBullet = PVector.dist(this.position, PVector.sub(b.position, PVector.mult(b.velocity, map(j, 0, 96, 0, 1))));
        if ((distBullet<diam)&&b.ai!=this) {
          B = bullets.get(i);
          health-=b.velocity.mag()*bullets.get(i).mass;
          for (int k=0; k<b.velocity.mag(); k++) {
            sparkfx.spawn(position.x, position.y, B.velocity.heading()+random(-1,1)/B.velocity.magSq(), random(0, b.velocity.mag()/5), map(B.velocity.mag(), 0, b.vel, 0, 0.9f));
          }
          if (bullets.get(i).type!=1) {
            bullets.remove(i);
          }
          sat=0;
          break;
        }
      }
    }
    sat+=16;
    if (sat>255) {
      sat=255;
    }
    if (health<0) {
      for (int i=0; i<sq(diam/2); i++) {
        sparkfx.spawn(position.x, position.y, random(2*PI), random(0, 64), random(0.3f));
      }
      enemies.remove(this);
    }
  }
  public void display() {
    colorMode(HSB, 255);
    strokeWeight(map(sat, 0, 255, 3, 2));
    stroke(100, sat, 255);
    pushMatrix();
    translate(position.x, position.y);
    fill(100, 255, 255, 128);
    text((int)health, diam, diam);
    rotate(velocity.heading()-PI/2);
    fill(100, 255, 0, 64);
    stroke(a);
    beginShape();
    vertex(0,0);
    vertex(diam/2,diam/2);
    vertex(diam/3,-diam/3);
    vertex(0,0);
    vertex(-diam/3,-diam/3);
    vertex(-diam/2,diam/2);
    vertex(0,0);
    endShape();
    noFill();
    popMatrix();
    //ellipse(position.x, position.y, diam, diam);
  }
}
class Bullet {
  PVector velocity, position;
  float mass, rate, vel;
  boolean hostile;
  int type, life;
  int c;
  AI ai;
  Bullet(float vel, float vx, float vy, float mass, float heading, float x, float y, boolean hostile, int type) {
    life=0;
    this.type = type;
    this.vel = vel;
    this.mass=mass;
    this.velocity = PVector.fromAngle(heading);
    velocity.setMag(vel);
    velocity.x+=vx;
    velocity.y+=vy;
    this.position = new PVector(x, y);
    this.hostile = hostile;
  }
  Bullet(float vel, float vx, float vy, float mass, float heading, float x, float y, boolean hostile, int type, AI ai_) {
    ai = ai_;
    life=0;
    this.type = type;
    this.vel = vel;
    this.mass=mass;
    this.velocity = PVector.fromAngle(heading);
    velocity.setMag(vel);
    velocity.x+=vx;
    velocity.y+=vy;
    this.position = new PVector(x, y);
    this.hostile = hostile;
  }
  public void update() {
    position.add(velocity);
    if ((position.y>arenaHeight)||(position.y<0)) {
      for (int i=0; i<velocity.mag()/20; i++) {
        sparkfx.spawn(position.x, position.y, random(2*PI), random(mass*velocity.mag()/20), map(velocity.mag(), 0, vel, 0, 0.9f));
      }
      if (position.y>arenaHeight) {
        position.y=arenaHeight+velocity.y/2;
      }
      if (position.y<0) {
        position.y=velocity.y/2;
      }
      if (type!=1) {
        velocity.y*=-1;
      } else {
        bullets.remove(this);
      }
    }
    if ((position.x>arenaWidth)||(position.x<0)) {
      for (int i=0; i<velocity.mag()/20; i++) {
        sparkfx.spawn(position.x, position.y, random(2*PI), random(mass*velocity.mag()/20), map(velocity.mag(), 0, vel, 0, 0.9f));
      }
      if (position.x>arenaWidth) {
        position.x=arenaWidth+velocity.x/2;
      }
      if (position.x<0) {
        position.x=velocity.x/2;
      }
      if (type!=1) {
        velocity.x*=-1;
      } else {
        bullets.remove(this);
      }
    }
    velocity.mult(0.99f * (1-1/(10*mass)));
    life++;
  }
  public void display() {
    colorMode(HSB, 255);
    switch(type) {
    case 1:
      strokeWeight(map(mass, 0, 30, 0.5f, 5));
      if (hostile) {
        stroke(map(velocity.mag(), 0, vel, 100, 0), 255, 255);
      } else {
        stroke(map(velocity.mag(), 0, vel, 0, 210), (map(velocity.mag(), vel, 0, 0, 255)), 255);
      }
      break;
    case 2:
      strokeWeight(3);
      if (hostile) {
      } else {
        stroke(map(velocity.mag(), 0, vel, 0, 210), 128, map(velocity.mag(), 10, 0, 255, 0));
      }
      break;
    }
    line(position.x, position.y, position.x-velocity.x, position.y-velocity.y);
  }
}
public class Ship {
  PVector position, velocity, acceleration;
  float heading, health, shieldAlpha, shieldDiam, centrepetalVel, acc;
  boolean newtonian = true;
  int cooldown=0;
  Ship(float x, float y) {
    acc=0.2f;
    heading = 0;
    centrepetalVel = 0;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    health = 10000;
    shieldAlpha=0;
    shieldDiam=32;
    colorMode(RGB, 255);
    a = color(0, 255, 0);
    b = color(255, 0, 0);
  }
  public void update() {
    PVector difference = new PVector(mouseX-width/2, mouseY-height/2);
    if (cooldown>0) {
      cooldown--;
    }
    if (keys[' ']) {
      if (cooldown<=0) {
        // laser.play();
        //laser.rewind();
        for (int i=0; i<1; i++) {
          bullets.add(new Bullet(750+random(-200,200), velocity.x, velocity.y, 1, difference.heading()+0.03f*randomGaussian(), ship.position.x, ship.position.y, false, 1));
        }
        cooldown=1;
        //bullets.add(new Bullet(20+ship.velocity.mag(), ship.heading+random(-PI/32, PI/32), ship.position.x, ship.position.y, false, 1));
      }
    }
    if (mousePressed) {
      if (rightgun) {
        if (frames%10==0) {
          //minigun.play();
          // minigun.rewind();

          //difference.sub(this.position);
          bullets.add(new Bullet(150+random(-4, 4), 0, 0, 20, difference.heading()+randomGaussian()*PI/128, ship.position.x, ship.position.y, false, 2));
          //bullets.add(new Bullet(60+ship.velocity.mag(), 0, 0, 0.5, difference.heading()+random(-PI/48, PI/48), ship.position.x, ship.position.y, false, 2));
        }
      }
    }
    if (newtonian) {
      if (left) {
        centrepetalVel-=0.002f;
      } else if (right) {
        centrepetalVel+=0.002f;
      } else {
        centrepetalVel*=0.9f;
      }
      heading+=centrepetalVel;
    } else {
      if (left) {
        heading-=0.1f;
      }
      if (right) {
        heading+=0.1f;
      }
    }
    acceleration = PVector.fromAngle(heading);
    if (up) {
      acc=0.1f;
      acceleration.setMag(acc);
      acceleration.limit(10);
    } else {
      if (newtonian) {
        acceleration.setMag(0);
        acc=0.1f;
      }
    }
    if (down) {
      velocity.mult(0.9f);
    }
    velocity.add(acceleration);
    velocity.limit(32);
    float k = -0.2f;
    float mu = 0.9f;
    if (position.x>arenaWidth) {
      position.x=0;
      // velocity.y*=mu;
    }
    if (position.x<0) {
      position.x=arenaWidth;
      //velocity.y*=mu;
    }
    if (position.y>arenaHeight) {
      position.y=0;
      //velocity.x*=mu;
    }
    if (position.y<0) {
      position.y=arenaHeight;
      //velocity.x*=mu;
    }
    for (int i=0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      float distBullet = PVector.dist(this.position, b.position);
      if ((distBullet<shieldDiam/2)&&(b.hostile)) {
        health-=bullets.get(i).velocity.mag()*bullets.get(i).mass;
        for (int q = 0; q<b.velocity.mag(); q++) {
          sparkfx.spawn(position.x, position.y, b.velocity.heading()+randomGaussian()/b.velocity.magSq(), random(0, b.velocity.mag()/2), map(b.velocity.mag(), 0, b.vel, 0.4f, 0));
        }
        bullets.remove(i);
        shieldAlpha=255;
        //break;
      }
    }
    shieldAlpha-=8;
    if (shieldAlpha<0) {
      shieldAlpha=0;
    }
    position.add(velocity);
    sparkfx.spawn(position.x, position.y, heading-PI+random(-0.01f, 0.01f), 2, 0.6f);
  }
  int a; 
  int b;
  public void display() {
    strokeWeight(2);
    pushMatrix();
    translate(position.x, position.y);
    fill(lerpColor(color(0xff00ff00), color(0xffff0000), map(health, 10000, 0, 0, 1)));
    text((int)map(health, 10000, 0, 100, 0)+"%", 10, 0);
    noFill();
    stroke(lerpColor(b, a, map(health, 10000, 0, 1, 0)), shieldAlpha);
    rotate(heading-PI/2);
    ellipse(0, 0, shieldDiam, shieldDiam);
    colorMode(RGB, 255);
    stroke(0, 200, 255);
    beginShape();
    vertex(0, 10);
    vertex(3, -14);
    vertex(10, -5);
    vertex(0, -10);
    vertex(-10, -5);
    vertex(-3, -14);
    endShape(CLOSE);
    beginShape();
    vertex(0, 10);
    vertex(5, -3);
    vertex(-5, -3);
    endShape(CLOSE);
    stroke(color(255, 0, 0, 128));
    line(0, 0, 0, 1000);
    popMatrix();
  }
}
public void retical(){
  colorMode(RGB,255);
  stroke(0,200,255);
  line(mouseX-10,mouseY,mouseX+10,mouseY);
  line(mouseX,mouseY-10,mouseX,mouseY+10);
}

class Star {
  int c;
  PVector p;
  float x1, y1, x2, y2;
  Star(float x, float y, float z) {
    colorMode(HSB, 1);
    c = color(random(1), 0.2f, 1);
    p=new PVector(x, y, z);
  }
  public void display() {
    x1 = p.x+(p.z*0.01f*(ship.position.x-arenaWidth/2));
    y1 = p.y+(p.z*0.01f*(ship.position.y-arenaHeight/2));
    strokeWeight(map(p.z, -20, 50, 2, 1));
    stroke(255);
    pushMatrix();
    //scale(p.z);
    stroke(c);
    line(x1, y1, x1-ship.velocity.x, y1-ship.velocity.y);

    popMatrix();
  }
}
SparkFX sparkfx = new SparkFX();
class SparkFX {
  ArrayList<Spark> parts;
  SparkFX() {
    parts = new ArrayList<Spark>();
  }
  public void spawn(float x_, float y_, float rads_, float mag, float h_) {
    parts.add(new Spark(x_, y_, rads_, mag, 1, h_));
  }
  public void update() {
    for (int i=0; i<parts.size(); i++) {
      parts.get(i).update();
    }
  }
  class Spark {
    PVector p, v, a;
    int c;
    float invMass, V;
    Spark(float x, float y, float radians, float mag, float m_, float hue_) {
      V = mag;
      invMass = 1/(abs(m_+0.000000001f));
      colorMode(HSB, 1);
      c = color(hue_, 1, 1);
      p = new PVector(x, y);
      v = PVector.fromAngle(radians);
      v.setMag(mag);
      if ((p.y>arenaHeight)||(p.y<0)) {
        if (p.y>arenaHeight) {
          p.y=arenaHeight+v.y/2;
        }
        if (p.y<0) {
          p.y=v.y/2;
        }
      }

      if ((p.x>arenaWidth)||(p.x<0)) {
        if (p.x>arenaWidth) {
          p.x=arenaWidth+v.x/2;
        }
        if (p.x<0) {
          p.x=v.x/2;
        }
      }
    }
    public void update() {
      a = PVector.fromAngle(v.heading()-randomGaussian()*PI);
      a.setMag(random(0.2f));
      v.add(a);
      p.add(PVector.mult(v, tick));
      v.mult(.99f);
      stroke(lerpColor(c, color(0, 1, 1, 0.5f), map(v.mag(), V, 0, 0, 1)));
      line(p.x, p.y, p.x-v.x, p.y-v.y);
      if (v.mag()<1) {
        parts.remove(this);
      }
      if ((p.y>arenaHeight)||(p.y<0)) {
        v.y*=-1;
        if (p.y>arenaHeight) {
          p.y=arenaHeight+v.y/2;
        }
        if (p.y<0) {
          p.y=v.y/2;
        }
      }
      if ((p.x>arenaWidth)||(p.x<0)) {
        v.x*=-1;
        if (p.x>arenaWidth) {
          p.x=arenaWidth+v.x/2;
        }
        if (p.x<0) {
          p.x=v.x/2;
        }
      }
    }
  }
}
public boolean onScreen(float x, float y) {
  return (abs(x-ship.position.x)<width && (abs(y-ship.position.y)<height));
}
  public void settings() {  size(displayWidth, displayHeight, OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "spaceship_game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
