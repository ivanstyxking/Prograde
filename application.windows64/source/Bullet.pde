class Bullet {
  PVector velocity, position;
  float mass, rate, vel;
  boolean hostile;
  int type, life;
  color c;
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
    //ship.velocity.sub(PVector.mult(velocity,mass/ship.mass));
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
    //ai.velocity.sub(PVector.mult(velocity,mass/ai.mass));
  }
  void update() {
    position.add(velocity);
    if ((position.y>arenaHeight)||(position.y<0)) {
      for (int i=0; i<velocity.mag()/10; i++) {
        sparkfx.spawn(position.x, position.y, random(2*PI), random(mass*velocity.mag()/20), map(velocity.mag(), 0, vel, 0, 0.9));
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
      for (int i=0; i<velocity.mag()/10; i++) {
        sparkfx.spawn(position.x, position.y, random(2*PI), random(mass*velocity.mag()/20), map(velocity.mag(), 0, vel, 0, 0.9));
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
    velocity.mult(0.99 * (1-1/(10*mass)));
    life++;
  }
  void display() {
    
    if (onScreen(position.x, position.y)) {
      for (int i=0; i<velocity.mag()/100; i++) {
        sparkfx.spawn(position.x, position.y, velocity.heading()+0.005*random(-1,1), velocity.mag()*0.5, map(velocity.mag(), 0, vel, 0, 0.9));
      }
      colorMode(HSB, 255);
      switch(type) {
      case 1:
        strokeWeight(map(mass, 0, 30, 0.5, 5));
        if (hostile) {
          stroke(map(velocity.mag(), 0, vel, 100, 0), 255, 255);
        } else {
          stroke(map(velocity.mag(), 0, vel, 0, 210), (map(velocity.mag(), vel, 0, 128, 255)), 255);
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
}
