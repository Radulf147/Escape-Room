import java.util.Arrays;
// Classe principal do jogo


class Jogo {
  PImage imgQuarto;         // Imagem que representa o fundo do quarto
  PImage imgEscapou;         // Imagem que representa o fundo quando escapa
  ArrayList<Puzzle> puzzles; // Lista que armazena os puzzles do jogo
  ArrayList<Janela> janelas; // Lista que armazena as janelas do jogo

  // Construtor da classe Jogo
  Jogo() {
    imgQuarto = loadImage("Fundo_Base.png"); // Carrega a imagem de fundo do quarto
    imgEscapou = loadImage("Fundo_Escapou.jpeg"); // Carrega a imagem de fundo dizendo que você escapou
    puzzles = new ArrayList<>(); // Inicializa a lista de puzzles
    janelas = new ArrayList<>(); // Inicializa a lista de janelas

    // Criando e associando as janelas aos puzzles
    Janela_Puzzle_Porta janela_puzzle_porta = new Janela_Puzzle_Porta(200, 100, 400, 400, "Fundo_Janela.png");
    Janela_Puzzle_Cadeado janela_puzzle_cadeado = new Janela_Puzzle_Cadeado(250, 150, 300, 300, "Fundo_Janela.png");
    Janela_Puzzle_Vinil janela_puzzle_vinil = new Janela_Puzzle_Vinil(150,50,500,500, "Fundo_Vinil.jpg");
    janelas.add(janela_puzzle_porta); // Adiciona a janela de puzzle da porta à lista de janelas
    janelas.add(janela_puzzle_cadeado); // Adiciona a janela de puzzle do cadeado à lista de janelas
    janelas.add(janela_puzzle_vinil); // Adiciona a janela de puzzle do cadeado à lista de janelas

    // Criando os puzzles e associando-os às janelas criadas
    puzzles.add(new Puzzle("Papel 1", 555, 140, 40, 60, "Papel.png", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 2", 595, 180, 25, 30, "tranca.png", janela_puzzle_cadeado));
    puzzles.add(new Puzzle("Papel 3", 520, 360, 60, 175, "", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 4", 80, 275, 75, 100, "", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 5", 300, 60, 100, 100, "", janela_puzzle_porta));
    puzzles.add(new Puzzle("Papel 6", 60, 445, 100, 100, "", janela_puzzle_vinil));
  }

  // Função responsável por desenhar os elementos do jogo
  void desenhar() {
    // Desenha o fundo do quarto na tela
    image(imgQuarto, 0, 0, width, height);

    // Desenha todos os puzzles na tela
    for (Puzzle puzzle : puzzles) {
      puzzle.desenhar();
    }

    // Desenha as janelas que estão abertas
    for (Janela janela : janelas) {
      if (janela.estaAberta) { // Verifica se a janela está aberta
        janela.desenhar(); // Desenha a janela aberta
      }
    }
  }

  // Função para verificar se o jogador clicou em algum elemento
  void verificarClique(int mouseX, int mouseY) {
     // Verifica se algum puzzle foi clicado
    boolean puzzleClicado = false;
     // Se nenhum puzzle foi clicado, verifica os cliques nas janelas abertas
    if (!puzzleClicado) {
      for (Janela janela : janelas) {
        if (janela.estaAberta) { // Verifica se a janela está aberta
          janela.verificarClique(mouseX, mouseY); // Verifica se o clique foi dentro da janela aberta
          break; // Interrompe o loop após o primeiro clique em uma janela
        }
      }
    }
    for (Puzzle puzzle : puzzles) {
      if (puzzle.verificarClique(mouseX, mouseY)) { // Verifica se o clique foi dentro do puzzle
        puzzleClicado = true; // Marca que um puzzle foi clicado
        break; // Interrompe o loop após o primeiro clique registrado
      }
    }
  }
}

// Classe que representa um puzzle
class Puzzle {
  String nome;               // Nome do puzzle
  int x, y;                  // Coordenadas de posição (x, y) do puzzle
  int largura, altura;       // Dimensões do puzzle
  boolean resolvido;         // Flag que indica se o puzzle foi resolvido
  PImage img;                // Imagem do puzzle
  Janela janelaAssociada;    // Janela associada ao puzzle

  // Construtor da classe Puzzle
  Puzzle(String nome, int x, int y, int largura, int altura, String imgPath, Janela janela) {
    this.nome = nome;                         // Inicializa o nome do puzzle
    this.x = x;                               // Inicializa a coordenada x do puzzle
    this.y = y;                               // Inicializa a coordenada y do puzzle
    this.largura = largura;                   // Inicializa a largura do puzzle
    this.altura = altura;                     // Inicializa a altura do puzzle
    this.resolvido = false;                   // Inicializa o estado como não resolvido
    this.janelaAssociada = janela;            // Associa a janela ao puzzle
    this.img = imgPath.isEmpty() ? null : loadImage(imgPath); // Carrega a imagem do puzzle (se o caminho não estiver vazio)
  }

  // Função para desenhar o puzzle na tela
  void desenhar() {
    if (img != null) { // Verifica se existe uma imagem para o puzzle
      image(img, x, y, largura, altura); // Desenha a imagem do puzzle nas coordenadas e dimensões especificadas
    }
    // Caso contrário, o puzzle permanece invisível, sem imagem
  }

  // Função para verificar se o puzzle foi clicado
  boolean verificarClique(int mouseX, int mouseY) {
    // Verifica se o puzzle ainda não foi resolvido e se o clique ocorreu dentro da área do puzzle
    if (!resolvido && mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      janelaAssociada.abrir(); // Se o clique ocorreu, abre a janela associada ao puzzle
      return true;  // Retorna true indicando que o clique foi detectado
    }
    return false; // Retorna false se o clique não ocorreu na área do puzzle
  }
}

// Classe abstrata que gerencia as janelas
abstract class Janela {
  int x, y;                  // Coordenadas de posição (x, y) da janela
  int largura, altura;       // Dimensões da janela
  boolean estaAberta;        // Flag que indica se a janela está aberta
  PGraphics superficie;      // Superfície de desenho da janela
  PImage fundo;              // Imagem de fundo da janela
  // Construtor da classe Janela
  Janela(int x, int y, int largura, int altura, String imgPath) {
    this.x = x;                               // Inicializa a coordenada x da janela
    this.y = y;                               // Inicializa a coordenada y da janela
    this.largura = largura;                   // Inicializa a largura da janela
    this.altura = altura;                     // Inicializa a altura da janela
    this.estaAberta = false;                  // Inicializa o estado da janela como fechada
    this.superficie = createGraphics(largura, altura); // Cria a superfície de desenho para a janela
    this.fundo = loadImage(imgPath);          // Carrega a imagem de fundo da janela

  }

  // Função para abrir a janela
  void abrir() {
    this.estaAberta = true; // Define a janela como aberta
  }

  // Função para fechar a janela
  void fechar() {
    this.estaAberta = false; // Define a janela como fechada
  }

  // Método abstrato para desenhar a janela (deve ser implementado nas classes filhas)
  abstract void desenhar();

  // Método abstrato para verificar cliques dentro da janela (deve ser implementado nas classes filhas)
  abstract void verificarClique(int mouseX, int mouseY);
}

// Subclasse de Janela para o puzzle da porta
class Janela_Puzzle_Porta extends Janela {
  // Construtor da subclasse que chama o construtor da superclasse (Janela)
  Janela_Puzzle_Porta(int x, int y, int largura, int altura, String imgPath) {
    super(x, y, largura, altura, imgPath); // Chama o construtor da classe pai (Janela) para inicializar a janela
  }

  // Método para desenhar a janela
  void desenhar() {
    if (!estaAberta) return; // Verifica se a janela está aberta antes de desenhar

    superficie.beginDraw(); // Inicia a renderização da superfície de desenho
    superficie.image(fundo, 0, 0, largura, altura); // Desenha o fundo da janela na superfície

    // Desenha um texto explicativo sobre o jogo
    superficie.fill(0); // Define a cor do texto como preto
    superficie.textSize(30); // Define o tamanho da fonte
    superficie.text("Olá, JOGADOR. Os seus\namigos te trancaram\ndentro de casa e pra\npoder sair você terá\nque achar os puzzles\ne resolve-los.\n                           Boa sorte!", 50, 100);
    superficie.endDraw(); // Finaliza a renderização da superfície

    image(superficie, x, y); // Desenha a superfície na tela nas coordenadas (x, y)
  }

  // Método para verificar cliques na janela
  void verificarClique(int mouseX, int mouseY) {
    // Verifica se o clique ocorreu dentro da área da janela
    if (mouseX > x && mouseX < x + largura && mouseY > y && mouseY < y + altura) {
      fechar(); // Se clicado, fecha a janela
    }
  }
}

// Subclasse de Janela para o puzzle do cadeado
class Janela_Puzzle_Cadeado extends Janela {
  String[] codigoEscrito = {"", "", "", ""}; // Armazena os valores inseridos nos campos de código
  String[] codigoValido = {"00001", "00010", "00011", "00100"}; // Códigos válidos para desbloqueio
  int campoAtivo = -1; // Indica qual campo de código está ativo (-1 significa nenhum campo ativo)
  boolean codigoEnviado = false; // Indica se o código foi enviado para verificação
  int qntCodigosCertos = 0; // Contador de códigos corretos
  String mensagemErro = ""; // Mensagem de erro que será exibida se o código for incorreto
  PImage xImg; // Imagem para o botão de fechar a janela

  // Construtor da subclasse
  Janela_Puzzle_Cadeado(int x, int y, int largura, int altura, String imgPath) {
    super(x, y, largura, altura, imgPath); // Chama o construtor da classe pai (Janela) para inicializar a janela
    xImg = loadImage("x.jpg"); // Carrega a imagem do botão de fechar
  }

  // Método para desenhar a janela
  @Override
  void desenhar() {
    if (!estaAberta) return; // Verifica se a janela está aberta antes de desenhar

    superficie.beginDraw(); // Inicia a renderização da superfície de desenho
    superficie.image(fundo, 0, 0, largura, altura); // Desenha o fundo da janela na superfície

    // Desenha os campos de texto para a inserção do código
    for (int i = 0; i < 4; i++) {
      int campoX = 50; // Posição X do campo de texto
      int campoY = 80 + i * 40; // Posição Y do campo de texto (espacamento entre os campos)
      int campoLargura = largura - 100; // Largura do campo
      int campoAltura = 30; // Altura do campo

      // Altera a cor de fundo do campo ativo
      superficie.fill(campoAtivo == i ? 200 : 255); // Se o campo estiver ativo, a cor de fundo será mais escura
      superficie.rect(campoX, campoY, campoLargura, campoAltura); // Desenha o campo de texto

      superficie.textAlign(PConstants.CENTER, PConstants.CENTER); // Alinha o texto no centro
      superficie.fill(0); // Define a cor do texto como preto
      superficie.textSize(16); // Define o tamanho da fonte
      superficie.text(codigoEscrito[i], campoX + campoLargura / 2, campoY + campoAltura / 2); // Desenha o texto inserido no campo
    }

    // Exibe mensagem de erro, se houver
    if (!mensagemErro.isEmpty()) {
      superficie.fill(255, 0, 0); // Vermelho para indicar erro
      superficie.textAlign(PConstants.CENTER, PConstants.CENTER);
      superficie.textSize(14);
      superficie.text(mensagemErro, largura / 2, 230); // Exibe a mensagem de erro
    }

    // Desenha o botão "Enviar"
    int botaoX = largura / 2 - 50;
    int botaoY = 250;
    int botaoLargura = 100;
    int botaoAltura = 40;

    superficie.fill(100, 150, 255); // Cor de fundo do botão
    superficie.rect(botaoX, botaoY, botaoLargura, botaoAltura); // Desenha o botão

    superficie.fill(0); // Cor do texto do botão
    superficie.textAlign(PConstants.CENTER, PConstants.CENTER);
    superficie.text("Enviar", botaoX + botaoLargura / 2, botaoY + botaoAltura / 2); // Texto do botão

    // Desenha o botão "Fechar"
    int botaoFecharX = largura - 60; // Botão de fechar no canto superior direito
    int botaoFecharY = 10;
    int botaoFecharLargura = 50;
    int botaoFecharAltura = 50;

    superficie.image(xImg, botaoFecharX, botaoFecharY, botaoFecharLargura, botaoFecharAltura); // Desenha o botão de fechar com a imagem carregada

    superficie.endDraw(); // Finaliza a renderização da superfície
    image(superficie, x, y); // Desenha a superfície na tela nas coordenadas (x, y)
  }

  // Método para verificar os cliques na janela
  void verificarClique(int mouseX, int mouseY) {
    // Verifica cliques nos campos de texto
    for (int i = 0; i < 4; i++) {
      int campoX = x + 50; // Posição X do campo de texto
      int campoY = y + 80 + i * 40; // Posição Y do campo de texto
      int campoLargura = largura - 100;
      int campoAltura = 30;

      if (mouseX > campoX && mouseX < campoX + campoLargura &&
          mouseY > campoY && mouseY < campoY + campoAltura) {
        campoAtivo = i; // Se o clique foi dentro do campo, marca o campo como ativo
        return;
      }
    }

    // Verifica clique no botão "Enviar"
    int botaoX = x + largura / 2 - 50;
    int botaoY = y + 250;
    int botaoLargura = 100;
    int botaoAltura = 40;

    if (mouseX > botaoX && mouseX < botaoX + botaoLargura &&
        mouseY > botaoY && mouseY < botaoY + botaoAltura) {
      EnviarValidacao(); // Se clicado no botão "Enviar", envia o código para validação
      return;
    }

    // Verifica clique no botão "Fechar"
    int botaoFecharX = x + largura - 60;
    int botaoFecharY = y + 10;
    int botaoFecharLargura = 50;
    int botaoFecharAltura = 50;

    if (mouseX > botaoFecharX && mouseX < botaoFecharX + botaoFecharLargura &&
        mouseY > botaoFecharY && mouseY < botaoFecharY + botaoFecharAltura) {
      fechar(); // Fecha a janela se o botão de fechar for clicado
      return;
    }

    campoAtivo = -1; // Se o clique não for em nenhum campo, desmarca o campo ativo
  }

  // Método para verificar a validade do código inserido
  void verificarValidade() {
    qntCodigosCertos = 0;
    boolean[] validade = {false, false, false, false}; // Array para verificar se os códigos foram acertados

    // Verifica se cada código inserido é válido
    for (int j = 0; j < 4; j++) {
      for (int i = 0; i < 4; i++) {
        if (codigoValido[i].equals(codigoEscrito[j]) && !validade[i]) {
          validade[i] = true; // Marca o código como válido
          qntCodigosCertos++; // Incrementa o contador de códigos certos
          break;
        }
      }
    }

    if (qntCodigosCertos == 4) {
      mensagemErro = ""; // Se todos os códigos forem certos, limpa a mensagem de erro
      println("Parabéns, você encontrou todos os códigos, agora pode ir embora!"); // Mensagem de sucesso
      jogo.puzzles.get(1).resolvido = true;
      this.fechar();
      
    } else {
      mensagemErro = "Existem códigos incorretos. Tente novamente!"; // Se houver erros, exibe mensagem de erro
      println("Existem códigos incorretos.");
    }
  }

  // Método que será chamado quando o código for enviado para validação
  void EnviarValidacao() {
    codigoEnviado = true; // Marca que o código foi enviado
    verificarValidade(); // Verifica a validade do código
  }

  // Método para registrar teclas pressionadas
  void registrarTecla(char tecla) {
    if (campoAtivo != -1) { // Se há um campo ativo
      if (tecla == BACKSPACE) {
        // Se a tecla for BACKSPACE, remove o último caractere do campo ativo
        if (codigoEscrito[campoAtivo].length() > 0) {
          codigoEscrito[campoAtivo] = codigoEscrito[campoAtivo].substring(0, codigoEscrito[campoAtivo].length() - 1);
        }
      } else if (tecla == ENTER || tecla == RETURN || tecla == TAB) {
        // Se a tecla for ENTER, RETURN ou TAB, passa para o próximo campo
        campoAtivo = (campoAtivo + 1) % 4;
      } else if (Character.isDigit(tecla)) {
        // Se a tecla for um número, adiciona o número ao campo ativo
        if (codigoEscrito[campoAtivo].length() < 5) {
          codigoEscrito[campoAtivo] += tecla;
        }
      }
    }
  }
}

//Classes que faltam serem implementadas. Ao implementar cada classe você poderá fazer novos puzzles existirem
/*class Janela_Puzzle_Luminaria_Grande extends Janela{}
class Janela_Puzzle_Luminaria_Pequena extends Janela{}*/


class Janela_Puzzle_Vinil extends Janela {

  // Constantes para os slots e inventário
  float[][] botoes;
  PImage xImg = loadImage("x.jpg");
  int[] craftingSlots = {0, 0, 0}; // Slots de crafting
  String[] selecionado = {"", "", ""}; // Inventário inicial
  int botaoSelecionado = -1; // Índice do item selecionado do inventário
  boolean combinacaoValida = false;
  String mensagemErro = "";
  PImage[] imagens = {loadImage("Pilha.png"), loadImage("Prego.png"), loadImage("Fio_Cobre.png"), loadImage("Madeira.png"), loadImage("Fio_Lã.png"), loadImage("Carregador.png"), loadImage("fundo_craft.jpg"), loadImage("fundo_craft.jpg"), loadImage("fundo_craft.jpg")};
  int[][] coordenadas = new int[10][3];
  int botaoFecharX = largura - 60; // Botão de fechar no canto superior direito
  int botaoFecharY = 10;
  int botaoFecharLargura = 50;
  int botaoFecharAltura = 50;
    
  Janela_Puzzle_Vinil(int x, int y, int largura, int altura, String imgPath) {
    super(x, y, largura, altura, imgPath);
  }

  public PImage getItemPorIndex(int index) {
    // Verifica se o índice está dentro do intervalo das imagens
    if (index >= 0 && index < imagens.length) {
        return imagens[index]; // Retorna a imagem correspondente ao índice
    } else {
        return null; // Retorna null caso o índice seja inválido
    }
  }
  @Override
  void desenhar() {
    if (!estaAberta) return;

    superficie.beginDraw();
    superficie.image(fundo, 0, 0, largura, altura);

    // Configurações gerais para os botões
    int botaoLargura = 100;
    int botaoAltura = 40;
    int espacoHorizontal = 40;
    int espacoVertical = 20;
    int cols = 3;
    int rows = 2;

    // Margens para centralizar os botões
    int margemSuperior = (altura - (rows * botaoAltura + (rows - 1) * espacoVertical)) / 2;
    int margemEsquerda = (largura - (cols * botaoLargura + (cols - 1) * espacoHorizontal)) / 2;

    // Matriz para armazenar as posições e dimensões (x, y, largura, altura)
    botoes = new float[11][4];
    int indice = 0;

    // Desenhar os 6 botões da grade
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            int x = margemEsquerda + col * (botaoLargura + espacoHorizontal);
            int y = margemSuperior + row * (botaoAltura + espacoVertical) + 140;

            botoes[indice][0] = x;
            botoes[indice][1] = y;
            botoes[indice][2] = botaoLargura;
            botoes[indice][3] = botaoAltura;
            superficie.image(imagens[indice], x, y, botaoLargura, botaoAltura);
            indice++;
        }
    }

    // Botão "Combinar"
    int botaoCombinarX = largura / 2 - botaoLargura / 2;
    int botaoCombinarY = margemSuperior + rows * (botaoAltura + espacoVertical) - 50;

    superficie.fill(100, 150, 255);
    superficie.rect(botaoCombinarX, botaoCombinarY, botaoLargura, botaoAltura);
    superficie.fill(0);
    superficie.textAlign(PConstants.CENTER, PConstants.CENTER);
    superficie.text("Combinar", botaoCombinarX + botaoLargura / 2, botaoCombinarY + botaoAltura / 2);
    botoes[10][0] = botaoCombinarX;
    botoes[10][1] = botaoCombinarY;
    botoes[10][2] = botaoLargura;
    botoes[10][3] = botaoAltura;

    // Retângulo maior
    int retanguloX = margemEsquerda;
    int retanguloY = botaoCombinarY - 210;
    int retanguloLargura = cols * botaoLargura + (cols - 1) * espacoHorizontal;
    int retanguloAltura = 180;

    superficie.fill(200, 200, 200);
    superficie.rect(retanguloX, retanguloY, retanguloLargura, retanguloAltura);

    // Botões internos
    int internoEspacoVertical = 20;
    int internoLargura = botaoLargura;
    int internoAltura = 35;
    
    for (int i = 0; i < 3; i++) {
        int internoX = retanguloX + 20;
        int internoY = retanguloY + 20 + i * (internoAltura + internoEspacoVertical);

        botoes[indice][0] = internoX;
        botoes[indice][1] = internoY;
        botoes[indice][2] = internoLargura;
        botoes[indice][3] = internoAltura;
        indice++;
        
        // Usar a imagem de fundo já presente no vetor
        superficie.image(imagens[i+6], internoX, internoY, internoLargura, internoAltura);
    }

    // Retângulo horizontal
    int internoHorizontalX = retanguloX + internoLargura + 60;
    int internoHorizontalY = retanguloY - 35 + internoAltura + internoEspacoVertical;
    int internoHorizontalLargura = internoLargura * 2;
    int internoHorizontalAltura = internoAltura + 110;

    botoes[indice][0] = internoHorizontalX;
    botoes[indice][1] = internoHorizontalY;
    botoes[indice][2] = internoHorizontalLargura;
    botoes[indice][3] = internoHorizontalAltura;
    indice++;
    superficie.fill(150, 150, 200);
    superficie.rect(internoHorizontalX, internoHorizontalY, internoHorizontalLargura, internoHorizontalAltura);

    superficie.image(xImg, botaoFecharX, botaoFecharY, botaoFecharLargura, botaoFecharAltura); // Desenha o botão de fechar com a imagem carregada

    superficie.endDraw(); // Finaliza a renderização da superfície
    image(superficie, x, y); // Desenha a superfície na tela nas coordenadas (x, y)
    superficie.endDraw();
    image(superficie, x, y);
}



