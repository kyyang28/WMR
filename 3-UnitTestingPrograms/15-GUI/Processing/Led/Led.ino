
int ledPin = 36;
int state;

void setup()
{
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  Serial.begin(38400);
}

void loop()
{
  if (Serial.available() > 0) {
    state = Serial.read();

    Serial.print("state is: ");
    Serial.println(state);

    if (state == 120) {
      digitalWrite(ledPin, HIGH);
      Serial.println("LED: OFF");
      state = 0;
    }else if (state == 0) {
      digitalWrite(ledPin, LOW);
      Serial.println("LED: ON");
      state = 0;
    }
  }
}

