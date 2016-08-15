
#define PWM_FREQ          10000
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

  /* Setup motors initial directions */
  digitalWrite(LeftMotorINA, HIGH);
  digitalWrite(LeftMotorINB, LOW);
  digitalWrite(RightMotorINA, LOW);
  digitalWrite(RightMotorINB, HIGH);

  /* Program start flag */
  while (start != 's') {
    start = Serial.read();
  }

  Serial.println("DC Motor is about to spin....");

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
#if 1
  if (TimerFlag) {
    TimerFlag = false;

    if (timeElapse == 200) {
      timeElapse = 0;

      if (flag) {
        flag = false;
        digitalWrite(LeftMotorINA, HIGH);
        digitalWrite(LeftMotorINB, HIGH);
        digitalWrite(RightMotorINA, HIGH);
        digitalWrite(RightMotorINB, HIGH);
        PWMC_SetDutyCycle(PWM_INTERFACE, leftChan, dt * 100);
        PWMC_SetDutyCycle(PWM_INTERFACE, rightChan, dt * 100);
        dt -= 2;

        if (dt < 0) {
          dt = 12;
        }
      } else {
        flag = true;
        digitalWrite(LeftMotorINA, HIGH);
        digitalWrite(LeftMotorINB, LOW);
        digitalWrite(RightMotorINA, LOW);
        digitalWrite(RightMotorINB, HIGH);
      }
    }

    showEncoderCnt();
    timeElapse++;
  }
#else
  if (TimerFlag) {
    TimerFlag = false;
    /* clock-wise (negative encoder value) */
    //digitalWrite(LeftMotorINA, LOW);
    //digitalWrite(LeftMotorINB, HIGH);

    /* counter-clock-wise (positive encoder value) */
    digitalWrite(LeftMotorINA, HIGH);
    digitalWrite(LeftMotorINB, LOW);

    /* clock-wise (negative encoder value) */    
    //digitalWrite(RightMotorINA, HIGH);
    //digitalWrite(RightMotorINB, LOW);
    
    /* counter-clock-wise (positive encoder value) */
    digitalWrite(RightMotorINA, LOW);
    digitalWrite(RightMotorINB, HIGH);

    showEncoderCnt();
  }
#endif
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

