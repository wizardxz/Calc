#include <stdint.h>

//void delay() {
//	int t;
//	for (t = 0; t < 100000; t++);
//}

void main(void) {
	
	display_init();
	switch_init();
	rotary_init();
	biz_init();	
	tim_init();

	
	
	while (1) {
		switch_handler();
		//rotary_handler();
		//delay();
	}
}