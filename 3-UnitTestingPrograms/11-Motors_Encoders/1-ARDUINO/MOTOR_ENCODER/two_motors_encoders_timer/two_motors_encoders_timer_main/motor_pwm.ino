
void MOTOR_PWM_Setup()
{
  /* Enable and configure pwm clock */
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(PWM_FREQ * PWM_DUTY_CYCLE, 0, VARIANT_MCK);

  /* Setup left motor pwm pin */
  PIO_Configure(g_APinDescription[LeftMotorPWMPin].pPort,
                g_APinDescription[LeftMotorPWMPin].ulPinType,
                g_APinDescription[LeftMotorPWMPin].ulPin,
                g_APinDescription[LeftMotorPWMPin].ulPinConfiguration);

  /* Setup right motor pwm pin */
  PIO_Configure(g_APinDescription[RightMotorPWMPin].pPort,
                g_APinDescription[RightMotorPWMPin].ulPinType,
                g_APinDescription[RightMotorPWMPin].ulPin,
                g_APinDescription[RightMotorPWMPin].ulPinConfiguration);

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
}

