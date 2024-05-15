PVector[] puntos = new PVector[4];

void setup() 
{
  size(800, 600);

  puntos[0] = new PVector(50, height-50);
  puntos[1] = new PVector(100, 100);
  puntos[2] = new PVector(300, 300);
  puntos[3] = new PVector(width-50, 50);
}

void draw() 
{
  background(255);
  
  for (int i = 0; i < puntos.length; i++) 
  {
    fill(255, 0, 0);
    ellipse(puntos[i].x, puntos[i].y, 10, 10);
  }
  
  noFill();
  stroke(0);
  beginShape();
  for (float t = 0; t <= 1; t += 0.01) 
  {
    PVector punto = interpolate(puntos, t);
    vertex(punto.x, punto.y);
  }
  endShape();
}

PVector interpolate(PVector[] puntos, float t) 
{
  int n = puntos.length - 1; 
  int idx = floor(t * n); 
  float u = t * n - idx; 

  PVector p0 = puntos[idx];
  PVector p1 = puntos[idx + 1];

  float h1 = 2 * pow(u, 3) - 3 * pow(u, 2) + 1;
  float h2 = -2 * pow(u, 3) + 3 * pow(u, 2);
  float h3 = pow(u, 3) - 2 * pow(u, 2) + u;
  float h4 = pow(u, 3) - pow(u, 2);

  PVector punto = new PVector(h1 * p0.x + h2 * p1.x + h3 * (p1.x - p0.x) + h4 * (p1.x - p0.x),h1 * p0.y + h2 * p1.y + h3 * (p1.y - p0.y) + h4 * (p1.y - p0.y));
  return punto;
}