  @Override
void verificarClique(int mouseX, int mouseY) {
  // Verifica clique no botão "Fechar"
    int botaoFecharX = x + largura - 60;
    int botaoFecharY = y + 10;
    int botaoFecharLargura = 50;
    int botaoFecharAltura = 50;

    if (mouseX > botaoFecharX && mouseX < botaoFecharX + botaoFecharLargura &&
        mouseY > botaoFecharY && mouseY < botaoFecharY + botaoFecharAltura) {
      fechar(); // Fecha a janela se o botão de fechar for clicado
      return;
    }
    // Ajusta as coordenadas do clique para o sistema de coordenadas local da janela
    int localMouseX = mouseX - this.x; // 'this.x' é a coordenada X da janela
    int localMouseY = mouseY - this.y; // 'this.y' é a coordenada Y da janela

    // Agora, usamos localMouseX e localMouseY para verificar os cliques
    for (int i = 0; i < botoes.length; i++) {
        
        float x = botoes[i][0];
        float y = botoes[i][1];
        float largura = botoes[i][2];
        float altura = botoes[i][3];

        // Verifica se o clique está dentro das coordenadas do botão, ajustado para a janela local
        if (localMouseX >= x && localMouseX <= x + largura && localMouseY >= y && localMouseY <= y + altura ) {
            // Depuração para verificar o índice do botão
            println("Botão clicado:", i, "Coordenadas locais:", localMouseX, localMouseY);

            // Define o botão selecionado
            if (i < 6) { // Índices de 0 a 5 correspondem aos botões principais
                
                botaoSelecionado = i;
                println("Botão selecionado:", botaoSelecionado);
            } else if (i >= 6 && i <= 8) { // Índices de 6 a 8 são os botões internos
                if (botaoSelecionado != -1 && botaoSelecionado < imagens.length) {
                    imagens[i] = getItemPorIndex(botaoSelecionado); // Atualiza a imagem, ajustando o índice para os internos
                    craftingSlots[i-6] = botaoSelecionado + 1;
                    println("Imagem atualizada no botão interno:", i);
                }
            }
            else if(i == 10)
            {
              int soma = 0;
              for(int p = 0; p <3 ; p++)
              {
                soma += craftingSlots[p];
              }
              if(soma == 6 && craftingSlots[0] != 0 && craftingSlots[1] != 0 && craftingSlots[2] != 0)
              {
                jogo.puzzles.get(5).resolvido = true;
                this.fechar();
              }
              println(soma);
            }
            return; // Sai da função após encontrar o botão
        }
    }

    // Caso nenhum botão seja clicado, redefine o estado
    botaoSelecionado = -1;
    println("Nenhum botão foi clicado.");
  }

}

