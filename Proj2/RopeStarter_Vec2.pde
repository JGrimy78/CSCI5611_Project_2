//PDEs and Integration
//CSCI 5611 Swinging Rope [Exercise]
//Stephen J. Guy <sjguy@umn.edu>

//NOTE: The simulation starts paused, press "space" to unpause

//TODO:
//  1. The rope moves very slowly now, this is because the timestep is 1/20 of realtime
//      a. Make the timestep realtime (20 times faster than the inital code), what happens?
//      b. Call the small 1/20th timestep update, 20 times each frame (in a for loop) -- why is it different?   It's updating it 20 times per frame every frame instead of once every frame or 1/20th of the update during a single frame
//  2. When the rope hanging down fully the spacing between the links is not equal, even though they
//     where initalized with an even spacing between each node. What is this?
//      - If this is a bug, fix the corisponding code -- not a bug
//      - If this why is not a bug, explain why this is the expected behavior -- less force on nodes closer to the bottom of the rope
//  3. By default, the rope starts vertically. Change initScene() so it starts at an angle. The rope should
//     then swing backc and forth. -- done
//  4. Try changing the mass and the k value. How do they interact wich each other? -- higher mass = more elasticity, higher k val = less elasticity
//  5. Set the kv value very low, does the rope bounce a lot? What about a high kv (not too high)? -- 325 max. Higher kv = less bounce 
//     Why doesn't the rope stop swinging at high values of kv?
//  6. Add friction/drag so that the rope eventually stops. An easy friction model is a scaled force 
//     in the opposite direction of a nodes current velocity. 

//Challenge:
//  - Set the top of the rope to be wherever the user's mouse is, and allow the user to drag the rope around the scene.
//  - Keep the top of the rope fixed, but allow the user to click and drag one of the balls of the rope to move it around.
//  - Place a medium-sized, static 2D ball in the scene, have the nodes on the rope experience a "bounce" force if they collide with this ball.


//Create Window
String windowTitle = "Swinging Rope";
void setup() {
  size(800, 600, P3D);
  surface.setTitle(windowTitle);
  initScene();
}

//Simulation Parameters
float floor = 500;
Vec2 gravity = new Vec2(0,400);

//Node Parameters
static int maxNodes = 100;
float radius = 5;


//Rope Parameters
static int maxNumRopes = 100;
int numRopes = 75;
Vec2 stringTop = new Vec2(600,50);
float restLen = 10;
float mass = 0.75; //TRY-IT: How does changing mass affect resting length of the rope?
float k = 200; //TRY-IT: How does changing k affect resting length of the rope?
float kv = 100; //TRY-IT: How big can you make kv?
ArrayList<Rope> ropeList = new ArrayList();

//Mesh Parameters
Mesh mesh = new Mesh(ropeList, numRopes);

//Obstacle Parameters
static int maxObstacles = 5;
int numObstacles = 1;
Vec2 obsPos = new Vec2(300, 300);
float obsRad = 25;
float obstacleSpeed = 200;
ArrayList<Obstacle> obsList = new ArrayList();

void initScene(){
  for (int i = 0; i < numObstacles; i++) {
     Obstacle tempObs = new Obstacle(obsPos, obsRad);
     obsList.add(tempObs);
     obsPos.x -= 80;
     //obsPos.y += 50;
  }
  
  mesh.initMesh();
}


void update(float dt){
  mesh.computeMeshForce(dt);
  
  Vec2 obstacleVel = new Vec2(0,0);
  if (shiftPressed) obstacleSpeed = 400;
  else obstacleSpeed = 200;
  if (leftPressed) obstacleVel = new Vec2(-obstacleSpeed,0);
  if (rightPressed) obstacleVel = new Vec2(obstacleSpeed,0);
  if (upPressed) obstacleVel = new Vec2(0,-obstacleSpeed);
  if (downPressed) obstacleVel = new Vec2(0,obstacleSpeed);
  
  // Next 4 lines implemented for diagonal motion
  if (leftPressed && upPressed){ obstacleVel = new Vec2(-1, -1); obstacleVel.setToLength(obstacleSpeed); } 
  if (rightPressed && upPressed){ obstacleVel = new Vec2(1, -1); obstacleVel.setToLength(obstacleSpeed); }
  if (leftPressed && downPressed){ obstacleVel = new Vec2(-1, 1); obstacleVel.setToLength(obstacleSpeed); }
  if (rightPressed && downPressed){ obstacleVel = new Vec2(1, 1); obstacleVel.setToLength(obstacleSpeed); } 
  Obstacle tempObstacle = obsList.get(0);
  tempObstacle.pos.add(obstacleVel.times(dt));
}


//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
void draw() {
  background(0,0,0);
  lightSpecular(20, 20, 100);
  ambientLight(80, 40, 100, 200, 200, 0);
  //directionalLight(51, 102, 126, -1, 0, -1);
  pointLight(100, 102, 79, 140, 160, 144);
  pointLight(255, 102, 0, 700, 160, 144);
  if (!paused) for(int i = 0; i < 20; i++) {update(1/(20*frameRate));}
  
  fill(255, 255, 255);
  
  for(int i = 0; i < numObstacles; i++){
    Obstacle tempObs = obsList.get(i);
    pushMatrix();
    //noStroke();
    translate(tempObs.pos.x, tempObs.pos.y);
    specular(255, 255, 255);
    shininess(5.0); 
    sphere(tempObs.radius);
    popMatrix();
  }
  
  
  fill(0,0,0);
 
  for(int r = 0; r < numRopes; r++){ 
    Rope tempRope = ropeList.get(r);
    for (int i = 0; i < tempRope.numNodes-1; i++){
        pushMatrix();
        
        line(tempRope.pos[i].x,tempRope.pos[i].y,tempRope.pos[i+1].x,tempRope.pos[i+1].y);
        translate(tempRope.pos[i+1].x,tempRope.pos[i+1].y);
        //sphere(tempRope.r);
        popMatrix();
      }
  }
  
  float red = 0;
  float g = 0;
  float b = 255;
  for(int r = 0; r < numRopes-1; r++){
    Rope curRope = ropeList.get(r);
    Rope nextRope = ropeList.get(r+1);
    for (int i = 0; i < curRope.numNodes-1; i++){
       pushMatrix();
       if (b > 1) { b -= 0.125; }
       if (red < 224) { red += 0.25; }
       fill(red, g, b);
       noStroke();
       quad(curRope.pos[i].x, curRope.pos[i].y, curRope.pos[i+1].x, curRope.pos[i+1].y, nextRope.pos[i+1].x, nextRope.pos[i+1].y, nextRope.pos[i].x, nextRope.pos[i].y);
       //line(curRope.pos[i].x, curRope.pos[i].y, nextRope.pos[i].x, nextRope.pos[i].y);
       translate(nextRope.pos[i].x, nextRope.pos[i].y);
       popMatrix();
    }
  }
  
  
  
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;
void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  if (key == ' ') paused = !paused;
}

void keyReleased(){
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}
