float g = 9.80665;
PVector realVelocity;
void retical(){
  colorMode(RGB,255);
  stroke(0,200,255);
  line(mouseX-10,mouseY,mouseX+10,mouseY);
  line(mouseX,mouseY-10,mouseX,mouseY+10);
}
void shipDataUI(){
  realVelocity.set(24*ship.velocity.x,24*ship.velocity.y);
  fill(0,200,255);
  textSize(15);
  text("ship energy = "+ship.health,width-350,height-60);
  text("position vector [x,y] = "+"["+nf(ship.position.x/1000,3,2)+"km] ["+nf(ship.position.y/1000,3,2)+"km]",width-350,height-45);
  text("speed = "+nf(realVelocity.mag()*2.23693629,4,2)+" mph (Mach "+nf(realVelocity.mag()/330F,0,2)+")",width-350,height-30);
  text("acceleration (G) = "+nf(+24*ship.rAcc.mag()*g,0,2)+ " g's (Standard Gravity)",width-350, height - 15);
  noFill();
}

void credits(){
  fill(255,196);
  textSize(14);
  text("Written by Adrian King | github.com/roofus64",10,13);
  noFill();
}
void enemyRadar(){
  colorMode(HSB,1);
  stroke(1);
  for(AI ai: enemies){
    ellipse(ai.position.x,ai.position.y,10,10);
  }
}
