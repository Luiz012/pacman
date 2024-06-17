int gridSize = 20;  //<>//
int rows, cols; 
int pacmanX, pacmanY; 
int pacmanSpeed = 1;
int direction; 
int score = 0; 
int qtdGhosts;
int open = 1;
int init = 1;

  PImage pacman;
  PImage pacman_closed;
  PImage ghost1;
  PImage ghost2;
  PImage ghost3;
  PImage ghost4;
  PImage vulcao;
  PImage deserto;
  PImage cidade;
  PImage arena;
  
//Define o labirinto  
int[][] maze = {
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
{1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1},
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

// Propriedades dos Fantasmas
int[][] ghosts = new int[4][3]; // Array para posição x, y e direção dos fantasmas
int ghostSpeed = 1;

int totalComida = 0;

boolean gameEnded = false;
boolean gameStarted = false; 

void setup() {
  size(400, 400);
  rows = height / gridSize;
  cols = width / gridSize;
  pacmanX = (cols / 2)-1;
  pacmanY = rows / 2 - 1;
  
  pacman = loadImage("assets/pacman_dir.png");
  pacman_closed = loadImage("assets/pacman_closed_dir.png");
  
  ghost1 = loadImage("assets/ghost1.png");
  ghost2 = loadImage("assets/ghost2.png");
  ghost3 = loadImage("assets/ghost3.png");
  ghost4 = loadImage("assets/ghost4.png");
  
 vulcao = loadImage("assets/vulcao.png");
 deserto = loadImage("assets/deserto.png");
 cidade = loadImage("assets/cidade.png");
  
 resetGhosts();
  
  // Conta total de comida para verificar se jogador ganhou
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (maze[i][j] == 0) {
        totalComida++;
      }
    }
  }
}

void draw() {
  
  if(init == 1){
    arena = cidade;
  }
  
  setBackground(arena);
  
  if (!gameStarted) {
    drawMainMenu();
  } else {
    drawMaze();
    if (!gameEnded) {
    movePacman();
    drawPacman();
    moveGhosts();
    drawGhosts();
    checkCollisions();
    displayScore();
  
    if (score == totalComida && totalComida > 0) {
      gameEnded = true;
      displayWinMessage();
    }
  }
  
  delay(50);
  }
  
}

void setBackground(PImage back){
  if(back.width == 0){
    background(0);
  }
  else{
    background(back);
  }
  
}

void drawMainMenu() {
  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Pacman Minimalista", width / 2, height / 2 - 100);

  textSize(24);
  drawButton(width / 2 - 110, height / 2 - 50, "Fácil");
  drawButton(width / 2, height / 2 - 50, "Médio");
  drawButton(width / 2 + 110, height / 2 - 50, "Difícil");
  
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Arenas", width / 2, height / 2);

  textSize(24);
  drawButton(width / 2 - 110, height / 2 + 50, "Cidade");
  drawButton(width / 2, height / 2 + 50, "Deserto");
  drawButton(width / 2 + 110, height / 2 + 50, "Vulcão");
  
  
  drawButton(width / 2, height / 2 + 100, "Créditos");
}

void drawButton(float x, float y, String label) {
  fill(100, 100, 255);
  rect(x - 50, y - 20, 100, 40);
  fill(255);
  textAlign(CENTER, CENTER);
  text(label, x, y);
}

