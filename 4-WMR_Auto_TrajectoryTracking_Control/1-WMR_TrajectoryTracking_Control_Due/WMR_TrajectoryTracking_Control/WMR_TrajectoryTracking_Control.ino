
#include "I2Cdev.h"
#include "MPU6050.h"

typedef union {
  int16_t num;
  byte byt[2];
} BytInt16;

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if (I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE) || (I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE1)
//    #define I2C_HIGHTSPEED_DUE
#include "Wire.h"
#endif

#define PWM_FREQ          20000
#define PWM_DUTY_CYCLE    1200

/* Motors pwm pins setup */
int LeftMotorPWMPin = 9;
int RightMotorPWMPin = 7;

/* Left motor direction pins */
int LeftMotorINA = 51;
int LeftMotorINB = 49;

/* Right motor direction pins */
int RightMotorINA = 33;
int RightMotorINB = 31;

int dt = 10;

/* encoder counter */
int leftMotorEncoderCnt = 0;
int rightMotorEncoderCnt = 0;

float leftEncoderRadian = 0.0;
float rightEncoderRadian = 0.0;

boolean flag = true;
boolean TimerFlag = false;
int channel_0 = 0;
int channel_1 = 1;
int channel_2 = 2;

uint32_t leftChan = g_APinDescription[LeftMotorPWMPin].ulPWMChannel;
uint32_t rightChan = g_APinDescription[RightMotorPWMPin].ulPWMChannel;


int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
//int leftMotorSpeed = -400;
//int rightMotorSpeed = -1000;
int LeftMotorReferenceSpeed = 5;
int RightMotorReferenceSpeed = 40;
int stopMotorSpeed = PWM_DUTY_CYCLE;  // stopMotorSpeed = 1200

int cnt = 0;

int buzzerPin = 12;

#define gRes 500.*PI/180./32768.
MPU6050 accelgyro;
BytInt16 ax, ay, az;
BytInt16 gx, gy, gz;

int cmdMode = 0;
int startMode = 0;

void setup()
{
  /* WARNING: When using HC-05 BLUETOOTH, make sure to employ serial 9600 baudrate, not 38400 */
  Serial.begin(9600);

  /* Bluetooth 1 and 2 serial initialisation */
  Serial2.begin(9600);
  Serial3.begin(9600);

  /* Motors pin setup */
  pinMode(LeftMotorPWMPin, OUTPUT);
  pinMode(RightMotorPWMPin, OUTPUT);
  pinMode(LeftMotorINA, OUTPUT);
  pinMode(LeftMotorINB, OUTPUT);
  pinMode(RightMotorINA, OUTPUT);
  pinMode(RightMotorINB, OUTPUT);

  /* Buzzer setup */
  pinMode(buzzerPin, OUTPUT);

  /* Setup motors initial directions */
  //digitalWrite(LeftMotorINA, HIGH);
  //digitalWrite(LeftMotorINB, LOW);
  //digitalWrite(RightMotorINA, HIGH);
  //digitalWrite(RightMotorINB, LOW);

  while (1) {
    if (Serial3.available() > 0) {

      startMode = Serial3.read();

      if (startMode == 'S') {

        /* Config MPU6050 */
        ConfigMPU6050();

        /* LED PWM setup */
        MOTOR_PWM_Setup();

        /* Encoder setup */
        EncoderInit();

        /* Timer Init */
        TimerInit();

        /* Start the timer */
        TimerStart();

        break;
      }
    }
  }
}

int timeElapse = 0;

void loop()
{
  if (Serial3.available() > 0) {
    cmdMode = Serial3.read();

    if (cmdMode == '1') {
      motorTest();
      Serial3.println(leftMotorEncoderCnt);
      Serial3.println(rightMotorEncoderCnt);
    } else if (cmdMode == '2') {
      gyroTest();
    }
  }

#if 0
  motorTest();

  /* Send left and right encoders' values to MATLAB via Bluetooth3 */
  Serial3.println(leftMotorEncoderCnt);
  Serial3.println(rightMotorEncoderCnt);

  gyroTest();
#endif
}

void gyroTest()
{
#if 0
  Serial.print("a/g:\t");
  Serial.print(ax.num); Serial.print("\t");
  Serial.print(ay.num); Serial.print("\t");
  Serial.print(az.num); Serial.print("\t");
  Serial.print(gx.num); Serial.print("\t");
  Serial.print(gy.num); Serial.print("\t");
  Serial.println(gz.num);
#endif
  Serial3.println(gz.num);
  //delay(200);
}

void BuzzerTest()
{
  digitalWrite(buzzerPin, HIGH);
  delay(400);
  digitalWrite(buzzerPin, LOW);
  delay(400);
}

void calcEncoderRadian()
{
  /*
      32 means for double edges of one channel results in 32 counts per revolution
      of the motor shaft
  */
  leftEncoderRadian = (float)leftMotorEncoderCnt * 2 * PI / 32;
  rightEncoderRadian = (float)rightMotorEncoderCnt * 2 * PI / 32;
}

