////Stack_Size      EQU     0x00000200
.word 0x00000200
////Heap_Size       EQU     0x00000200
.word 0x00000200

.global __Vectors
__Vectors:                       
                .word     0//__initial_sp              // Top of Stack
                .word     Reset_Handler             // Reset        
                .word     NMI_Handler               // NMI
                .word     HardFault_Handler         // Hard Fault
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     SVC_Handler               // SVCall
                .word     0                         // Reserved
                .word     0                         // Reserved
                .word     PendSV_Handler            // PendSV
                .word     SysTick_Handler           // SysTick

                .word     PORTA_IRQHandler
                .word     PORTB_IRQHandler
                .word     PORTC_IRQHandler
                .word     PORTD_IRQHandler
                .word     DMAC_IRQHandler
                .word     TIM3_IRQHandler
                .word     UART0_IRQHandler
                .word     UART1_IRQHandler
                .word     LPUART0_IRQHandler
                .word     LPUART1_IRQHandler
                .word     SPI0_IRQHandler
                .word     SPI1_IRQHandler
                .word     I2C0_IRQHandler
                .word     I2C1_IRQHandler
                .word     TIM0_IRQHandler
                .word     TIM1_IRQHandler
                .word     TIM2_IRQHandler
                .word     LPTIM_IRQHandler
                .word     TIM4_IRQHandler
                .word     TIM5_IRQHandler
                .word     TIM6_IRQHandler
                .word     PCA_IRQHandler
                .word     WDT_IRQHandler
                .word     RTC_IRQHandler
                .word     ADC_IRQHandler
                .word     PCNT_IRQHandler
                .word     VC0_IRQHandler
                .word     VC1_IRQHandler
                .word     LVD_IRQHandler
                .word     LCD_IRQHandler
                .word     FLASH_RAM_IRQHandler
                .word     CLKTRIM_IRQHandler

                
                //IMPORT  SystemInit
                //IMPORT  __main

                //EXTERN __main

Reset_Handler:   
               //reset NVIC if in rom debug
    //            LDR     R0, =0x20000000
   //             LDR     R2, =0x0
  //              MOVS    R1, #0                 // for warning, 
 //               ADD     R1, PC,#0              // for A1609W, 
//                CMP     R1, R0
//                BLS     RAMCODE

              // ram code base address. 
//                ADD     R2, R0,R2
//RAMCODE
//              // reset Vector table address.
//                LDR     R0, =0xE000ED08 
//                STR     R2, [R0]

                //LDR     R0, =SystemInit
                BLX     R0
                //LDR     R0, =__main
                BX      R0
                bl      main



// Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler:
                ldr r0, =NMI_Handler
                bx r0
                
                
HardFault_Handler:
                ldr r0, =HardFault_Handler
                bx r0

SVC_Handler:
                ldr r0, =SVC_Handler
                bx r0

PendSV_Handler:
                ldr r0, =PendSV_Handler
                bx r0

SysTick_Handler:
                ldr r0, =SysTick_Handler
                bx r0

//__user_initial_stackheap:
                //LDR     R0, =  Heap_Mem
                //LDR     R1, =(Stack_Mem + Stack_Size)
                //LDR     R2, = (Heap_Mem +  Heap_Size)
                //LDR     R3, = Stack_Mem
                //BX      LR
