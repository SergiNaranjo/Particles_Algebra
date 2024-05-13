// Variables y objetos
float increment_temps = 0.4;
PVector desti;
particula boid1;
particula boid2;
particula lider;
voxel primer_voxel;
particula[] boids = new particula[10]; // Arreglo de boids adicionales

// Funciones y clases
class voxel {
  // Atributos
  PVector forca_dins_voxel;
  PVector posicio_voxel;
  float alcada_voxel, ample_voxel, profunditat_voxel;
  color color_voxel;
  // Constructor
  voxel(PVector f, PVector p, float alcada, float ample, float profunditat, color c) {
    forca_dins_voxel = f.copy();
    posicio_voxel = p.copy();
    alcada_voxel = alcada;
    ample_voxel = ample;
    profunditat_voxel = profunditat;
    color_voxel = c;
  }
  // Métodos
  void pintar_voxel() {
    noFill();
    stroke(color_voxel);
    pushMatrix();
    translate(posicio_voxel.x, posicio_voxel.y, posicio_voxel.z);
    box(ample_voxel, alcada_voxel, profunditat_voxel);
    popMatrix();
  }
}

class particula {
  // Atributos
  PVector posicio_particula;
  PVector velocitat_particula;
  PVector acceleracio_particula;
  float massa_particula;
  float tamany_particula;
  float constant_desti, constant_lider, constant_friccio;
  color color_particula;
  // Constructor
  particula(PVector p, PVector v, float m, float tam, float const_d, float const_l, float const_f, color c) {
    posicio_particula = p.copy();
    velocitat_particula = v.copy();
    massa_particula = m;
    tamany_particula = tam;
    color_particula = c;
    constant_desti = const_d;
    constant_lider = const_l;
    constant_friccio = const_f;
  }
  // Métodos
  void calcula_particula() {
    PVector acumulador_forsa = new PVector(0.0, 0.0, 0.0);
    // Forca cap al desti
    PVector vector_per_usar = PVector.sub(desti, posicio_particula);
    vector_per_usar.normalize();
    vector_per_usar.mult(constant_desti);
    acumulador_forsa.add(vector_per_usar);
    // Forca cap al lider
    if (this != lider) {
      PVector vector_lider = PVector.sub(lider.posicio_particula, posicio_particula);
      vector_lider.normalize();
      vector_lider.mult(constant_lider);
      acumulador_forsa.add(vector_lider);
    }
    // Forca del voxel
    float min_x = primer_voxel.posicio_voxel.x - 0.5 * primer_voxel.ample_voxel;
    float max_x = primer_voxel.posicio_voxel.x + 0.5 * primer_voxel.ample_voxel;
    float min_y = primer_voxel.posicio_voxel.y - 0.5 * primer_voxel.alcada_voxel;
    float max_y = primer_voxel.posicio_voxel.y + 0.5 * primer_voxel.alcada_voxel;
    float min_z = primer_voxel.posicio_voxel.z - 0.5 * primer_voxel.profunditat_voxel;
    float max_z = primer_voxel.posicio_voxel.z + 0.5 * primer_voxel.profunditat_voxel;
    if (posicio_particula.x > min_x && posicio_particula.x < max_x &&
        posicio_particula.y > min_y && posicio_particula.y < max_y &&
        posicio_particula.z > min_z && posicio_particula.z < max_z) {
      acumulador_forsa.add(primer_voxel.forca_dins_voxel);
    }
    // Forca hacia el nuevo destino
    PVector vector_destino = PVector.sub(desti, posicio_particula);
    vector_destino.normalize();
    vector_destino.mult(constant_desti);
    acumulador_forsa.add(vector_destino);
    acumulador_forsa.mult(-1);
    
    // Forca de friccio
    PVector friccio = velocitat_particula.copy();
    friccio.mult(-1.0 * constant_friccio);
    acumulador_forsa.add(friccio);
    // Aceleracio
    acceleracio_particula = acumulador_forsa.div(massa_particula);
    // Actualizar velocidad
    velocitat_particula.add(acceleracio_particula.mult(increment_temps));
    // Actualizar posicion
    posicio_particula.add(velocitat_particula.copy().mult(increment_temps));
}

  void pinta_particula() {
    pushMatrix();
    translate(posicio_particula.x, posicio_particula.y, posicio_particula.z);
    stroke(color_particula);
    sphere(tamany_particula);
    popMatrix();
  }
}

// Configuracion inicial
void setup() {
  size(1920, 1080, P3D);
  desti = new PVector(500, height/2.0 - 50, -400);
  primer_voxel = new voxel(new PVector(0.0, -1.0, 0.0), new PVector(width / 2.0, height / 2.0, 0.0),
    100.0, 150.0, 100.0, color(200));
  boid1 = new particula(new PVector(width / 4.0, 3 * height / 4.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 15.0, 0.2, 0.2, 0.5, color(255, 0, 0));
  boid2 = new particula(new PVector(3.0 * width / 4.0, 3 * height / 4.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 15.0, 0.8, 0.1, 0.2, color(0, 255, 0));
  lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, 0.6, color(0, 0, 255));
  
  // Inicializar los boids adicionales
  for (int i = 0; i < boids.length; i++) {
    float x = random(width);
    float y = random(height);
    float z = random(-500, 500);
    PVector posicion = new PVector(x, y, z);
    PVector velocidad = PVector.random3D();
    float masa = random(0.5, 2.0);
    float tamano = random(10, 20);
    float constante_destino = random(0.1, 0.5);
    float constante_lider = random(0.1, 0.5);
    float constante_friccion = random(0.1, 0.5);
    color color_boid = color(random(255), random(255), random(255));
    boids[i] = new particula(posicion, velocidad, masa, tamano, constante_destino, constante_lider, constante_friccion, color_boid);
  }
}

// Bucle principal de dibujo
void draw() {
  background(0);
  boid1.calcula_particula();
  boid2.calcula_particula();
  lider.calcula_particula();
  boid1.pinta_particula();
  boid2.pinta_particula();
  lider.pinta_particula();
  primer_voxel.pintar_voxel();
  
  // Dibujar y actualizar los boids adicionales
  for (int i = 0; i < boids.length; i++) {
    boids[i].calcula_particula();
    boids[i].pinta_particula();
  }
  
  fill(255);
  stroke(0);
  rect(0.0, 0.0, 20, height);
  rect(width - 20, 0.0, 20, height);
  rect(0.0, height - 20, width, 20);
  rect(0.0, 0.0, width, 20);
  
  noFill();
  stroke(255);
  pushMatrix();
  translate(width/2.0, height/2.0 - 50, 0);
  rotateX(20);
  box(width/2.0, height/2.0, 500);
  popMatrix();
  
  // NUEVO DESTINO
  fill(255, 255, 0);
  stroke(0);
  pushMatrix();
  translate(500, height/2.0 - 50, -400);
  rotateX(20);
  box(50, 50, 50);
  popMatrix();
  
}
