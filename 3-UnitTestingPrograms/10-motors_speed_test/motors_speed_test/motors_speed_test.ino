
#define PWM_FREQ          20000
#define PWM_DUTY_CYCLE    1200

/* Motors pwm pins setup */
int LeftMotorPWMPin = 9;
int RightMotorPWMPin = 7;

/* Left motor direction pins */
int LeftMotorINA = 51;
int LeftMotorINB = 49;

/* Right motor direction pins */
int RightMotorINA = 33;
int RightMotorINB = 31;

int dt = 10;

/* encoder counter */
int leftMotorEncoderCnt = 0;
int rightMotorEncoderCnt = 0;

float leftEncoderRadian = 0.0;
float rightEncoderRadian = 0.0;

boolean flag = true;
boolean TimerFlag = false;
int channel_0 = 0;
int channel_1 = 1;
int channel_2 = 2;

uint32_t leftChan = g_APinDescription[LeftMotorPWMPin].ulPWMChannel;
uint32_t rightChan = g_APinDescription[RightMotorPWMPin].ulPWMChannel;

char start = 'a';

int leftMotorSpeed = -400;
int rightMotorSpeed = -1000;
int LeftMotorReferenceSpeed = 30;
int RightMotorReferenceSpeed = 30;
int stopMotorSpeed = PWM_DUTY_CYCLE;  // stopMotorSpeed = 1200

int cnt = 0;

int buzzerPin = 12;
                                                                                                                                            
void setup()
{
  Serial.begin(115200);
  Serial.println("DC Motor Testing Program");

  /* Motors pin setup */
  pinMode(LeftMotorPWMPin, OUTPUT);
  pinMode(RightMotorPWMPin, OUTPUT);
  pinMode(LeftMotorINA, OUTPUT);
  pinMode(LeftMotorINB, OUTPUT);
  pinMode(RightMotorINA, OUTPUT);
  pinMode(RightMotorINB, OUTPUT);

  /* Buzzer setup */
  pinMode(buzzerPin, OUTPUT);

  /* Setup motors initial directions */
  digitalWrite(LeftMotorINA, HIGH);
  digitalWrite(LeftMotorINB, LOW);
  digitalWrite(RightMotorINA, LOW);
  digitalWrite(RightMotorINB, HIGH);

  Serial.println("Press 's' to spin the motors ....");

#if 0
  /* Program start flag */
  while (start != 's') {
    start = Serial.read();
  }
#endif

  /* LED PWM setup */
  MOTOR_PWM_Setup();

  /* Encoder setup */
  EncoderInit();

  /* Timer Init */
  TimerInit();

  /* Start the timer */
  TimerStart();
}

int timeElapse = 0;

void loop()
{
  motorTest();
  //BuzzerTest();
}

void BuzzerTest()
{
  digitalWrite(buzzerPin, HIGH);
  delay(400);
  digitalWrite(buzzerPin, LOW);
  delay(400);
}

void calcEncoderRadian()
{
  /*
      32 means for double edges of one channel results in 32 counts per revolution
      of the motor shaft
  */
  leftEncoderRadian = (float)leftMotorEncoderCnt * 2 * PI / 32;
  rightEncoderRadian = (float)rightMotorEncoderCnt * 2 * PI / 32;
}

void showEncoderCnt()
{
  Serial.print(leftMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(dt);
  Serial.print('\t');
  Serial.print(PWM->PWM_CH_NUM[leftChan].PWM_CDTY);
  Serial.print('\t');
  Serial.print(leftEncoderRadian);
  Serial.print('\t');
  Serial.print('\t');
  Serial.print(rightMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(dt);
  Serial.print('\t');
  Serial.print(PWM->PWM_CH_NUM[rightChan].PWM_CDTY);
  Serial.print('\t');
  Serial.println(rightEncoderRadian);
}

int MotorSpeedPIController(int RawCnts, int SpeedRef)
{
  static int currError, prevError, motorPWM;

  float Kp = 1, Ki = 0.1;   // Pololu 30:1 GearMotor with 64 CPR encoder
  //float Kp = 300, Ki = 1.5;

  currError = RawCnts - SpeedRef;

  /* Based on incremental discrete equation of PI controller */
  motorPWM += Kp * (currError - prevError) + Ki * currError;
  
  /* Update prevError variable to currError for next round */
  prevError = currError;

  Serial.print(RawCnts);
  Serial.print('\t');
  Serial.print(SpeedRef);
  Serial.print('\t');
  Serial.print(currError);
  Serial.print('\t');
  Serial.print(motorPWM);
  Serial.print('\t');
  Serial.print(prevError);
  Serial.print('\t');
  Serial.print(currError - prevError);
  
  return motorPWM;
}

void motorTest()
{
    leftMotorSpeed = MotorSpeedPIController(leftMotorEncoderCnt, LeftMotorReferenceSpeed);
    rightMotorSpeed = MotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
    setLeftMotorSpeed(leftMotorSpeed);
    setRightMotorSpeed(rightMotorSpeed);
    //showEncoderCnt();
    Serial.print(leftMotorSpeed);
    Serial.print('\t');
    Serial.print('\t');
    Serial.println(rightMotorSpeed);

#if 0  
  if (cnt != 10) {
    leftMotorSpeed = MotorSpeedPIController(leftMotorEncoderCnt, LeftMotorReferenceSpeed);
    rightMotorSpeed = MotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
    setLeftMotorSpeed(leftMotorSpeed);
    setRightMotorSpeed(rightMotorSpeed);
    //showEncoderCnt();
    Serial.print(leftMotorSpeed);
    Serial.print('\t');
    Serial.print('\t');
    Serial.println(rightMotorSpeed);
    cnt++;
  } else {
    setLeftMotorSpeed(stopMotorSpeed);    // speed = 1200 - 1200 = 0, stop the left motor
    setRightMotorSpeed(stopMotorSpeed);   // speed = 1200 - 1200 = 0, stop the right motor
  }
#endif

#if 0
  if (cnt != 10) {
    //digitalWrite(RightMotorINA, LOW);
    //digitalWrite(RightMotorINB, HIGH);

    digitalWrite(RightMotorINA, HIGH);
    digitalWrite(RightMotorINB, LOW);
    PWMC_SetDutyCycle (PWM, rightChan, 200);    // speed = 200

    //digitalWrite(LeftMotorINA, LOW);
    //digitalWrite(LeftMotorINB, HIGH);

    digitalWrite(LeftMotorINA, HIGH);
    digitalWrite(LeftMotorINB, LOW);
    PWMC_SetDutyCycle (PWM, leftChan, 200);    // speed = 200

    cnt++;

  } else {
    digitalWrite(RightMotorINA, LOW);
    digitalWrite(RightMotorINB, LOW);
    digitalWrite(LeftMotorINA, LOW);
    digitalWrite(LeftMotorINB, LOW);
  }
#endif

#if 0
  setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);

  showEncoderCnt();

  /* The larger the motorSpeed, the slower the motors spin */
  if (motorSpeed < 1100 && motorSpeed > 0) {
    motorSpeed += 100;
  } else if (motorSpeed > -1100 && motorSpeed < 0) {
    motorSpeed -= 100;
  }

  if (motorSpeed >= 1100) {
    motorSpeed = -800;
  } else if (motorSpeed <= -1100) {
    motorSpeed = 800;
  }
#endif
  delay(800);
}

