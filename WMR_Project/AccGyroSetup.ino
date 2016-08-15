
void AccGyroSetup() {
  bool FAT_STATS = true;
  const int AccGyroOffset[6] = {485, 236, 1646, 72, 27, 0};
  // join I2C bus (I2Cdev library doesn't do this automatically)
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
  Wire.setClock(400000);
  Wire.begin();
#elif I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE1
  Wire1.setClock(400000);
  Wire1.begin();
#endif
  digitalWrite(LED_PING, true);
  digitalWrite(LED_PINY, false);
  digitalWrite(LED_PINR, false);
  Serial.println("Initializing accgyro device.");
#ifdef BT_DEBUG
  Serial3.println("Initializing accgyro device.");
#endif
  accelgyro.initialize();
  //accelgyro.setRate(MPU6050_GYRO_DATA_RATE_5);
  Serial.println("Testing device connections...");
#ifdef BT_DEBUG
  Serial3.println("Testing device connections...");
#endif
  bool FAT_Net = accelgyro.testConnection();
  Serial.println(FAT_Net ? "MPU6050 connection successful" : "MPU6050 connection failed");
#ifdef BT_DEBUG
  Serial3.println(FAT_Net ? "MPU6050 connection successful" : "MPU6050 connection failed");
#endif
  if (!FAT_Net)
  {
    Serial.println("Please reset the Arduino or MPU9150");
#ifdef BT_DEBUG
    Serial3.println("Please reset the Arduino or MPU9150");
#endif
    while (FAT_Net) {
      digitalWrite(LED_PING, FAT_STATS);
      digitalWrite(LED_PINY, FAT_STATS);
      digitalWrite(LED_PINR, FAT_STATS);
      FAT_STATS = !FAT_STATS;
      delay(500);
    }
  }
  accelgyro.setXAccelOffset(AccGyroOffset[0]);//mpu9150 1676 -2.1904 1662 -0.5152
  accelgyro.setYAccelOffset(AccGyroOffset[1]);//mpu9150 204 0.731375 179 -0.3275
  accelgyro.setZAccelOffset(AccGyroOffset[2]);//mpu9150 1355 -4.9

  accelgyro.setXGyroOffset(AccGyroOffset[3]);//mpu6050 8 -0.7864
  accelgyro.setYGyroOffset(AccGyroOffset[4]);//mpu6050 -7 0.78
  accelgyro.setZGyroOffset(AccGyroOffset[5]);//mpu6050 -23 -0.83

  Serial.println("AccGyro offset:");
  Serial.print(accelgyro.getXAccelOffset()); Serial.print("\t"); // -1164
  Serial.print(accelgyro.getYAccelOffset()); Serial.print("\t"); // 2332
  Serial.print(accelgyro.getZAccelOffset()); Serial.print("\t"); // 1202
  Serial.print(accelgyro.getXGyroOffset()); Serial.print("\t"); // 108
  Serial.print(accelgyro.getYGyroOffset()); Serial.print("\t"); // -49
  Serial.print(accelgyro.getZGyroOffset()); Serial.print("\t"); // 19
  Serial.print("\n");
  Serial.println("AccGyro setup finished.");

#ifdef BT_DEBUG
  Serial3.println("AccGyro offset:");
  Serial3.print(accelgyro.getXAccelOffset()); Serial3.print("\t"); // -1164
  Serial3.print(accelgyro.getYAccelOffset()); Serial3.print("\t"); // 2332
  Serial3.print(accelgyro.getZAccelOffset()); Serial3.print("\t"); // 1202
  Serial3.print(accelgyro.getXGyroOffset()); Serial3.print("\t"); // 108
  Serial3.print(accelgyro.getYGyroOffset()); Serial3.print("\t"); // -49
  Serial3.println(accelgyro.getZGyroOffset()); // 19
  Serial3.println("AccGyro setup finished.");
#endif
}

