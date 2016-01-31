/**
 *Clase que construye cada Gorgona, compuesta por rostros y tentaculos
 */
class MedusaFace {
  float xP;
  float yP;
  float v;
  float paso = 5;
  float scale;
  int count = 20;
  float inc = 0;
  String[] gorgonas = { "gorgona1.svg", "gorgona2.svg", "gorgona3.svg", "gorgona4.svg" };
  PShape meduShape;  
  PShape cuerpo;
  Tentacle[] tentacles;

  MedusaFace() {
    count = 20; 
    inc = 0;
    scale = 0.25;        
    int index = int(random(gorgonas.length));    
    meduShape = loadShape(gorgonas[index]);        
    //cuerpo = loadShape("cuerpo.svg");
    begin();
  }

  void dibujarMedusa(float x, float y) {
    v = x-xP;
    xP = x;
    yP = y;
    inc -= 0.1;
    dibujarTentaculosAtras(inc);    
    shapeFace();
    dibujarTentaculos(inc);

  }
  void begin() {
    tentacles = new Tentacle[count];
    for (int i=0; i<count; i++) {

      if (i>=14) {
        tentacles[i] = new Tentacle(false);
      } else {
        tentacles[i] = new Tentacle(true);
      }
    }
  }

  void shapeFace() {  
    pushMatrix();
    translate(xP, yP);
    shapeMode(CENTER);
    shape(meduShape, 8*scale, 305*scale, 660*scale, 831*scale);
    popMatrix();
  }

  void shapeCuerpo() {  
    pushMatrix();
    translate(xP, yP);
    shapeMode(CENTER);    
    shape(cuerpo, 8*scale, 305*scale, 660*scale, 831*scale);
    popMatrix();
  }
  
  //Rostro generado
  void drawFace() {
    noStroke();
    pushMatrix();
    translate(xP, yP);
    beginShape();
    vertex(-30*scale, -100*scale);  
    vertex(30*scale, -100*scale);
    vertex(90*scale, -50*scale);
    vertex(100*scale, 0*scale);
    vertex(80*scale, 120*scale);
    vertex(25*scale, 170*scale);
    vertex(-25*scale, 170*scale);
    vertex(-80*scale, 120*scale);
    vertex(-100*scale, 0*scale);  
    vertex(-90*scale, -50*scale);
    endShape(CLOSE);
    popMatrix();
  }

  void setScale(float s) {
    this.scale = s;

    for (int i=0; i<count; i++) {
      tentacles[i].setMayorScale(s);
    }
  }
  void dibujarTentaculosAtras(float inc) {
    pushMatrix();
    translate(xP, yP);



    tentacles[14].drawTentacle(90*scale, 30*scale, inc);
    tentacles[15].drawTentacle(-90*scale, 30*scale, inc);
    tentacles[16].drawTentacle(80*scale, 70*scale, inc);
    tentacles[17].drawTentacle(-80*scale, 70*scale, inc);
    tentacles[18].drawTentacle(70*scale, 100*scale, inc);
    tentacles[19].drawTentacle(-70*scale, 100*scale, inc);


    popMatrix();
  }
  void dibujarTentaculos(float inc) {
    pushMatrix();
    translate(xP, yP);

    tentacles[0].drawTentacle(-30*scale, -100*scale, inc);
    tentacles[1].drawTentacle(30*scale, -100*scale, inc);
    tentacles[2].drawTentacle(90*scale, -50*scale, inc);
    tentacles[3].drawTentacle(100*scale, 0*scale, inc);
    tentacles[4].drawTentacle(-100*scale, 0*scale, inc);
    tentacles[5].drawTentacle(-90*scale, -50*scale, inc);

    tentacles[6].drawTentacle(15*scale, -100*scale, inc);
    tentacles[7].drawTentacle(-15*scale, -100*scale, inc);

    tentacles[8].drawTentacle(50*scale, -80*scale, inc);
    tentacles[9].drawTentacle(70*scale, -60*scale, inc);

    tentacles[10].drawTentacle(-50*scale, -80*scale, inc);
    tentacles[11].drawTentacle(-70*scale, -60*scale, inc);

    tentacles[12].drawTentacle(95*scale, -25*scale, inc);
    tentacles[13].drawTentacle(-95*scale, -25*scale, inc);
    popMatrix();
  }
}