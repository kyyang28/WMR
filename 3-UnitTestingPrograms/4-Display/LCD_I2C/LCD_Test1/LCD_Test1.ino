#include <Wire.h>  
#include <LiquidCrystal_I2C.h> // Using version 1.2.1
 
// The LCD constructor - address shown is 0x27 - may or may not be correct for yours
// Also based on YWRobot LCM1602 IIC V1
LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);  

void setup()
{
  lcd.begin(16,2); // sixteen characters across - 2 lines
  lcd.backlight();
  // first character - 1st line
  lcd.setCursor(0,0);
  lcd.print("Hello World!");
  // 8th character - 2nd line 
  lcd.setCursor(8,1);
  lcd.print("-------");
}
 
 
void loop()
{
}

