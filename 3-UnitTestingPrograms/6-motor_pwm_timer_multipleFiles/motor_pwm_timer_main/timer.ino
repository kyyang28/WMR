
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
  TC_SetRC(TC1, channel_0, 1575000);   // 1575000 / 2625000 = 0.6s = 600ms
  //TC_SetRC(TC1, channel_0, 2625000);   // 2625000 / 2625000 = 1s
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
  TimerFlag = true;
}

void TimerStart()
{
  TC_Start(TC1, channel_0);
}

