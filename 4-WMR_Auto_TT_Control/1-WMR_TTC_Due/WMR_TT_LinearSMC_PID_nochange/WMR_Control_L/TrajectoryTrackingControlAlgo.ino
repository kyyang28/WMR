
void RefCal() {
  vr = 0.1;
  wr = 0;
  Time += tt;
}

void WMRParaIni() {
  eta[0] = 10;
  eta[1] = 10;
  eps[0] = 0.01;
  eps[1] = 0.1;
}

float eR = 0;
float eL = 0;
float deR, deL;
float edp;

void TrajectoryTrackingAlgo()
{
  /* omege_R = v / r + w*b / r = 2*pi / 32 * wheelR */
  const static float v_constant = 32.0 / 0.06 / PI;
  const static float w_constant = 23 / 6 / PI * 16.0;
  //const static float v_constant = 32.0 / 0.063 / PI;
  //const static float w_constant = 22.5 / 6.3 / PI * 16.0;
  float dp;

  float cpSqrt, s2;

  RefCal();

  /* Convert to radian */
  w_enL = float(leftMotorEncoderCnt) * PI / 16;
  w_enR = float(rightMotorEncoderCnt) * PI / 16;
  //w_enL = float(leftMotorEncoderCnt) * 2*PI / 32;
  //w_enR = float(rightMotorEncoderCnt) * 2*PI / 32;

  v_WMR = (w_enL + w_enR) * 0.06 / 4;   // why divide 4?
  //v_WMR = (w_enL + w_enR) * 0.063 / 4;
  //w_WMR = (w_enR - w_enL) * 0.063 / 0.2;

  dTheta = -float(gz.num) * gRes;
  if (abs(dTheta) < 0.01 ) {
    dTheta = 0;
  }

  /* For Motor testking */
  //uctrl[0] = vr;
  //uctrl[1] = wr;

  qc.x += v_WMR * cos(qc.z) * tt;
  qc.y += v_WMR * sin(qc.z) * tt;
  qc.z += dTheta * tt;

  if (qc.z > 2 * PI) {
    qc.z -= 2 * PI;
  } else if (qc.z <= 0) {
    qc.z += 2 * PI;
  }

  qr.x += vr * cos(qr.z) * tt;
  qr.y += vr * sin(qr.z) * tt;
  qr.z += wr * tt;

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

  /* wheelR = w_R, wheelL = w_L */
  wheelR = uctrl[0] * v_constant + uctrl[1] * w_constant;
  wheelL = uctrl[0] * v_constant - uctrl[1] * w_constant;

  if (wheelR > MOTORMAX)
    wheelR = MOTORMAX;
  else if (wheelR < -MOTORMAX)
    wheelR = -MOTORMAX;

  if (wheelL > MOTORMAX)
    wheelL = MOTORMAX;
  else if (wheelL < -MOTORMAX)
    wheelL = -MOTORMAX;

  edp = eR;
  eR = wheelR - float(rightMotorEncoderCnt);
  deR = eR - edp;
  edp = eL;
  eL = wheelL - float(leftMotorEncoderCnt);
  deL = eL - edp;

  upid[0] = wheelR * 10 + (wheelR - float(rightMotorEncoderCnt)) * 12;
  upid[1] = wheelL * 10 + (wheelL - float(leftMotorEncoderCnt)) * 12;

#if 0  
  ki[0] += (eR + deR) / (abs(eR + deR) + 1) * 5;
  ki[1] += (eL + deL) / (abs(eL + deL) + 1) * 5;

  if (ki[0] > KIMAX)
    ki[0] = KIMAX;
  else if (ki[0] < -KIMAX)
    ki[0] = -KIMAX;

  if (ki[1] > KIMAX)
    ki[1] = KIMAX;
  else if (ki[1] < -KIMAX)
    ki[1] = -KIMAX;

  upid[0] += ki[0];
  upid[1] += ki[1];
#endif

  setLeftMotorSpeed(upid[0]);
  setRightMotorSpeed(upid[1]);
}















