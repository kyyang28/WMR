
void MOTOR_PWM_Setup()
{
  uint16_t Half_PWM_duty = PWM_DUTY_CYCLE / 2;

  Serial.println("Initializing PWM module...");

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

  Serial.println("Synchronizing PWM channel...");

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

  Serial.println("PWM module setup finished.");
  
#if 0
  /* Configure LEFT motor PWM channel to employ CLOCKA */
  PWMC_ConfigureChannel(PWM_INTERFACE, leftChan, PWM_CMR_CPRE_CLKA, 0, 0);

  /* Setup LEFT motor pwm period to 1200(PWM_DUTY_CYCLE) */
  PWMC_SetPeriod(PWM_INTERFACE, leftChan, PWM_DUTY_CYCLE);

  /* Initially setup the LEFT motor pwm duty cycle to maximum 1200 (PWM_DUTY_CYCLE) */
  PWMC_SetDutyCycle(PWM_INTERFACE, leftChan, PWM_DUTY_CYCLE);

  /* Enable LEFT motor PWM channel */
  PWMC_EnableChannel(PWM_INTERFACE, leftChan);

  /* Configure RIGHT motor PWM channel to employ CLOCKA */
  PWMC_ConfigureChannel(PWM_INTERFACE, rightChan, PWM_CMR_CPRE_CLKA, 0, 0);

  /* Setup RIGHT motor pwm period to 1200(PWM_DUTY_CYCLE) */
  PWMC_SetPeriod(PWM_INTERFACE, rightChan, PWM_DUTY_CYCLE);

  /* Initially setup the RIGHT motor pwm duty cycle to maximum 1200 (PWM_DUTY_CYCLE) */
  PWMC_SetDutyCycle(PWM_INTERFACE, rightChan, PWM_DUTY_CYCLE);

  /* Enable RIGHT motor PWM channel */
  PWMC_EnableChannel(PWM_INTERFACE, rightChan);
#endif  
}

int SetMotorChan(uint8_t channel, uint16_t _PER, uint16_t _DUTY, uint32_t align, uint32_t polar)
{
  PWMC_ConfigureChannel (PWM, channel, PWM_CMR_CPRE_CLKA, align,                      //alignment
                         polar);                                                //Polarity
  PWMC_SetPeriod (PWM, channel, _PER);
  PWMC_SetDutyCycle (PWM, channel, _DUTY);
  return 0;
}

int setLeftMotorSpeed(float leftMotorSpeed)
{
  int speed = 0;
  
  if (leftMotorSpeed > PWM_DUTY_CYCLE) {
    speed = 0;
  }else if (leftMotorSpeed < -PWM_DUTY_CYCLE) {
    speed = 0;
  }else {
    speed = PWM_DUTY_CYCLE - abs(int(leftMotorSpeed));
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

int setRightMotorSpeed(float rightMotorSpeed)
{
  int speed = 0;

  if (rightMotorSpeed > PWM_DUTY_CYCLE) {
    speed = 0;
  }else if (rightMotorSpeed < -PWM_DUTY_CYCLE) {
    speed = 0;
  }else {
    speed = PWM_DUTY_CYCLE - abs(int(rightMotorSpeed));
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

  PWMC_SetDutyCycle (PWM, rightChan, speed);
}

