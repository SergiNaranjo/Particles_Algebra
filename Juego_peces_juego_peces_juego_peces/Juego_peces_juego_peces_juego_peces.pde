// Un sistema de particules necessita estructura
// Una bona manera d'estructurar es tenir objectes
// Els objectes es creen amb classes
// Una particula pot ser un objecte! i moltes tb

// Afegirem comportaments de Boids (vida artificial)
// En posarem 2 amb 2 heuristiques de moviment (intencions)
// Una de seguir a un lider i una altra d'anar a un desti
// Aquestes intencions faran de forces

// Afegirem 4 voxels (volume elements) al mig de la finestra
// Faran unes forces en diagonal i cap a fora

// Variables i objectes
float increment_temps = 0.4;
PVector desti;
particula boid1; // Objecte de la Classe particula
particula boid2; // Objecte de la Classe particula
particula lider; // Objecte de la Classe particula
voxel primer_voxel; // Objecte de la Classe voxel

// Funcions i classes
class voxel{
  // Atributs
  PVector forca_dins_voxel;
  PVector posicio_voxel;
  float alt_voxel, ample_voxel;
  color color_voxel;
  // Constructor
  voxel(PVector f, PVector p, float alt, float amp, color c){
    forca_dins_voxel = new PVector(0.0,0.0);
    posicio_voxel = new PVector(0.0,0.0);
    forca_dins_voxel = f;
    posicio_voxel = p;
    alt_voxel = alt;
    ample_voxel = amp;
    color_voxel = c;
  }
  // Metodes
  void calcular_forca_voxel(){
    // AIXO ARA NO CAL
  }
  
  void pintar_voxel(){
    noFill();
    stroke(color_voxel);
    rectMode(CENTER);
    rect(posicio_voxel.x,posicio_voxel.y,ample_voxel,alt_voxel);
  }
}

class particula {
  // Atributs
  PVector posicio_particula;
  PVector velocitat_particula;
  PVector acceleracio_particula;
  boolean soc_lider;
  float massa_particula;
  float tamany_particula;
  float constant_desti, constant_lider, constant_friccio;
  color color_particula;
  // Constructor
  particula(boolean l, PVector p, PVector v, float m, float tam,
    float const_d, float const_l, float const_f, color c) {
    posicio_particula = new PVector(0.0, 0.0);
    velocitat_particula = new PVector(0.0, 0.0);
    acceleracio_particula = new PVector(0.0, 0.0);

    posicio_particula.set(p);
    velocitat_particula.set(v);

    massa_particula = m;
    tamany_particula = tam;
    color_particula = c;

    constant_desti = const_d;
    constant_lider = const_l;
    constant_friccio = const_f;
    
    soc_lider = l;
  }
  // Metodes
  void calcula_particula() {
    PVector acumulador_forsa;
    PVector vector_per_usar;
    acumulador_forsa = new PVector(0.0, 0.0);
    vector_per_usar = new PVector(0.0, 0.0);
    // Solver Euler
    // 0) Acumular les forces
    // Forca cap al desti
    // Calculem el vector que va del boid al desti
    vector_per_usar.x = desti.x - posicio_particula.x;
    vector_per_usar.y = desti.y - posicio_particula.y;
    // Calculem el modul d'aquest vector
    float modul = sqrt(vector_per_usar.x*vector_per_usar.x
      +vector_per_usar.y*vector_per_usar.y);
    // Fem el vector unitari dividint-lo pel seu modul
    vector_per_usar.x/=modul;
    vector_per_usar.y/=modul;
    // Multipliquem el vector per la seva constant associada
    vector_per_usar.x*=constant_desti;
    vector_per_usar.y*=constant_desti;
    // Ara el vector ja és la forca que necessitem per anar al desti
    acumulador_forsa.x = vector_per_usar.x;
    acumulador_forsa.y = vector_per_usar.y;
    // Forca cap al lider
    if (!soc_lider){
      // Calculo el vector que va del boid al lider
      vector_per_usar.x = lider.posicio_particula.x - posicio_particula.x;
      vector_per_usar.y = lider.posicio_particula.y - posicio_particula.y;
      // Calculo el modul d'aquest vector
      modul = sqrt(vector_per_usar.x*vector_per_usar.x
        +vector_per_usar.y*vector_per_usar.y);
      // Faig unitari el vector dividint-lo pel seu modul
      vector_per_usar.x/=modul;
      vector_per_usar.y/=modul;
      // Multiplico al vector per la constant i ja tindre la força lider
      vector_per_usar.x*=constant_lider;
      vector_per_usar.y*=constant_lider;
      // Acumulo (afegeixo) aquesta forca a les altres que hi ha
      acumulador_forsa.x += vector_per_usar.x;
      acumulador_forsa.y += vector_per_usar.y;
    }
    // Forca de voxels
    // Anem a calcular els valors Xmin, Ymin, Xmax, Ymax del voxel
    // ULL! Aixo esta fatal perque es podria PREcalcular i fer nomes 1 cop
    // Perque aquests valors NO canvien, NO depenen del Boid
    PVector xymin_voxel = new PVector(0.0,0.0); // Xmin i Ymin del voxel
    PVector xymax_voxel = new PVector(0.0,0.0); // Xmax i Ymax del voxel
    xymin_voxel.x = primer_voxel.posicio_voxel.x-0.5*primer_voxel.ample_voxel;
    xymin_voxel.y = primer_voxel.posicio_voxel.y-0.5*primer_voxel.alt_voxel;
    xymax_voxel.x = primer_voxel.posicio_voxel.x+0.5*primer_voxel.ample_voxel;
    xymax_voxel.y = primer_voxel.posicio_voxel.y+0.5*primer_voxel.alt_voxel;
    // He de comprovar si la particula esta dins del voxel o no
    if ((posicio_particula.x>xymin_voxel.x)
    && (posicio_particula.x<xymax_voxel.x)
    && (posicio_particula.y>xymin_voxel.y)
    && (posicio_particula.y<xymax_voxel.y)){
      // Som dins del voxel
      acumulador_forsa.x += primer_voxel.forca_dins_voxel.x;
      acumulador_forsa.y += primer_voxel.forca_dins_voxel.y;
    }  
    // Forca de friccio
    acumulador_forsa.x += -1.0*constant_friccio*velocitat_particula.x;
    acumulador_forsa.y += -1.0*constant_friccio*velocitat_particula.y;
    // 1) Acceleracio
    acceleracio_particula.x = acumulador_forsa.x / massa_particula;
    acceleracio_particula.y = acumulador_forsa.y / massa_particula;
    // 2) Velocitat
    velocitat_particula.x = velocitat_particula.x
      + acceleracio_particula.x * increment_temps;
    velocitat_particula.y = velocitat_particula.y
      + acceleracio_particula.y * increment_temps;
    // 3) Posicio
    posicio_particula.x = posicio_particula.x
      + velocitat_particula.x * increment_temps;
    posicio_particula.y = posicio_particula.y
      + velocitat_particula.y * increment_temps;
  }

