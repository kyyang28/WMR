
const int AccGyroOffset[6] = {501, 234, 1654, 67, 26, 11};

void ConfigMPU6050()
{
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.setClock(400000);
  Wire.begin();
#elif I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE1
  Wire1.setClock(400000);
  Wire1.begin();
#endif

  Serial3.println("Initializing accgyro device.");

  accelgyro.initialize();

  Serial3.println("Testing device connections...");

  bool isConnected = accelgyro.testConnection();
  Serial3.println(isConnected ? "MPU6050 connection successful" : "MPU6050 connection failed");

  if (!isConnected) {
    Serial.println("Please reset the Arduino or MPU6050");
  }

  /* Calibrate MPU6050 */
  calibrateMPU6050();

  Serial3.println("MPU6050 setup finished.");
}

void calibrateMPU6050()
{
  accelgyro.setXAccelOffset(AccGyroOffset[0]);//mpu9150 1676 -2.1904 1662 -0.5152
  accelgyro.setYAccelOffset(AccGyroOffset[1]);//mpu9150 204 0.731375 179 -0.3275
  accelgyro.setZAccelOffset(AccGyroOffset[2]);//mpu9150 1355 -4.9

  accelgyro.setXGyroOffset(AccGyroOffset[3]);//mpu6050 8 -0.7864
  accelgyro.setYGyroOffset(AccGyroOffset[4]);//mpu6050 -7 0.78
  accelgyro.setZGyroOffset(AccGyroOffset[5]);//mpu6050 -23 -0.83

#if 0
  Serial.println("AccGyro offset:");
  Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -1164
  Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // 2332
  Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1202
  Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 108
  Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // -49
  Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 19
  Serial.print("\n");
#endif
}

