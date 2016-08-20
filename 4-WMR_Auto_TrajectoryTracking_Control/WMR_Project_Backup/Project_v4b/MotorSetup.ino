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

  ML.Disable();
  ML.pinSetup();
  MR.Disable();
  MR.pinSetup();
  Serial.println("Synchronizing PWM channel...");
#ifdef BT_DEBUG
  Serial3.println("Synchronizing PWM channel...");
#endif
  PWMC_ConfigureSyncChannel (PWM,
                             (0x1u << ML.C1) | (0x1u << ML.C2) |
                             (0x1u << MR.C1) | (0x1u << MR.C2) | PWM_SCM_SYNC0,   //channel
                             PWM_SCM_UPDM_MODE1,                            //update mode
                             0,                                             //PDC transfer request mode
                             0);                                            //PDC transfer request comparison seletion

  MotorSetChan(PWM_CH0, PER, PER0, 0, 0);
  MotorSetChan(ML.C1, PER, 0, 0, 0);
  MotorSetChan(ML.C2, PER, 0, 0, 0);

  MotorSetChan(MR.C1, PER, 0, 0, 0);
  MotorSetChan(MR.C2, PER, 0, 0, 0);

  PWMC_SetSyncChannelUpdatePeriod (PWM, 1);
  ML.Enable();
  MR.Enable();

  PWMC_SetSyncChannelUpdateUnlock (PWM);
  PWMC_EnableChannel (PWM, PWM_CH0);

  PWMC_SetSyncChannelUpdateUnlock (PWM);
  Serial.println("PWM module setup finished.");
#ifdef BT_DEBUG
  Serial3.println("PWM module setup finished.");
#endif
}

