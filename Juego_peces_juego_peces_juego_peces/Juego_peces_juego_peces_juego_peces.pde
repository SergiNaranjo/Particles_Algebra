// Variables y objetos

float increment_temps = 0.4;
PVector desti;
boolean isometric = true;
particula boid1;
particula boid2;
particula lider;
voxel primer_voxel;
voxel segon_voxel;
voxel tercer_voxel;
voxel quart_voxel;
voxel cinque_voxel;
particula[] boids = new particula[20]; // Arreglo de boids adicionales
corba la_primera_corba;
float u; // Variable de la posició al llarg de la corba
float velocidad; // Velocitat de l'element
boolean anada; // Direcció de l'element

corbaBezier la_segona_corba;
float u2; // Variable de la posició al llarg de la corba
float velocidadBezier; // Velocitat de l'element
boolean anadaBezier; // Direcció de l'element

// Funciones y clases
// Classes

// CURVA DE BEZIER
// Classes
enum estacions
{
  VERANO, OTOÑO, INVIERNO, PRIMAVERA
}
 estacions estacio;
class corbaBezier {
  // Atributs
  PVector[] punts_ctrl_Bezier; // Per on passa
  PVector[] coefs_Bezier; // Governen l'eqüació
  int numero_punts_Bezier; // Quants punts volem pintar per la corba
  
  // Constructor
  corbaBezier(PVector[] pc2, int np2) {
    punts_ctrl_Bezier = new PVector[4]; // Hi ha 4 punts de control
    coefs_Bezier = new PVector[4];
    for (int i = 0; i < 4; i++) {
      punts_ctrl_Bezier[i] = new PVector(0.0, 0.0, 0.0);
      coefs_Bezier[i] = new PVector(0.0, 0.0, 0.0);
      // Copiem els 4 punts de ctrl que ens han passat
      punts_ctrl_Bezier[i] = pc2[i];
    }
    numero_punts_Bezier = np2;
  }
  
  // Mètodes
  void calcular_coefs2() {
    // Necessitem les equacions de la corba d'interpolació
    // C0 = P0
    coefs_Bezier[0].set(punts_ctrl_Bezier[0]);
    // C1 = -5.5P0 + 9P1 - 4.5P2 + P3
    coefs_Bezier[1].set(
      -3 * punts_ctrl_Bezier[0].x + 3 * punts_ctrl_Bezier[1].x,
      -3 * punts_ctrl_Bezier[0].y + 3 * punts_ctrl_Bezier[1].y,
      -3 * punts_ctrl_Bezier[0].z + 3 * punts_ctrl_Bezier[1].z);
    // C2 = 9P0 - 22.5P1 + 18P2 - 4.5P3
    coefs_Bezier[2].set(
      3 * punts_ctrl_Bezier[0].x - 6 * punts_ctrl_Bezier[1].x + 3 * punts_ctrl_Bezier[2].x,
      3 * punts_ctrl_Bezier[0].y - 6 * punts_ctrl_Bezier[1].y + 3 * punts_ctrl_Bezier[2].y,
      3 * punts_ctrl_Bezier[0].z - 6 * punts_ctrl_Bezier[1].z + 3 * punts_ctrl_Bezier[2].z);
    // C3 = -4.5P0 + 13.5P1 - 13.5P2 + 4.5P3
    coefs_Bezier[3].set(
      -punts_ctrl_Bezier[0].x + 3 * punts_ctrl_Bezier[1].x - 3 * punts_ctrl_Bezier[2].x + punts_ctrl_Bezier[3].x,
      -punts_ctrl_Bezier[0].y + 3 * punts_ctrl_Bezier[1].y - 3 * punts_ctrl_Bezier[2].y + punts_ctrl_Bezier[3].y,
      -punts_ctrl_Bezier[0].z + 3 * punts_ctrl_Bezier[1].z - 3 * punts_ctrl_Bezier[2].z + punts_ctrl_Bezier[3].z
    );
  }
  
