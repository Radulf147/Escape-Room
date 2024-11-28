
PImage img;

void setup() {
  size(800, 600);  // Define o tamanho da tela
  img = loadImage("foto.gif");  // Carrega a imagem
}

void draw() {
  background(255);  // Cor de fundo
  // Redimensiona a imagem para caber dentro da tela (800x600)
  image(img, 0, 0, width, height);  // A imagem será esticada para 800x600
}
