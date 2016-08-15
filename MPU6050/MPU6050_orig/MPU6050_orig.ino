
#include <Wire.h>

//Declaring some global variables
int gyro_x, gyro_y, gyro_z;
long acc_x, acc_y, acc_z, acc_total_vector;
int temperature;
long gyro_x_cal, gyro_y_cal, gyro_z_cal;

float angle_pitch, angle_roll;
int angle_pitch_buffer, angle_roll_buffer;
boolean set_gyro_angles;
float angle_roll_acc, angle_pitch_acc;
float angle_pitch_output, angle_roll_output;

void setup()
{
  Wire.begin();                                                        //Start I2C as master
  Serial.begin(115200);                                               //Use only for debugging
  pinMode(13, OUTPUT);                                                 //Set output 13 (LED) as output

  setup_mpu_6050_registers();                                          //Setup the registers of the MPU-6050 (500dfs / +/-8g) and start the gyro

  digitalWrite(13, HIGH);                                              //Set digital output 13 high to indicate startup

  Serial.println("MPU-6050 IMU V1.0");                                         //Print text to screen

  delay(1500);                                                         //Delay 1.5 second to display the text

  Serial.println("Calibrating gyro");                                       //Print text to screen

  /* Calibration algorithm */
  for (int cal_int = 0; cal_int < 2000 ; cal_int++) {                 //Run this code 2000 times
    if (cal_int % 125 == 0)
      Serial.print(".");                              //Print a dot on the LCD every 125 readings
    read_mpu_6050_data();                                              //Read the raw acc and gyro data from the MPU-6050
    gyro_x_cal += gyro_x;                                              //Add the gyro x-axis offset to the gyro_x_cal variable
    gyro_y_cal += gyro_y;                                              //Add the gyro y-axis offset to the gyro_y_cal variable
    gyro_z_cal += gyro_z;                                              //Add the gyro z-axis offset to the gyro_z_cal variable
    delay(3);                                                          //Delay 3us to simulate the 250Hz program loop
  }

  Serial.println();

  gyro_x_cal /= 2000;                                                  //Divide the gyro_x_cal variable by 2000 to get the avarage offset
  gyro_y_cal /= 2000;                                                  //Divide the gyro_y_cal variable by 2000 to get the avarage offset
  gyro_z_cal /= 2000;                                                  //Divide the gyro_z_cal variable by 2000 to get the avarage offset

  digitalWrite(13, LOW);                                               //All done, turn the LED off
}

void loop()
{
  read_mpu_6050_data();                                                //Read the raw acc and gyro data from the MPU-6050

  gyro_x -= gyro_x_cal;                                                //Subtract the offset calibration value from the raw gyro_x value
  gyro_y -= gyro_y_cal;                                                //Subtract the offset calibration value from the raw gyro_y value
  gyro_z -= gyro_z_cal;                                                //Subtract the offset calibration value from the raw gyro_z value

#if 0
  Serial.print(gyro_x_cal);
  Serial.print("(gyro_x_cal)");
  Serial.print('\t');
  Serial.print(gyro_y_cal);
  Serial.print("(gyro_y_cal)");
  Serial.print('\t');
  Serial.print(gyro_z_cal);
  Serial.print("(gyro_z_cal)");
  Serial.print('\t');
  Serial.print(gyro_x);
  Serial.print("(gyro_x)");
  Serial.print('\t');
  Serial.print(gyro_y);
  Serial.print("(gyro_y)");
  Serial.print('\t');
#endif
  Serial.print(gyro_z);
  Serial.println("(gyro_z)");

  delay(200);
}

void setup_mpu_6050_registers()
{
  //Activate the MPU-6050
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x6B);                                                    //Send the requested starting register
  Wire.write(0x00);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
  //Configure the accelerometer (+/-8g)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1C);                                                    //Send the requested starting register
  Wire.write(0x10);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
  //Configure the gyro (500dps full scale)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1B);                                                    //Send the requested starting register
  Wire.write(0x08);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
}

void read_mpu_6050_data() {                                            //Subroutine for reading the raw gyro and accelerometer data
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x3B);                                                    //Send the requested starting register
  Wire.endTransmission();                                              //End the transmission
  Wire.requestFrom(0x68, 14);                                          //Request 14 bytes from the MPU-6050
  while (Wire.available() < 14);                                       //Wait until all the bytes are received

  acc_x = Wire.read() << 8 | Wire.read();                                //Add the low and high byte to the acc_x variable
  acc_y = Wire.read() << 8 | Wire.read();                                //Add the low and high byte to the acc_y variable
  acc_z = Wire.read() << 8 | Wire.read();                                //Add the low and high byte to the acc_z variable
  temperature = Wire.read() << 8 | Wire.read();                          //Add the low and high byte to the temperature variable
  gyro_x = Wire.read() << 8 | Wire.read();                               //Add the low and high byte to the gyro_x variable
  gyro_y = Wire.read() << 8 | Wire.read();                               //Add the low and high byte to the gyro_y variable
  gyro_z = Wire.read() << 8 | Wire.read();                               //Add the low and high byte to the gyro_z variable
}

