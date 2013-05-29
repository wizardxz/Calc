//#include "main.h"
//extern int review_status;
//#define REVIEW_RESET_PENDING 3

void delay(int t) {
	while (t--);
}


void main(void) {
	event_init();
	
	display_init();
	display_on();
	
	switch_init();
	switch_on();
	
	rotary_init();
	rotary_on();

	init();
	biz_init();	
	
	
	//SysTick_Config(SystemCoreClock / 1000);
	
	while (1) {


		delay(1000);
		switch_handler();
//		if (review_status == REVIEW_RESET_PENDING)
//			break;
	}
}