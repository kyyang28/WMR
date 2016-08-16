
// These are the clock frequencies available to the timers /2,/8,/32,/128
// 84Mhz/2 = 42.000 MHz     (CLOCK1)
// 84Mhz/8 = 10.500 MHz     (CLOCK2)
// 84Mhz/32 = 2.625 MHz     (CLOCK3)
// 84Mhz/128 = 656.250 KHz  (CLOCK4)
//
// 42Mhz/44.1Khz = 952.38
// 10.5Mhz/44.1Khz = 238.09 
// 2.625Hmz/44.1Khz = 59.5
// 656Khz/44.1Khz = 14.88 // 131200 / 656000 = .2 (.2 seconds)

// 84Mhz/44.1Khz = 1904 instructions per tick

int redLedPin = 30;
int yellowLedPin = 31;
int greenLedPin = 32;

int redLedState = false;
int yellowLedState = false;
int greenLedState = false;

int channel_0 = 0;
int channel_1 = 1;
int channel_2 = 2;

void setup()
{
  /* led pin setup */
  pinMode(redLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);

  /* red led timer setup */
  redLedTimerInit();
  yellowLedTimerInit();
  greenLedTimerInit();
  
  /* start red, yellow, green led timers */
  redLedTimerStart();
  yellowLedTimerStart();
  greenLedTimerStart();
}

void loop()
{
  /* Nothing need to be included */
  /* the timer interrupt service routine will handle the led blinking */
}

void redLedTimerInit()
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
  TC_SetRC(TC1, channel_0, 262500);   // 262500 / 2625000 = 0.01s = 100ms
  //TC_SetRC(TC1, channel_0, 656250);   // 1s * 656250Hz = 656250 counts
  TC_SetRA(TC1, channel_0, 13125);      // 13125 / 2625000 = 0.005s = 5ms

  TC1->TC_CHANNEL[channel_0].TC_IER = TC_IER_CPCS;   // IER = interrupt enable register
  TC1->TC_CHANNEL[channel_0].TC_IDR = ~TC_IER_CPCS;  // IDR = interrupt disable register

  NVIC_EnableIRQ(TC3_IRQn);
}

void yellowLedTimerInit()
{
  /* timer setup */
  pmc_set_writeprotect(false);
  pmc_enable_periph_clk(ID_TC4);

  /* TC_CMR_TCCLKS_TIMER_CLOCK4 = 84Mhz/128 = 656.250 KHz */
  TC_Configure(/* clock */TC1, /* channel */channel_1, 
            TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC 
            | /* using clock3 */TC_CMR_TCCLKS_TIMER_CLOCK3
            | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  //TC_SetRC(TC1, channel_1, 26250);      // 26250 / 2625000 = 0.01s = 10ms
  TC_SetRC(TC1, channel_1, 1050000);   // 1050000 / 2625000 = 0.4s = 400ms
  //TC_SetRC(TC1, channel_1, 656250);   // 1s * 656250Hz = 656250 counts
  TC_SetRA(TC1, channel_1, 13125);      // 13125 / 2625000 = 0.005s = 5ms

  TC1->TC_CHANNEL[channel_1].TC_IER = TC_IER_CPCS;   // IER = interrupt enable register
  TC1->TC_CHANNEL[channel_1].TC_IDR = ~TC_IER_CPCS;  // IDR = interrupt disable register

  NVIC_EnableIRQ(TC4_IRQn);  
}

void greenLedTimerInit()
{
  /* timer setup */
  pmc_set_writeprotect(false);
  pmc_enable_periph_clk(ID_TC5);

  /* TC_CMR_TCCLKS_TIMER_CLOCK4 = 84Mhz/128 = 656.250 KHz */
  TC_Configure(/* clock */TC1, /* channel */channel_2, 
            TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC 
            | /* using clock3 */TC_CMR_TCCLKS_TIMER_CLOCK3
            | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  //TC_SetRC(TC1, channel_2, 26250);      // 26250 / 2625000 = 0.01s = 10ms
  TC_SetRC(TC1, channel_2, 2625000);   // 2625000 / 2625000 = 1s
  //TC_SetRC(TC1, channel_2, 656250);   // 1s * 656250Hz = 656250 counts
  TC_SetRA(TC1, channel_2, 13125);      // 13125 / 2625000 = 0.005s = 5ms

  TC1->TC_CHANNEL[channel_2].TC_IER = TC_IER_CPCS;   // IER = interrupt enable register
  TC1->TC_CHANNEL[channel_2].TC_IDR = ~TC_IER_CPCS;  // IDR = interrupt disable register

  NVIC_EnableIRQ(TC5_IRQn);  
}

void redLedTimerStart()
{
  TC_Start(TC1, channel_0);
}

void yellowLedTimerStart()
{
  TC_Start(TC1, channel_1);
}

void greenLedTimerStart()
{
  TC_Start(TC1, channel_2);
}

void TC3_Handler()
{
  TC_GetStatus(TC1, channel_0);
  redLedState = !redLedState;
  digitalWrite(redLedPin, redLedState);
}

void TC4_Handler()
{
  TC_GetStatus(TC1, channel_1);
  yellowLedState = !yellowLedState;
  digitalWrite(yellowLedPin, yellowLedState);
}

void TC5_Handler()
{
  TC_GetStatus(TC1, channel_2);
  greenLedState = !greenLedState;
  digitalWrite(greenLedPin, greenLedState);
}

/* Normal polling method */
#if 0
  redLedState = !redLedState;
  digitalWrite(redLedPin, redLedState);
  delay(600);

  yellowLedState = !yellowLedState;
  digitalWrite(yellowledPin, redLedState);
  delay(600);
  
  greenLedState = !greenLedState;
  digitalWrite(greenLedPin, redLedState);
  delay(600);
#endif

