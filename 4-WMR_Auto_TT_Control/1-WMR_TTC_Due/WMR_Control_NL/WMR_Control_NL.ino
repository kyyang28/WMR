
#include "I2Cdev.h"
#include "MPU6050.h"

/* Debugging flags */
#define BT_DEBUG    1
#define UART_DEBUG  0

/* Motor related macros */
#define PWM_FREQ          20000
#define PWM_DUTY_CYCLE    1200
#define MOTORMAX          50
#define INTLIMIT          1200

/* +--- Type defined structures ---+ */
typedef union {
  int16_t num;
  byte byt[2];
} BytInt16;

typedef struct {
  float x;
  float y;
  float z;
} g_Posture;
/* +--- Type defined structures ---+ */

/* Variables for postures of
   current, reference and error sytem
*/
g_Posture qc;
g_Posture qr;
g_Posture xe;

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if (I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE) || (I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE1)
//    #define I2C_HIGHTSPEED_DUE
#include "Wire.h"
#endif

/* +--- Motor related variables ---+ */
/* Motors pwm pins setup */
int LeftMotorPWMPin = 9;
int RightMotorPWMPin = 7;

/* Left motor direction pins */
int LeftMotorINA = 51;
int LeftMotorINB = 49;

/* Right motor direction pins */
int RightMotorINA = 33;
int RightMotorINB = 31;

/* encoder counter */
int leftMotorEncoderCnt = 0;
int rightMotorEncoderCnt = 0;

uint32_t leftChan = g_APinDescription[LeftMotorPWMPin].ulPWMChannel;
uint32_t rightChan = g_APinDescription[RightMotorPWMPin].ulPWMChannel;

int leftMotorSpeed = 0;
int rightMotorSpeed = 0;
float LeftMotorReferenceSpeed = 0;
float RightMotorReferenceSpeed = 0;
int stopMotorSpeed = PWM_DUTY_CYCLE;  // stopMotorSpeed = 1200

const float intPartLimit = INTLIMIT;
const float boundMotor = MOTORMAX;
/* +--- Motor related variables ---+ */

/* +--- Timer related variables ---+ */
boolean TimerFlag = false;
int channel_0 = 0;
int channel_1 = 1;
int channel_2 = 2;
/* +--- Timer related variables ---+ */

/* +--- Buzzer pin ---+ */
int buzzerPin = 12;
/* +--- Buzzer pin ---+ */

/* +--- Gyroscope variables ---+ */
#define gRes 250.*PI/180./32768.
MPU6050 accelgyro;
BytInt16 ax, ay, az;
BytInt16 gx, gy, gz;
/* +--- Gyroscope variables ---+ */

/* Program start command */
int startMode = 0;

/* +--- Related variables for sliding mode algorithm ---+ */
float vr;
float wr;
float tt = 0.01;    // 0.01s = 10ms

float eta[2];
float eps[2];
float u_input[2];

float w_enL, w_enR, yawAngle;
float v_WMR;
float w_WMR;
int k1_n = 1;
float matG[2][2];
float invMatG[2][2];
float matF[2];

float tmpParam;
float matFParam;

float w_R;
float w_L;

float vrVal = 0.0;
float wrVal = 0.0;
/* +--- Related variables for sliding mode algorithm ---+ */

void setup()
{
  /* Default serial port */
  Serial.begin(115200);

  /* Bluetooth serial initialisation */
  Serial3.begin(38400);

  /* Motors pin setup */
  pinMode(LeftMotorPWMPin, OUTPUT);
  pinMode(RightMotorPWMPin, OUTPUT);
  pinMode(LeftMotorINA, OUTPUT);
  pinMode(LeftMotorINB, OUTPUT);
  pinMode(RightMotorINA, OUTPUT);
  pinMode(RightMotorINB, OUTPUT);

  /* Config parameters of sliding mode algorithm */
  ConfigSMCParams();

  /* Buzzer setup */
  pinMode(buzzerPin, OUTPUT);

  /*
      WARNING: Wait for BT to connect WMR in order to start the program
      Synchronising Arduino with MATLAB via Bluetooth3(BT3)
      Sending initialisation information to listbox of MATLAB GUI
  */
  while (1) {
    if (Serial3.available() > 0) {

      startMode = Serial3.read();

      /* Sychronisation character 'S' */
      if (startMode == 1)
      {
        /* Line trajectory settings */
        ConfigLineParams();
      }
      else if (startMode == 2)
      {
        /* Circle of radius 25cm trajectory settings */
        ConfigCircle25cmParams();
      }
      else if (startMode == 3)
      {
        ConfigCircle50cmParams();
      }
      else if (startMode == 'S')
      {
        /* Config linear and angular velocities of reference WMR */
        ConfigRefParams();

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

        //Serial.println("Initialisations are completed");

        /* Initialise once */
        break;
      }
    }
  }

  /* WMR program starts 2s after initialisation processes are finished */
  delay(2000);
}

void loop()
{
  /* Execute trajectory tracking control algorithm every 10ms */
  if (TimerFlag) {
    TimerFlag = false;

    /* Calling trajectory tracking control algorithm */
    TrajectoryTrackingAlgo();
  }
}

/* Helper function to setup the boundary value */
template<class T> int BoundFunc(T* pData, T bound) {
  if (*pData > bound) *pData = bound;
  else if (*pData < -bound) *pData = -bound;
  return 0;
}

static void ConfigLineParams()
{
  //qc.x = -0.3;
  //qc.y = -0.3;
  qc.x = -0.2;
  qc.y = -0.2;
  qc.z = 1.5708;  // 90 degree
  qr.x = 0.0;
  qr.y = 0.0;
  //qr.z = 0.0;
  qr.z = 0.7854;  // 45 degree
  vrVal = 0.2;
  wrVal = 0.0;
  //wrVal = 0.8;
  //Serial.println("Line trajectory setting is completed");
}

static void ConfigCircle25cmParams()
{
  qc.x = -0.25;
  qc.y = -0.11;
  //qc.x = 0.25;
  //qc.y = -0.25;
  qc.z = PI / 2;
  qr.x = 0.0;
  qr.y = 0.0;
  qr.z = PI / 2;
  vrVal = 0.2;
  wrVal = 0.8;
  //Serial.println("Circle trajectory setting is completed");
}

static void ConfigCircle50cmParams()
{
  /* Circle of radius 50cm trajectory settings */
  //qc.x = 0.0;
  //qc.y = 0.0;
  qc.x = -0.50;
  qc.y = -0.11;
  //qc.x = -0.5;
  //qc.y = -0.75;
  qc.z = PI / 2;
  qr.x = 0.0;
  qr.y = 0.0;
  qr.z = PI / 2;
  vrVal = 0.2;
  wrVal = 0.4;
  //Serial.println("Circle trajectory setting is completed");
}