  void pinta_particula() {
    fill(color_particula);
    ellipse(posicio_particula.x, posicio_particula.y,
      tamany_particula, tamany_particula);
  }
}

// Setup
void setup() {
  size(500, 500);
  // Inicialitzo el desti
  desti = new PVector(width/2.0, 100.0);
  // Inicialitzo el voxel
  // Hi fico un vector unitari apuntant cap amunt en vertical
  // Per tant les seves coordenades son (0, -1)
  primer_voxel = new voxel(new PVector(0.0,-1.0), new PVector(width/2.0, height/2.0),
  100.0, 150.0, color(200));
  // Inicialitzo les particules
  // Constructor = PVector p, PVector v, float m, float tam, color c
  boid1 = new particula(false, new PVector(width/4.0, 3*height/4.0),
    new PVector(0.0, 0.0), 1.0, 30.0, 0.2, 0.2, 0.5, color(255, 0, 0)); // KD = 0.2
  boid2 = new particula(false, new PVector(3.0*width/4.0, 3*height/4.0),
    new PVector(0.0, 0.0), 1.0, 30.0, 0.8, 0.1, 0.2, color(0, 255, 0)); // KD = 0.8
  lider = new particula(true, new PVector(width/2.0, height-50.0),
    new PVector(0.0, 0.0), 1.0, 45.0, 0.9, 0.0, 0.6, color(0, 0, 255));
}
// Draw
void draw() {
  background(0);
  // Calcular
  boid1.calcula_particula();
  boid2.calcula_particula();
  lider.calcula_particula();
  // Pintar
  boid1.pinta_particula();
  boid2.pinta_particula();
  lider.pinta_particula();
  primer_voxel.pintar_voxel();
  // Pintar desti
  fill(255, 255, 0);
  stroke(255);
  rectMode(CENTER);
  rect(desti.x, desti.y, 30.0, 30.0);
}

// Events

void mouseMoved(){
  desti.x = mouseX;
  desti.y = mouseY;
}