void drawMaze() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      
      if (maze[i][j] == 1) {
        if(arena == cidade){
          fill(#898686); // Cinza     
        }
        if(arena == deserto){
          fill(#D0D163); // Bege          
        }
        if(arena == vulcao){
          fill(#fd4e03); // Laranja     
        }
        noStroke();
        rect(j * gridSize, i * gridSize, gridSize, gridSize);
      } else if (maze[i][j] == 0) {
        //Comida
        if(arena == cidade){
          fill(#FFE600); 
        }
        if(arena == deserto){
          fill(#FA0828);         
        }
        if(arena == vulcao){
          fill(#689FEA);   
        }
        ellipse(j * gridSize + gridSize / 2, i * gridSize + gridSize / 2, 4, 4);
      }
    }
  }
}

void drawPacman() {
  
  if(open == 1){
    image(pacman, pacmanX * gridSize, pacmanY * gridSize, gridSize, gridSize);
    open = 0;
  }else{
    image(pacman_closed, pacmanX * gridSize, pacmanY * gridSize, gridSize, gridSize);
    open = 1;
  }
}

void drawGhosts() {
  fill(255, 0, 0);
  noStroke();
  for (int i = 0; i < qtdGhosts; i++) {
    
    switch(i){
      case 0:
        image(ghost1, ghosts[i][0] * gridSize, ghosts[i][1] * gridSize, gridSize, gridSize);
      break;
      
      case 1:
        image(ghost2, ghosts[i][0] * gridSize, ghosts[i][1] * gridSize, gridSize, gridSize);
      break;
      
      case 2:
        image(ghost3, ghosts[i][0] * gridSize, ghosts[i][1] * gridSize, gridSize, gridSize);
      break;
      
      case 3:
        image(ghost4, ghosts[i][0] * gridSize, ghosts[i][1] * gridSize, gridSize, gridSize);
      break;
    } 
}
}

void setArena(int i){
  switch(i){
    case 1:
      arena = cidade;
      init = 0;
    break;
    
    case 2:
      arena = deserto;
      init = 0;
    break;
    
    case 3:
      arena = vulcao;
      init = 0;
    break;
  };
}

void mousePressed() {
  if (!gameStarted) {
    if (isButtonClicked(width / 2 - 110, height / 2 - 50)) {
      startGame("Facil");
    } else if (isButtonClicked(width / 2, height / 2 - 50)) {
      startGame("Medio");
    } else if (isButtonClicked(width / 2 + 110, height / 2 - 50)) {
      startGame("Dificil");
    }
    
    if (isButtonClicked(width / 2 - 110, height / 2 + 50)) {
      setArena(1);
    } else if (isButtonClicked(width / 2, height / 2 + 50)) {
      setArena(2);
    } else if (isButtonClicked(width / 2 + 110, height / 2 + 50)) {
      setArena(3);
    }
    
    if (isButtonClicked(width / 2, height / 2 + 100)) {
      creditos();
    }
  }
}

boolean isButtonClicked(float x, float y) {
  return mouseX > x - 50 && mouseX < x + 50 && mouseY > y - 20 && mouseY < y + 20;
}

void creditos(){
  fill(0);
  rect((width / 2)-175, (height / 2)-50, 350, 150);
  fill(255, 0, 0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Nome: Luiz Felipe da Silva", width / 2, height / 2 - 20);
  textSize(24);
  text("RA: 001201905111" + score, width / 2, height / 2 + 20);
  text("Aperte ENTER para voltar ao menu", width / 2, height / 2 + 50);
  gameEnded = true;
  noLoop();
}

void startGame(String difficulty) {
  switch (difficulty) {
    case "Facil":
      qtdGhosts = 1;
      break;
    case "Medio":
      qtdGhosts = 2;
      break;
    case "Dificil":
      qtdGhosts = 4;
      break;
  }
  gameStarted = true;
}

void movePacman() {
  if (keyPressed) {
    if (keyCode == UP && isValidMove(pacmanX, pacmanY - pacmanSpeed) && !gameEnded) {
      direction = UP;
      pacman = loadImage("assets/pacman_up.png");
      pacman_closed = loadImage("assets/pacman_closed_up.png");
    } else if (keyCode == DOWN && isValidMove(pacmanX, pacmanY + pacmanSpeed) && !gameEnded) {
      direction = DOWN;
      pacman = loadImage("assets/pacman_down.png");
      pacman_closed = loadImage("assets/pacman_closed_down.png");
    } else if (keyCode == LEFT && isValidMove(pacmanX - pacmanSpeed, pacmanY) && !gameEnded) {
      direction = LEFT;
      pacman = loadImage("assets/pacman_esq.png");
      pacman_closed = loadImage("assets/pacman_closed_esq.png");
    } else if (keyCode == RIGHT && isValidMove(pacmanX + pacmanSpeed, pacmanY) && !gameEnded) {
      direction = RIGHT;
      pacman = loadImage("assets/pacman_dir.png");
      pacman_closed = loadImage("assets/pacman_closed_dir.png");
    }
  }

  // Move Pacman
  switch(direction) {
    case UP:
      if (isValidMove(pacmanX, pacmanY - pacmanSpeed)) {
        pacmanY -= pacmanSpeed;
      }
      break;
    case DOWN:
      if (isValidMove(pacmanX, pacmanY + pacmanSpeed)) {
        pacmanY += pacmanSpeed;
      }
      break;
    case LEFT:
      if (isValidMove(pacmanX - pacmanSpeed, pacmanY)) {
        pacmanX -= pacmanSpeed;
      }
      break;
    case RIGHT:
      if (isValidMove(pacmanX + pacmanSpeed, pacmanY)) {
        pacmanX += pacmanSpeed;
      }
      break;
  }
}

void moveGhosts() {
  for (int i = 0; i < 4; i++) {
 
    switch (i) {
      case 0:
      case 2:
        if (abs(pacmanX - ghosts[i][0]) > abs(pacmanY - ghosts[i][1])) {
          if (pacmanX > ghosts[i][0] && maze[ghosts[i][1]][ghosts[i][0] + ghostSpeed] != 1) {
            ghosts[i][0] += ghostSpeed;
          } else if (pacmanX < ghosts[i][0] && maze[ghosts[i][1]][ghosts[i][0] - ghostSpeed] != 1) {
            ghosts[i][0] -= ghostSpeed;
          }
        } else {
          if (pacmanY > ghosts[i][1] && maze[ghosts[i][1] + ghostSpeed][ghosts[i][0]] != 1) {
            ghosts[i][1] += ghostSpeed;
          } else if (pacmanY < ghosts[i][1] && maze[ghosts[i][1] - ghostSpeed][ghosts[i][0]] != 1) {
            ghosts[i][1] -= ghostSpeed;
          }
        }
        break;
      case 1:
      case 3:
        
        int direction = (int)random(0, 4);
        
       
        switch (direction) { //<>//
          case 0:
            if (ghosts[i][1] > 0 && maze[ghosts[i][1] - ghostSpeed][ghosts[i][0]] != 1) {
              ghosts[i][1] -= ghostSpeed;
            }
            break;
          case 1:
            if (ghosts[i][1] < rows - 1 && maze[ghosts[i][1] + ghostSpeed][ghosts[i][0]] != 1) {
              ghosts[i][1] += ghostSpeed;
            }
            break;
          case 2:
            if (ghosts[i][0] > 0 && maze[ghosts[i][1]][ghosts[i][0] - ghostSpeed] != 1) {
              ghosts[i][0] -= ghostSpeed;
            }
            break;
          case 3:
            if (ghosts[i][0] < cols - 1 && maze[ghosts[i][1]][ghosts[i][0] + ghostSpeed] != 1) {
              ghosts[i][0] += ghostSpeed;
            }
            break;
        }
        break;
    }
  }
}

void checkCollisions() {
  int comidaX = pacmanX;
  int comidaY = pacmanY;
  comidaX = floor(comidaX + 0.5);
  comidaY = floor(comidaY + 0.5);
  if (maze[comidaY][comidaX] == 0) {
    score++;
    maze[comidaY][comidaX] = -1;
  }

  // Colisao com parede
  if (maze[pacmanY][pacmanX] == 1) {
    pacmanX = constrain(pacmanX, 0, cols - 1);
    pacmanY = constrain(pacmanY, 0, rows - 1);
  }

  // Colisao com fantasma
  for (int i = 0; i < qtdGhosts; i++) {
    if (pacmanX == ghosts[i][0] && pacmanY == ghosts[i][1]) {
      gameEnded = true;
      gameOver();
    }
  }
}

void displayScore() {
  fill(255);
  textSize(16);
  textAlign(RIGHT);
  text("Pontos: " + score, 80, 15);
}

boolean isValidMove(int x, int y) {
  // Verifica posição atual
  return x >= 0 && x < cols && y >= 0 && y < rows && maze[y][x] != 1;
}

//Mensagem de vitória
void displayWinMessage() {
  fill(0);
  rect((width / 2)-175, (height / 2)-75, 350, 150);
  fill(0, 255, 0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Você venceu!", width / 2, height / 2 - 50);
  textSize(24);
  text("Pontuação Final: " + score, width / 2, height / 2);
  text("Aperte ENTER para voltar ao menu", width / 2, height / 2 + 50);
  noLoop();
}

//Mensagem de fim de jogo
void gameOver() {
  fill(0);
  rect((width / 2)-175, (height / 2)-50, 350, 150);
  fill(255, 0, 0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Fim de Jogo", width / 2, height / 2);
  textSize(24);
  text("Pontuação Final: " + score, width / 2, height / 2 + 25);
  text("Aperte ENTER para voltar ao menu", width / 2, height / 2 + 50);
  gameEnded = true;
  noLoop();
}

//Reseta
void resetGame() {
  score = 0;
  pacmanX = (cols / 2)-1;
  pacmanY = rows / 2;
  resetGhosts();
  gameEnded = false;
  gameStarted = false;
  resetMaze();
  loop();
}

void resetMaze(){
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if(maze[i][j] == -1){
        maze[i][j] = 0;
      }
    }
  }
}

void resetGhosts(){
  for (int i = 0; i < 4; i++) {
    if(i == 0){
      ghosts[i][0] = 1;
      ghosts[i][1] = 1;
      ghosts[i][2] = (int)random(0, 4);
    }
    if(i == 1){
      ghosts[i][0] = 18;
      ghosts[i][1] = 1;
      ghosts[i][2] = (int)random(0, 4);
    }
    if(i == 2){
      ghosts[i][0] = 18;
      ghosts[i][1] = 18;
      ghosts[i][2] = (int)random(0, 4);
    }
    if(i == 3){
      ghosts[i][0] = 1;
      ghosts[i][1] = 18;
      ghosts[i][2] = (int)random(0, 4);
    }
  }
  
}

void keyPressed() {
  if (gameEnded && keyCode == ENTER) {
    resetGame();
  }
}
