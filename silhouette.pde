// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.processing.*;
import gab.opencv.*;
PGraphics pg;

OpenCV opencv;

PImage canny;
Kinect2 kinect2;

// Depth image
PImage depthImg;

// Which pixels do we care about?
int minDepth =  0;
int maxDepth =  4500; //4.5m

// What is the kinect's angle
float angle;

void setup() {
  size(640, 480);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initRegistered();
  kinect2.initDevice();
  
  // Blank image
  depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight);
  opencv = new OpenCV(this, depthImg);
  pg = createGraphics(kinect2.depthWidth, kinect2.depthHeight);
}

void draw() {
  background(loadImage("abc.jpg"));
  // Draw the raw image
  // image(kinect2.getDepthImage(), 0, 0);

  // Threshold the depth image
  int[] rawDepth = kinect2.getRawDepth();
  
  
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(0);
    } else {
      depthImg.pixels[i] = color(255);
    }
  }
  

  // Draw the thresholded image
  depthImg.updatePixels();
  // image(depthImg, kinect2.depthWidth, 0);
  // fill(255);
  // text("TILT: " + angle, 10, 20);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  opencv.loadImage(depthImg);
  opencv.erode();
  opencv.findCannyEdges(20,75);
  canny = opencv.getSnapshot();
  blend(canny, 0, 0, kinect2.depthHeight, kinect2.depthWidth, 0, 0, kinect2.depthHeight, kinect2.depthWidth, OVERLAY);
}

// Adjust the angle and the depth threshold min and maxaaaaaaaaaaaaaaaa
void keyPressed() {
  if (key == 'a') {
    minDepth = constrain(minDepth+100, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-100, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+100, minDepth, 1165952918);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-100, minDepth, 1165952918);
  }
  println(minDepth, maxDepth);
}