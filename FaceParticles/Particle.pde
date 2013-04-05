class Particle {

  PVector position, velocity, acceleration, force;
  float drag, radius, mass;
  int fllColor;

  public Particle(PVector _position) {
    position = _position;
    velocity = new PVector();
    acceleration = new PVector();
    force = new PVector();
    drag = 0.95f;
  } 

  void update() {
    velocity.mult(drag);
    velocity.add(force);
    position.add(velocity);
    force.div(mass);
    acceleration = new PVector();
    force = new PVector();
    velocity.limit(10);
  }


}

