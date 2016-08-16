#define TC_PRI 1

// Generate Timer interupt
void Timer_Setup(){
  Serial.println("Initializing timer interupt...");
  #ifdef BT_DEBUG
    Serial3.println("Initializing timer interupt...");
  #endif
  // Nested Vector Interupt Controller Initilising
  
  NVIC_DisableIRQ(TC3_IRQn);
  NVIC_ClearPendingIRQ(TC3_IRQn);
  NVIC_SetPriority(TC3_IRQn,TC_PRI);
  NVIC_EnableIRQ(TC3_IRQn);
  
  NVIC_DisableIRQ(TC4_IRQn);
  NVIC_ClearPendingIRQ(TC4_IRQn);
  NVIC_SetPriority(TC4_IRQn,TC_PRI);
//  NVIC_EnableIRQ(TC4_IRQn);
  
  NVIC_DisableIRQ(TC5_IRQn);
//  NVIC_ClearPendingIRQ(TC5_IRQn);
//  NVIC_SetPriority(TC5_IRQn,0);
//  NVIC_EnableIRQ(TC5_IRQn);
  
  // Enable the periph clock
  
  pmc_enable_periph_clk(TC_INTERFACE_ID + 3);
  pmc_enable_periph_clk(TC_INTERFACE_ID + 4);
  pmc_enable_periph_clk(TC_INTERFACE_ID + 5);
  
  // Configure of the timer
  
  // Timer architecture Congiguration of TC1
  // Channel 0 will generate a pulse every 10ms to act as the 
  // clock of the channel 1, and the channel 1 will record the 
  // counts. So does the connection between channel 1 and 2. 
  
  TC1->TC_BMR= TC_BMR_TC1XC1S_TIOA0 | TC_BMR_TC2XC2S_TIOA2;
  Serial.println("Time circle: 10 ms...");
  // Channel0 configuration
  
  TC_Configure(TC1, 0, 
               TC_CMR_TCCLKS_TIMER_CLOCK3 
               | TC_CMR_WAVE | TC_CMR_WAVSEL_UP_RC
               | TC_CMR_ACPC_SET | TC_CMR_ACPA_CLEAR);
  TC_SetRC( TC1, 0, 26250);
  TC_SetRA (TC1, 0, 13125);
  TC1->TC_CHANNEL[0].TC_IER = TC_IER_CPCS; 
  
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
  
  TC_Start(TC1,2);
  TC_Start(TC1,1);
  Serial.println("Timer interupt setup finished.");
  #ifdef BT_DEBUG
    Serial3.println("Timer interupt setup finished.");
  #endif
}

void Timer_Start(){
  Serial.println("System starts...");
  #ifdef BT_DEBUG
    Serial3.println("System starts...");
  #endif
  TC_Start(TC0,2);
  TC_Start(TC2,2);
//  delay(1);
  TC_Start(TC1,0);
}
