import ddf.minim.*;
//Minim minim;
//AudioPlayer laser;
//AudioPlayer minigun;
//import com.hamoid.*;
//VideoExport videoExport;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
Ship ship;
ArrayList<AI> enemies = new ArrayList<AI>();
ArrayList<Star> stars = new ArrayList<Star>();
float arenaWidth, arenaHeight;
float tick = 1;
float zoom = 1;
PImage background;
float cameraX, cameraY;
void setup() {
  background = loadImage("background.png");
  //videoExport = new VideoExport(this);
  noCursor();
  arenaHeight=20000;
  arenaWidth=20000;
  // minim = new Minim(this);
  // laser = minim.loadFile("laser.wav");
  // minigun = minim.loadFile("laser2.wav");
  ship = new Ship(width/2, height/2);
  //fullScreen(OPENGL);
  fullScreen(OPENGL);
  frame.setResizable(true);
  for (int i=0; i<=5000; i++) {
    stars.add(new Star(random(0, arenaWidth), random(0, arenaHeight), random(-20, 120)));
  }
  //enemies.add(new AI(random(0, width), random(0, height)));
  //frameRate(99999);
 //videoExport.startMovie();
}
int frames =0;
float delta, t1, t2;
;
void draw() {
  image(background,0,0);
  pushMatrix();
  translate(zoom*(-ship.position.x-5*ship.velocity.x)+width/2, zoom*(-ship.position.y-5*ship.velocity.y)+height/2);
  scale(zoom);
  rect(0,0,arenaWidth,arenaHeight);
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
  if (random(1000)<1 && enemies.size() < 1024) {
    enemies.add(new AI(random(0, arenaWidth), random(0, arenaHeight), random(6, 100)));
  }
  if (ship.health<=0) {
    ship = new Ship(arenaWidth/2, arenaHeight/2);
  }
  sparkfx.update();
   enemyRadar();
  popMatrix();
  retical();
  frames++;
  //videoExport.saveFrame();
}

boolean up, down, left, right;
boolean [] keys = new boolean [128];

void keyPressed() {
  key = Character.toLowerCase(key);
  if (key == 'q') {
    //videoExport.endMovie();
    //exit();
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
  zoom = smoothing(zoom, zoom*pow(2, -e.getCount()), 0.2);
}
