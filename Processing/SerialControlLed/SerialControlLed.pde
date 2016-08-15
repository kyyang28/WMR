import processing.serial.*;

Serial myPort;
String myText = "";

void setup()
{
  size(300, 300);
  myPort = new Serial(this, "COM8", 115200);
  myPort.bufferUntil('\n');
}

void serialEvent(Serial myPort)
{
  myText = myPort.readStringUntil('\n');
}

void draw()
{
  background(0,0,0);    // black background
  text(myText, 120, 120);
  myText = "";
  
  if (mousePressed && (mouseButton == LEFT)) {
     myPort.write('1');    // turn on LED 
  }
  
  if (mousePressed && (mouseButton == RIGHT)) {
     myPort.write('0');    // turn off LED 
  }
}

