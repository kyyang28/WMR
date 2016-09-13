
/* Config motor PWM */
void MOTOR_PWM_Setup()
{
  uint16_t Half_PWM_duty = PWM_DUTY_CYCLE / 2;

  //Serial3.println("Initializing PWM module...");

  /* Enable and configure pwm clock */
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(PWM_FREQ * PWM_DUTY_CYCLE, 0, VARIANT_MCK);

  PWMC_DisableChannel (PWM, leftChan);

  /* Setup left motor pwm pin */
  PIO_Configure(g_APinDescription[LeftMotorPWMPin].pPort,
                g_APinDescription[LeftMotorPWMPin].ulPinType,
                g_APinDescription[LeftMotorPWMPin].ulPin,
                g_APinDescription[LeftMotorPWMPin].ulPinConfiguration);

  PWMC_DisableChannel (PWM, rightChan);

  /* Setup right motor pwm pin */
  PIO_Configure(g_APinDescription[RightMotorPWMPin].pPort,
                g_APinDescription[RightMotorPWMPin].ulPinType,
                g_APinDescription[RightMotorPWMPin].ulPin,
                g_APinDescription[RightMotorPWMPin].ulPinConfiguration);

  //Serial3.println("Synchronizing PWM channel...");

  PWMC_ConfigureSyncChannel (PWM,
                             (0x1u << leftChan) | (0x1u << rightChan) | PWM_SCM_SYNC0,   //channel
                             PWM_SCM_UPDM_MODE1,                            //update mode
                             0,                                             //PDC transfer request mode
                             0);                                            //PDC transfer request comparison seletion

  SetMotorChan(PWM_CH0, PWM_DUTY_CYCLE, Half_PWM_duty, 0, 0);
  SetMotorChan(leftChan, PWM_DUTY_CYCLE, 0, 0, 0);
  SetMotorChan(rightChan, PWM_DUTY_CYCLE, 0, 0, 0);

  PWMC_SetSyncChannelUpdatePeriod(PWM, 1);
  PWMC_EnableChannel(PWM, leftChan);
  PWMC_EnableChannel(PWM, rightChan);

  PWMC_SetSyncChannelUpdateUnlock(PWM);
  PWMC_EnableChannel(PWM, PWM_CH0);

  PWMC_SetSyncChannelUpdateUnlock(PWM);

  //Serial3.println("PWM module setup finished.");
}

/* Helper function to setup motor pwm channel */
int SetMotorChan(uint8_t channel, uint16_t _PER, uint16_t _DUTY, uint32_t align, uint32_t polar)
{
  PWMC_ConfigureChannel (PWM, channel, PWM_CMR_CPRE_CLKA, align,                      //alignment
                         polar);                                                //Polarity
  PWMC_SetPeriod (PWM, channel, _PER);
  PWMC_SetDutyCycle (PWM, channel, _DUTY);
  return 0;
}

/* Setup left motor speed */
int setLeftMotorSpeed(float leftMotorSpeed)
{
  int speed = 0;
  
  if (abs(leftMotorSpeed) > PWM_DUTY_CYCLE) {
    speed = PWM_DUTY_CYCLE ;
  }else {
    speed = abs(int(leftMotorSpeed));
  }

  if (leftMotorSpeed > 0) {
    /* WMR moves forward */
    digitalWrite(LeftMotorINA, LOW);
    digitalWrite(LeftMotorINB, HIGH);
  }else {
    /* WMR moves backward */
    digitalWrite(LeftMotorINA, HIGH);
    digitalWrite(LeftMotorINB, LOW);
  }

  PWMC_SetDutyCycle (PWM, leftChan, speed);
}

/* Setup right motor speed */
int setRightMotorSpeed(float rightMotorSpeed)
{
  int speed = 0;
  
  if (abs(rightMotorSpeed) > PWM_DUTY_CYCLE) {
    speed = PWM_DUTY_CYCLE;
  }else {
    speed = abs(int(rightMotorSpeed));
  }

  if (rightMotorSpeed > 0) {
    /* WMR moves forward */
    digitalWrite(RightMotorINA, LOW);
    digitalWrite(RightMotorINB, HIGH);    
  }else {
    /* WMR moves backward */
    digitalWrite(RightMotorINA, HIGH);
    digitalWrite(RightMotorINB, LOW);
  }

  PWMC_SetDutyCycle(PWM, rightChan, speed);
}

