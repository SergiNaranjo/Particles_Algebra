// Puntos de control
PVector[] puntos = new PVector[4];

void setup() {
  size(800, 600);
  // Definir los puntos de control
  puntos[0] = new PVector(50, height-50);
  puntos[1] = new PVector(100, 100);
  puntos[2] = new PVector(300, 300);
  puntos[3] = new PVector(width-50, 50);
}

void draw() {
  background(255);
  
  // Dibujar puntos de control
  for (int i = 0; i < puntos.length; i++) {
    fill(255, 0, 0);
    ellipse(puntos[i].x, puntos[i].y, 10, 10);
  }
  
  // Dibujar la curva spline cúbica
  noFill();
  stroke(0);
  beginShape();
  curveVertex(puntos[0].x, puntos[0].y);
  for (int i = 0; i < puntos.length - 1; i++) {
    curveVertex(puntos[i].x, puntos[i].y);
    curveVertex(puntos[i+1].x, puntos[i+1].y);
  }
  curveVertex(puntos[puntos.length-1].x, puntos[puntos.length-1].y);
  endShape();
}
