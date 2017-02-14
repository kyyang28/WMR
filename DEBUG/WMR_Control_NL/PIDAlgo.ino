
/* PID algorithm for left DC motor */
float LeftMotorSpeedPIDController(int LeftRawCnts, float LeftSpeedRef)
{
  float currError = 0;
  float LeftMotorPWM;
  static float prevError, pprevError, intPart;
  //static int currError, prevError, motorPWM;

#if PID_ALGO
  const float Kp = 30, Ki = 5, Kd = 2.5;   // Pololu 30:1 GearMotor with 64 CPR encoder
#endif

#if PI_ALGO
  const float Kp = 100, Ki = 10;   // Pololu 30:1 GearMotor with 64 CPR encoder
#endif

  /* Calculate the current error */
  currError = LeftSpeedRef - LeftRawCnts;

#if PID_ALGO
  /* Based on incremental discrete equation of PI controller */
  intPart += Ki * currError;
#endif

  /* Set limit of integral part */
  BoundFunc(&intPart, intPartLimit);

#if PID_ALGO
  /* Calculate motor PWM data using position-type digital PID controller */
  LeftMotorPWM = Kp * currError + intPart + Kd * (currError - prevError);
#endif

#if PI_ALGO
  /* Calculate motor PWM data using increment-type digital PID controller */
  LeftMotorPWM += Kp * (currError - prevError) + Ki * currError;
#endif
  
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

