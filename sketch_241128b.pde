Janela_Cena janela_cena1;            // Janela para exibir mensagens ou puzzles
ArrayList<Puzzle> puzzles; // Lista de puzzles
// Classe principal do jogo
class Jogo {
  Jogo() {
    puzzles = new ArrayList<>();
    janela_cena1 = new Janela_Cena(200, 100, 400, 400, "Fundo_Janela.png"); // Janela inicial
        // Criar puzzles (papéis clicáveis)
    puzzles.add(new Puzzle_Porta("Papel 1", 525, 75, 100, 200, "Papel.png", janela_cena1));
    
    /* Precisa criar um extend para cada puzzle e janela existente para conseguir gerar um novo puzzle*/
    //puzzles.add(new Puzzle_(...)("Papel 2", 60, 445, 100, 100, "Papel.png", janela_cena1));
    //puzzles.add(new Puzzle_(...)("Papel 3", 520, 360, 60, 175, "Papel.png", janela_cena1));
    //puzzles.add(new Puzzle_(...)("Papel 4", 80, 275, 75, 100, "Papel.png", janela_cena1));
    //puzzles.add(new Puzzle_(...)("Papel 5", 300, 60, 100, 100, "Papel.png", janela_cena1));
  }

  void verificarClique(int mouseX, int mouseY, Janela_Cena janela) {
    // Verificar se algum puzzle foi clicado
    boolean puzzleClicado = false;
    for (Puzzle puzzle : puzzles) {
      if (puzzle.verificarClique(mouseX, mouseY)) {
        puzzleClicado = true;
        break;
      }
    }
  
    // Se nenhum puzzle foi clicado, verificar clique na janela
    if (!puzzleClicado && janela.estaAberta) {
      janela.verificarClique(mouseX, mouseY);
    }
  }

}

// Classe que representa um puzzle
abstract class Puzzle {
  String nome;
  int x, y, largura, altura;
  boolean resolvido;
  PImage img;
  Janela janela;

  Puzzle(String nome, int x, int y, int largura, int altura, String imgPath, Janela janela) {
    this.nome = nome;
    this.x = x;
    this.y = y;
    this.largura = largura;
    this.altura = altura;
    this.resolvido = false;
    this.img = loadImage(imgPath);
    this.janela = janela;
  }

  void desenhar() {
    if (!resolvido) {
      image(img, x, y, largura, altura);
    }
  }

  abstract void interagir(); // Define o comportamento ao interagir com o puzzle
  
  boolean verificarClique(int mouseX, int mouseY) {
    if (!resolvido && mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      janela.abrir();  // Abre a janela associada ao puzzle
      return true;
    }
    return false;
  }

}

// Classe que representa um puzzle com mensagem
class Puzzle_Porta extends Puzzle {
  Puzzle_Porta(String nome, int x, int y, int largura, int altura, String imgPath, Janela janela) {
    super(nome, x, y, largura, altura, imgPath, janela);  
  }

  void renderizarConteudo(PGraphics superficie) {
    superficie.fill(0);
    superficie.textSize(20);
    superficie.text("Olá, JOGADOR. Os seus\namigos te trancaram\ndentro de casa e pra\npoder sair você terá\nque achar os puzzles\ne resolve-los.\n                           Boa sorte!", 50, 100);
  }

  @Override
  void interagir() {
    // Definir o que ocorre quando interage com o puzzle de mensagem
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

  void desenhar() {
    if (!estaAberta) return;

    superficie.beginDraw();
    superficie.image(fundo, 0, 0, largura, altura); // Fundo da janela
    superficie.fill(0);
    superficie.textSize(30);
    superficie.endDraw();

    image(superficie, x, y);
  }
  
  abstract void renderizarConteudo(PGraphics superficie); // Renderiza o conteúdo da janela
  abstract void verificarClique(int mouseX, int mouseY); 
}

// Classe que implementa a Janela_Cena
class Janela_Cena extends Janela {
  PImage imgQuarto;         // Fundo do quarto
  Janela_Cena(int x, int y, int largura, int altura, String imgPath) {
    super(x, y, largura, altura, imgPath);
    imgQuarto = loadImage("Fundo_Base.png"); // Carrega o fundo do quarto
  }
    
  @Override
  void renderizarConteudo(PGraphics superficie) {
    this.desenhar();  // Desenha o conteúdo da janela no contexto principal
    // Desenhar fundo do quarto
    image(imgQuarto, 0, 0, width, height);

    // Desenhar puzzles (papéis)
    for (Puzzle puzzle : puzzles) {
      puzzle.desenhar();
    }

    // Desenhar a janela, se estiver aberta
    if (this.estaAberta) {
      this.desenhar();
    }
  }
  void verificarClique(int mouseX, int mouseY)
  {
     if (mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      fechar();
    }
  }
}
class Janela_Porta extends Janela {
  Janela_Porta(int x, int y, int largura, int altura, String imgPath) {
    super(x, y, largura, altura, imgPath);
  }
    
  @Override
  void renderizarConteudo(PGraphics superficie) {
    desenhar();  // Desenha o conteúdo da janela no contexto principal
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
  janela_cena1.desenhar();  // Chama o método de desenho do Jogo
}

void mousePressed() {
  jogo.verificarClique(mouseX, mouseY, janela_cena1); // Verifica cliques no jogo
}
