class ParticleSystem {

  Particle[] particles;
  int difX, difY;
  PGraphics canvas;
  PGraphics fader;

  public ParticleSystem(int _numberOfParticles, int _width, int _height) {
    particles = new Particle[_numberOfParticles];
    canvas = createGraphics(_width, _height);
    fader = createGraphics(_width,_height);
    fader.beginDraw();
    fader.background(0,5);
    fader.endDraw();
    for (int i = 0; i < _numberOfParticles; ++i) {
      particles[i] = new Particle(new PVector(random(width), random(height)));
    }
    difX = width/2;
    difY = height/2;
  }

  void run() {
    if (faces.length>0) {
      difX = faces[0].x + faces[0].width / 2;
      difY = faces[0].y + faces[0].height / 2;
    }
    canvas.beginDraw();
     
    for (int i=0; i<particles.length; i++) {
      Particle particle1 = particles[i];
      color pixel = cam.get((int) particle1.position.x, (int) particle1.position.y);
      int pixelBrightness = getBrightness(pixel);      
      particle1.radius = map(pixelBrightness, 0, 255, 0.25, 10.0);
      particle1.mass = map(pixelBrightness, 0, 255, 0.25, 0.855);
      particle1.fllColor = color(red(pixel), green(pixel), blue(pixel), 200);
      PVector attractor = new PVector(particle1.position.x - difX, particle1.position.y - difY);


      float magnitude = attractor.mag();
      float attractorStrength = (magnitude - particle1.mass) * -0.001;

      attractor.mult(attractorStrength/magnitude);
      particle1.force.add(attractor);


      if (i >= particles.length - 1) continue;

      for (int j = i + 1; j < particles.length; j++) {
        Particle particle2 = particles[j];
        attractor.set(particle2.position);
        attractor.sub(particle1.position);
        magnitude = attractor.mag();
        attractorStrength = particle2.mass * (particle2.mass*50-magnitude);
        if ((attractorStrength > 0) && (magnitude > 0)) {
          attractor.mult(attractorStrength*(particle1.mass/100) / magnitude);
          particle1.force.sub(attractor);
          particle2.force.add(attractor);
        }
      }
      particle1.update();
      canvas.strokeWeight(particle1.radius);
      canvas.stroke(particle1.fllColor);
      canvas.point(particle1.position.x, particle1.position.y);
    }
    canvas.blendMode(BLEND);
    canvas.blend(fader,0,0,width,height,0,0,width,height,HARD_LIGHT);
    canvas.endDraw();
  }
}

