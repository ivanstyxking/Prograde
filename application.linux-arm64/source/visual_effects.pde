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
      strokeWeight(map(p.z, -20, 100, 5, 2));
      stroke(255);
      pushMatrix();
      //scale(p.z);
      stroke(c);
      point(x1, y1);
      line(x1, y1, x1-(cameraX-previousX), y1-(cameraY-previousY));

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
  void vectorSpawn(float x_, float y_, PVector pV_, float h_) {
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
      V = pV.mag();
      invMass = 1/(abs(m_+0.000000001f));
      colorMode(HSB, 1);
      c = color(hue_, 1, 1);
      p = new PVector(x, y);
      v = pV;
      p.sub(v);
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
      colorMode(HSB, 1);
      a = PVector.fromAngle(v.heading()-randomGaussian()*PI);
      a.setMag(random(0.2));
      v.add(a);
      float gaus = noise(0.5*frames)-0.5+0.2*randomGaussian();
      v.rotate(0.02*gaus);
      p.add(PVector.mult(v, tick));
      v.mult(.99-0.2*abs(gaus));

      if (onScreen(p.x, p.y)&&withinPlayspace(p.x, p.y)) {
        strokeWeight(1);
        stroke(lerpColor(c, color(0, 1, 1, 0.5), map(v.mag(), V, 0, 0, 1)));
        line(p.x, p.y, p.x-(ship.velocity.x-v.x), p.y-(ship.velocity.y-v.y));
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
      colorMode(RGB, 255);
    }
  }
}

ArrayList<PVector []> trail;
int tLen = 128;
Trail shipTrail;
class Trail {
  Trail() {
    trail = new ArrayList<PVector[]>();
    for (int i=0; i<tLen; i++) {
      trail.add(new PVector[2]);
      trail.get(i)[0] = new PVector(0,0);
      trail.get(i)[1] = new PVector(0,0);
    }
  }
  void updateAndRender(PVector p, float h) {
    trail.get(0)[0] = PVector.add(p,PVector.fromAngle(h+radians(120)).setMag(12));
    trail.get(0)[1] = PVector.add(p,PVector.fromAngle(h+radians(-120)).setMag(12));
    colorMode(HSB, 255);
    strokeWeight(1);
    for (int i=tLen-1; i>0; i--) {
      stroke(map(i,0,tLen,140,96),255,255,map(i,0,tLen,255,0));
      line(trail.get(i)[0].x, trail.get(i)[0].y,trail.get(i-1)[0].x, trail.get(i-1)[0].y);
      line(trail.get(i)[1].x, trail.get(i)[1].y,trail.get(i-1)[1].x, trail.get(i-1)[1].y);
      trail.get(i)[0].set(trail.get(i-1)[0]);
      trail.get(i)[1].set(trail.get(i-1)[1]);
    }
  }
}
