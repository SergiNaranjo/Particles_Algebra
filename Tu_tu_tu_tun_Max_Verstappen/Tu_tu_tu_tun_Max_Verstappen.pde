// Per a generar una trajectòria
// Polinòmica, Cúbica, Paramètrica
// Amb 4 punts de control (P0, P1, P2, P3)

// Variables i objectes
corba la_primera_corba;
float u; // Variable de la posició al llarg de la corba
float velocidad; // Velocitat de l'element
boolean anada; // Direcció de l'element

// Classes
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
      -3 * punts_ctrl[0].x + 3 * punts_ctrl[1].x,
      -3 * punts_ctrl[0].y + 3 * punts_ctrl[1].y,
      -3 * punts_ctrl[0].z + 3 * punts_ctrl[1].z);
    // C2 = 9P0 - 22.5P1 + 18P2 - 4.5P3
    coefs[2].set(
      3 * punts_ctrl[0].x - 6 * punts_ctrl[1].x + 3 * punts_ctrl[2].x,
      3 * punts_ctrl[0].y - 6 * punts_ctrl[1].y + 3 * punts_ctrl[2].y,
      3 * punts_ctrl[0].z - 6 * punts_ctrl[1].z + 3 * punts_ctrl[2].z);
    // C3 = -4.5P0 + 13.5P1 - 13.5P2 + 4.5P3
    coefs[3].set(
      -punts_ctrl[0].x + 3 * punts_ctrl[1].x - 3 * punts_ctrl[2].x + punts_ctrl[3].x,
      -punts_ctrl[0].y + 3 * punts_ctrl[1].y - 3 * punts_ctrl[2].y + punts_ctrl[3].y,
      -punts_ctrl[0].z + 3 * punts_ctrl[1].z - 3 * punts_ctrl[2].z + punts_ctrl[3].z
    );
  }
  
  void pintar() {
    // Comencem pintant els punts de ctrl --> son 4
    fill(255, 0, 0);
    strokeWeight(3);
    stroke(255);
    for (int i = 0; i < 4; i++) {
      pushMatrix();
      translate(punts_ctrl[i].x, punts_ctrl[i].y, punts_ctrl[i].z);
      sphere(12.5);
      popMatrix();
    }
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
    
    stroke(200);
    strokeWeight(2);
    
    line(punts_ctrl[0].x, punts_ctrl[0].y, punts_ctrl[0].z, punts_ctrl[1].x, punts_ctrl[1].y, punts_ctrl[1].z);
    line(punts_ctrl[1].x, punts_ctrl[1].y, punts_ctrl[1].z, punts_ctrl[3].x, punts_ctrl[3].y, punts_ctrl[3].z);
    line(punts_ctrl[3].x, punts_ctrl[3].y, punts_ctrl[3].z, punts_ctrl[2].x, punts_ctrl[2].y, punts_ctrl[2].z);
    line(punts_ctrl[2].x, punts_ctrl[2].y, punts_ctrl[2].z, punts_ctrl[0].x, punts_ctrl[0].y, punts_ctrl[0].z);
  }
  
  PVector getPuntARecorrer(float u) {
    return new PVector(
      coefs[0].x + coefs[1].x * u + coefs[2].x * u * u + coefs[3].x * u * u * u,
      coefs[0].y + coefs[1].y * u + coefs[2].y * u * u + coefs[3].y * u * u * u,
      coefs[0].z + coefs[1].z * u + coefs[2].z * u * u + coefs[3].z * u * u * u
    );
  }
}

// Funcions
void setup() {
  size(800, 600, P3D);
  // Els 4 punts de ctrl
  PVector[] p = new PVector[4];
  p[0] = new PVector(100, 100, 0);
  p[1] = new PVector(300, 200, -100);
  p[2] = new PVector(400, 300, 100);
  p[3] = new PVector(700, 400, 0);
  // Crido al constructor de la corba
  la_primera_corba = new corba(p, 200);
  // Calculem els coeficients
  la_primera_corba.calcular_coefs();
  
  // Inicialitzem variables per a l'animació
  u = 0;
  velocidad = 0.01;
  anada = true;
}

void draw() {
  background(0);
  lights(); // Afegir llums per a efectes 3D
  
  // Pintar la corba
  la_primera_corba.pintar();
  
  // Actualitzar la posició de l'element que recorre la corba
  PVector posicio = la_primera_corba.getPuntARecorrer(u);
  
  // Dibuixar l'element
  fill(0, 0, 255);
  noStroke();
  pushMatrix();
  translate(posicio.x, posicio.y, posicio.z);
  sphere(10);
  popMatrix();
  
  // Actualitzar la variable de posició u
  if (anada) {
    u += velocidad;
    if (u >= 1) {
      u = 1;
      anada = false;
    }
  } else {
    u -= velocidad;
    if (u <= 0) {
      u = 0;
      anada = true;
    }
  }
}
