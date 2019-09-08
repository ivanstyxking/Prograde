import ddf.minim.*;
Minim minim;
AudioPlayer music;
//AudioPlayer laser;
//AudioPlayer minigun;
import com.hamoid.*;
VideoExport videoExport;
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
  videoExport = new VideoExport(this);
  noCursor();
  arenaHeight=20000;
  arenaWidth=20000;
  minim = new Minim(this);
  music = minim.loadFile("Warp Factor Six.mp3");
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
 videoExport.startMovie();
 music.loop();
}
int frames =0;
float delta, t1, t2;
;
void draw() {
  image(background,0,0);
  pushMatrix();
  cameraX = -ship.position.x-5*ship.velocity.x;
  cameraY = -ship.position.y-5*ship.velocity.y;
  translate(zoom*cameraX+width/2, zoom*cameraY+height/2);
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
  noStroke();
  colorMode(HSB,1);
  fill(0.5,1,1,0.075);
  rect(0,0,arenaWidth,arenaHeight);
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
  videoExport.saveFrame();
}
