
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

int readEncoderVal = 1200;

void setup()
{
  /* WARNING: When using HC-05 BLUETOOTH, make sure to employ serial 9600 baudrate, not 38400 */
  Serial.begin(9600);

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

  /* Send left and right motors' encoder values to MATLAB via BT */
  Serial.println(leftMotorEncoderCnt);
  Serial.println(rightMotorEncoderCnt);
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
  setLeftMotorSpeed(900);
  setRightMotorSpeed(900);
}

