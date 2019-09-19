public class Ship {
  PVector position, velocity, Pvelocity, acceleration, rAcc;
  float heading, health, shieldAlpha, shieldDiam, centrepetalVel, acc, mass;
  boolean newtonian = true;
  int cooldown1=0;
  int cooldown2=0;
  float maxV=3430F/24;
  float maxA = 4.7/(24);
  Ship(float x, float y) {
    mass = 5000;
    acc=0.4;
    heading = 0;
    centrepetalVel = 0;
    acceleration = new PVector(0, 0);
    rAcc = new PVector(0, 0);
    velocity = new PVector(0, 0);
    Pvelocity = new PVector(0, 0);
    position = new PVector(x, y);
    health = 10000;
    shieldAlpha=0;
    shieldDiam=32;
    colorMode(RGB, 255);
    a = color(0, 255, 0);
    b = color(255, 0, 0);
  }
  void update() {
    PVector difference = new PVector(mouseX-width/2, mouseY-height/2);
    if (cooldown1>0) {
      cooldown1--;
    }
    if (cooldown2>0) {
      cooldown2--;
    }
    if (mousePressed) {
      if (leftgun) {
        if (cooldown1<=0) {
          // laser.play();
          //laser.rewind();
          for (int i=0; i<1; i++) {
            bullets.add(new Bullet(500+random(-200, 200)+velocity.mag(), velocity.x, velocity.y, 1.5, difference.heading()+0.03*randomGaussian(), ship.position.x+ship.velocity.x*2, ship.position.y+ship.velocity.y*2, false, 1));
          }
          cooldown1=2;
          //bullets.add(new Bullet(20+ship.velocity.mag(), ship.heading+random(-PI/32, PI/32), ship.position.x, ship.position.y, false, 1));
        }
      }
      if (mousePressed) {
        if (rightgun) {
          if (cooldown2<=0) {
            //minigun.play();
            // minigun.rewind();

            //difference.sub(this.position);
            bullets.add(new Bullet(velocity.mag()+450+random(-4, 4), velocity.x, velocity.y, 200, difference.heading()+randomGaussian()*PI/512, ship.position.x+ship.velocity.x*2, ship.position.y+ship.velocity.y*2, false, 2));
            cooldown2=23;
            //bullets.add(new Bullet(60+ship.velocity.mag(), 0, 0, 0.5, difference.heading()+random(-PI/48, PI/48), ship.position.x, ship.position.y, false, 2));
          }
        }
      }
    }
    if (left) {
      centrepetalVel-=0.002;
    } else if (right) {
      centrepetalVel+=0.002;
    } else {
      centrepetalVel*=0.9;
    }
    heading+=centrepetalVel;
    acceleration = PVector.fromAngle(heading);
    Pvelocity.set(velocity);
    if (up) {
      acc=maxA;
      acceleration.setMag(acc);
      acceleration.limit(10);
    } else {
      if (newtonian) {
        acceleration.setMag(0);
        acc=0.1;
      }
    }
    if (down) {
      velocity.mult(0.98);
      acceleration.setMag(0.1);
    }
    velocity.add(acceleration);
    velocity.limit(maxV);
    float k = -0.2;
    float mu = 0.9;
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
    float distBullet;
    for (int i=0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      for (int j=0; j<96; j++) {
        distBullet = PVector.dist(this.position, PVector.sub(b.position, PVector.mult(b.velocity, map(j, 0, 96, 0, 1))));
        if ((distBullet<shieldDiam)&&b.ai!=null) {
          health-=b.velocity.mag()*bullets.get(i).mass;
          ship.velocity.add(PVector.mult(b.velocity, b.mass/ship.mass));
          if (health<=0) {
            die();
          }
          for (int l=0; l<b.velocity.mag()*b.mass; l++) {
            sparkfx.spawn(position.x, position.y, b.velocity.heading()+2/b.velocity.magSq(), random(0, b.velocity.mag()), map(b.velocity.mag(), 0, b.vel, 0.9, 0));
          }
          if (bullets.get(i).type!=0) {
            bullets.remove(i);
          }
          //  bullets.remove(i);
          shieldAlpha=255;
          break;
        }
      }
    }
    shieldAlpha-=8;
    if (shieldAlpha<0) {
      shieldAlpha=0;
    }
    position.add(velocity);
    rAcc = PVector.sub(velocity, Pvelocity);
    for (int i=0; i<16*rAcc.mag(); i++) {
      sparkfx.vectorSpawn(position.x, position.y, PVector.add(velocity, PVector.mult(acceleration, -maxV)), 0.6);
    }
  }
  color a; 
  color b;
  void die() {
    for (int q=0; q<128; q++) {
      sparkfx.spawn(position.x, position.y, random(2*PI), random(0, 64), 0.6);
    }
  }
  void display() {
    strokeWeight(2);
    pushMatrix();
    translate(position.x, position.y);
    fill(lerpColor(color(#00ff00), color(#ff0000), map(health, 10000, 0, 0, 1)));
    // text((int)map(health, 10000, 0, 100, 0)+"%", 10, 0);
    noFill();
    colorMode(HSB, 1);
    stroke(lerpColor(b, a, map(health, 10000, 0, 1, 0)), map(shieldAlpha, 255, 0, 1, 0));
    rotate(heading-PI/2);
    ellipse(0, 0, shieldDiam, shieldDiam);
    colorMode(RGB, 255);
    stroke(0, 200, 255);

    beginShape();//=============================================================================================================== SHIP
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
    //line(0, 0, 0, 1000);

    //line(0,2.3175,0,-2.3175);//=============================================================================================================== length of f1 car
    popMatrix();
  }
}
