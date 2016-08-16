import processing.serial.*;

Serial ser;
String wmrMotion = "STOP";

void setup()
{
  size(450, 500);
  ser = new Serial(this, "COM25", 38400);
  ser.bufferUntil('\n');
}

void serialEvent(Serial ser)
{
  wmrMotion = ser.readStringUntil('\n');
}

void draw()
{
  background(237, 240, 241);
  fill(20, 160, 133);
  stroke(33);
  strokeWeight(1);
  rect(150, 100, 150, 60, 10);
  rect(50, 200, 150, 60, 10);
  rect(250, 200, 150, 60, 10);
  rect(150, 300, 150, 60, 10);
  fill(255);

  textSize(32);
  text("Forward", 165, 140);
  text("Left", 95, 240);
  text("Right", 290, 240);
  text("Backward", 152, 340);

  textSize(24);
  fill(33);
  text("Status:", 160, 410);

  text(wmrMotion, 190, 410);

  if (mousePressed && mouseX > 150 && mouseX < 300 && 
    mouseY > 100 && mouseY < 160) {
    /* Send "FOREWARD" command to WMR */
    ser.write('1');
    wmrMotion = "Moving forward";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(150, 100, 150, 60, 10);
  }

  if (mousePressed && mouseX > 50 && mouseX < 200 && 
    mouseY > 200 && mouseY < 260) {
    /* Send "LEFT" command to WMR */
    ser.write('2');
    wmrMotion = "Turning left";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(50, 200, 150, 60, 10);
  }

  if (mousePressed && mouseX > 250 && mouseX < 400 && 
    mouseY > 200 && mouseY < 260) {
    /* Send "RIGHT" command to WMR */
    ser.write('3');
    wmrMotion = "Turning right";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(250, 200, 150, 60, 10);
  }

  if (mousePressed && mouseX > 150 && mouseX < 300 && 
    mouseY > 300 && mouseY < 360) {
    /* Send "BACKWARD" command to WMR */
    ser.write('4');
    wmrMotion = "Moving backward";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(150, 300, 150, 60, 10);
  }

  /* Send "STOP" command to WMR */
  ser.write('5');
}