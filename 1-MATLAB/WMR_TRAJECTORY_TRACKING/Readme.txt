
1. Check simulation results in folder 'RESULTS'

2. ProjectCore folders contains all the GUI files and M-files related to this project

3. Login GUI files contains the main entry program of this project

4. Testing scenarios

	Task 1. Tracking line

			Description: the WMR tracks a pre-defined line
		 Configurations: WMR initial position [x, y, theta] = [-0.2, -0.2, 1.5708]
		 				 WMR reference position [x_r, y_r, theta_r] = [0, 0, 0.7854]
		 				 WMR linear and angular reference velocities [V_r, Omega_r] = [0.2, 0.0]

	Task 2. Tracking circle

		case a: 
				Description: The WMR initial position resides inside the circle
			 Configurations: WMR initial position [x, y, theta] = [-0.25, -0.11, 1.5708]
			 				 WMR reference position [x_r, y_r, theta_r] = [0, 0, 1.5708]
			 				 WMR linear and angular reference velocities [V_r, Omega_r] = [0.2, 0.8]
			 				 The radius of circle is 0.2 / 0.8 = 0.25 m

		case b: 
				Description: The WMR initial position resides outside the circle
			 Configurations: WMR initial position [x, y, theta] = [0.25, -0.25, 1.5708]
			 				 WMR reference position [x_r, y_r, theta_r] = [0, 0, 1.5708]
							 WMR linear and angular reference velocities [V_r, Omega_r] = [0.2, 0.8]
			 				 The radius of circle is 0.2 / 0.8 = 0.25 m

5. 	To run the program, simply type Login in the MATLAB command window as follows
	
	>> Login

	The login GUI will be opened, once it is opened, input the login information as the following
		username: young
		password: 1111

6. 	The name of the bluetooth device is WMR_BT and the password to pair bluetooth of WMR with PC's bluetooth is 1234





