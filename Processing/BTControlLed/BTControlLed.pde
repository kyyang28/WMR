import processing.serial.*;

Serial myPort;
String ledStatus = "LED: OFF";

void setup()
{
  size(450, 500);
  //myPort = new Serial(this, "COM8", 38400);
  myPort = new Serial(this, "COM26", 9600);
  myPort.bufferUntil('\n');
}

void serialEvent(Serial myPort)
{
  ledStatus = myPort.readStringUntil('\n');
}

void draw()
{
  background(237, 240, 241);
  fill(20, 160, 133);    // Green color
  stroke(33);
  strokeWeight(1);
  rect(50, 100, 150, 50, 10);
  rect(250, 100, 150, 50, 10);
  rect(50, 300, 150, 50, 10);
  rect(250, 300, 150, 50, 10);
  fill(255);

  textSize(32);
  text("Forward", 60, 135);
  text("Backward", 255, 135);
  text("Left", 95, 335);
  text("Right", 280, 335);
  textSize(24);
  fill(33);
  text("Status:", 190, 200);
  textSize(30);
  textSize(16);
  text("Program made by Kyyang", 130, 400);

  text(ledStatus, 190, 240);

  if (mousePressed && mouseX > 50 && mouseX < 200 && 
    mouseY > 100 && mouseY < 150) {
    myPort.write('1');
    ledStatus = "Moving forward";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(50, 100, 150, 50, 10);
  }

  if (mousePressed && mouseX > 250 && mouseX < 400 && 
    mouseY > 100 && mouseY < 150) {
    myPort.write('2');
    ledStatus = "Moving backward";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(250, 100, 150, 50, 10);
  }

  if (mousePressed && mouseX > 50 && mouseX < 200 && 
    mouseY > 300 && mouseY < 350) {
    myPort.write('3');
    ledStatus = "Turning left";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(50, 300, 150, 50, 10);
  }

  if (mousePressed && mouseX > 250 && mouseX < 400 && 
    mouseY > 300 && mouseY < 350) {
    myPort.write('4');
    ledStatus = "Turning right";

    /* Highlights the buttons in red color when pressed */
    stroke(255, 0, 0);
    strokeWeight(2);
    noFill();
    rect(250, 300, 150, 50, 10);
  }

  if (!mousePressed) {
    myPort.write('5');
    ledStatus = "Stop";
  }
}