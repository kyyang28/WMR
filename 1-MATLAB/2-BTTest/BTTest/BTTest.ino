
int recvVal = 0;

void setup()
{
  Serial.begin(9600);
}

void loop()
{
#if 0  
  if (Serial.available() > 0) {
    recvVal = Serial.read();

    Serial.println(recvVal);

    if (recvVal == '1') {
      Serial.println("Received value is ONE!!!");
    }else if (recvVal == '2') {
      Serial.println("Received value is TWO!!!");
    }
  }
#else
  Serial.println(recvVal);
  recvVal++;

  delay(400);
#endif
}

