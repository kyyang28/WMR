#ifndef MOTOR_H
#define MOTOR_H

#include "Arduino.h"

class MotorJMu {
  public:
    uint8_t CHAN;

  private:
    uint32_t PWM_PIN;
    uint32_t INA_PIN;
    uint32_t INB_PIN;
    uint16_t PER;

  public:   
    MotorJMu() {
      PWM_PIN = 9;
      INA_PIN = 51;
      INB_PIN = 49;
      PER = 1200;
      CHAN = g_APinDescription[PWM_PIN].ulPWMChannel;
    }
    
    MotorJMu(int PWMPin, INAPin, INBPin) {
      PWM_PIN = PWMPin;
      INA_PIN = INAPin;
      INB_PIN = INBPin;
      PER = 1200;
      CHAN = g_APinDescription[PWM_PIN].ulPWMChannel;
    }
    
    int setChan(int Pin) {
      PWM_PIN = Pin;
      CHAN = g_APinDescription[PWM_PIN].ulPWMChannel;
      return 0;
    }
    
    int Initial(uint16_t FRE, uint16_t _PER) {
      PER = _PER;
      uint16_t PER0 = PER/2; 
      pmc_enable_periph_clk (PWM_INTERFACE_ID);
      PWMC_ConfigureClocks( FRE * PER, 0, VARIANT_MCK);
      
      Disable();
      pinSetup();
      
      PWMC_ConfigureSyncChannel (PWM,
								(0x1u<<CHAN) | PWM_SCM_SYNC0,       //channel
                          PWM_SCM_UPDM_MODE1,                            //update mode
                          0,                                             //PDC transfer request mode
                          0);                                            //PDC transfer request comparison seletion
                                
/*	  PWMC_SetPeriod (PWM, C1, pwm_period);
  	  PWMC_SetPeriod (PWM, C2, pwm_period);

  	  PWMC_ConfigureChannel (PWM, C1, PWM_CMR_CPRE_CLKA, 0, 0);
  	  PWMC_ConfigureChannel (PWM, C2, PWM_CMR_CPRE_CLKA, 0, 0);

  	  PWMC_SetDutyCycle (PWM, C1, 0);
  	  PWMC_SetDutyCycle (PWM, C2, 0);

  	  PWMC_SetPeriod (PWM, 0, PER);
  	  PWMC_SetDutyCycle (PWM, 0, PER0);
  	  PWMC_ConfigureChannel (PWM, 0, PWM_CMR_CPRE_CLKA, 0,0);*/	
        
  	  setChan(C1, PER,PER, 0, 0);
  	  setChan(C2, PER,PER, 0, 0);
  	  setChan(0, PER,PER0, 0, 0);
  	  
      PWMC_SetSyncChannelUpdatePeriod (PWM, 1);
      Enable();
      
      PWMC_SetSyncChannelUpdateUnlock (PWM);
      PWMC_EnableChannel (PWM, PWM_CH0);
      
      PWMC_SetSyncChannelUpdateUnlock (PWM);  
      
      return 0;     
    }
    
    int Disable() {
      PWMC_DisableChannel (PWM, CHAN);
      return 0;
    }
    
    int Enable() {
      PWMC_EnableChannel (PWM, CHAN);
      return 0;
    }
    
    int pinSetup() {
      setPin(PWM_PIN);
      return 0;     
    }
    
    int setPin(uint32_t ulPin) {
      PIO_Configure (g_APinDescription[ulPin].pPort,
                  		     g_APinDescription[ulPin].ulPinType,
                  		     g_APinDescription[ulPin].ulPin,
                  		     g_APinDescription[ulPin].ulPinConfiguration);
      return 0;
    }
	
    int setChan(uint8_t channel, uint16_t PER, uint16_t DUTY, uint32_t align, uint32_t polar) {
  	  PWMC_SetPeriod (PWM, channel, PER);
        PWMC_SetDutyCycle (PWM, channel, DUTY);
        PWMC_ConfigureChannel (PWM, channel, PWM_CMR_CPRE_CLKA, align,                      //alignment
                                        polar);                                                //Polarity     
      return 0;  
    }
    
    int setDuty(int _duty) {
      uint16_t DUTY = _duty;

      if (DUTY > PER)
        return -1;
      else {
        PWMC_SetDutyCycle (PWM, CHAN, DUTY);
        return 0;
      }
    }
	
	int setSpeed(float _speed) {
		int speed;
		int speedMAX = PER;   // speedMAX = PER = 1200

		if (_speed > speedMAX)
      speed = 0;
		else if (_speed < -speedMAX)
      speed = 0;
		else
      speed = speedMAX - abs(int(_speed));

#if 0		
    if (_speed >= 0) {
			setDuty(speed, 2);
			setDuty(speedMAX, 1);
		}else {
			setDuty(speed, 1);
			setDuty(speedMAX, 2);
		}
#else
    if (_speed > 0) {
      INA_PIN = 
    }else {

    }
#endif    
	}
};
#endif
