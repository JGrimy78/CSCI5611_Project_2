//Compute collision tests. Code from the in-class exercises may be helpful here.

//Returns true if the point is inside a circle
//You must consider a point as colliding if it's distance is <= eps
boolean pointInCircle(Vec2 center, float r, Vec2 pointPos, float eps){
  float dist = pointPos.distanceTo(center);
  if (dist <= r+2 || dist <= eps){ //small safety factor :: changed r+2 to eps
    return true;
  }
  return false;
}

//Returns true if the point is inside a list of circle
//You must consider a point as colliding if it's distance is <= eps
boolean pointInCircleList(Vec2[] centers, float[] radii, int numObstacles, Vec2 pointPos, float eps){
    for (int i = 0; i < numObstacles; i++){
    Vec2 center =  centers[i];
    float r = radii[i];
    if (pointInCircle(center,r,pointPos, eps)){
      return true;
    }
  }
  return false;
}


class hitInfo{
  public boolean hit = false;
  public float t = 9999999;
}

void detectCollision(int numObstacles, int numNodes, Vec2 pos[], Vec2 vel[], float r ) {
  float COR = 0.7;
  
  for (int i = 1; i < numNodes; i++){
    if (pos[i].y > height - r){
      pos[i].y = height - r;
      vel[i].y *= -COR;
    }
    if (pos[i].y < r){
      pos[i].y = r;
      vel[i].y *= -COR;
    }
    if (pos[i].x > width - r){
      pos[i].x = width - r;
      vel[i].x *= -COR;
    }
    if (pos[i].x < r){
      pos[i].x = r;
      vel[i].x *= -COR;
    } 
  }
  
  if (numObstacles > 0) {
    for(int i = 1; i < numNodes; i++){
      for(int o = 0; o < numObstacles; o++){
        Obstacle tempObs = obsList.get(o);
        if (pos[i].distanceTo(tempObs.pos) < (tempObs.radius+r)){
          Vec2 normal = (pos[i].minus(tempObs.pos)).normalized();
          //Vec2 obstNormal;                      //Obstacle velocity normal
          pos[i] = tempObs.pos.plus(normal.times(tempObs.radius+r).times(1.01));
          Vec2 velNormal = normal.times(dot(vel[i],normal));
          vel[i].subtract(velNormal.times(1 + COR));
        }
      }
    }   
  }
}
