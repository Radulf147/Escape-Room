PImage imgQuarto;  // Imagem do quarto
boolean interruptorLigado = false;
int xInterruptor = 300, yInterruptor = 200, larguraInterruptor = 50, alturaInterruptor = 30;  // Posição e tamanho do interruptor dentro da imagem

PGraphics novaJanela;  // Objeto para a superfície da nova janela (não é uma janela separada, mas uma área gráfica)

void setup() {
  size(800, 600);  // Tamanho da tela principal
  imgQuarto = loadImage("foto.gif");  // Carregar a imagem do quarto
  novaJanela = createGraphics(400, 400);  // Criar uma superfície de 400x400 para a nova janela
  noStroke();
}

void draw() {
  background(255);

  // Desenhar a imagem do quarto como fundo
  image(imgQuarto, 0, 0, width, height);  // Ajuste para caber na tela toda

  // Desenhar o interruptor (pode ser um retângulo ou uma imagem)
  fill(interruptorLigado ? color(0, 255, 0) : color(255, 0, 0));  // Mudar cor se ligado/desligado
  rect(xInterruptor, yInterruptor, larguraInterruptor, alturaInterruptor);  // Desenhar o interruptor como um retângulo

  // Se a nova janela (superfície) estiver "aberta", desenha-la na tela
  if (interruptorLigado) {
    novaJanela.beginDraw();  // Inicia a desenhar na nova superfície
    novaJanela.background(200, 200, 255);  // Cor de fundo da nova "janela"
    novaJanela.fill(0);
    novaJanela.textSize(32);
    novaJanela.text("Janela Aberta", 50, 100);  // Texto dentro da nova janela
    novaJanela.endDraw();  // Finaliza a superfície

    // Desenhar a "nova janela" na tela principal
    image(novaJanela, 50, 50);  // Desenha a nova superfície dentro da tela principal
  }
}

void mousePressed() {
  // Verificar se o clique do mouse ocorreu dentro da área do interruptor
  if (mouseX > xInterruptor && mouseX < xInterruptor + larguraInterruptor &&
      mouseY > yInterruptor && mouseY < yInterruptor + alturaInterruptor) {
    // Se a área for clicada, alterar o estado do interruptor
    interruptorLigado = !interruptorLigado;
    // Imprimir no console ou realizar algum evento
    println(interruptorLigado ? "Interruptor ligado" : "Interruptor desligado");
  }
}
