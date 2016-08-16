
#include <NewSoftSerial.h>

/* 声明蓝牙串口接收的引脚为数字8 */
#define BT_RXD   45

/* 声明蓝牙串口发送的引脚为数字9 */
#define BT_TXD   43

/* 声明蓝牙串口构造函数BT */
NewSoftSerial BT(BT_RXD, BT_TXD);

/* 声明串口接收的字符val */
char val;

void setup()
{
    /* 初始化Arduino串口的波特率为9600 */
    Serial.begin(9600);

    /* 初始化蓝牙串口的波特率为9600 */
    BT.begin(9600);
    
    /* 打印蓝牙串口已准备好 */
    Serial.println("HC-05 bluetooth is ready!");
}

void loop()
{
    /* 
     * 如果Arduino IDE的串口终端有数据要发送，
     * 串口read数据到val，并调用蓝牙串口的print，
     * 在蓝牙端（本例程使用的是安卓手机客户端app程序）
     * 打印出来。 
     */
    if (Serial.available()) {
        val = Serial.read();
        BT.print(val); 
    }
    
    /* 
     * 如果安卓手机的蓝牙APP程序有数据发送给
     * Arduino IDE的串口终端，那么调用蓝牙串口
     * 的read函数读出数据到val，然后调用Arduino的
     * 串口println函数打印出val的值。
     */
    if (BT.available()) {
        val = BT.read();
        Serial.print("Receive data from HC-05: ");
        Serial.println(val);
        
        /* 
         * 如果安卓手机的蓝牙APP程序发送了字符‘1’，
         * 那么打印接收到了'1'字符。
         * 如果安卓手机的蓝牙APP程序发送了字符‘2’,
         * 那么打印接收到了'2'字符
         * 注明，读者可以根据自己的实际情况，编写自定义的
         * 测试方法。
         * 注意：此测试代码使用的是安卓手机Bluetooth SPP
         *       应用程序的按键模式（Keyboard mode）发送的
         *       字符‘1’和‘2’。
         */
        if (val == '1') {
            Serial.println("Arduino has already received one");
        }else if (val == '2') {
            Serial.println("Arduino has already received two");
        }
    }
}

