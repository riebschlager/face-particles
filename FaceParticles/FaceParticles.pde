import codeanticode.gsvideo.*;
import java.awt.*;
import hypermedia.video.*;

ParticleSystem psFace, psType;
GSCapture cam;
OpenCV opencv;
PGraphics canvas;
Rectangle[] faces;
PImage t;

PGraphics fade(PImage img, float percentage) {
  PGraphics tmpImg = createGraphics(img.width, img.height, JAVA2D);
  tmpImg.beginDraw();
  tmpImg.image(img, 0, 0);
  tmpImg.loadPixels();
  for (int i = 0; i < tmpImg.pixels.length; i++) {
    int p = tmpImg.pixels[i];
    float a = alpha(p) * (percentage / 100);
    tmpImg.pixels[i] = color(red(p), green(p), blue(p), a);
  }
  tmpImg.updatePixels();
  tmpImg.endDraw();
  return tmpImg;
}

void setup() {
  size(640, 360);

  background(255);
  ellipseMode(CENTER);
  canvas = createGraphics(width, height);
  cam = new GSCapture(this, 640, 480);
  cam.start();
  opencv = new OpenCV(this);
  opencv.allocate(640, 480); 
  opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT);
  psFace = new ParticleSystem(500, width, height);
  psType = new ParticleSystem(500, width, height);
  faces = new Rectangle[1];
  faces[0] = new Rectangle(width/2, height/2, 1, 1);
  t = loadImage("text.png");
}

void draw() {
  background(0);

  if (frameCount % 100 == 0) {
    opencv.copy(cam);
    faces = opencv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);
  }

  psFace.run();

  image(psFace.canvas, 0, 0);
  blend(fade(cam.get(),10), 0, 0, width, height, 0, 0, width, height, OVERLAY);
  //saveFrame("images/####.tif");
}

int getBrightness(int c) { 
  int r = c >> 16 & 0xFF, g = c >> 8 & 0xFF, b = c & 0xFF; 
  return c = (c = r > g ? r : g) < b ? b : c;
} 

void captureEvent(GSCapture c) {
  c.read();
}

public void stop() {
  opencv.stop();
  super.stop();
}

