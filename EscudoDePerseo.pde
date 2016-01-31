/**
 * EL ESCUDO DE PERSEO
 * Joan Lopez - www.joansebastianlopez.com -2016
 * Implementa codigo del ejemplo de la libreria OPENCV WhichFace
 * Implementa codigo del sketch http://www.openprocessing.org/sketch/126679  - Por lby en OpenProcessing.org
 * WhichFace por Daniel Shiffman -http://shiffman.net/2011/04/26/opencv-matching-faces-over-time/
 * Todos los recursos graficos son derivados de www.openclipart.com
 */

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

// Lista de rostros detectados
ArrayList<Face> faceList;
PImage img;
PShape shield;
// Lista de rostros detectados por cada Frame
Rectangle[] faces;

// Numero de rostros detectados a lo largo del tiempo
int faceCount = 0;

// Escala para redimensionar la captura del video
int scl = 2;

Tentacle[] tentacles;
ArrayList<MedusaFace> medusas;
float lscale = 0.25;

void setup() {
  size(640, 480);
  img = loadImage("texture-1.jpg");
  shield = loadShape("shieldGreek.svg");
  video = new Capture(this, width/scl, height/scl);
  opencv = new OpenCV(this, width/scl, height/scl);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faceList = new ArrayList<Face>();
  medusas = new ArrayList<MedusaFace>();
  video.start();
  smooth();
}

void draw() {
  scale(scl);
  println("FRAMERATE: "+frameRate);
  opencv.loadImage(video);

  fill(0);
  noStroke();
  rect(0, 0, width, height);

  //Para mostrar la imagen de la webcam
  //image(video, 0, 0 );  
  detectFaces();
  // Dibuja las medusas detectadas
  float dy = -12;
  for (int i = 0; i < faces.length; i++) {
    float xp = 0;
    xp = (width/scl)-(faces[i].x+faces[i].width);    
    lscale = map(faces[i].width*faces[i].height, 0, 40000, 0.25, 1);    
    medusas.get(i).setScale(lscale);    
    medusas.get(i).dibujarMedusa(xp+(faces[i].width/2), (faces[i].y+(faces[i].height/2))+dy);
  }

  ellipseMode(CENTER);
  noFill();
  stroke(230, 129, 3);
  strokeWeight(357);
  strokeCap(ROUND);
  ellipse(width/(scl*2), height/(scl*2), width, width);
  shape(shield, (width/(scl*2))+1, (height/(scl*2))+-1, 377, 277);
  blend(img, 0, 0, width, height, 0, 0, width, height, MULTIPLY);
}

void detectFaces() {

  faces = opencv.detect();

  if (faceList.isEmpty()) {
    // Crea un objeto de tipo Face por cada rectangulo
    for (int i = 0; i < faces.length; i++) {      
      faceList.add(new Face(faceCount, faces[i].x, faces[i].y, faces[i].width, faces[i].height));
      MedusaFace m = new MedusaFace();
      medusas.add(m);
      faceCount++;
    }
  } else if (faceList.size() <= faces.length) {
    boolean[] used = new boolean[faces.length];
    // Asigna cada objeto Face a cada rectangulo
    for (Face f : faceList) {
      float record = 50000;
      int index = -1;
      for (int i = 0; i < faces.length; i++) {
        float d = dist(faces[i].x, faces[i].y, f.r.x, f.r.y);
        if (d < record && !used[i]) {
          record = d;
          index = i;
        }
      }
      // Actualiza la ubicacion de cada rostro a lo largo del tiempo
      used[index] = true;
      f.update(faces[index]);
    }

    for (int i = 0; i < faces.length; i++) {
      if (!used[i]) {        
        faceList.add(new Face(faceCount, faces[i].x, faces[i].y, faces[i].width, faces[i].height));
        MedusaFace m = new MedusaFace();
        medusas.add(m);
        faceCount++;
      }
    }
  } else {
    
    for (Face f : faceList) {
      f.available = true;
    } 
    
    for (int i = 0; i < faces.length; i++) {
      
      float record = 50000;
      int index = -1;
      for (int j = 0; j < faceList.size(); j++) {
        Face f = faceList.get(j);
        float d = dist(faces[i].x, faces[i].y, f.r.x, f.r.y);
        if (d < record && f.available) {
          record = d;
          index = j;
        }
      }

      Face f = faceList.get(index);
      f.available = false;
      f.update(faces[i]);
    } 

    for (Face f : faceList) {
      if (f.available) {
        f.countDown();
        if (f.dead()) {
          f.delete = true;
        }
      }
    }
  }

  // Borra los rostros que ya no estan en pantalla
  for (int i = faceList.size()-1; i >= 0; i--) {
    Face f = faceList.get(i);
    if (f.delete) {
      faceList.remove(i);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}