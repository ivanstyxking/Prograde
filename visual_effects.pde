class Star {
  color c;
  PVector p;
  float x1, y1, x2, y2;
  Star(float x, float y, float z) {
    colorMode(HSB, 1);
    c = color(random(1), 0.2, 1);
    p=new PVector(x, y, z);
  }
  void display() {
    x1 = p.x+(p.z*0.005*(ship.position.x-arenaWidth/2));
    y1 = p.y+(p.z*0.005*(ship.position.y-arenaHeight/2));
    if (onScreen(x1, y1)) {
      strokeWeight(map(p.z, -20, 100, 3, 1));
      stroke(255);
      pushMatrix();
      //scale(p.z);
      stroke(c);
      line(x1, y1, x1-ship.velocity.x, y1-ship.velocity.y);

      popMatrix();
    }
  }
}
SparkFX sparkfx = new SparkFX();
class SparkFX {
  ArrayList<Spark> parts;
  SparkFX() {
    parts = new ArrayList<Spark>();
  }
  void spawn(float x_, float y_, float rads_, float mag, float h_) {
    parts.add(new Spark(x_, y_, rads_, mag, 1, h_));
  }
  void vectorSpawn(float x_, float y_, PVector pV_, float h_){
    parts.add(new Spark(x_, y_, pV_, 1, h_));
  }
  void update() {
    for (int i=0; i<parts.size(); i++) {
      parts.get(i).update();
    }
  }
  class Spark {
    PVector p, v, a;
    color c;
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
    Spark(float x, float y, PVector pV, float m_, float hue_) {
      invMass = 1/(abs(m_+0.000000001f));
      colorMode(HSB, 1);
      c = color(hue_, 1, 1);
      p = new PVector(x, y);
      v = pV;
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
    void update() {
      colorMode(HSB,1);
      a = PVector.fromAngle(v.heading()-randomGaussian()*PI);
      a.setMag(random(0.2));
      v.add(a);
      p.add(PVector.mult(v, tick));
      v.mult(.97);
      if (onScreen(p.x, p.y)) {
        stroke(lerpColor(c, color(0, 1, 1, 0.5), map(v.mag(), V, 0, 0, 1)));
        line(p.x, p.y, p.x-v.x, p.y-v.y);
      }
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
      colorMode(RGB,255);
    }
  }
}
boolean onScreen(float x, float y) {
  return (abs(x-ship.position.x)<width/zoom && (abs(y-ship.position.y)<height/zoom));
}