  void pintar2() {
    // Comencem pintant els punts de ctrl --> son 4
    
    // Seguim pintant els punts de la corba --> son tants com decidim
    stroke(0, 255, 0);
    strokeWeight(3);
    noFill();
    beginShape();
    // corba(u) = C0 + C1 * u + C2 * u^2 + C3 * u^3
    // u va de 0 (inici) a 1 (fí)
    // l'interval = 1 / numero_punts
    PVector punt_a_pintar_Bezier = new PVector();
    float interval_Bezier = 1.0 / numero_punts_Bezier;
    for (float u2 = 0.0; u2 <= 1.0; u2 += interval_Bezier) { // He de pintar tants punts de la corba com digui numero_punts
      punt_a_pintar_Bezier.set(
        coefs_Bezier[0].x + coefs_Bezier[1].x * u2 + coefs_Bezier[2].x * u2 * u2 + coefs_Bezier[3].x * u2 * u2 * u2,
        coefs_Bezier[0].y + coefs_Bezier[1].y * u2 + coefs_Bezier[2].y * u2 * u2 + coefs_Bezier[3].y * u2 * u2 * u2,
        coefs_Bezier[0].z + coefs_Bezier[1].z * u2 + coefs_Bezier[2].z * u2 * u2 + coefs_Bezier[3].z * u2 * u2 * u2
      );
      vertex(punt_a_pintar_Bezier.x, punt_a_pintar_Bezier.y, punt_a_pintar_Bezier.z);
    }
    endShape();
   
  }
  
  PVector getPuntARecorrer(float u) {
    return new PVector(
      coefs_Bezier[0].x + coefs_Bezier[1].x * u2 + coefs_Bezier[2].x * u2 * u2 + coefs_Bezier[3].x * u2 * u2 * u2,
      coefs_Bezier[0].y + coefs_Bezier[1].y * u2 + coefs_Bezier[2].y * u2 * u2 + coefs_Bezier[3].y * u2 * u2 * u2,
      coefs_Bezier[0].z + coefs_Bezier[1].z * u2 + coefs_Bezier[2].z * u2 * u2 + coefs_Bezier[3].z * u2 * u2 * u2
    );
  }
}

// CURVA DE INTERPOLACION
class corba {
  // Atributs
  PVector[] punts_ctrl; // Per on passa
  PVector[] coefs; // Governen l'eqüació
  int numero_punts; // Quants punts volem pintar per la corba
  
  // Constructor
  corba(PVector[] pc, int np) {
    punts_ctrl = new PVector[4]; // Hi ha 4 punts de control
    coefs = new PVector[4];
    for (int i = 0; i < 4; i++) {
      punts_ctrl[i] = new PVector(0.0, 0.0, 0.0);
      coefs[i] = new PVector(0.0, 0.0, 0.0);
      // Copiem els 4 punts de ctrl que ens han passat
      punts_ctrl[i] = pc[i];
    }
    numero_punts = np;
  }
  
  // Mètodes
  void calcular_coefs() {
    // Necessitem les equacions de la corba d'interpolació
    // C0 = P0
    coefs[0].set(punts_ctrl[0]);
    // C1 = -5.5P0 + 9P1 - 4.5P2 + P3
    coefs[1].set(
      -5.5 * punts_ctrl[0].x + 9 * punts_ctrl[1].x - 4.5 * punts_ctrl[2].x + punts_ctrl[3].x,
      -5.5 * punts_ctrl[0].y + 9 * punts_ctrl[1].y - 4.5 * punts_ctrl[2].y + punts_ctrl[3].y,
      -5.5 * punts_ctrl[0].z + 9 * punts_ctrl[1].z - 4.5 * punts_ctrl[2].z + punts_ctrl[3].z
    );
    // C2 = 9P0 - 22.5P1 + 18P2 - 4.5P3
    coefs[2].set(
      9 * punts_ctrl[0].x - 22.5 * punts_ctrl[1].x + 18 * punts_ctrl[2].x - 4.5 * punts_ctrl[3].x,
      9 * punts_ctrl[0].y - 22.5 * punts_ctrl[1].y + 18 * punts_ctrl[2].y - 4.5 * punts_ctrl[3].y,
      9 * punts_ctrl[0].z - 22.5 * punts_ctrl[1].z + 18 * punts_ctrl[2].z - 4.5 * punts_ctrl[3].z
    );
    // C3 = -4.5P0 + 13.5P1 - 13.5P2 + 4.5P3
    coefs[3].set(
      -4.5 * punts_ctrl[0].x + 13.5 * punts_ctrl[1].x - 13.5 * punts_ctrl[2].x + 4.5 * punts_ctrl[3].x,
      -4.5 * punts_ctrl[0].y + 13.5 * punts_ctrl[1].y - 13.5 * punts_ctrl[2].y + 4.5 * punts_ctrl[3].y,
      -4.5 * punts_ctrl[0].z + 13.5 * punts_ctrl[1].z - 13.5 * punts_ctrl[2].z + 4.5 * punts_ctrl[3].z
    );
  }
  
