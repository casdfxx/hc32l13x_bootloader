#if 1
#include "uart.h"
#include "gpio.h"

volatile uint8_t u8TxData[2] = {0xaa,0x55};
volatile uint8_t u8RxData[2] = {0x00};
uint8_t u8TxCnt=0,u8RxCnt=0;


//UART1中断
void Uart1_IRQHandler(void)
{
    if(Uart_GetStatus(M0P_UART1, UartRC))
    {
        Uart_ClrStatus(M0P_UART1, UartRC);              //清除中断状态位
        u8RxData[u8RxCnt]=Uart_ReceiveData(M0P_UART1);  //发送数据
        u8RxCnt++;
        if(u8RxCnt>1)                                   //如果已接收两个字节
        {
            Uart_DisableIrq(M0P_UART1,UartRxIrq);       //禁止接收中断
        }
    }

    if(Uart_GetStatus(M0P_UART1, UartTC))
    {
        Uart_ClrStatus(M0P_UART1, UartTC);              //清除中断状态位
        Uart_SendDataIt(M0P_UART1, u8TxData[u8TxCnt++]);//发送数据
        if(u8TxCnt>1)                                   //如果已发送两个字节
        {
            u8TxCnt = 0;
            u8RxCnt = 0;
            Uart_DisableIrq(M0P_UART1,UartTxIrq);       //禁止发送中断
            Uart_EnableIrq(M0P_UART1,UartRxIrq);        //使能接收中断
        }
    }

}

//串口模块配置
void App_UartCfg(void)
{
    stc_uart_cfg_t  stcCfg;
    stc_uart_baud_t stcBaud;

    DDL_ZERO_STRUCT(stcCfg);
    DDL_ZERO_STRUCT(stcBaud);

    Sysctrl_SetPeripheralGate(SysctrlPeripheralUart1,TRUE); ///<使能UART1外设时钟门控开关

    ///<UART Init
    stcCfg.enRunMode        = UartMskMode3;                 ///<模式3
    stcCfg.enStopBit        = UartMsk1bit;                  ///<1bit停止位
    stcCfg.enMmdorCk        = UartMskDataOrAddr;            ///<多机模式时
    stcCfg.stcBaud.u32Baud  = 9600;                         ///<波特率9600
    stcCfg.stcBaud.enClkDiv = UartMsk8Or16Div;              ///<通道采样分频配置
    stcCfg.stcBaud.u32Pclk  = Sysctrl_GetPClkFreq();        ///</<获得外设时钟（PCLK）频率值
    Uart_Init(M0P_UART1, &stcCfg);                          ///<串口初始化

    ///<UART中断使能
    Uart_ClrStatus(M0P_UART1,UartRC);                       ///<清接收请求
    Uart_ClrStatus(M0P_UART1,UartTC);                       ///<清接收请求
    Uart_EnableIrq(M0P_UART1,UartTxIrq);                    ///<使能串口接收中断
    EnableNvic(UART1_IRQn, IrqLevel3, TRUE);              ///<系统中断使能

}

//串口引脚配置
void App_PortInit(void)
{
    stc_gpio_cfg_t stcGpioCfg;

    DDL_ZERO_STRUCT(stcGpioCfg);

    Sysctrl_SetPeripheralGate(SysctrlPeripheralGpio,TRUE);  ///<使能GPIO外设时钟门控开关

    stcGpioCfg.enDir = GpioDirOut;
    Gpio_Init(GpioPortA,GpioPin2,&stcGpioCfg);
    Gpio_SetAfMode(GpioPortA,GpioPin2,GpioAf1);             ///<配置PA02 为UART1 TX
    stcGpioCfg.enDir = GpioDirIn;
    Gpio_Init(GpioPortA,GpioPin3,&stcGpioCfg);
    Gpio_SetAfMode(GpioPortA,GpioPin3,GpioAf1);             ///<配置PA03 为UART1 RX
}

void main(){

    //UART端口初始化
    App_PortInit();

    //串口模块配置
    App_UartCfg();

    //发送地址后，触发中断，后续发送数据
    M0P_UART1->SBUF = (1<<8)|0xc0;

    while(1);
    //return;
}
#else

//#include <math.h>
#include <stdlib.h>

int getRandom(){
    return random();
}

void main(){
    int temp;
    temp    = getRandom();
    if(temp > 0){
        return;
    }

    while(1);
    return;
}
#endif
