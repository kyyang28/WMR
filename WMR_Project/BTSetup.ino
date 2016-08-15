void BTSetup(){
  
  Serial3.begin(115200);
  Serial.println("Test BT connection, send a from device to continue...");
  char a='b';
  #ifdef BT_BINARY
  Serial3.print('a');
  #else
  Serial3.println("Test BT connection, send 'a' to continue...");
  #endif
  int i=0;
  bool FAT_LED=true;
  while(a!='a')
    {
      a=Serial3.read();
      i++;
      if(i>100){
        i=0;
        FAT_LED=!FAT_LED;       
      }
    }
}

void BTStart(){  
  char a='b';  
  Serial.println("Connection is successful, please send a to start the program");
  #ifdef BT_BINARY
  Serial3.print('a');
  #else
  Serial3.println("Test BT connection, send 'a' to continue...");
  #endif 
    while(a!='a')
    {
      a=Serial3.read();
    }
}
