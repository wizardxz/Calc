#include <stdint.h>

void delay() {
	int t;
	for (t = 0; t < 10000; t++);
}

void main(void) {
	
	biz_init();	
	display_init();
	switch_init();
	rotary_init();
	tim_init();

	
	
	while (1) {
		switch_handler();
		rotary_handler();
		delay();
	}
}