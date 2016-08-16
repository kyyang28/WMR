
/* Motors pwm pins setup */
int LeftMotorPWMPin = 9;
int RightMotorPWMPin = 7;

/* Left motor direction pins */
int LeftMotorINA = 51;
int LeftMotorINB = 49;

/* Right motor direction pins */
int RightMotorINA = 33;
int RightMotorINB = 31;

/* encoder counter */
int leftMotorEncoderCnt = 0;
int rightMotorEncoderCnt = 0;

float leftEncoderRadian = 0.0;
float rightEncoderRadian = 0.0;

uint32_t leftChan = g_APinDescription[LeftMotorPWMPin].ulPWMChannel;
uint32_t rightChan = g_APinDescription[RightMotorPWMPin].ulPWMChannel;

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;

int WMRStatus;

void setup()
{
  Serial.begin(38400);

  /* Motors pin setup */
  pinMode(LeftMotorPWMPin, OUTPUT);
  pinMode(RightMotorPWMPin, OUTPUT);
  pinMode(LeftMotorINA, OUTPUT);
  pinMode(LeftMotorINB, OUTPUT);
  pinMode(RightMotorINA, OUTPUT);
  pinMode(RightMotorINB, OUTPUT);
}

void loop()
{
  if (Serial.available() > 0) {
    WMRStatus = Serial.read();

    Serial.print("WMRStatus is: ");
    Serial.println(WMRStatus);

    if (WMRStatus == 120) {
      digitalWrite(ledPin, HIGH);
      Serial.println("LED: OFF");
      WMRStatus = 0;
    }else if (WMRStatus == 0) {
      digitalWrite(ledPin, LOW);
      Serial.println("LED: ON");
      WMRStatus = 0;
    }
  }
}

