
int recvVal = 0;

void setup()
{
  Serial.begin(9600);
  Serial3.begin(9600);
}

void loop()
{
#if 1
  if (Serial3.available() > 0) {
    recvVal = Serial3.read();

    Serial3.println(recvVal);

    if (recvVal == '1') {
      Serial3.println("Received value is ONE!!! ");
    }else if (recvVal == '2') {
      Serial3.println("Received value is TWO!!! ");
    }
  }
#else
  Serial3.println(recvVal);
  recvVal++;

  delay(400);
#endif
}

