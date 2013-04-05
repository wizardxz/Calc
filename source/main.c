
void main(void) {
	
	display_init();
	switch_init();
	systick_init();
	biz_init();
	
	
	while (1) {
		switch_handler();
	}
}