void showEncoderCnt()
{
  Serial.print(leftMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(dt);
  Serial.print('\t');
  Serial.print(PWM->PWM_CH_NUM[leftChan].PWM_CDTY);
  Serial.print('\t');
  Serial.print(leftEncoderRadian);
  Serial.print('\t');
  Serial.print('\t');
  Serial.print(rightMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(dt);
  Serial.print('\t');
  Serial.print(PWM->PWM_CH_NUM[rightChan].PWM_CDTY);
  Serial.print('\t');
  Serial.println(rightEncoderRadian);
}

int LeftMotorSpeedPIController(int LeftRawCnts, int LeftSpeedRef)
{
  int currError = 0;
  static int prevError, LeftMotorPWM;
  //static int currError, prevError, motorPWM;

  float Kp = 0.4, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = abs(LeftRawCnts) - abs(LeftSpeedRef);

  /* Based on incremental discrete equation of PI controller */
  LeftMotorPWM += Kp * (currError - prevError) + Ki * currError;

  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(LeftRawCnts);
  Serial.print("(LeftEncoderVal)");
  Serial.print('\t');
  Serial.print(LeftSpeedRef);
  Serial.print("(LeftSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  Serial.print("(LeftCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  Serial.print("(LeftPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(LeftMotorPWM);
  Serial.println("(LeftMotorPWM)");
#endif

  return LeftMotorPWM;
}

int RightMotorSpeedPIController(int RightRawCnts, int RightSpeedRef)
{
  int currError = 0;
  static int prevError, RightMotorPWM;
  //static int currError, prevError, motorPWM;

  float Kp = 0.4, Ki = 1;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = abs(RightRawCnts) - abs(RightSpeedRef);

  /* Based on incremental discrete equation of PI controller */
  RightMotorPWM += Kp * (currError - prevError) + Ki * currError;

  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(RightRawCnts);
  Serial.print("(RightEncoderVal)");
  Serial.print('\t');
  Serial.print(RightSpeedRef);
  Serial.print("(RightSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  Serial.print("(RightCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  Serial.print("(RightPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(RightMotorPWM);
  Serial.println("(RightMotorPWM)");
#endif

  return RightMotorPWM;
}

void motorTest()
{
#if 0
  leftMotorSpeed = LeftMotorSpeedPIController(leftMotorEncoderCnt, LeftMotorReferenceSpeed);
  rightMotorSpeed = RightMotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
  setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);
#endif

  setLeftMotorSpeed(-900);
  setRightMotorSpeed(-1100);

  //showEncoderCnt();
#if 0
  Serial.print(leftMotorSpeed);
  Serial.print('\t');
  Serial.print("(LeftMotorPWM)");
  Serial.print('\t');
  Serial.print(rightMotorSpeed);
  Serial.println("(RightMotorPWM)");
#endif

#if 0
  if (cnt != 10) {
    leftMotorSpeed = MotorSpeedPIController(leftMotorEncoderCnt, LeftMotorReferenceSpeed);
    rightMotorSpeed = MotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
    setLeftMotorSpeed(leftMotorSpeed);
    setRightMotorSpeed(rightMotorSpeed);
    //showEncoderCnt();
    Serial.print(leftMotorSpeed);
    Serial.print('\t');
    Serial.print('\t');
    Serial.println(rightMotorSpeed);
    cnt++;
  } else {
    setLeftMotorSpeed(stopMotorSpeed);    // speed = 1200 - 1200 = 0, stop the left motor
    setRightMotorSpeed(stopMotorSpeed);   // speed = 1200 - 1200 = 0, stop the right motor
  }
#endif

#if 0
  if (cnt != 10) {
    //digitalWrite(RightMotorINA, LOW);
    //digitalWrite(RightMotorINB, HIGH);

    digitalWrite(RightMotorINA, HIGH);
    digitalWrite(RightMotorINB, LOW);
    PWMC_SetDutyCycle (PWM, rightChan, 200);    // speed = 200

    //digitalWrite(LeftMotorINA, LOW);
    //digitalWrite(LeftMotorINB, HIGH);

    digitalWrite(LeftMotorINA, HIGH);
    digitalWrite(LeftMotorINB, LOW);
    PWMC_SetDutyCycle (PWM, leftChan, 200);    // speed = 200

    cnt++;

  } else {
    digitalWrite(RightMotorINA, LOW);
    digitalWrite(RightMotorINB, LOW);
    digitalWrite(LeftMotorINA, LOW);
    digitalWrite(LeftMotorINB, LOW);
  }
#endif

#if 0
  setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);

  showEncoderCnt();

  /* The larger the motorSpeed, the slower the motors spin */
  if (motorSpeed < 1100 && motorSpeed > 0) {
    motorSpeed += 100;
  } else if (motorSpeed > -1100 && motorSpeed < 0) {
    motorSpeed -= 100;
  }

  if (motorSpeed >= 1100) {
    motorSpeed = -800;
  } else if (motorSpeed <= -1100) {
    motorSpeed = 800;
  }
#endif

  delay(400);
}

