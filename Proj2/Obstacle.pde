public class Obstacle {
  Vec2 pos = new Vec2(0, 0);
  float radius = 0;
  
  public Obstacle (Vec2 pos, float radius) {
    this.pos.x = pos.x;
    this.pos.y = pos.y; 
    this.radius = radius;
  }
  
}
