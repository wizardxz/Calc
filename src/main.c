void delay(int t) {
	while (t--);
}


void main(void) {
	event_init();		//Init event handlers
	
	display_init();	
	switch_init();
	rotary_init();

	init();				//Init timer and systick
	biz_init();			//Init business logic
	
	
	while (1) {
		delay(1000);
		switch_handler();
	}
}