  void pintar() {
   
    // Seguim pintant els punts de la corba --> son tants com decidim
    stroke(0, 255, 0);
    strokeWeight(3);
    noFill();
    beginShape();
    // corba(u) = C0 + C1 * u + C2 * u^2 + C3 * u^3
    // u va de 0 (inici) a 1 (fí)
    // l'interval = 1 / numero_punts
    PVector punt_a_pintar = new PVector();
    float interval = 1.0 / numero_punts;
    for (float u = 0.0; u <= 1.0; u += interval) { // He de pintar tants punts de la corba com digui numero_punts
      punt_a_pintar.set(
        coefs[0].x + coefs[1].x * u + coefs[2].x * u * u + coefs[3].x * u * u * u,
        coefs[0].y + coefs[1].y * u + coefs[2].y * u * u + coefs[3].y * u * u * u,
        coefs[0].z + coefs[1].z * u + coefs[2].z * u * u + coefs[3].z * u * u * u
      );
      vertex(punt_a_pintar.x, punt_a_pintar.y, punt_a_pintar.z);
    }
    endShape();
  }
  
  PVector getPuntARecorrer(float u) {
    return new PVector(
      coefs[0].x + coefs[1].x * u + coefs[2].x * u * u + coefs[3].x * u * u * u,
      coefs[0].y + coefs[1].y * u + coefs[2].y * u * u + coefs[3].y * u * u * u,
      coefs[0].z + coefs[1].z * u + coefs[2].z * u * u + coefs[3].z * u * u * u
    );
  }
}

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
    translate(posicio_voxel.x, posicio_voxel.y - 10, posicio_voxel.z + 200);
    rotateX(50.0);
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
  float radio_repulsion; 
  color color_particula;
  boolean esLider; 
  // Constructor
  particula(PVector p, PVector v, float m, float tam, float const_d, float const_l, float const_f, color c,  float radio_rep) {
    posicio_particula = p.copy();
    velocitat_particula = v.copy();
    massa_particula = m;
    tamany_particula = tam;
    color_particula = c;
    constant_desti = const_d;
    constant_lider = const_l;
    constant_friccio = const_f;
    radio_repulsion = radio_rep; 
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
    
 min_x = segon_voxel.posicio_voxel.x - 0.5 * segon_voxel.ample_voxel;
 max_x = segon_voxel.posicio_voxel.x + 0.5 * segon_voxel.ample_voxel;
 min_y = segon_voxel.posicio_voxel.y - 0.5 * segon_voxel.alcada_voxel;
 max_y = segon_voxel.posicio_voxel.y + 0.5 * segon_voxel.alcada_voxel;
 min_z = segon_voxel.posicio_voxel.z - 0.5 * segon_voxel.profunditat_voxel;
 max_z = segon_voxel.posicio_voxel.z + 0.5 * segon_voxel.profunditat_voxel;

     if (posicio_particula.x > min_x && posicio_particula.x < max_x &&
        posicio_particula.y > min_y && posicio_particula.y < max_y &&
        posicio_particula.z > min_z && posicio_particula.z < max_z) {
      acumulador_forsa.add(segon_voxel.forca_dins_voxel);
    }
    
    
    min_x = tercer_voxel.posicio_voxel.x - 0.5 * tercer_voxel.ample_voxel;
 max_x = tercer_voxel.posicio_voxel.x + 0.5 * tercer_voxel.ample_voxel;
 min_y = tercer_voxel.posicio_voxel.y - 0.5 * tercer_voxel.alcada_voxel;
 max_y = tercer_voxel.posicio_voxel.y + 0.5 * tercer_voxel.alcada_voxel;
 min_z = tercer_voxel.posicio_voxel.z - 0.5 * tercer_voxel.profunditat_voxel;
 max_z = tercer_voxel.posicio_voxel.z + 0.5 * tercer_voxel.profunditat_voxel;

     if (posicio_particula.x > min_x && posicio_particula.x < max_x &&
        posicio_particula.y > min_y && posicio_particula.y < max_y &&
        posicio_particula.z > min_z && posicio_particula.z < max_z) {
      acumulador_forsa.add(tercer_voxel.forca_dins_voxel);
    }
    
        min_x = quart_voxel.posicio_voxel.x - 0.5 * quart_voxel.ample_voxel;
 max_x = quart_voxel.posicio_voxel.x + 0.5 * quart_voxel.ample_voxel;
 min_y = quart_voxel.posicio_voxel.y - 0.5 * quart_voxel.alcada_voxel;
 max_y = quart_voxel.posicio_voxel.y + 0.5 * quart_voxel.alcada_voxel;
 min_z = quart_voxel.posicio_voxel.z - 0.5 * quart_voxel.profunditat_voxel;
 max_z = quart_voxel.posicio_voxel.z + 0.5 * quart_voxel.profunditat_voxel;

     if (posicio_particula.x > min_x && posicio_particula.x < max_x &&
        posicio_particula.y > min_y && posicio_particula.y < max_y &&
        posicio_particula.z > min_z && posicio_particula.z < max_z) {
      acumulador_forsa.add(quart_voxel.forca_dins_voxel);
    }

   
        min_x = cinque_voxel.posicio_voxel.x - 0.5 * cinque_voxel.ample_voxel;
 max_x = cinque_voxel.posicio_voxel.x + 0.5 * cinque_voxel.ample_voxel;
 min_y = cinque_voxel.posicio_voxel.y - 0.5 * cinque_voxel.alcada_voxel;
 max_y = cinque_voxel.posicio_voxel.y + 0.5 * cinque_voxel.alcada_voxel;
 min_z = cinque_voxel.posicio_voxel.z - 0.5 * cinque_voxel.profunditat_voxel;
 max_z = cinque_voxel.posicio_voxel.z + 0.5 * cinque_voxel.profunditat_voxel;

     if (posicio_particula.x > min_x && posicio_particula.x < max_x &&
        posicio_particula.y > min_y && posicio_particula.y < max_y &&
        posicio_particula.z > min_z && posicio_particula.z < max_z) {
      acumulador_forsa.add(cinque_voxel.forca_dins_voxel);
    }
    
    // Forca hacia el nuevo destino
    PVector vector_destino = PVector.sub(desti, posicio_particula);
    vector_destino.normalize();
    vector_destino.mult(constant_desti);
    acumulador_forsa.add(vector_destino);
    
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
    
    // Centro de gravedad
    PVector centroGravedad = new PVector(0, 0, 0);
    for (int i = 0; i < boids.length; i++) {
      if (boids[i] != this) {
        centroGravedad.add(boids[i].posicio_particula);
        // Fuerza de repulsión entre partículas si están muy cerca
        PVector direccion = PVector.sub(boids[i].posicio_particula, posicio_particula);
        float distancia = direccion.mag();
        if (distancia < radio_repulsion) {
          direccion.normalize();
          float fuerza = 1 / (distancia * distancia);
          direccion.mult(-fuerza);
          acumulador_forsa.add(direccion);
        }
      }
    }
    centroGravedad.div(boids.length - 1);
    // Fuerza de atracción hacia el centro de gravedad
    PVector direccion_centroGravedad = PVector.sub(centroGravedad, posicio_particula);
    direccion_centroGravedad.normalize();
    direccion_centroGravedad.mult(constant_desti); // Ajusta la magnitud de la fuerza hacia el centro de gravedad
    acumulador_forsa.add(direccion_centroGravedad);
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

 float friccio_lider =  0.6;
 float friccio_peix = 0.2;
 boolean friccio = true;
  
  size(1920, 1080, P3D);
  desti = new PVector(500, height/2.0 - 50, -400);
  primer_voxel = new voxel(new PVector(0.0, 0.0, -30.0), new PVector(width / 2.0, height / 2.0, 0.0),
   50.0, 50.0, 100.0, color(200));
  segon_voxel = new voxel(new PVector(-1.5, 0.0, 0.0), new PVector((width / 2.0)+300, height / 2.0, 0.0),
    100.0, 150.0, 100.0, color(200));
  tercer_voxel = new voxel(new PVector(0.0, 1.5, 0.0), new PVector((width / 2.0)- 300, height / 2.0, 0.0),
    100.0, 150.0, 100.0, color(200));
  quart_voxel = new voxel(new PVector(0.0, 0.0, 30.0), new PVector(width / 2.0, (height / 2.0)-100, 0.0),
   50.0, 50.0, 100.0, color(200));
  cinque_voxel = new voxel(new PVector(0.0, -3.0, 0.0), new PVector(width / 2.0, (height / 2.0)+100, 0.0),
   50.0, 50.0, 100.0, color(200));
   
   
  
  
   
   
  
  boid1 = new particula(new PVector(width / 4.0, 3 * height / 4.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 15.0, 0.2, 0.2, friccio_peix, color(255, 0, 0), 0.0);
  boid2 = new particula(new PVector(3.0 * width / 4.0, 3 * height / 4.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 15.0, 0.8, 0.1, friccio_peix, color(0, 255, 0), 0.0);
      lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, friccio_lider, color(0, 0, 255), 0.0);
  if (estacio == estacions.VERANO)
  {
    lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, friccio_lider, color(0, 0, 255), 0.0);
  }
  if (estacio == estacions.OTOÑO)
  {
    lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, friccio_lider+0.2 , color(0, 0, 255), 0.0);
  }
  if (estacio == estacions.INVIERNO)
  {
    lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, friccio_lider+0.5, color(0, 0, 255), 0.0);
  }
  if (estacio == estacions.PRIMAVERA)
  {
    lider = new particula(new PVector(width / 2.0, height - 50.0, 0.0),
    new PVector(0.0, 0.0, 0.0), 1.0, 20.0, 0.9, 0.0, friccio_lider+0.1, color(0, 0, 255), 0.0);
  }
  
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
    float constante_friccion = 0;
    if (friccio)
    {
      constante_friccion = random(0.1, 0.5);
    }
    
    color color_boid = color(random(255), random(255), random(255));
    boids[i] = new particula(posicion, velocidad, masa, tamano, constante_destino, constante_lider, constante_friccion, color_boid, 50);
  }
  
  PVector[] p = new PVector[4];
  p[0] = new PVector(500, height/2.0 - 50, -400);
  p[1] = new PVector(300, height/2.0, -200);
  p[2] = new PVector(width/2.0 + 200, height/2.0 + 20, 100);
  p[3] = new PVector(width/2.0 + 100, 300, 0);
  // Crido al constructor de la corba
  la_primera_corba = new corba(p, 200);
  // Calculem els coeficients
  la_primera_corba.calcular_coefs();
  
  PVector[] p2 = new PVector[4];
  p2[0] = new PVector(width/2.0 + 100, 300, 0);
  p2[1] = new PVector(700, 200, -100);
  p2[2] = new PVector(800, 500, 100);
  p2[3] = new PVector(500, height/2.0 - 50, -400);
  // Crido al constructor de la corba
  la_segona_corba = new corbaBezier(p2, 200);
  // Calculem els coeficients
  la_segona_corba.calcular_coefs2();
}

  int count = 0;
  int num = 0;