//class Janela_Janela extends Janela{}
  
  
// Funções principais do Processing
Jogo jogo; // Cria uma variável do tipo 'Jogo' chamada jogo

// Função setup() é chamada uma vez no início do programa para configurar o ambiente
void setup() {
  size(800, 600); // Define o tamanho da janela para 800x600 pixels
  jogo = new Jogo(); // Cria uma nova instância da classe Jogo e a armazena na variável jogo
}

// Função draw() é chamada repetidamente, geralmente para atualizar a tela
void draw() {
  background(255); // Define a cor de fundo da tela como branco (255 representa a cor branca)
  jogo.desenhar(); // Chama o método desenhar() da classe Jogo para renderizar o estado do jogo na tela
  if (jogo.puzzles.get(1).resolvido) {
     image(jogo.imgEscapou, 0, 0, width, height);
  }
  if (jogo.puzzles.get(2).resolvido) {
     image(jogo.imgEscapou, 0, 0, width, height);
  } 
  if (jogo.puzzles.get(3).resolvido) {
     image(jogo.imgEscapou, 0, 0, width, height);
  }  
  if (jogo.puzzles.get(4).resolvido) {
     image(jogo.imgEscapou, 0, 0, width, height);
  } 
  if (jogo.puzzles.get(0).resolvido) {
     image(jogo.imgEscapou, 0, 0, width, height);
  } 
} 

// Função mousePressed() é chamada sempre que o botão do mouse é pressionado
void mousePressed() {
  jogo.verificarClique(mouseX, mouseY); // Chama o método verificarClique() do jogo, passando as coordenadas do mouse
}

// Função keyPressed() é chamada sempre que uma tecla é pressionada
void keyPressed() {
  // Loop que percorre todas as janelas abertas no jogo
  for (Janela janela : jogo.janelas) {
    // Verifica se a janela é uma instância de Janela_Puzzle_Cadeado e se está aberta
    if (janela instanceof Janela_Puzzle_Cadeado && janela.estaAberta) {
      // Cast para Janela_Puzzle_Cadeado e chama o método registrarTecla() passando a tecla pressionada
      ((Janela_Puzzle_Cadeado) janela).registrarTecla(key);
    }
  }
}
