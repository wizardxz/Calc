#include <stdint.h>

void main(void) {
	
	display_init();
	switch_init();
	biz_init();	
	tim_init();

	
	
	while (1) {
		switch_handler();
	}
}