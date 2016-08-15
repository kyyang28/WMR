int MotorSetChan(uint8_t channel, uint16_t _PER, uint16_t _DUTY, uint32_t align, uint32_t polar) {
  PWMC_ConfigureChannel (PWM, channel, PWM_CMR_CPRE_CLKA, align,                      //alignment
                         polar);                                                //Polarity
  PWMC_SetPeriod (PWM, channel, _PER);
  PWMC_SetDutyCycle (PWM, channel, _DUTY);
  return 0;
}

void MotorSetup() {
  uint16_t PER0 = PER / 2;
  Serial.println("Initializing PWM module...");
#ifdef BT_DEBUG
  Serial3.println("Initializing PWM module...");
#endif
  digitalWrite(LED_PING, true);
  digitalWrite(LED_PINY, true);
  digitalWrite(LED_PINR, false);
  pmc_enable_periph_clk (PWM_INTERFACE_ID);
  PWMC_ConfigureClocks( FRE * PER, 0 , VARIANT_MCK);

  PWMC_DisableChannel (PWM, leftChan);
  /* Setup left motor pwm pin */
  PIO_Configure(g_APinDescription[LeftMotorPWMPin].pPort,
                g_APinDescription[LeftMotorPWMPin].ulPinType,
                g_APinDescription[LeftMotorPWMPin].ulPin,
                g_APinDescription[LeftMotorPWMPin].ulPinConfiguration);  
  //ML.Disable();
  //ML.pinSetup();
  
  PWMC_DisableChannel (PWM, rightChan);
  /* Setup left motor pwm pin */
  PIO_Configure(g_APinDescription[RightMotorPWMPin].pPort,
                g_APinDescription[RightMotorPWMPin].ulPinType,
                g_APinDescription[RightMotorPWMPin].ulPin,
                g_APinDescription[RightMotorPWMPin].ulPinConfiguration);  
  //MR.Disable();
  //MR.pinSetup();

  Serial.println("Synchronizing PWM channel...");
#ifdef BT_DEBUG
  Serial3.println("Synchronizing PWM channel...");
#endif
  PWMC_ConfigureSyncChannel (PWM,
                             (0x1u << leftChan) | (0x1u << rightChan) | PWM_SCM_SYNC0,   //channel
                             PWM_SCM_UPDM_MODE1,                            //update mode
                             0,                                             //PDC transfer request mode
                             0);                                            //PDC transfer request comparison seletion

  MotorSetChan(PWM_CH0, PER, PER0, 0, 0);
  MotorSetChan(leftChan, PER, 0, 0, 0);
  MotorSetChan(rightChan, PER, 0, 0, 0);

  PWMC_SetSyncChannelUpdatePeriod (PWM, 1);
  PWMC_EnableChannel (PWM, leftChan);
  PWMC_EnableChannel (PWM, rightChan);
  //ML.Enable();
  //MR.Enable();

  PWMC_SetSyncChannelUpdateUnlock (PWM);
  PWMC_EnableChannel (PWM, PWM_CH0);

  PWMC_SetSyncChannelUpdateUnlock (PWM);
  Serial.println("PWM module setup finished.");
#ifdef BT_DEBUG
  Serial3.println("PWM module setup finished.");
#endif
}

int setLeftMotorSpeed(float leftMotorSpeed)
{
  int speed = 0;
  
  if (leftMotorSpeed > PER) {
    speed = 0;
  }else if (leftMotorSpeed < -PER) {
    speed = 0;
  }else {
    speed = PER - abs(int(leftMotorSpeed));
  }

  if (leftMotorSpeed > 0) {
    digitalWrite(LeftMotorINA, LOW);
    digitalWrite(LeftMotorINB, HIGH);
  }else {
    digitalWrite(LeftMotorINA, HIGH);
    digitalWrite(LeftMotorINB, LOW);
  }

  PWMC_SetDutyCycle (PWM, leftChan, speed);
}

int setRightMotorSpeed(float rightMotorSpeed)
{
  int speed = 0;

  if (rightMotorSpeed > PER) {
    speed = 0;
  }else if (rightMotorSpeed < -PER) {
    speed = 0;
  }else {
    speed = PER - abs(int(rightMotorSpeed));
  }

  if (rightMotorSpeed > 0) {
    digitalWrite(RightMotorINA, LOW);
    digitalWrite(RightMotorINB, HIGH);    
  }else {
    digitalWrite(RightMotorINA, HIGH);
    digitalWrite(RightMotorINB, LOW);
  }

  PWMC_SetDutyCycle (PWM, rightChan, speed);
}

