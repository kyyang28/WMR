
// MD03A_Motor_basic
// Test MD03a / Pololu motor

#define InA1            51                  // INA motor pin
#define InB1            49                  // INB motor pin 
#define PWM1            9                   // PWM motor pin

void setup() {
 pinMode(InA1, OUTPUT);
 pinMode(InB1, OUTPUT);
 pinMode(PWM1, OUTPUT);
}

void loop() {
 motorForward(150);                        //(25%=64; 50%=127; 100%=255)
 delay(4000);

 motorStop();
 delay(4000);

 motorBackward(150);
 delay(4000);
}

void motorForward(int PWM_val)  {
 analogWrite(PWM1, PWM_val);
 digitalWrite(InA1, LOW);
 digitalWrite(InB1, HIGH);
}

void motorBackward(int PWM_val)  {
 analogWrite(PWM1, PWM_val);
 digitalWrite(InA1, HIGH);
 digitalWrite(InB1, LOW);
}

void motorStop()  {
 analogWrite(PWM1, 0);
 digitalWrite(InA1, LOW);
 digitalWrite(InB1, LOW);
}

