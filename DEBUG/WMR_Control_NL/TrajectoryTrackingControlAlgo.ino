
/* v_param = 1920 / 100(time) / diameter of wheel(0.12m) / pi
   w_param = 1920 / 100(time) * distanceOfTwoWheels / 2.0 / PI / diameterOfWheel
              = 19.2 * d / (2 *pi * (2 * R))
*/
const static float v_param = 19.2 / 0.12 / PI;
const static float w_param = 19.2 * 23.0 / 2.0 / PI / 12.0;

int K1 = 1;
int K2 = 1;
int K3 = 1;

void TrajectoryTrackingAlgo()
{
  /* Convert to radian */
  ConvertEncoderVal2Radian(leftMotorEncoderCnt, rightMotorEncoderCnt);

  /* 0.066 is the diameter of small wheel (m)
     0.199 is the distance between two wheels (m)
  */
  CalculateLinearVelocityOfCurrWMR(w_enL, w_enR);

  /* Gyro installation is facing upward, so yawAngle is positive */
  CalculateYawAngleOfWMR();

  /* Calculate the current posture of WMR */
  CalculateCurrPostureOfWMR();

  /* Send the current posture data to MATLAB program via Bluetooth */
  SendRTPostureDataToMATLAB();

  /* Calculate the reference posture of WMR */
  CalculateRefPostureOfWMR();

  /* Calculate the errors between the current posture
     and reference posture
  */
  CalculatePostureOfTrackingErrorSys();

  /*  Apply sliding mode algorithm with nonlinear component
      and discontinuous switching part
  */
  ApplyNLSlidingModeAlgorithm();

  /* w_R = w_R, w_L = w_L */
  /* See dissertation notes equation 24 */
  CalculateAngularVelocities();

  /* Set speed boundary for both left and right motors */
  SetMotorSpeedBounds();

  /* Apply PID algorithm to adjust the left and right motors */
  ApplyPIDAlgorithms();

  /* Set up motors speed */
  SetupMotorsSpeed();
}

/* Helper functions for trajectory tracking control algorithm */
/* Config the reference linear and angular velocities */
void ConfigRefParams()
{
  vr = vrVal;
  wr = wrVal;
}

/* Config parameters of sliding mode algorithm */
void ConfigSMCParams()
{
  eta[0] = 1;
  eta[1] = 4;
  eps[0] = 0.1;
  eps[1] = 0.5;
}

/* Convert encoder value to radian */
static void ConvertEncoderVal2Radian(int leftCnt, int rightCnt)
{
  w_enL = float(leftCnt) * PI / 9.6;
  w_enR = float(rightCnt) * PI / 9.6;
}

/* Calculate linear and angular velocities of current WMR */
static void CalculateLinearVelocityOfCurrWMR(float leftEncVal, float rightEncVal)
{
  v_WMR = (leftEncVal + rightEncVal) * 0.12 / 4;
  w_WMR = (rightEncVal - leftEncVal) * 0.12 / 0.23;
}

/* Calculate the heading angle of WMR */
static void CalculateYawAngleOfWMR()
{
  yawAngle = float(gz.num) * gRes;

  if (abs(yawAngle) < 0.01 ) {
    yawAngle = 0;
  }
}

/* Calculate the current posture of WMR */
static void CalculateCurrPostureOfWMR()
{
  qc.x += v_WMR * cos(qc.z) * tt;
  qc.y += v_WMR * sin(qc.z) * tt;
  qc.z += yawAngle * tt;

  if (qc.z > 2 * PI) {
    qc.z -= 2 * PI;
  } else if (qc.z <= 0) {
    qc.z += 2 * PI;
  }
}

/* Send the real-time posture data of WMR to MATLAB */
static void SendRTPostureDataToMATLAB()
{
#if BT_DEBUG
  Serial3.println(qc.x);
  Serial3.println(qc.y);
#endif
}

/* Calculate the reference posture of WMR */
static void CalculateRefPostureOfWMR()
{
  qr.x += vr * cos(qr.z) * tt;
  qr.y += vr * sin(qr.z) * tt;
  qr.z += wr * tt;

  /* Saturation */
  if (qr.z > 2 * PI) {
    qr.z -= 2 * PI;
  } else if (qr.z <= 0) {
    qr.z += 2 * PI;
  }
}

/* Calculate the posture of tracking error system */
static void CalculatePostureOfTrackingErrorSys()
{
  xe.x = (qr.x - qc.x) * cos(qc.z) + (qr.y - qc.y) * sin(qc.z);
  xe.y = -(qr.x - qc.x) * sin(qc.z) + (qr.y - qc.y) * cos(qc.z);
  xe.z = (qr.z - qc.z);

  /*  yaw angle saturation */
  if (xe.z > PI) {
    xe.z -= 2 * PI;
  } else if (xe.z <= -PI) {
    xe.z += 2 * PI;
  }
}

/* Apply sliding mode algorithm with nonlinear component */
static void ApplyNLSlidingModeAlgorithm()
{
  /* matrix G */
  //matG[0][0] = -K1;
  //matG[0][1] = K1 * xe.y;
  //matG[1][0] = 0;
  //matG[1][1] = -K2 - K3 * xe.x / (1 + xe.y * xe.y);

  /* Temperary variable */
  tmpParam = 1 + xe.y * xe.y;

  /* Calculate the inverted matrix G */
  invMatG[0][0] = -K2 * tmpParam - K3 * xe.x;
  invMatG[0][1] = -K1 * xe.y * tmpParam / (K1 * K2 * tmpParam + K1 * K3 * xe.x);
  invMatG[1][0] = 0;
  invMatG[1][1] = -tmpParam / (K2 * tmpParam + K3 * xe.x);

  /* Second sliding surface */
  matFParam = K2 * xe.z + K3 * atan(xe.y);

  /* Applying hyperbolic tangent function */
  //matF[0] = K1 * vr * cos(xe.z) + eta[0] * tanh(K1 * xe.x);
  //matF[1] = (K3 * vr * sin(xe.z) / tmpParam) + K2 * wr + eta[1] * tanh(matFParam / 0.8);

  /* Calculate the matrix F using switching function */
  matF[0] = K1 * vr * cos(xe.z) + (eta[0] * K1 * xe.x) / (abs(K1 * xe.x) + eps[0]);
  matF[1] = (K3 * vr * sin(xe.z) / tmpParam) + K2 * wr + eta[1] * (matFParam / (abs(matFParam) + eps[1]));

  /* Derive the control laws */
  for (int ic = 0; ic < 2; ic++) {
    u_input[ic] = -(invMatG[ic][0] * matF[0] + invMatG[ic][1] * matF[1]);
  }
}

/* Calculate angular velocities of left and right motors */
static void CalculateAngularVelocities()
{
  w_L = u_input[0] * v_param - u_input[1] * w_param;
  w_R = u_input[0] * v_param + u_input[1] * w_param;
}

/* Set angular speeds limit to left and right motors */
static void SetMotorSpeedBounds()
{
  BoundFunc(&w_R, boundMotor);
  BoundFunc(&w_L, boundMotor);
}

/* Apply PID algorightms to left and right motors */
static void ApplyPIDAlgorithms()
{
  leftMotorSpeed = LeftMotorSpeedPIDController(leftMotorEncoderCnt, w_L);
  rightMotorSpeed = RightMotorSpeedPIDController(rightMotorEncoderCnt, w_R);
}

/* Set left and right motor speeds */
static void SetupMotorsSpeed()
{
  setLeftMotorSpeed(leftMotorSpeed);
  setRightMotorSpeed(rightMotorSpeed);
}

