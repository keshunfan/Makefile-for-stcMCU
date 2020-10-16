#include "sdcc_stc8a.h"
#include "delay.h"
#include "led.h"
void main()
{
    while (1)
    {
	led_con(200 );
	sys_delayms(200);
	led_con(00 );
	sys_delayms(200);
	
    }
}
