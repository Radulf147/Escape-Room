// Classe principal do jogo
class Jogo {
  PImage imgQuarto;         // Fundo do quarto
  ArrayList<Puzzle> puzzles; // Lista de puzzles
  Janela_Puzzle_Porta janela_puzzle_porta;   // Janela para exibir mensagens ou puzzles

  Jogo() {
    imgQuarto = loadImage("Fundo_Base.png"); // Carrega o fundo do quarto
    puzzles = new ArrayList<>();
    janela_puzzle_porta = new Janela_Puzzle_Porta(200, 100, 400, 400, "Fundo_Janela.png"); // Janela inicial
    
    // Criar puzzles
    puzzles.add(new Puzzle("Papel 1", 525, 75, 100, 200, "Papel.png", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 2", 60, 445, 100, 100, "Papel.png", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 3", 520, 360, 60, 175, "Papel.png", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 4", 80, 275, 75, 100, "Papel.png", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 5", 300, 60, 100, 100, "Papel.png", janela_puzzle_porta));
  }

  void desenhar() {
    // Desenhar fundo do quarto
    image(imgQuarto, 0, 0, width, height);

    // Desenhar puzzles
    for (Puzzle puzzle : puzzles) {
      puzzle.desenhar();
    }

    // Desenhar a janela, se estiver aberta
    if (janela_puzzle_porta.estaAberta) {
      janela_puzzle_porta.desenhar();
    }
  }

  void verificarClique(int mouseX, int mouseY) {
    // Verificar se algum puzzle foi clicado
    boolean puzzleClicado = false;
    for (Puzzle puzzle : puzzles) {
      if (puzzle.verificarClique(mouseX, mouseY)) {
        puzzleClicado = true;
        break;
      }
    }

    // Se nenhum puzzle foi clicado, verificar clique na janela
    if (!puzzleClicado && janela_puzzle_porta.estaAberta) {
      janela_puzzle_porta.verificarClique(mouseX, mouseY);
    }
  }
}

// Classe que representa um puzzle
class Puzzle {
  String nome;
  int x, y, largura, altura;
  boolean resolvido;
  PImage img;
  Janela_Puzzle_Porta janelaAssociada;

  Puzzle(String nome, int x, int y, int largura, int altura, String imgPath, Janela_Puzzle_Porta janela) {
    this.nome = nome;
    this.x = x;
    this.y = y;
    this.largura = largura;
    this.altura = altura;
    this.resolvido = false;
    this.img = loadImage(imgPath);
    this.janelaAssociada = janela;
  }

  void desenhar() {
    image(img, x, y, largura, altura);
  }

  boolean verificarClique(int mouseX, int mouseY) {
    if (!resolvido && mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      janelaAssociada.abrir();
      return true;
    }
    return false;
  }
}

// Classe que gerencia janelas
abstract class Janela {
  int x, y, largura, altura;
  boolean estaAberta;
  PGraphics superficie;
  PImage fundo;

  Janela(int x, int y, int largura, int altura, String imgPath) {
    this.x = x;
    this.y = y;
    this.largura = largura;
    this.altura = altura;
    this.estaAberta = false;
    this.superficie = createGraphics(largura, altura);
    this.fundo = loadImage(imgPath);
  }

  void abrir() {
    this.estaAberta = true;
  }

  void fechar() {
    this.estaAberta = false;
  }

  abstract void desenhar();

  abstract void verificarClique(int mouseX, int mouseY);
}
class Janela_Puzzle_Porta extends Janela
{
  Janela_Puzzle_Porta(int x, int y, int largura, int altura, String imgPath){
    super(x, y, largura, altura, imgPath);  
  }
  void desenhar(){
    if (!estaAberta) return;

    superficie.beginDraw();
    superficie.image(fundo, 0, 0, largura, altura); // Fundo da janela
    superficie.fill(0);
    superficie.textSize(16);
    superficie.text("Olá, JOGADOR. Os seus\namigos te trancaram\ndentro de casa e pra\npoder sair você terá\nque achar os puzzles\ne resolve-los.\n                           Boa sorte!", 50, 100);
    superficie.endDraw();

    image(superficie, x, y);
  }
  void verificarClique(int mouseX, int mouseY)
  {
    if (mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      fechar();
    }
  }
  
}

// Funções principais do Processing
Jogo jogo;

void setup() {
  size(800, 600);
  jogo = new Jogo(); // Inicializa o jogo
}

void draw() {
  background(255);
  jogo.desenhar(); // Desenha o jogo
}

void mousePressed() {
  jogo.verificarClique(mouseX, mouseY); // Verifica cliques no jogo
}
