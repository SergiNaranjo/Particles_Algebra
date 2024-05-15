// Variables y objetos
float increment_temps = 0.4;
particula[] particulas = new particula[20];
PVector destino = new PVector(250, 250, 250); // Destino en el centro del lienzo tridimensional

// Funciones y clases
class particula {
  // Atributos
  PVector posicio_particula;
  PVector velocitat_particula;
  PVector acceleracio_particula;
  float massa_particula;
  float tamany_particula;
  float constant_friccio;
  float fuerza_destino;
  float radio_repulsion; // Nuevo atributo para la distancia de repulsión entre partículas
  color color_particula;
  boolean esLider; // Nuevo atributo para indicar si la partícula es líder
  
  // Constructor
  particula(PVector p, PVector v, float m, float tam,
    float const_f, float radio_rep, color c, boolean lider) {
    posicio_particula = new PVector(0.0, 0.0, 0.0);
    velocitat_particula = new PVector(0.0, 0.0, 0.0);
    acceleracio_particula = new PVector(0.0, 0.0, 0.0);

    posicio_particula.set(p);
    velocitat_particula.set(v);

    massa_particula = m;
    tamany_particula = tam;
    color_particula = c;

    constant_friccio = const_f;
    fuerza_destino = 0.1;
    radio_repulsion = radio_rep;
    esLider = lider; // Establecer si es líder
  }
  
  // Métodos
  void calcula_particula(particula[] particles) {
    PVector acumulador_forsa;
    PVector vector_per_usar;
    acumulador_forsa = new PVector(0.0, 0.0, 0.0);
    vector_per_usar = new PVector(0.0, 0.0, 0.0);
    // Resolver Euler
    // 0) Acumular fuerzas
    // Fuerza de fricción
    acumulador_forsa.x += -1.0 * constant_friccio * velocitat_particula.x;
    acumulador_forsa.y += -1.0 * constant_friccio * velocitat_particula.y;
    acumulador_forsa.z += -1.0 * constant_friccio * velocitat_particula.z;
    // Calcular centro de gravedad de todas las partículas
    PVector centroGravedad = new PVector(0, 0, 0);
    for (int i = 0; i < particles.length; i++) {
      if (particles[i] != this) {
        centroGravedad.add(particles[i].posicio_particula);
        // Fuerza de repulsión entre partículas si están muy cerca
        PVector direccion = PVector.sub(particles[i].posicio_particula, posicio_particula);
        float distancia = direccion.mag();
        if (distancia < radio_repulsion) {
          direccion.normalize();
          float fuerza = 1 / (distancia * distancia);
          direccion.mult(-fuerza);
          acumulador_forsa.add(direccion);
        }
      }
    }
    centroGravedad.div(particles.length - 1);
    // Fuerza de atracción hacia el centro de gravedad
    PVector direccion_centroGravedad = PVector.sub(centroGravedad, posicio_particula);
    direccion_centroGravedad.normalize();
    direccion_centroGravedad.mult(fuerza_destino); // Ajusta la magnitud de la fuerza hacia el centro de gravedad
    acumulador_forsa.add(direccion_centroGravedad);
    // Fuerza de atracción hacia el destino
    PVector direccion_destino = PVector.sub(destino, posicio_particula);
    direccion_destino.normalize();
    
    // Multiplicar por un factor mayor si es el líder
    if (esLider) {
      direccion_destino.mult(fuerza_destino * 2); // Ajusta la magnitud de la fuerza hacia el destino para el líder
    } else {
      direccion_destino.mult(fuerza_destino); // Ajusta la magnitud de la fuerza hacia el destino
    }
    
    acumulador_forsa.add(direccion_destino);
    // 1) Aceleración
    acceleracio_particula.x = acumulador_forsa.x / massa_particula;
    acceleracio_particula.y = acumulador_forsa.y / massa_particula;
    acceleracio_particula.z = acumulador_forsa.z / massa_particula;
    // 2) Velocidad
    velocitat_particula.add(acceleracio_particula);
    // 3) Posición
    posicio_particula.add(velocitat_particula);
    
    if (posicio_particula.x < 0 || posicio_particula.x > width) {
      velocitat_particula.x *= -1;
    }

  }

  void pinta_particula() {
    stroke(color_particula);
    fill(color_particula);
    pushMatrix();
    translate(posicio_particula.x, posicio_particula.y, posicio_particula.z);
    sphere(tamany_particula);
    popMatrix();
  }
}

// Configuración
void setup() {
  size(500, 500, P3D);
  // Inicializar las partículas
  for (int i = 0; i < particulas.length; i++) {
    boolean esLider = (i == 0); // La primera partícula será el líder
    particulas[i] = new particula(
      new PVector(random(width), random(height), random(width)), // posición aleatoria en tres dimensiones
      PVector.random3D().mult(2), // Velocidades aleatorias iniciales en tres dimensiones multiplicadas por 2
      10.0, 3.0, 0.1, 50, color(random(255), random(255), random(255)), esLider); // Modificamos el radio de repulsión a 50
  }
}

// Dibujo
void draw() {
  background(0);
  // Actualizar destino
  destino.set(constrain(mouseX, 0, width), constrain(mouseY, 0, height), constrain(mouseX, 0, width)); // Asegurar que el destino esté dentro del lienzo
  // Calcular y dibujar
  for (int i = 0; i < particulas.length; i++) {
    particulas[i].calcula_particula(particulas);
    // Limitar las partículas dentro del marco de la pantalla
    particulas[i].pinta_particula();
  }
}
