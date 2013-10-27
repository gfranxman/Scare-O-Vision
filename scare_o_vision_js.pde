// Hallloween Scare-O-Vision
// just hacking some bits of code together.
// based on code form 
// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
// Example 16-13: Simple motion detection
// and a vector based skeleton from Robb Godshaw 

import processing.video.*;
// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 50;
int cnt = 0;

// for skeleton
float offset=0, offsetindexed, increment; //initialization of things explained below
 float skullDia = 75;
color figure = color(255);
color ground = color(0);
 
boolean clickOnce = false;



void setup() {
  size(320*4,240*4);
  video = new Capture(this, width, height, 8);
  // Create an empty image the same size as the video
  video.start();
  prevFrame = createImage(video.width,video.height,RGB);
  
  // for skeleton
  smooth();
  noStroke();
  //colorMode(HSB);

}

void draw() {
  
  // Capture video
  if (video.available()) {
    cnt += 1;
    if(cnt > 105) cnt=0;
    // Save previous frame for motion detection!!
    // Before we read the new frame, we always save the previous frame for comparison!
    if( cnt == 5 ){
      prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); 
    
    prevFrame.updatePixels();
    }video.read();
  } else {
    //console.log("no vid" );
  }
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      
      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color
      
      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); float g1 = green(current); float b1 = blue(current);
      float r2 = red(previous); float g2 = green(previous); float b2 = blue(previous);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, highlight
        pixels[loc] = color(2*red(previous),0,blue(current),.5);//color(255);//0);
      } else {
        // If not, display bkgrnd
        pixels[loc] = color(0);//video.pixels[loc];//color(0);//255);
      }
    }
  }
  updatePixels();
  if( clickOnce ) {
    drawSkeleton();
  }
}


// skeleton
// from //Robb Godshaw 
void drawSkeleton() {
  offset = offset + 0.035;
  //background(ground);
 
  translate(mouseX, mouseY);
  skull(0, -20, sine(-PI / 8, PI / 8, .01));
 
  //RIGHT arm 
  pushMatrix();//a
  translate(50, 12);
  rotate( sine(-PI / 3, 0, 1));
  femur();
  translate(0, 95);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  popMatrix();//a
   
   
  //LEFT ARM
  pushMatrix();//b
  translate(-50, 12);
  rotate( sine(0, PI / 3, 1));
  femur();
  translate(0, 95);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  popMatrix();//b
 
 
  pushMatrix();//c
  translate(0, 22);
  for (int i = 0; i<7;i++) {
    translate(0, 10);
    rotate( sine(-PI / 100, PI / 100, .01));
    ribs();
  }
  noStroke();
 
  popMatrix();//c
 
  pushMatrix();//d
 
  for (int i = 0; i<14;i++) {
    translate(0, 10);
    rotate( sine(-PI/100, PI/100, .01));
    vertebrae();
  }
 
  hips();
 
  //LEFT LEG///
  pushMatrix();//dd
  translate(-27, 8);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  translate(0, 95);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  popMatrix();//dd
 
 
  //RIGHT LEG
  pushMatrix();//ddd
  translate(27, 8);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  translate(0, 95);
  rotate( sine(-PI / 10, PI / 10, 1));
  femur();
  popMatrix();//ddd
  popMatrix();//d
}

void skull(float neckX, float neckY, float theta) {
  pushMatrix();//e
  translate(neckX, neckY);
  rotate(theta);
  fill(figure);
  ellipse(0, -skullDia / 2, skullDia, skullDia);
  fill(ground);
  float eyeDia = 11;
  ellipse(-skullDia / 4, -skullDia / 2, eyeDia, eyeDia);
  ellipse(skullDia / 4, -skullDia / 2, eyeDia, eyeDia);
  float nostrilHd = 5;
  float nostrilPitch = 2;
  strokeCap(ROUND);
  strokeWeight(2);
  stroke(ground);
  line(-nostrilPitch, -skullDia / 3, -nostrilPitch, -skullDia / 3 + nostrilHd);
  line(nostrilPitch, -skullDia / 3, nostrilPitch, -skullDia / 3 + nostrilHd);
  noStroke();
  popMatrix();//e
  fill(figure);
}
 
void vertebrae() {
  rectMode(CENTER);
  fill(figure);
  rect(0, -2, -10, -4);
  rect(0, -4, -5, -10);
}
 
void ribs() {
  strokeWeight(5);
  stroke(figure);
  noFill();
  float ribHt = 28;
  float ribWd = 66;
  arc(0, -ribHt / 2, ribWd, ribHt, -PI, 0);
}
 
void hips() {
  float pitch = 27;
  float ht = 26;
  float wd = 22;
  ellipse(-pitch, -ht / 2, wd, ht);
  ellipse(pitch, -ht  / 2, wd, ht);
}
 
void femur() {
  float bulb = 9;
  float lt = 80;
  ellipse(-bulb / 2, 0, bulb, bulb);
  ellipse(bulb / 2, 0, bulb, bulb);
  rectMode(CORNER);
  rect(-bulb / 2, 0, bulb, lt);
  ellipse(-bulb / 2, lt, bulb, bulb);
  ellipse(bulb / 2, lt, bulb, bulb);
}
 
 
 
/////// Function to return sine'd values in a manner kinda like random ///////
float sine(float low, float high, float speed) {
  float cooked;
 
  if (clickOnce) {
    noiseDetail(4);//4 is defailt. Higher is more finely grained. More sparatic.
    cooked = map(noise(offset), 0, 1, low, high);//This scales the noise value to match its application and spits out a neatly packaged float for you. Still warm.
//    ground=color(frameCount % 255, 255, 255);
//    figure=color(0);
  }
 
  else { 
    float raw =  sin(map(millis() % 1000, 0, 1000, 0, TWO_PI)); //SINE!!
    cooked = map(raw, -1, 1, low, high);
    ground=color(0);
    figure=color(255);
  }
 
  return cooked;
}
 
void mousePressed() {
  clickOnce = !clickOnce ;
}


