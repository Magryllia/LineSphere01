import processing.opengl.*;

int radius = 150;
ArrayList<Strip> pos = new ArrayList<Strip>();

void setup()
{
  size(720, 720, OPENGL);
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
    color c = lerpColor(#fdfcfb, #e2d1c3, (float)h/height);
    stroke(c);
    line(0, h, width, h);
  }
  hint(ENABLE_DEPTH_TEST);
}

void draw()
{
  drawBackground();
  translate(width/2, height/2, 0);
  int max = 60 * 6; //6秒で1ループ
  int repeat = frameCount%(max);
  float rot = map(repeat, 0, max, 0, 2 * PI);//1rev/6sec
  rotateX(rot * 1);
  rotateY(rot * 0);

  colorMode(HSB);
  int sat = 70;
  int bri = 200;
  float hue = map(repeat, 0, max, 0, 255);

  //角度を計算
  float radS = rot * 12;
  float radT = PI/2.;

  //座標を計算
  float thisx = 0 + (radius * cos(radS) * sin(radT));
  float thisz = 0 + (radius * sin(radS) * sin(radT));
  float thisy = 0 + (radius * cos(radT));

  //座標を回転
  PMatrix3D mat = new PMatrix3D(thisx, thisy, thisz, 0, 0, 0);
  mat.rotateZ(rot*3);
  mat.rotateX(rot*0);
  mat.rotateY(rot*1);
  thisx = mat.m00;
  thisy = mat.m01;
  thisz = mat.m02;

  pos.add(new Strip(thisx, thisy, thisz, hue));

  //Stripの長さを制限
  int length = 50;
  if (pos.size() > length)  pos.remove(0);

  //中心線
  stroke(hue, sat, bri);
  strokeWeight(4.5);
  line(-thisx, -thisy, -thisz, thisx, thisy, thisz);
  fill(hue, sat, bri);
  sphere(75);
  
  //先端の球
  int tip = 6;
  pushMatrix();
  translate(thisx, thisy, thisz);
  sphere(tip);
  popMatrix();
  pushMatrix();
  translate(-thisx, -thisy, -thisz);
  sphere(tip);
  popMatrix();

  //Stripを描画
  float linewidth = 15;
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

  //Stripの座標更新
  for (Strip p : pos)
  {
    p.updatePos();
  }
}
