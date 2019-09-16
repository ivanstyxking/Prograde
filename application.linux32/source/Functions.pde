float smoothing(float start, float end, float change) {
  float dy = end-start;
  if (abs(dy)>0) {
    start+=dy*change;
  }
  return start;
}

boolean onScreen(float x, float y) {
  return (abs(x-ship.position.x)<width/zoom && (abs(y-ship.position.y)<height/zoom));
}

boolean withinPlayspace(float x, float y){
  return (x>0||x<arenaWidth)&&(y>0||y<arenaHeight);
}

boolean up, down, left, right;
boolean [] keys = new boolean [128];

void keyPressed() {
  key = Character.toLowerCase(key);
  if (key == 'q') {
    //videoExport.endMovie();
   // exit();
  }
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
void keyReleased() {
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
void mousePressed() {
  if (mouseButton == LEFT) {
    leftgun = true;
  }
  if (mouseButton == RIGHT) {
    rightgun = true;
  }
}
void mouseReleased() {
  if (mouseButton == LEFT) {
    leftgun = false;
  }
  if (mouseButton == RIGHT) {
    rightgun = false;
  }
}
void mouseWheel(MouseEvent e) {
  zoom = smoothing(zoom, zoom*pow(2, -e.getCount()), 0.1);
  if(zoom>7){zoom=7;}
  if(zoom<0.0625){zoom=0.0625;}
}
