class Strip
{
  float x = 0;
  float y = 0;
  float z = 0;
  float hue = 0;
  Strip(float _x, float _y, float _z, float _hue)
  {
    x = _x;
    y = _y;
    z = _z;
    hue = _hue;
  }
  
  //中央から遠ざかっていく
  void updatePos()
  {
    PVector pos = new PVector(x, y, z);
    PVector npos = pos.normalize();
    float step = .5;
    x += step * npos.x;
    y += step * npos.y;
    z += step * npos.z;
  }
}
