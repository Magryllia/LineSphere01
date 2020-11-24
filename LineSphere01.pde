import processing.opengl.*;

int radius = 100;
float s = 0;
float t = 0;
ArrayList<Strip> pos = new ArrayList<Strip>();

void setup()
{
  size(500, 500, OPENGL);
  background(255);
  stroke(0);
  noFill();
  frameRate(60);
  //translate(width, height);
}

void drawBackground()
{
  hint(DISABLE_DEPTH_TEST);
  strokeWeight(1);
  for (int h = 0; h <= height; h++)
  {
    colorMode(HSB);
    color c = lerpColor(#fdfcfb, #e2d1c3, (float)h/width);
    stroke(c);
    line(0, h, width, h);
  }
  hint(ENABLE_DEPTH_TEST);
}

void draw()
{
  drawBackground();
  translate(width/2, height/2, 0);
  int max = 60 * 6;
  int repeat = frameCount%(max);
  float rotZ = map(repeat, 0, max, 0, 2 * PI);
  rotateX(rotZ);
  //rotateY(rotZ);
  
  colorMode(HSB);
  int sat = 70;
  int bri = 200;
  s = (s+12)%360;
  //t = (t+3)%360;
  t = map(repeat, 0, max, 0, 360);
  float hue = map(t, 0, 360, 0, 255);
  
  //角度を計算
  float radT = radians(t);
  //s = (s + 6 + sin(radT) * 6)%360; 
  float radS = radians(s);
  radT = PI/2.;
  //座標を計算
  pushMatrix();
  //rotateX(frameCount * .03);
  float thisx = 0 + (radius * cos(radS) * sin(radT));
  float thisz = 0 + (radius * sin(radS) * sin(radT));
  //float thisy = 0 + (radius * cos(radT));
  float thisy = 0;
  PMatrix3D mat = new PMatrix3D(thisx, thisy, thisz, 0, 0, 0);
  mat.rotateZ(frameCount * .06);
  //mat.rotateX(frameCount * .03);
  mat.rotateY(frameCount * .02);
  thisx = mat.m00;
  thisy = mat.m01;
  thisz = mat.m02;
  
  popMatrix();
  
  pos.add(new Strip(thisx, thisy, thisz, hue));
  if (pos.size() > 50)  pos.remove(0);

  stroke(hue, sat, bri);
  strokeWeight(3);
  line(0, 0, 0, thisx, thisy, thisz);
  line(0, 0, 0, -thisx, -thisy, -thisz);
  fill(hue, sat, bri);
  sphere(50);
  
  int tip = 4;
  pushMatrix();
  translate(thisx, thisy, thisz);
  sphere(tip);
  popMatrix();
  
  pushMatrix();
  translate(-thisx, -thisy, -thisz);
  sphere(tip);
  popMatrix();
  
  float linewidth = 10;
  noFill();
  beginShape();
  for (int i = pos.size()-1; i >= 0; i--)
  {
    float w = map(i, pos.size()-1, 0, linewidth, 0);
    Strip p = pos.get(i);
    strokeWeight(w);
    stroke(p.hue, sat, bri);
    curveVertex(p.x, p.y, p.z);
  }
  endShape();
  
  beginShape();
  for (int i = pos.size()-1; i >= 0; i--)
  {
    float w = map(i, pos.size()-1, 0, linewidth, 0);
    Strip p = pos.get(i);
    strokeWeight(w);
    stroke(p.hue, sat, bri);
    curveVertex(-p.x, -p.y, -p.z);
  }
  endShape();
  
  for(Strip p : pos)
  {
    p.updatePos();
  }
  
}
