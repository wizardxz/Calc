//#include <stm32f4xx.h>


void delay(int t) {
	while (t--);
}


void main(void) {
	biz_init();	
	display_init();
	display_on();
	switch_init();
	rotary_init();
	tim_init();
	 
	while (1) {


		delay(10000);
		switch_handler();
	}
}