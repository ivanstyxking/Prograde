float G = 0.01;
float c = 3*pow(10,8);
ArrayList<GravityWell> anomolies = new ArrayList<GravityWell>();
class GravityWell{
  PVector position;
  float mass,rad;
  GravityWell(PVector location, float m){
    position = new PVector(location.x,location.y);
    mass = m;
    rad = 0.5*G*mass*0.01;
  }
  void update(){
    PVector d = PVector.sub(position,ship.position);
    if(d.mag()<rad){
      mass+=ship.mass;
      ship.die();
      ship.health =0;
    }
    PVector a = PVector.fromAngle(d.heading()).setMag(G*mass/d.magSq());
    ship.velocity.add(a);
    
    for(int i =0; i < bullets.size();i++){
      Bullet b = bullets.get(i);
      d =  PVector.sub(position, b.position);
     if(d.mag()<rad){
       mass+=0.5*b.mass*b.velocity.magSq();
       bullets.remove(b);
     }
      a.set(PVector.fromAngle(d.heading()).setMag(100*G*mass/d.magSq()));
      b.velocity.add(a);
    }
    colorMode(HSB,1);
    fill(0);
    stroke(1,0,1);
    ellipse(position.x,position.y,2*rad,2*rad);
  }
}
