
#define PWM_FREQ          10000
#define PWM_DUTY_CYCLE    1200

int MotorPWMPin = 7;

int MotorINA = 36;
int MotorINB = 38;
//int MotorINA = 30;
//int MotorINB = 32;

int dt = 10;

/* encoder counter */
int leftMotorEncoderCnt = 0;

boolean flag = true;
boolean TimerFlag = false;
int channel_0 = 0;
int channel_1 = 1;
int channel_2 = 2;

uint32_t chan = g_APinDescription[MotorPWMPin].ulPWMChannel;

char start = 'a';

void setup()
{
  Serial.begin(115200);
  Serial.println("DC Motor Testing Program");

  /* LED pin setup */
  pinMode(MotorPWMPin, OUTPUT);
  pinMode(MotorINA, OUTPUT);
  pinMode(MotorINB, OUTPUT);
  
  digitalWrite(MotorINA, HIGH);
  digitalWrite(MotorINB, LOW);

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
  if (TimerFlag) {
    TimerFlag = false;

    if (timeElapse == 200) {
      timeElapse = 0;

      if (flag) {
        flag = false;
        digitalWrite(MotorINA, HIGH);
        digitalWrite(MotorINB, HIGH);
        PWMC_SetDutyCycle(PWM_INTERFACE, chan, dt * 100);
        dt -= 2;

        if (dt < 0) {
          dt = 12;
        }
      } else {
        flag = true;
        digitalWrite(MotorINA, HIGH);
        digitalWrite(MotorINB, LOW);
      }
    }

    showEncoderCnt();
    timeElapse++;
  }

}

void showEncoderCnt()
{
  Serial.print(leftMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(dt);
  Serial.print('\t');
  Serial.println(PWM->PWM_CH_NUM[chan].PWM_CDTY);
}

