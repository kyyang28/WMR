
void MOTOR_PWM_Setup()
{
  /* Enable and configure pwm clock */
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(PWM_FREQ * PWM_DUTY_CYCLE, 0, VARIANT_MCK);

  /* Setup pwm channel of pwm pin */
  PIO_Configure(g_APinDescription[MotorPWMPin].pPort,
                g_APinDescription[MotorPWMPin].ulPinType,
                g_APinDescription[MotorPWMPin].ulPin,
                g_APinDescription[MotorPWMPin].ulPinConfiguration);

  /* Configure PWM channel to employ CLOCKA */
  PWMC_ConfigureChannel(PWM_INTERFACE, chan, PWM_CMR_CPRE_CLKA, 0, 0);

  /* Setup pwm period to 1200(PWM_DUTY_CYCLE) */
  PWMC_SetPeriod(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Initially setup the pwm duty cycle to maximum 1200 (PWM_DUTY_CYCLE) */
  PWMC_SetDutyCycle(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Enable PWM channel */
  PWMC_EnableChannel(PWM_INTERFACE, chan);
}

