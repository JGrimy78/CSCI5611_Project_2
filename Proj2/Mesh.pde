public class Mesh {
  ArrayList<Rope> ropeList;
  int numRopes;
  Rope firstRope, lastRope;
  Rope curRope, nextRope;
  
  public Mesh(ArrayList<Rope> ropeList, int numRopes) {
     this.ropeList = ropeList;
     this.numRopes = numRopes;
  }
  
  
  public void initMesh() {
     for(int i = 0; i < numRopes; i++){
        Rope tempRope = new Rope(i, stringTop, restLen, mass, k, kv, radius);
        ropeList.add(tempRope);
        tempRope.initNodes();
        stringTop.x -= 7;
     }
     firstRope = ropeList.get(0);
     lastRope = ropeList.get(numRopes-1);
  }
  
  
  public void computeMeshForce(float dt){
    for(int r = 0; r < numRopes; r++){
      curRope = ropeList.get(r);
      curRope.computeForce(dt);
      for (int i = 1; i < curRope.numNodes; i++){
        curRope.vel[i].add(curRope.acc[i].times(dt));
        Vec2 halfV = curRope.vel[i].plus(curRope.acc[i].times(0.5*dt));
        curRope.pos[i].add(halfV.times(dt));
      }
    }
    //Horizontal Detection
      
    float hRestLen = (lastRope.pos[0].x - firstRope.pos[0].x)/numRopes;
    for (int r = 0; r < numRopes-1; r++) {
      curRope = ropeList.get(r);
      nextRope = ropeList.get(r+1);
      for (int i = 0; i < curRope.numNodes; i++){
        Vec2 diff = nextRope.pos[i].minus(curRope.pos[i]);
        float stringF = -curRope.k*(diff.length() - hRestLen);
        //////println(stringF, diff.length(),curRope.restLen);
        
        Vec2 stringDir = diff.normalized();
        float projVbot = dot(curRope.vel[i], stringDir);
        float projVtop = dot(nextRope.vel[i], stringDir);
        float dampF = -curRope.kv*(projVtop - projVbot);
        //////println(dampF, curRope.kv, projVtop, projVbot, stringDir);
        
        Vec2 force = stringDir.times(stringF+dampF);
        //println(force);
        curRope.acc[i].add(force.times(-1.0/mass));
        nextRope.acc[i].add(force.times(1.0/nextRope.mass));
      }
    }
    
    for(int r = 0; r < numRopes; r++){
      curRope = ropeList.get(r);
      //Collision detection and response
      for (int i = 0; i < curRope.numNodes; i++) {
        if (curRope.pos[i].y+radius > floor) {
          curRope.vel[i].y *= -.9;
          curRope.pos[i].y = floor - radius; 
        }
      }
      detectCollision(numObstacles, curRope.numNodes, curRope.pos, curRope.vel, curRope.r);
    }
  }
}
  
