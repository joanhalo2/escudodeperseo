/**
 *Clase que genera el movimiento de las serpientes para cada Gorgona
 */
class Tentacle {
  float[] a = new float[3];
  float[] b = new float[3];
  float[] c = new float[3];
  float tLength;
  float stepSize;
  float tRotate;
  int   alpha;
  PShape snakehead;
  //static float inc = 0.0;
  float mayorScale;

  Tentacle(boolean frente) {
    for (int i=0; i<3; i++) {
      a[i] = random(0.005, 0.03);
      b[i] = random(0, TWO_PI);
      c[i] = random(2, 50);
    }
    //tRotate = random(-PI,PI);
    if (frente) {
      tRotate = random(-PI, (-HALF_PI)/3);
    } else {
      tRotate = random(0, PI);
    }

    float scale = cos(tRotate+HALF_PI)+2;
    tLength = (height/scale)*random(0.18, 0.20)*scale;
    stepSize = 5;
    alpha = int(random(30, 100));
    mayorScale = 0.25;

    snakehead = loadShape("snakeHead.svg");
  }

  void setMayorScale(float s) {
    this.mayorScale = s;
  }

  void drawTentacle(float xPos, float yPos, float inc) {
    float x, y;
    x = 0;
    pushMatrix();
    translate(xPos, yPos);
    rotate(tRotate);

    float red = 0; //206
    float green = 0; //74
    float blue = 0; //37


    while (x<tLength) {
      float r = map(x, 0, tLength, 13*mayorScale, 16*mayorScale);
      float A = map(x, 0, tLength, 0, 1);

      //colores
      red = map(x, 0, tLength, 230, 222);
      green = map(x, 0, tLength, 129, 16);
      blue = map(x, 0, tLength, 3, 16);

      y = sin(a[0]*x+b[0]+inc)*c[0] + sin(a[1]*x+b[1]+inc)*c[1] + sin(a[2]*x+b[2]+inc)*c[2];
      y = y*A;
      fill(red, green, blue);

      if ((x+stepSize)>=tLength) {
        //ellipse(x,y,r+5,r+2);
        shape(snakehead, x+2, y, 2*r, 1.5*r);
      } else {
        ellipse(x, y, r, r);
      }

      //if(r>15)
      stepSize = r/10;           
      x += stepSize;
    }
    popMatrix();
  }
}
