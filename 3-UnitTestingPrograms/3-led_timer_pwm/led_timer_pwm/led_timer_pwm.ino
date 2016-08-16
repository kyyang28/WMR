
#define PWM_FREQ          10000
#define PWM_DUTY_CYCLE    1200

int redLEDPWMPin = 6;
int dt = 12;

int flag = false;
int channel_0 = 0;

uint32_t chan = g_APinDescription[redLEDPWMPin].ulPWMChannel;

void setup()
{
  /* LED pin setup */
  pinMode(redLEDPWMPin, OUTPUT);

  /* LED PWM setup */
  LED_PWM_Setup();

  /* Timer Init */
  TimerInit();

  /* Start the timer */
  TimerStart();
}

void loop()
{
  if (flag) {
    digitalWrite(redLEDPWMPin, HIGH);
    PWMC_SetDutyCycle(PWM_INTERFACE, chan, dt * 100);
    dt -= 2;

    if (dt < 0) {
      dt = 12;
    }
    digitalWrite(redLEDPWMPin, LOW);
  }
}

void LED_PWM_Setup()
{
  /* Enable and configure pwm clock */
  pmc_enable_periph_clk(PWM_INTERFACE_ID);
  PWMC_ConfigureClocks(PWM_FREQ * PWM_DUTY_CYCLE, 0, VARIANT_MCK);

  /* Setup pwm channel of pwm pin */
  PIO_Configure(g_APinDescription[redLEDPWMPin].pPort,
                g_APinDescription[redLEDPWMPin].ulPinType,
                g_APinDescription[redLEDPWMPin].ulPin,
                g_APinDescription[redLEDPWMPin].ulPinConfiguration);

  /* Configure PWM channel to employ CLOCKA */
  PWMC_ConfigureChannel(PWM_INTERFACE, chan, PWM_CMR_CPRE_CLKA, 0, 0);

  /* Setup pwm period to 1200(PWM_DUTY_CYCLE) */
  PWMC_SetPeriod(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Initially setup the pwm duty cycle to maximum 1200 (PWM_DUTY_CYCLE) */
  PWMC_SetDutyCycle(PWM_INTERFACE, chan, PWM_DUTY_CYCLE);

  /* Enable PWM channel */
  PWMC_EnableChannel(PWM_INTERFACE, chan);
}

void TimerInit()
{
  /* timer setup */
  pmc_set_writeprotect(false);
  pmc_enable_periph_clk(ID_TC3);

  /* TC_CMR_TCCLKS_TIMER_CLOCK4 = 84Mhz/128 = 656.250 KHz */
  TC_Configure(/* clock */TC1, /* channel */channel_0,
                          TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC
                          | /* using clock3 */TC_CMR_TCCLKS_TIMER_CLOCK3
                          | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  //TC_SetRC(TC1, channel_0, 26250);      // 26250 / 2625000 = 0.01s = 10ms
  TC_SetRC(TC1, channel_0, 2625000);   // 2625000 / 2625000 = 1s
  //TC_SetRC(TC1, channel_0, 1050000);   // 1050000 / 2625000 = 0.4s = 400ms
  //TC_SetRC(TC1, channel_0, 262500);   // 262500 / 2625000 = 0.01s = 100ms
  //TC_SetRC(TC1, channel_0, 656250);   // 1s * 656250Hz = 656250 counts
  TC_SetRA(TC1, channel_0, 13125);      // 13125 / 2625000 = 0.005s = 5ms

  TC1->TC_CHANNEL[channel_0].TC_IER = TC_IER_CPCS;   // IER = interrupt enable register
  TC1->TC_CHANNEL[channel_0].TC_IDR = ~TC_IER_CPCS;  // IDR = interrupt disable register

  NVIC_EnableIRQ(TC3_IRQn);
}

void TC3_Handler()
{
  TC_GetStatus(TC1, channel_0);
  flag = !flag;
}

void TimerStart()
{
  TC_Start(TC1, channel_0);
}

