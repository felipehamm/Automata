// Dimensões da matriz //<>//
int M = 64;
int N = 64;

// Dimensões da janela
int WIDTH = 1280;
int HEIGHT = 1280;

// Dimensões de um elemento da matriz
int E_WIDTH = WIDTH / M;
int E_HEIGHT = HEIGHT / N;


// Parâmetro dos valores pseudo-aleatórios
int SEED = (int) random(-100000, 100000);

// Cores
color ON = color(0, 0, 0);
color OFF = color(255, 255, 255);
color LINE_COLOR = color(192, 192, 192);

// Matriz Original
int [][] A = new int[M][N];

void setup() {

  size(1280, 1280);

  frameRate(120);

  arrayClear();

  drawGrid();
}

void draw() {

  // Muda o título da janela
  surface.setTitle ("Automata" 
    + " | " + M + "x" + N 
    + " | " + "I: " + str(getPositionX()) + " / J: " +  str(getPositionY()) 
    + " | " + "N -> " + sumOfNeighbours(getPositionX(), getPositionY())
    + " | " + " FPS: " + round(frameRate)
    + " | " + " F: " + frameCount); 

  //arrayRandom()

  // Limpa a janela 
  background(0, 0, 0);

  // Renderiza a matriz
  drawArray();
}

void mouseClicked() {

  invertMouseElement();
}

void keyPressed() {

  // Space -> Run / Stop
  // Left / Right -> Move through frames
  // Up / Down -> Control Framerate

  if (key == CODED) {
    
    if (keyCode == RIGHT) {gameOfLife();}
    
    if (keyCode == LEFT) {gameOfLife();}

  }
}

void arrayClear() {

  for (int i=0; i<M; i++) {
    for (int j=0; j<N; j++) {
      A[i][j] = 0;
    }
  }
}

void arrayRandom() {

  randomSeed(SEED);
  for (int i=0; i<M; i++) {
    for (int j=0; j<N; j++) {
      A[i][j] = (int) random(-1, 2);
    }
  }
  SEED = (int) random(-100000, 100000);
}

void invertMouseElement() {

  // Checa se o cursor está dentro da janela
  if ((mouseX <= width) && (mouseY <= height)) {

    // Inverte elemento
    if (A[getPositionX()][getPositionY()] == 0)
      A[getPositionX()][getPositionY()] = 1;
    else
      A[getPositionX()][getPositionY()] = 0;
  }
}

int sumOfNeighbours (int i, int j) {

  int s = 0;
  int b, c, d, f;

  // b -> c (i)
  // d -> f (j)

  // -------

  if (i == 0) {
    b = i;
    c = i+1;
  } else {

    if (i == M-1) {
      b = i-1;
      c = i;
    } else {
      b = i-1;
      c = i+1;
    }
  }

  // -------

  if (j == 0) {
    d = j;
    f = j+1;
  } else {

    if (j == N-1) {
      d = j-1;
      f = j;
    } else {
      d = j-1;
      f = j+1;
    }
  }

  // -------

  for (int x = b; x <= c; x++) {
    for (int y = d; y <= f; y++) {

      if ((x == i) && (y == j))
        continue;
      if (A[x][y] == 1)
        s++;
    }
  }
  return s;
}

int getPositionX() {

  int positionX = (int) (mouseX / E_WIDTH);

  if (positionX >= M) {
    return M-1;
  } else {
    return positionX;
  }
}

int getPositionY() {

  int positionY = (int) (mouseY / E_HEIGHT);

  if (positionY >= N) {
    return N-1;
  } else {
    return positionY;
  }
}

void gameOfLife() {

  int [][] t = new int[M][N];   

  // Gera uma matriz temporária com o resultado da iteração
  for (int i=0; i<M; i++) {
    for (int j=0; j<N; j++) {

      if (sumOfNeighbours(i, j) < 2) // Morre de Solidão
        t[i][j] = 0;
      if (sumOfNeighbours(i, j) > 3) // Morre de Superpopulação
        t[i][j] = 0;
      if ((sumOfNeighbours(i, j) == 3) && (A[i][j] == 0)) // Nasce por reprodução
        t[i][j] = 1;
      if (((sumOfNeighbours(i, j) == 2) || (sumOfNeighbours(i, j) == 3)) && (A[i][j] == 1))// Continua viva
        t[i][j] = 1;
    }
  }

  // Copia a matriz temporária para a matriz original
  for (int i=0; i<M; i++)
    for (int j=0; j<N; j++)
      A[i][j] = t[i][j];
}

void drawGrid() {

  for (int i=1; i<M; i++) {
    for (int j=1; j<N; j++) {
      stroke(LINE_COLOR);
      line(E_WIDTH*i, E_HEIGHT*j, E_WIDTH, E_HEIGHT);
    }
  }
}

void drawArray() {

  for (int i=0; i<M; i++) {
    for (int j=0; j<N; j++) {
      if (A[i][j] == 1) {
        fill(ON);
        rect(E_WIDTH*i, E_HEIGHT*j, E_WIDTH, E_HEIGHT);
      } else {
        fill(OFF);
        rect(E_WIDTH*i, E_HEIGHT*j, E_WIDTH, E_HEIGHT);
      }
    }
  }
}
