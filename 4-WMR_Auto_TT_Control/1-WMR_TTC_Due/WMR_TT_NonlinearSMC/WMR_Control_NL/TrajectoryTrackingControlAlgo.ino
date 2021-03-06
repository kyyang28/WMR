
void RefCal() {
  vr = vrVal;
  wr = wrVal;
  //Time += tt;
}

void WMRParaIni() {
#if 1  
  eta[0] = 1;
  eta[1] = 4;   // maximum eta(2) value is 5, otherwise the car will run uncontrolled
  eps[0] = 0.1;
  eps[1] = 0.5;
#else  
  //eta[0] = 0.25;
  //eta[1] = 2;
  //eps[0] = 0.1;
  //eps[1] = 0.5;
#endif  
}

float eR = 0;
float eL = 0;
float deR, deL;
float edp;

void TrajectoryTrackingAlgo()
{
  /* v_constant = 1920 / 100(time) / diameter of wheel(0.12m) / pi
     w_constant = 1920 / 100(time) * distanceOfTwoWheels / 2.0 / PI / diameterOfWheel
                = 19.2 * d / (2 *pi * (2 * R))
  */
  //const static float v_constant = 19.2 / 0.066 / PI;
  //const static float w_constant = 19.2 * 19.9 / 2.0 / PI / 6.6; // 6.6 is the diameter of wheel
  const static float v_constant = 19.2 / 0.12 / PI;
  const static float w_constant = 19.2 * 23.0 / 2.0 / PI / 12.0;
  //const static float v_constant = 32.0 / 0.063 / PI;
  //const static float w_constant = 22.5 / 6.3 / PI * 16.0;
  float dp;

  float cpSqrt, s2;

  RefCal();

  /* Convert to radian */
  // w_enL = rawEncoderVal * 2 * PI / 19.2
  // 19.2 = 1920(30:1 Pololu DC motor gearbox encoder total value) / 100 (time);
  w_enL = float(leftMotorEncoderCnt) * PI / 9.6;
  w_enR = float(rightMotorEncoderCnt) * PI / 9.6;
  //w_enL = float(leftMotorEncoderCnt) * PI / 16;
  //w_enR = float(rightMotorEncoderCnt) * PI / 16;
  //w_enL = float(leftMotorEncoderCnt) * 2*PI / 32;
  //w_enR = float(rightMotorEncoderCnt) * 2*PI / 32;

  /* 0.066 is the diameter of small wheel (m)
     0.199 is the distance between two wheels (m)
  */
  //v_WMR = (w_enL + w_enR) * 0.066 / 4;
  v_WMR = (w_enL + w_enR) * 0.12 / 4;
  //v_WMR = (w_enL + w_enR) * 0.063 / 4;
  //w_WMR = (w_enR - w_enL) * 0.066 / 0.199;
  w_WMR = (w_enR - w_enL) * 0.12 / 0.23;

#if UART_DEBUG
  Serial.print(leftMotorEncoderCnt);
  Serial.print('\t');
  Serial.print(w_enL);
  Serial.print('\t');
  Serial.print(v_WMR);
  Serial.print('\t');
  Serial.print(w_WMR);
#endif

  /* Gyro installation is facing upward, so dTheta is positive */
  dTheta = float(gz.num) * gRes;
  if (abs(dTheta) < 0.01 ) {
    dTheta = 0;
  }

#if UART_DEBUG
  Serial.print('\t');
  Serial.print(dTheta);
#endif

  /* For Motor testking */
#if 0
  uctrl[0] = vr;
  uctrl[1] = wr;
#else
  qc.x += v_WMR * cos(qc.z) * tt;
  qc.y += v_WMR * sin(qc.z) * tt;
  qc.z += dTheta * tt;

#if UART_DEBUG
  Serial.print('\t');
  Serial.print(qc.x);
#endif

#if BT_DEBUG
  //Serial3.println('C');
  Serial3.println(qc.x);
  Serial3.println(qc.y);
#endif

  if (qc.z > 2 * PI) {
    qc.z -= 2 * PI;
  } else if (qc.z <= 0) {
    qc.z += 2 * PI;
  }

  qr.x += vr * cos(qr.z) * tt;
  qr.y += vr * sin(qr.z) * tt;
  qr.z += wr * tt;

#if UART_DEBUG
  Serial.print(qr.x);
  Serial.print('\t');
  Serial.print(qr.y);
  Serial.print('\t');
  Serial.println(qr.z);
#else
  //Serial3.println(qr.x);
  //Serial3.println(qr.y);
  //Serial.print(qr.x);
  //Serial.print('\t');
  //Serial.println(qr.y);
  //Serial.print('\t');
  //Serial.println(qr.z);
#endif

  /* Saturation */
  if (qr.z > 2 * PI) {
    qr.z -= 2 * PI;
  } else if (qr.z <= 0) {
    qr.z += 2 * PI;
  }

  /* Calculate the errors between the current posture and reference posture */
  xe.x = (qr.x - qc.x) * cos(qc.z) + (qr.y - qc.y) * sin(qc.z);
  xe.y = -(qr.x - qc.x) * sin(qc.z) + (qr.y - qc.y) * cos(qc.z);
  xe.z = (qr.z - qc.z);

  /* Saturation */
  if (xe.z > PI) {
    xe.z -= 2 * PI;
  } else if (xe.z <= -PI) {
    xe.z += 2 * PI;
  }

  dp = (1 + xe.y * xe.y + xe.x * xe.x);
  s2 = k1_n * xe.z + xe.y / sqrt(dp);
  cpSqrt = sqrt(dp * dp * dp);
  /* For inverse rho */
  //dp=xe.x*xe.x*xe.x+xe.x+cpSqrt;

  /* rho */
  //gammaG[0][0] = -1.0;
  //gammaG[0][1] = xe.y;
  //gammaG[1][0] = xe.y * cpSqrt;
  //gammaG[1][1] = -xe.y * xe.y * cpSqrt - dp;

  /* inverted rho */
  gammaG[0][0] = -1 - xe.x * xe.y * xe.y / dp;
  gammaG[0][1] = -xe.y * cpSqrt / dp;
  gammaG[1][0] = -xe.x * xe.y / dp;
  gammaG[1][1] = -cpSqrt / dp;

  gammaF[0] = vr * cos(xe.z) + eta[0] * xe.x / (abs(xe.x) + eps[0]);
  gammaF[1] = wr - (1 + xe.x * xe.x) / cpSqrt * vr * sin(xe.z) - xe.y * xe.x / cpSqrt * vr * cos(xe.z) + eta[1] * s2 / (abs(s2) + eps[1]);

  for (int ic = 0; ic < 2; ic++) {
    uctrl[ic] = -(gammaG[ic][0] * gammaF[0] + gammaG[ic][1] * gammaF[1]);
  }
#endif
  /* wheelR = w_R, wheelL = w_L */
  wheelL = uctrl[0] * v_constant - uctrl[1] * w_constant;
  wheelR = uctrl[0] * v_constant + uctrl[1] * w_constant;

  boundFun(&wheelR, boundMotor);
  boundFun(&wheelL, boundMotor);

  leftMotorSpeed = LeftMotorSpeedPIDController(leftMotorEncoderCnt, wheelL);
  rightMotorSpeed = RightMotorSpeedPIDController(rightMotorEncoderCnt, wheelR);

#if UART_DEBUG
  Serial.print('\n');
#endif

  setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);
}

