PImage imgQuarto;          // Imagem do quarto
PImage imgInterruptor;     // Imagem do interruptor
PImage imgFundoJanela;     // Imagem de fundo para a nova janela
boolean janela_papel_porta_aberta = false;
int xPapel_porta = 560, yPapel_porta = 150, larguraPapel_porta = 35, alturaPapel_porta = 45;  // Posição e tamanho do interruptor
int xJanela_papel_porta = 200, yJanela_papel_porta = 100;

PGraphics novaJanela;  // Objeto para a superfície da nova janela

void setup() {
  size(800, 600);  // Tamanho da tela principal
  imgQuarto = loadImage("Fundo_Base.png");         // Carregar a imagem do quarto
  imgInterruptor = loadImage("Papel.png");   // Carregar a imagem do interruptor
  imgFundoJanela = loadImage("Fundo_Janela.png");  // Carregar a imagem de fundo da nova janela
  novaJanela = createGraphics(400, 400);  // Criar uma superfície de 400x400 para a nova janela
}

void draw() {
  background(255);

  // Desenhar a imagem do quarto como fundo
  image(imgQuarto, 0, 0, width, height);  // Ajuste para caber na tela toda

  // Desenhar o interruptor como imagem
  image(imgInterruptor, xPapel_porta, yPapel_porta, larguraPapel_porta, alturaPapel_porta);

  // Se a nova janela (superfície) estiver "aberta", desenha-la na tela
  if (janela_papel_porta_aberta) {
    novaJanela.beginDraw();  // Inicia a desenhar na nova superfície
    novaJanela.image(imgFundoJanela, 0, 0, novaJanela.width, novaJanela.height);  // Desenhar a imagem de fundo na janela
    novaJanela.fill(0);
    novaJanela.textSize(32);
    novaJanela.text("Olá, JOGADOR. Os seus\namigos te trancaram\ndentro de casa e pra\npoder sair você terá\nque achar os puzzles\ne resolve-los.\n                           Boa sorte!", 50, 120);  // Texto dentro da nova janela
    novaJanela.endDraw();  // Finaliza a superfície

    // Desenhar a "nova janela" na tela principal
    image(novaJanela, xJanela_papel_porta, yJanela_papel_porta);  // Desenha a nova superfície dentro da tela principal
  }
}

void mousePressed() {
  // Verificar se o clique do mouse ocorreu dentro da área da nova janela, para poder fechá-la caso esteja aberta
  if (mouseX > xJanela_papel_porta && mouseX < xJanela_papel_porta + novaJanela.width &&
      mouseY > yJanela_papel_porta && mouseY < yJanela_papel_porta + novaJanela.height && janela_papel_porta_aberta == true) {
    // Imprimir no console ou realizar algum evento
    println(janela_papel_porta_aberta ? "Janela fechada" : "Janela Aberta");
    // Se a área for clicada e a janela estiver fechada, abri-lá.
    janela_papel_porta_aberta = !janela_papel_porta_aberta;
    
  }
  if (mouseX > xPapel_porta && mouseX < xPapel_porta + larguraPapel_porta &&
      mouseY > yPapel_porta && mouseY < yPapel_porta + alturaPapel_porta && janela_papel_porta_aberta == false) {
    // Imprimir no console ou realizar algum evento
    println(janela_papel_porta_aberta ? "Janela aberta" : "Janela Fechada");
    // Se a área for clicada e a janela estiver fechada, abri-lá.
    janela_papel_porta_aberta = !janela_papel_porta_aberta;

  }
}
