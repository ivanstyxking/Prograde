class AI {
  color a;
  PVector position, velocity, acceleration;
  PVector difference;
  float diam, health, sat, mass, density;
  Bullet B;
  AI(float x, float y, float D_) {
    density = 10000;
    mass = D_/2*sq(D_/2) * density;
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    diam = D_;
    health = sq(diam);
    sat=0;
    colorMode(HSB, 255);
    a = color(100, 255, 255);
  }
  float targetBearing(Ship target, float pV) {
    PVector d = PVector.sub(target.position, position);
    float t = PVector.div(d, pV).mag();
    PVector h = PVector.add(target.position, PVector.mult(PVector.sub(target.velocity, velocity), t));
    h = PVector.sub(h, position);
    return h.heading();
  }
  void update() {
    float dist = PVector.dist(ship.position, this.position);
    if (dist<200*diam) {
      difference = PVector.sub(ship.position, this.position);
      acceleration = PVector.fromAngle(difference.heading());
      acceleration.setMag(2/(0.2*diam));
      //this.velocity.limit(2);
      if (dist>50) {
        velocity.add(acceleration);
        velocity.limit(map(diam, 0, 64, 128, 32));
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
    if ((frames%int(map(diam, 64, 2, 24, 1)) == 0)&&(dist<200*diam)&&difference.heading()-velocity.heading()<0.002*diam) {
      float pV = diam + velocity.mag();
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
          for (int k=0; k<b.velocity.mag()*b.mass*0.5; k++) {
            sparkfx.spawn(position.x, position.y, B.velocity.heading()+random(-1, 1)/B.velocity.magSq(), random(0, b.velocity.mag()/5), map(B.velocity.mag(), 0, b.vel, 0, 0.9));
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
        sparkfx.spawn(position.x, position.y, random(2*PI), random(0, 64), random(0.3));
      }
      enemies.remove(this);
    }
  }
  void display() {
    if (onScreen(position.x, position.y)) {
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
      vertex(0, 0);
      vertex(diam/2, diam/2);
      vertex(diam/3, -diam/3);
      vertex(0, 0);
      vertex(-diam/3, -diam/3);
      vertex(-diam/2, diam/2);
      vertex(0, 0);
      endShape();
      noFill();
      popMatrix();
      //ellipse(position.x, position.y, diam, diam);
    }
  }
}
