
#define PWM_FREQ          10000
#define PWM_DUTY_CYCLE    1200

int redLEDPWMPin = 6;
int yellowLEDPWMPin = 7;
int blueLEDPWMPin = 8;
int dt = 12;

uint32_t chan = g_APinDescription[blueLEDPWMPin].ulPWMChannel;

void setup()
{
  /* LED pin setup */
  pinMode(blueLEDPWMPin, OUTPUT);
  
  /* LED PWM setup */
  LED_PWM_Setup();
}

void loop()
{
  digitalWrite(blueLEDPWMPin, HIGH);
  PWMC_SetDutyCycle(PWM_INTERFACE, chan, dt*100);
  dt -= 2;

  if (dt < 0) {
    dt = 12;
  }

  digitalWrite(blueLEDPWMPin, LOW);
  delay(400);
}

void LED_PWM_Setup()
{
  /* Enable and configure pwm clock */
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(PWM_FREQ * PWM_DUTY_CYCLE, 0, VARIANT_MCK);

  /* Setup pwm channel of pwm pin */
  PIO_Configure(g_APinDescription[blueLEDPWMPin].pPort,
                g_APinDescription[blueLEDPWMPin].ulPinType,
                g_APinDescription[blueLEDPWMPin].ulPin,
                g_APinDescription[blueLEDPWMPin].ulPinConfiguration);

  /* Configure PWM channel to employ CLOCKA */
  PWMC_ConfigureChannel(PWM_INTERFACE, chan, PWM_CMR_CPRE_CLKA, 0, 0);

  /* Setup pwm period to 1200(PWM_DUTY_CYCLE) */
  PWMC_SetPeriod(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Initially setup the pwm duty cycle to maximum 1200 (PWM_DUTY_CYCLE) */
  PWMC_SetDutyCycle(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Enable PWM channel */
  PWMC_EnableChannel(PWM_INTERFACE, chan);
}

