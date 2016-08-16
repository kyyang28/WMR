
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

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
//int leftMotorSpeed = -400;
//int rightMotorSpeed = -1000;
int LeftMotorReferenceSpeed = 5;
int RightMotorReferenceSpeed = 40;
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
  //digitalWrite(LeftMotorINA, HIGH);
  //digitalWrite(LeftMotorINB, LOW);
  //digitalWrite(RightMotorINA, HIGH);
  //digitalWrite(RightMotorINB, LOW);

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

int LeftMotorSpeedPIController(int LeftRawCnts, int LeftSpeedRef)
{
  int currError = 0;
  static int prevError, LeftMotorPWM;
  //static int currError, prevError, motorPWM;

  float Kp = 10, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder
  //float Kp = 0.4, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = abs(LeftRawCnts) - abs(LeftSpeedRef);

  /* Based on incremental discrete equation of PI controller */
  LeftMotorPWM += Kp * (currError - prevError) + Ki * currError;
  
  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(LeftRawCnts);
  Serial.print("(LeftEncoderVal)");
  Serial.print('\t');
  Serial.print(LeftSpeedRef);
  Serial.print("(LeftSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  Serial.print("(LeftCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  Serial.print("(LeftPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(LeftMotorPWM);
  Serial.println("(LeftMotorPWM)");
#endif
  
  return LeftMotorPWM;
}

int RightMotorSpeedPIController(int RightRawCnts, int RightSpeedRef)
{
  int currError = 0;
  static int prevError, RightMotorPWM;
  //static int currError, prevError, motorPWM;

  float Kp = 10, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder
  //float Kp = 0.4, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = abs(RightRawCnts) - abs(RightSpeedRef);

  /* Based on incremental discrete equation of PI controller */
  RightMotorPWM += Kp * (currError - prevError) + Ki * currError;
  
  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(RightRawCnts);
  Serial.print("(RightEncoderVal)");
  Serial.print('\t');
  Serial.print(RightSpeedRef);
  Serial.print("(RightSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  Serial.print("(RightCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  Serial.print("(RightPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(RightMotorPWM);
  Serial.println("(RightMotorPWM)");
#endif
  
  return RightMotorPWM;
}

void motorTest()
{
#if 1
    leftMotorSpeed = LeftMotorSpeedPIController(leftMotorEncoderCnt, LeftMotorReferenceSpeed);
    rightMotorSpeed = RightMotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
    setLeftMotorSpeed(leftMotorSpeed);
    setRightMotorSpeed(rightMotorSpeed);
#endif

    //setLeftMotorSpeed(-600);
    //setRightMotorSpeed(-600);

    //showEncoderCnt();
#if 0
    Serial.print(leftMotorSpeed);
    Serial.print('\t');
    Serial.print("(LeftMotorPWM)");
    Serial.print('\t');
    Serial.print(rightMotorSpeed);
    Serial.println("(RightMotorPWM)");
#endif

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