// Bucle principal de dibujo
void draw() {
  background(0);
if (!isometric)
{
  ortho(-width/2.0, width/2.0, -height/2.0, height/2.0, -1000.0, 1000.0);

}
else
  {
    perspective();

  }
  boid1.calcula_particula();
  boid2.calcula_particula();
  lider.calcula_particula();
  boid1.pinta_particula();
  boid2.pinta_particula();
  lider.pinta_particula();
  primer_voxel.pintar_voxel();
  segon_voxel.pintar_voxel();
  tercer_voxel.pintar_voxel();
  quart_voxel.pintar_voxel();
  cinque_voxel.pintar_voxel();
  
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
  
 
  
  lights(); // Afegir llums per a efectes 3D
  
  // Pintar la corba
  la_primera_corba.pintar();
  
  lights();
  // Pintar la corba
  la_segona_corba.pintar2();
}


int posZ = 0;
void keyPressed()
{
 
  estacio = estacions.VERANO;
  if (key == 'c' || key == 'C')
  {
    isometric = !isometric;
  }
   if (key == '1')
   {
     segon_voxel = new voxel(new PVector(0.0, 0.0, 0.0), new PVector((width / 2.0)+300, height / 2.0, 0.0),
    100.0, 150.0, 100.0, color(200));
   }
   if (key == '2')
   {
     segon_voxel = new voxel(new PVector(-1.5, 0.0, 0.0), new PVector((width / 2.0)+300, height / 2.0, 0.0),
    100.0, 150.0, 100.0, color(200));
   }
   switch(key)
   {
     case '6':
     estacio = estacions.VERANO;
     break;
     case '7':
     estacio = estacions.OTOÑO;
     break;
     case '8':
     estacio = estacions.INVIERNO;
     break;
     case '9':
     estacio = estacions.PRIMAVERA;
     break;
   }
   
}


void mouseMoved()
{

  desti = new PVector(mouseX, mouseY, 0);
  if (mousePressed) 
   {
     posZ = posZ++;
   }
}
