                                                    // Controller Sketch
// Measures parameters from computer and sends them to Arduino for display
// on servo driven dials.  
// 
// by Les Hall
// Modidied from original example Servo Firmata sketch begiining on
// Thu Jul 11 2018.  Origintal comment follows.  
// 



/*
arduino_servo
 
 Demonstrates the control of servo motors connected to an Arduino board
 running the StandardFirmata firmware.  Moving the mouse horizontally across
 the sketch changes the angle of servo motors on digital pins 4 and 7.  For
 more information on servo motors, see the reference for the Arduino Servo
 library: http://arduino.cc/en/Reference/Servo
 
 To use:
 * Using the Arduino software, upload the StandardFirmata example (located
 in Examples > Firmata > StandardFirmata) to your Arduino board.
 * Run this sketch and look at the list of serial ports printed in the
 message area below. Note the index of the port corresponding to your
 Arduino board (the numbering starts at 0).  (Unless your Arduino board
 happens to be at index 0 in the list, the sketch probably won't work.
 Stop it and proceed with the instructions.)
 * Modify the "arduino = new Arduino(...)" line below, changing the number
 in Arduino.list()[0] to the number corresponding to the serial port of
 your Arduino board.  Alternatively, you can replace Arduino.list()[0]
 with the name of the serial port, in double quotes, e.g. "COM5" on Windows
 or "/dev/tty.usbmodem621" on Mac.
 * Connect Servos to digital pins 4 and 7.  (The servo also needs to be
 connected to power and ground.)
 * Run this sketch and move your mouse horizontally across the screen.
 
 For more information, see: http://playground.arduino.cc/Interfacing/Processing
 */



// bring in libraries
import processing.serial.*;
import cc.arduino.*;



// declare global variables
Arduino arduino;
int[] pins = {9, 10};
int rotMin = 0;
int rotMax = 180;
int depth = 800;  // make z-axis values have this limit


// perform initialization
void setup() {
  
  // graphics stuff
  size(800, 600, P3D);  // screen size
  noFill();
  stroke(255, 255, 0);
  strokeWeight(4);
  
  // Prints out the available serial ports.
  String[] ArduinoList = Arduino.list();
  int selection = ArduinoList.length - 1;
  println(ArduinoList[selection]);

  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[selection], 57600);

  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

  // Configure digital pins 4 and 7 to control servo motors.
  for (int pin = 0; pin < 2; pin++) {
    arduino.pinMode(pins[pin], Arduino.SERVO);
  }
}



// do this in an infinite loop
void draw() {
  
  // set the background color as mapping of mouse position
  background(0, float(mouseX)/width*255, float(mouseY)/height*255);
  
  // find dial reading
  // ps command from the following web forum thread:  8
  // https://stackoverflow.com/questions/12715382/get-cpu-usage-with-applescript
  //println(launch("open -a /bin/ps axo %cpu > ~/Dcouments/Processing/Controller/Controller.txt"));
  println(launch("ps axo %cpu"));
  //exit();
  
  // draw limits box
  pushMatrix();
    translate(width/2, height/2, 0);
    box(69, height/2, depth/2);
  popMatrix();

  // Write an value to the servos, telling them to go to the corresponding
  // angle (for standard servos) or move at a particular speed (continuous
  // rotation servos).
  arduino.servoWrite(pins[1], int(constrain(180.0 - mouseX*180/width, 45, 135)));
  //arduino.servoWrite(pins[0], int(180.0-mouseY*90.0/height));
}
