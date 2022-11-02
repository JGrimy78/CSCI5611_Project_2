public class Rope {
  Vec2 stringTop = new Vec2(0,0);
  float restLen = 0;
  float mass = 0; 
  float k = 0;
  float kv = 0; 
  int id;
  int numNodes = 15;
  float r = 0;
  float COR = -0.7;
  Obstacle obs;
  
  Vec2 pos[] = new Vec2[maxNodes];
  Vec2 vel[] = new Vec2[maxNodes];
  Vec2 acc[] = new Vec2[maxNodes];
  
  public Rope(int i, Vec2 top, float len, float mass, float k, float kv, float r){
     id = i;
     stringTop = top;
     restLen = len;
     this.mass = mass;
     this.k = k;
     this.kv = kv;
     this.r = r;
  }
  
  
  public void initNodes(){
    for (int i = 0; i < numNodes; i++){
      pos[i] = new Vec2(0,0);
      pos[i].x = stringTop.x + 8*i;
      pos[i].y = stringTop.y + 8*i; //Make each node a little lower
      vel[i] = new Vec2(0,0);
      acc[i] = new Vec2(0,0);
      acc[i].add(gravity);
    }
  }
  
   public void computeForce(float dt){
      for (int i = 0; i < numNodes; i++){
          acc[i] = new Vec2(0,0);
          acc[i].add(gravity);
        }
      
      //Compute (damped) Hooke's law for each spring
      for (int i = 0; i < numNodes-1; i++){
        Vec2 diff = pos[i+1].minus(pos[i]);
        float stringF = -k*(diff.length() - restLen);
        //println(stringF,diff.length(),restLen);
        
        Vec2 stringDir = diff.normalized();
        float projVbot = dot(vel[i], stringDir);
        float projVtop = dot(vel[i+1], stringDir);
        float dampF = -kv*(projVtop - projVbot);
        
        float kFric = 0.000125;   //Edit this to change friction force
        Vec2 fricF = vel[i].times(-kFric);
        vel[i].add(fricF);
        
        Vec2 force = stringDir.times(stringF+dampF);
        
        acc[i].add(force.times(-1.0/mass));
        acc[i+1].add(force.times(1.0/mass));
      }
    
      
      
  }
}


  
  
