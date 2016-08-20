//#include "MatrixJ.h"
#include "VectorQuaternion.h"

#include "Motor.h"

#include "I2Cdev.h"
#include "MPU6050.h"

#define MOTORMAX 100.0
#define KIMAX 400.0e

// uncomment "MOTOR_TEST" for running robot, this is for
// Motor test
#define MOTOR_TEST

// uncomment "BT_DEBUG" for bluetooth debug with char data
#define BT_DEBUG

// uncomment "BT_BINARY" for sending binary data from bluetooth
//#define BT_BINARY

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

/*#include "Matrix.h"
  #include "JianqiuAHRS.h"*/

/*
  ===========================================
  Timer Varables
  ===========================================
*/
bool FAT = false; //Time interupt FAT

/*
  ===========================================
  Motor Varables
  ===========================================
*/
#define FRE 20000 //PWM frequency
#define PER 1200  //PWM Counts

int count_enL = 0;  //Reading from Left Encoder
int count_enR = 0;  //Reading from Right Encoder

MotorJMu MR(8, 9); //PWM setup for left motor
MotorJMu ML(7, 6); //PWM setup for right motor

/*
  ===========================================
  AccGyro Varables
  ===========================================
*/
#define gRes 500.*PI/180./32768.
MPU6050 accelgyro;
BytInt16 ax, ay, az;
BytInt16 gx, gy, gz;

/*
  ===========================================
  AHRS Varables
  ===========================================
*/
float deltat = 0.0f;
float q[4] = {1.0f, 0.0f, 0.0f, 0.0f};    // vector to hold quaternion
float eInt[3] = {0.0f, 0.0f, 0.0f};       // vector to hold integral error for Mahony method
float pitch, yaw, roll;

float _thr = 0.05;

/*float Acc[3];
  float Gyr[3];
  float Mag[3];*/

float GyroMeasError = PI * (60.0f / 180.0f);   // gyroscope measurement error in rads/s (start at 40 deg/s)
float GyroMeasDrift = PI * (0.0f  / 180.0f);   // gyroscope measurement drift in rad/s/s (start at 0.0 deg/s/s)

float beta = 0.2;   // compute beta
float zeta = sqrt(3.0f / 4.0f) * GyroMeasDrift;   // compute zeta, the other free parameter in the Madgwick scheme usually set to a small or zero value
#define Kp 2.0f * 5.0f // these are the free parameters in the Mahony filter and fusion scheme, Kp for proportional feedback, Ki for integral
#define Ki 0.0f

/*
  ===========================================
  Control Design Varables
  ===========================================
*/
vectorJMu<float> qc(-.1, -.1, 0.6);
vectorJMu<float> qr(0, 0, 0);
float tt = 0.01;
float Time;

vectorJMu<float> xe;
vectorJMu<float> dxe;
float gammaG[2][2];
float gammaF[2];
float uctrl[2];
float eta[2];
float eps[2];
float vr;
float wr;
float upid[2];
float ki[2] = {0};

float wheelR;
float wheelL;

float w_enL, w_enR, dTheta;
float v_WMR;
float w_WMR;
/*
  ===========================================
  LED Varables
  ===========================================
*/
#define LED_PING 48
#define LED_PINY 50
#define LED_PINR 52

int LED_I = 0;
bool FAT_LED = false;
bool FAT_GYRO = true;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Start to initializing the system...");
#ifdef BT_DEBUG
  BTSetup();
#endif
  pinMode(LED_PING, OUTPUT);
  pinMode(LED_PINY, OUTPUT);
  pinMode(LED_PINR, OUTPUT);

  AccGyroSetup();
  MotorSetup();  //PWM setup
  Encoder_Setup();
  Timer_Setup();

  digitalWrite(LED_PING, false);
  digitalWrite(LED_PINY, false);
  digitalWrite(LED_PINR, false);
  /*Serial.println (PWM->PWM_SCM,BIN);
    Serial.println (PWM->PWM_CLK,BIN);
    Serial.println (PWM->PWM_SR,BIN);
    Serial.println (PWM->PWM_CH_NUM[0].PWM_CMR,BIN);
    Serial.println (PWM->PWM_CH_NUM[0].PWM_CPRD,BIN);*/
#ifdef BT_DEBUG
  BTStart();
#endif
  WMRParaIni();
  Timer_Start();
}

void loop() {
  // put your main code here, to run repeatedly:
  if (FAT)
  {
    FAT = false;
    if (!FAT_GYRO)
    {
      Serial.println("AccGyro not functioning, please reset device...");
      TC_Stop(TC0, 2);
      TC_Stop(TC2, 2);
      TC_Stop(TC1, 0);
    }
    WMRcaculation();
    WMRdisplay();
  }

}

void WMRdisplay() {
#ifdef BT_DEBUG
  Serial3.print(upid[0]);
  Serial3.print('\t');
  Serial3.print(upid[1]);
  Serial3.print('\t');
  Serial3.print(wheelR);
  Serial3.print('\t');
  Serial3.print(wheelL);
  Serial3.print('\t');
  Serial3.print(count_enR);
  Serial3.print('\t');
  Serial3.println(count_enL);
  /*Serial3.print(qc.x);
    Serial3.print('\t');
    Serial3.print(qc.y);
    Serial3.print('\t');
    Serial3.print(qc.z/PI*180);*/
#endif
  Serial.print(upid[0]);
  Serial.print('\t');
  Serial.print(upid[1]);
  Serial.print('\t');
  Serial.print(wheelR);
  Serial.print('\t');
  Serial.print(wheelL);
  Serial.print('\t');
  Serial.print(count_enR);
  Serial.print('\t');
  Serial.print(count_enL);
  /*Serial.print(qc.x);
    Serial.print('\t');
    Serial.print(qc.y);
    Serial.print('\t');
    Serial.print(qc.z/PI*180);
    Serial.print('\t');
    Serial.print(qr.x);
    Serial.print('\t');
    Serial.print(qr.y);
    Serial.print('\t');
    Serial.print(qr.z/PI*180);*/
  Serial.print('\n');
  return;
}

void TC3_Handler(void) {
  TC1->TC_CHANNEL[0].TC_SR; // VERY IMPORTANT!!!!IF NOT INCLUDED, INTERUPT FUNCTION WILL KEEP GOING AND GOING!!!!!
  count_enL = -TC0->TC_CHANNEL[0].TC_RA;
  count_enR = -TC2->TC_CHANNEL[0].TC_RA;
  accelgyro.getMotion6(&ax.num, &ay.num, &az.num, &gx.num, &gy.num, &gz.num);
  LED_I++;
  FAT = true;
  if (LED_I > 5) {
    FAT_GYRO = accelgyro.testConnection();
    digitalWrite(LED_PINR, FAT_GYRO);
    LED_I = 0;
    FAT_LED = !FAT_LED;
    digitalWrite(LED_PINY, FAT_LED);
  }
}

