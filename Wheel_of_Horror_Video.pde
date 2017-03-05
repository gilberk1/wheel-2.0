import processing.sound.*;

SoundFile ambiance;
SoundFile door;
SoundFile musicbox;
SoundFile powerdown;
SoundFile scream;
SoundFile staticSound;

PImage[] bonnie = new PImage[16];
PImage[] chica = new PImage[16];
PImage[] foxy = new PImage[16];
PImage[] mangle = new PImage[16];
PImage[] golden = new PImage[16];
PImage[] freddy = new PImage[16];

int i, j = 0;
int x = 5;
float z = 0;
boolean check = false;
PImage[] wheel = new PImage[6];
PFont font;
int spinX, spinY;
int resetX, resetY;
int spinWidth = 120;
int spinHeight = 60;
color spinHighlight = color(51);
boolean spinOver = false;
boolean characterSelected = false;
String character = "";
PImage tvStatic;

void setup() {
  size(1024, 768, P3D);
  background(19, 19, 19);
  spinX = width/2-spinWidth/2-5;
  spinY = height/2-spinHeight/2-140;
  wheel[0] = loadImage("bonnie.jpg");
  wheel[1] = loadImage("chica.jpg");
  wheel[2] = loadImage("foxy.jpg");
  wheel[3] = loadImage("freddy.jpg");
  wheel[4] = loadImage("golden freddy.jpg");
  wheel[5] = loadImage("mangle.jpg");
  font = loadFont("Herculanum-48.vlw");
  ambiance = new SoundFile(this, "ambiance.wav");
  door = new SoundFile(this, "door.wav");
  musicbox = new SoundFile(this, "musicbox.wav");
  musicbox.rate(.5);
  powerdown = new SoundFile(this, "powerdown.wav");
  powerdown.rate(.5);
  scream = new SoundFile(this, "scream.wav");
  scream.rate(.5);
  staticSound = new SoundFile(this, "static.wav");
  staticSound.rate(.5);
  for (int i = 0; i < 16; i++) {
    bonnie[i] = loadImage("bonnie/bonnie"+i+".png");
  }
  for (int i = 0; i < 16; i++) {
    chica[i] = loadImage("chica/chica"+i+".png");
  }
  for (int i = 0; i < 16; i++) {
    foxy[i] = loadImage("foxy/foxy"+i+".png");
  }
  for (int i = 0; i < 16; i++) {
    freddy[i] = loadImage("freddy/freddy"+i+".png");
  }
  for (int i = 0; i < 16; i++) {
    golden[i] = loadImage("golden/golden"+i+".png");
  }
  for (int i = 0; i < 16; i++) {
    mangle[i] = loadImage("mangle/mangle"+i+".png");
  }
  tvStatic = loadImage("static.png");
  ambiance.loop();
}

void draw() {
  //draw wheel of horror while character not selected
  if (!characterSelected) {
    update();
    strokeWeight(2);
    stroke(255, 255, 255);
    noFill();
    fill(255, 0, 0);
    textAlign(CENTER);
    textFont(font, 60);
    text("Wheel of Horror", 512, 100);
    textFont(font, 40);
    text("See who will be haunting your dreams", 512, 150);
    fill(19, 19, 19);

    //spin button hover
    if (spinOver) {
      fill(spinHighlight);
    } else {
      fill(19, 19, 19);
    }

    //create spin button
    stroke(255);
    rect(spinX, spinY, spinWidth, spinHeight);
    fill(255, 0, 0);
    textFont(font, 50);
    text("SPIN", spinX+60, spinY+45);
    fill(19, 19, 19);
    translate(width/2, height/2+150);

    //Wheel
    ellipse(0, 0, 400, 400);

    //Decision on wheel
    stroke(255, 0, 0);
    strokeWeight(5);
    line(0, -250, 0, -100);
    triangle(0, -100, -25, -150, 25, -150);

    stroke(255);
    strokeWeight(2);
    
    //assign characters based off angle
    if ((z % (TWO_PI)) >= 0 && (z % (TWO_PI)) < (PI/3)) {
      character = "foxy";
    } else if ((z % (TWO_PI)) >= (PI/3) && (z % (TWO_PI)) < (2*PI/3)) {
      character = "chica";
    } else if ((z % (TWO_PI)) >= (2*PI/3) && (z % (TWO_PI)) < (PI)) {
      character = "bonnie";
    } else if ((z % (TWO_PI)) >= (PI) && (z % (TWO_PI)) < (4*PI/3)) {
      character = "mangle";
    } else if ((z % (TWO_PI)) >= (4*PI/3) && (z % (TWO_PI)) < (5*PI/3)) {
      character = "golden";
    } else if ((z % (TWO_PI)) >= (5*PI/3) && (z % (TWO_PI)) < (TWO_PI)) {
      character = "freddy";
    }

    //Splits in wheel
    rotate(z);
    for (int i = 0; i<6; i++) {
      rotateZ(PI/3);
      image(wheel[i], 5, 50);
      line(0, 0, 0, 200);
    }

    //only run if spin button clicked
    if (check == true) {
      //Creates spin
      z=z+(PI/x);

      //Slows down spin
      int randomCount = (int) random(15, 20);

      if (frameCount % 80 == 0 && x < 80) {
        x+=randomCount;
      }
      //finish wheel
      if (x >= 80) {
        characterSelected = true;
      }
    }
  }
  //run once character selected
  else {
    //play music box
    if (i == 0) {
      door.stop();
      playMusicbox();
    }
    //set background black
    if (i == 1 || i == 5) {
      background(19, 19, 19);
    }
    //play powerdown
    if (i == 2) {
      activatePowerdown();
    }
    //show the character selected
    if (i == 3) {
      showCharacter();
      
      if(j == 15) {
        j=0;
      }
      else{
        i--;
      }
    }
    //show static
    if (i == 4) {
      showStatic();
    }
    
    i++;
    //reset sketch
    if (i == 6) {
      characterSelected = false;
      z = 0;
      x = 5;
      check = false;
      i = 0;
      setup();
    }
  }
}

//checks to see if the mouse is over the button
void update() {
  if (overButton(spinX, spinY, spinWidth, spinHeight)) {
    spinOver = true;
  } else {
    spinOver = false;
  }
}

//when the mouse is pressed, allows for the wheel to spin
void mousePressed() {
  if (spinOver) {
    check = true;
    door.play();
  }
}

//checks the coordinates to know if you are over the button
boolean overButton(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

//plays musicbox theme
void playMusicbox() {
  ambiance.stop();
  int randomLength = (int) random(5000, 10000);
  musicbox.play();
  delay(randomLength);
  musicbox.stop();
  characterSelected = true;
}

//play powerdown theme
void activatePowerdown() {
  powerdown.play();
  delay(2000);
}

//play the character selected
void showCharacter() {
  if(j==0) {
    scream.play();
  }
  if (character == "bonnie") {
    background(19,19,19);
    image(bonnie[j],0,0);
    delay(25);
  } else if (character == "chica") {
    background(19,19,19);
    image(chica[j],0,0);
    delay(25);
  } else if (character == "foxy") {
    background(19,19,19);
    image(foxy[j],0,0);
    delay(25);
  } else if (character == "mangle") {
    background(19,19,19);
    image(mangle[j],0,0);
    delay(25);
  } else if (character == "golden") {
    background(19,19,19);
    image(golden[j],0,0);
    delay(25);
  } else if (character == "freddy") {
    background(19,19,19);
    image(freddy[j],0,0);
    delay(25);
  }
  j++;
}

//play and show tv static
void showStatic() {
  background(tvStatic);
  delay(2000);
  staticSound.play();
}
