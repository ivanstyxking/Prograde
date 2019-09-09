void retical(){
  colorMode(RGB,255);
  stroke(0,200,255);
  line(mouseX-10,mouseY,mouseX+10,mouseY);
  line(mouseX,mouseY-10,mouseX,mouseY+10);
}
void enemyRadar(){
  colorMode(HSB,1);
  stroke(1);
  for(AI ai: enemies){
    ellipse(ai.position.x,ai.position.y,10,10);
  }
}
