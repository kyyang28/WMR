
int mode = -1;

void setup()
{
  Serial.begin(9600);
  Serial.println('a');
  char a = 'b';

  while (a != 'a') {
    a = Serial.read();
  }
}

void loop()
{
  if (Serial.available() > 0) {
    mode = Serial.read();

    if (mode == 'R') {
      Serial.println("mode R received!!!");
    }

    delay(20);
  }
}

