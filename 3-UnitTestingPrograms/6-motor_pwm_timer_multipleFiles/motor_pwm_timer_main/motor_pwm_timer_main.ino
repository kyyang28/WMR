
#define PWM_FREQ          10000
#define PWM_DUTY_CYCLE    1200

int MotorPWMPin = 6;
int MotorINA = 52;
int MotorINB = 53;
int dt = 12;

boolean flag = true;
boolean TimerFlag = false;
int channel_0 = 0;

uint32_t chan = g_APinDescription[MotorPWMPin].ulPWMChannel;

void setup()
{
  /* LED pin setup */
  pinMode(MotorPWMPin, OUTPUT);
  pinMode(MotorINA, OUTPUT);
  pinMode(MotorINB, OUTPUT);

  /* LED PWM setup */
  MOTOR_PWM_Setup();

  /* Timer Init */
  TimerInit();

  /* Start the timer */
  TimerStart();
}

void loop()
{
  if (TimerFlag) {
    TimerFlag = false;
    
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
}

