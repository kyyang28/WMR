
void TimerInit()
{
  /* timer setup */
  pmc_set_writeprotect(false);

  /* timer starts from group0 */
  pmc_enable_periph_clk(ID_TC3);  // group1 first timer
  pmc_enable_periph_clk(ID_TC4);  // group1 second timer
  pmc_enable_periph_clk(ID_TC5);  // group1 third timer

  /* Timer architecture Congiguration of TC1
    Channel 0 will generate a pulse every 10ms to act as the
    clock of the channel 1, and the channel 1 will record the
    counts. So does the connection between channel 1 and 2.
  */

  TC1->TC_BMR = TC_BMR_TC1XC1S_TIOA0 | TC_BMR_TC2XC2S_TIOA2;

  /* TC_CMR_TCCLKS_TIMER_CLOCK4 = 84Mhz/128 = 656.250 KHz */
  TC_Configure(/* clock */TC1, /* channel */channel_0,
                          TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC
                          | /* using clock3 */TC_CMR_TCCLKS_TIMER_CLOCK3
                          | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  TC_SetRC(TC1, channel_0, 26250);      // 26250 / 2625000 = 0.01s = 10ms
  //TC_SetRC(TC1, channel_0, 1575000);   // 1575000 / 2625000 = 0.6s = 600ms
  //TC_SetRC(TC1, channel_0, 2625000);   // 2625000 / 2625000 = 1s
  //TC_SetRC(TC1, channel_0, 1050000);   // 1050000 / 2625000 = 0.4s = 400ms
  //TC_SetRC(TC1, channel_0, 262500);   // 262500 / 2625000 = 0.01s = 100ms
  //TC_SetRC(TC1, channel_0, 656250);   // 1s * 656250Hz = 656250 counts
  TC_SetRA(TC1, channel_0, 13125);      // 13125 / 2625000 = 0.005s = 5ms

  TC1->TC_CHANNEL[channel_0].TC_IER = TC_IER_CPCS;   // IER = interrupt enable register
  TC1->TC_CHANNEL[channel_0].TC_IDR = ~TC_IER_CPCS;  // IDR = interrupt disable register

  /*  */
  TC_Configure(TC1, 1,
               TC_CMR_TCCLKS_XC1 | TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC
               | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  TC_SetRC( TC1, 1, 100);
  TC_SetRA (TC1, 1, 50);
  //  TC1->TC_CHANNEL[1].TC_IER = TC_IER_CPCS;

  TC_Configure(TC1, 2,
               TC_CMR_TCCLKS_XC2 | TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC
               | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  TC_SetRC( TC1, 2, 60);
  // TC1->TC_CHANNEL[2].TC_IER = TC_IER_CPCS;

  NVIC_EnableIRQ(TC3_IRQn);
  NVIC_EnableIRQ(TC4_IRQn);
  NVIC_EnableIRQ(TC5_IRQn);

  /* Start  */
  TC_Start(TC1, channel_2);
  TC_Start(TC1, channel_1);
}

void TC3_Handler()
{
  //TC_GetStatus(TC1, channel_0);
  TC1->TC_CHANNEL[0].TC_SR;
  leftMotorEncoderCnt = -TC0->TC_CHANNEL[0].TC_RA;
  rightMotorEncoderCnt = -TC2->TC_CHANNEL[0].TC_RA;
  calcEncoderRadian();
  TimerFlag = true;
}

void TimerStart()
{
  TC_Start(TC0, channel_2);
  TC_Start(TC2, channel_2);
  TC_Start(TC1, channel_0);
}

