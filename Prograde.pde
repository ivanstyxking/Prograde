//import ddf.minim.*;
//Minim minim;
//AudioPlayer music;
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
float zoom = 2;
PImage background;
float cameraX, cameraY, previousX, previousY;
void setup() {
  background = loadImage("background.png");
  videoExport = new VideoExport(this);
  noCursor();
  arenaHeight=100000;
  arenaWidth=100000;
  //minim = new Minim(this);
  //music = minim.loadFile("Warp Factor Six.mp3");
  // laser = minim.loadFile("laser.wav");
  // minigun = minim.loadFile("laser2.wav");
  ship = new Ship(arenaWidth/2, arenaHeight/2-5000);
  size(1280, 720, OPENGL);
  surface.setResizable(true);
  //fullScreen(OPENGL);
  frame.setResizable(true);
  for (int i=0; i<=5000; i++) {
    stars.add(new Star(random(0, arenaWidth), random(0, arenaHeight), random(-200, 190)));
  }
  realVelocity= new PVector(0, 0);
  shipTrail = new Trail(ship.position);
  //enemies.add(new AI(random(0, width), random(0, height)));
  //frameRate(99999);
 // videoExport.startMovie();
  //music.loop();
  anomolies.add(new GravityWell(new PVector(arenaWidth/2,arenaHeight/2),10000000000000L));
}
int frames =0;
float delta, t1, t2;

void draw() {
  image(background, 0, 0);
  pushMatrix();

  previousX = cameraX; 
  previousY = cameraY;
  // cameraX = -ship.position.x-9*ship.velocity.x/zoom;
  //cameraY = -ship.position.y-9*float(height)/float(width)*ship.velocity.y/zoom;
  cameraX = smoothing(previousX, -ship.position.x-9*ship.velocity.x/zoom, 0.3*zoom);
  cameraY = smoothing(previousY, -ship.position.y-9*float(height)/float(width)*ship.velocity.y/zoom, 0.3*zoom);
  translate(zoom*previousX+width/2, zoom*previousY+height/2);
  scale(zoom);
  fill(0,25,32,128);
  rect(0, 0, arenaWidth, arenaHeight);
  for (int i=0; i<stars.size(); i++) {
    Star star = stars.get(i);
    star.display();
  }
  stroke(255);
  noFill();
  strokeWeight(2);
  colorMode(RGB, 255);
  stroke(0, 64, 64, 128);
  rect(0, 0, arenaWidth, arenaHeight);
  noStroke();
  colorMode(HSB, 1);
  fill(0.5, 1, 1, 0.075);
  rect(0, 0, arenaWidth, arenaHeight);
  strokeWeight(1);
  stroke(0, 255, 255, 48);
  /*for(int i=0;i<=arenaWidth;i+=32){
   line(i,0,i,arenaHeight);
   }
   for(int j=0;j<=arenaHeight;j+=32){
   line(0,j,arenaWidth,j);
   }*/
   anomolies.get(0).update();
  for (int i=0; i<bullets.size(); i++) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.velocity.mag()<1) {
      bullets.remove(i);
    }
  }
  ship.update();
  for (int i=0; i<enemies.size(); i++) {
    AI enemy = enemies.get(i);
    enemy.update();
    enemy.display();
  }
  if (random(0xFF)<1 && enemies.size() < 64) {
    enemies.add(new AI(random(0, arenaWidth), random(0, arenaHeight), random(6, 100)));
  }
  if (ship.health<=0) {
    for (int i=0; i<sq(ship.shieldDiam); i++) {
      sparkfx.vectorSpawn(ship.position.x, ship.position.y, PVector.add(ship.velocity, PVector.fromAngle(random(2*PI)).setMag(random(256))), 0.7);
    }
    ship =new Ship(arenaWidth/2, arenaHeight/2-5000);
  }
  sparkfx.update();
  shipTrail.updateAndRender(ship.position,ship.heading);
  ship.display();
  enemyRadar();
  popMatrix();
  retical();
  shipDataUI();
  credits();
  frames++;
  //videoExport.saveFrame();
}
