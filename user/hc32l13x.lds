SECTIONS{
    . = 0;
    .text : {
        user/startup_hc32l13x.o
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}
 
SECTIONS{
    . = 0;
    .text : {       /*写成 .text:{ 不对，要有空格。*/
        *(.text)    /*写成 *{.text} 不对，要为小括号。*/
    }
    .data : {
        *(.data)
    }
    .bss : {
        _sbss = .;         /* define a global symbol at bss start */
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);
        _ebss = .;         /* define a global symbol at bss end */
        __bss_end__ = _ebss;
        end    = .;
    }
}

