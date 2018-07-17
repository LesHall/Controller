# Controller
Controller / indicator of music origin that serves as hardware UI device in place of screen UI.  

This project has hardware and software components that work together.  

The hardware is a 3D printed enclosere designed in the OpenSCAD Computer Aided Design program.  The OpenSCAD file creates *.stl files that are suitable for 3D printing on a 3D printer.  The electronics in the enclosure include an Arduino board, an Arduino Motor Sheild, and one or more servo motors.  

The software is a Processing sketch receives input from the computer, calculates a control value, then sends this control value to the hardware which then drives the servo motor(s) to their angular positions.  In this way the user (you) sees the dials move corresponding to the measured value.  

This is useful and kind of fun because you get visual and auditory indications of what's going on inside your computer without taking up screen area.  

At the moment some issues exist and many changes are planned.  Enjoy!  

Les Hall


