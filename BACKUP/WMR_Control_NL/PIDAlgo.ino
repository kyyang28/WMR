
/* PID algorithm for left DC motor */
float LeftMotorSpeedPIDController(int LeftRawCnts, float LeftSpeedRef)
{
  float currError = 0;
  float LeftMotorPWM;
  static float prevError, intPart;
  //static int currError, prevError, motorPWM;

  const float Kp = 30, Ki = 5, Kd = 2.5;   // Pololu 30:1 GearMotor with 64 CPR encoder

  /* Calculate the current error */
  currError = LeftSpeedRef - LeftRawCnts;

  /* Based on incremental discrete equation of PI controller */
  intPart += Ki * currError;

  /* Set limit of integral part */
  BoundFunc(&intPart, intPartLimit);

  /* Calculate motor PWM data */
  LeftMotorPWM = Kp * currError + intPart + Kd * (currError - prevError);
  
  /* Update prevError variable to currError for next round */
  prevError = currError;

  return LeftMotorPWM;
}

/* PID algorithm for right DC motor */
float RightMotorSpeedPIDController(int RightRawCnts, float RightSpeedRef)
{
  float currError = 0;
  float RightMotorPWM;
  static float prevError, intPart;
  //static int currError, prevError, motorPWM;

  const float Kp = 30, Ki = 5, Kd = 2.5;   // Pololu 30:1 GearMotor with 64 CPR encoder

  /* Calculate the current error */
  currError = RightSpeedRef - RightRawCnts;

  /* Based on incremental discrete equation of PI controller */
  intPart += Ki * currError;

  /* Set limit of integral part */
  BoundFunc(&intPart, intPartLimit);
  
  /* Calculate motor PWM data */
  RightMotorPWM = Kp * currError + intPart + Kd * (currError - prevError);

  /* Update prevError variable to currError for next round */
  prevError = currError;

  return RightMotorPWM;
}

