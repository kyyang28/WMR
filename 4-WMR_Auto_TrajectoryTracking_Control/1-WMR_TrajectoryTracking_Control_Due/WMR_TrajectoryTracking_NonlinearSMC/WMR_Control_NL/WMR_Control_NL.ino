
#include "I2Cdev.h"
#include "MPU6050.h"
#include "VectorQuaternion.h"

#define KCONSTANT 19.2/200/PI
#define PWM_FREQ          20000
#define PWM_DUTY_CYCLE    1200
#define MOTORMAX          50
#define INTLIMIT          1200
//#define KIMAX             100.0

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
//int LeftMotorReferenceSpeed = 5;
float LeftMotorReferenceSpeed = 0;
float RightMotorReferenceSpeed = 0;
int stopMotorSpeed = PWM_DUTY_CYCLE;  // stopMotorSpeed = 1200

const float intPartLimit = INTLIMIT;

int cnt = 0;

int buzzerPin = 12;

#define gRes 500.*PI/180./32768.
MPU6050 accelgyro;
BytInt16 ax, ay, az;
BytInt16 gx, gy, gz;

int cmdMode = 0;
int startMode = 0;

/* Algorithm Variables */
vectorJMu<float> qc(-.1, -.1, 0.6);
vectorJMu<float> qr(0, 0, 0);
vectorJMu<float> xe;
vectorJMu<float> dxe;
float vr;
float wr;
float tt = 0.01;    // 0.01s = 10ms
float Time;

float eta[2];
float eps[2];
float uctrl[2];
float upid[2];
float ki[2] = {0};

float w_enL, w_enR, dTheta;
float v_WMR;
float w_WMR;
int k1_n = 1;
float gammaG[2][2];
float gammaF[2];

float wheelR;
float wheelL;

const float boundMotor = MOTORMAX;

void setup()
{
  /* WARNING: When using HC-05 BLUETOOTH, make sure to employ serial 9600 baudrate, not 38400 */
  Serial.begin(115200);

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

#if 0
  /*
      WARNING: Wait for BT to connect WMR in order to start the program
      Synchronising Arduino with MATLAB via Bluetooth3(BT3)
      Sending initialisation information to listbox of MATLAB GUI
  */
  while (1) {
    if (Serial3.available() > 0) {

      startMode = Serial3.read();

      /* Sychronisation character 'S' */
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

        /* Initialise once */
        break;
      }
    }
  }
#else
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
#endif

  /* WMR program starts 2s after initialisation processes are finished */
  delay(2000);
}

int timeElapse = 0;

void motorTest()
{
#if 1
  //LeftMotorReferenceSpeed+=float(rightMotorEncoderCnt)/5.0;
  //LeftMotorReferenceSpeed=round(LeftMotorReferenceSpeed);
  /*if(rightMotorEncoderCnt>0) LeftMotorReferenceSpeed=30;
  else if(rightMotorEncoderCnt<0) LeftMotorReferenceSpeed=0;*/

  RightMotorReferenceSpeed+=float(leftMotorEncoderCnt)/5.0;
  RightMotorReferenceSpeed=round(RightMotorReferenceSpeed);
  /*if(leftMotorEncoderCnt>0) RightMotorReferenceSpeed=30;
  else if(leftMotorEncoderCnt<0) RightMotorReferenceSpeed=0;*/
  
  //leftMotorSpeed = LeftMotorSpeedPIController(leftMotorEncoderCnt, (int)LeftMotorReferenceSpeed);
  rightMotorSpeed = RightMotorSpeedPIController(rightMotorEncoderCnt, RightMotorReferenceSpeed);
  //setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);
#endif
}

void loop()
{
  if(TimerFlag){
    TimerFlag=false;
    //motorTest();
    TrajectoryTrackingAlgo();
    /*Serial.print(leftMotorEncoderCnt);
    Serial.print('\t');
    Serial.print(rightMotorEncoderCnt);
    Serial.print('\t');
    Serial.println(gz.num);*/
    Serial.print('\n');
  }
#if 0
  if (TimerFlag) {
    TrajectoryTrackingAlgo();

    Serial3.println(leftMotorEncoderCnt);
    Serial3.println(rightMotorEncoderCnt);
    Serial3.println(wheelL);
    Serial3.println(wheelR);
    Serial3.println(leftMotorSpeed);
    Serial3.println(rightMotorSpeed);
    Serial3.println(gz.num);
    //Serial3.println(upid[0]);
    //Serial3.println(upid[1]);
  }
#endif

#if 0
  if (Serial3.available() > 0) {
    cmdMode = Serial3.read();

    if (cmdMode == '1') {
      motorTest();
      Serial3.println(leftMotorEncoderCnt);
      Serial3.println(rightMotorEncoderCnt);
      Serial3.println(gz.num);
    } else if (cmdMode == '2') {
      gyroTest();
    }
  }
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

float LeftMotorSpeedPIController(int LeftRawCnts, float LeftSpeedRef)
{
  float currError = 0;
  float LeftMotorPWM;
  static float prevError, intPart;
  //static int currError, prevError, motorPWM;

  const float Kp = 30, Ki = 5, Kd = 2.5;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = LeftSpeedRef - LeftRawCnts;

  /* Based on incremental discrete equation of PI controller */
  intPart += Ki * currError;
  boundFun(&intPart,intPartLimit);
  LeftMotorPWM = Kp * currError + intPart + Kd * (currError - prevError);
  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(LeftRawCnts);
  //Serial.print("(LeftEncoderVal)");
  Serial.print('\t');
  Serial.print(LeftSpeedRef);
  //Serial.print("(LeftSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  //Serial.print("(LeftCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  //Serial.print("(LeftPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(LeftMotorPWM);
  //Serial.println("(LeftMotorPWM)");
#endif

  return LeftMotorPWM;
}

float RightMotorSpeedPIController(int RightRawCnts, float RightSpeedRef)
{
  float currError = 0;
  float RightMotorPWM;
  static float prevError, intPart;
  //static int currError, prevError, motorPWM;

  const float Kp = 30, Ki = 5, Kd = 2.5;   // Pololu 30:1 GearMotor with 64 CPR encoder

  currError = RightSpeedRef - RightRawCnts;

  /* Based on incremental discrete equation of PI controller */
  intPart += Ki * currError;
  boundFun(&intPart,intPartLimit);
  /*if(intPart > INTLIMIT) intPart = INTLIMIT;
  else if(intPart < -INTLIMIT) intPart = -INTLIMIT;*/
  RightMotorPWM = Kp * currError + intPart + Kd * (currError - prevError);

  /* Update prevError variable to currError for next round */
  prevError = currError;

#if 1
  Serial.print(RightRawCnts);
  //Serial.print("(RightEncoderVal)");
  Serial.print('\t');
  Serial.print(RightSpeedRef);
  //Serial.print("(RightSpeedRef)");
  Serial.print('\t');
  Serial.print(currError);
  //Serial.print("(RightCurrError)");
  Serial.print('\t');
  Serial.print(prevError);
  //Serial.print("(RightPrevError)");
  Serial.print('\t');
  //Serial.print(currError - prevError);
  //Serial.print("(currError - PrevError)");
  //Serial.print('\t');
  Serial.print(RightMotorPWM);
  //Serial.println("(RightMotorPWM)");
#endif

  return RightMotorPWM;
}

template<class T> int boundFun(T* pData, T bound){
  if (*pData > bound) *pData = bound;
  else if (*pData < -bound) *pData = -bound;
  return 0;
}


