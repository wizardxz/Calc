/*
  Upper level functions including the event handlers, update function of digit panel and LEDs.
  They call lower level functions(get/set values from hardware) which is written in asm.
  These functions has lots of conditional branches and mod operations, which is not necessarily in asm language.
*/
#define FREQUENCY 0
#define TEST 1

void modify_frequency(int delta);
void switch_down(int num);
void switch_up(int num);
void update_number();
void update_led();

extern int number[4];
extern int led[6]; //off 0, red 1, green 2
extern int number_start;
extern int led_start;
extern void (*switch_down_event)(int);
extern void (*switch_up_event)(int);
extern int button_state[12], prev_button_state[12];
int mode;
int frequency;

void biz_init() {
	frequency = 125;
	mode = FREQUENCY;
	
	switch_down_event = &switch_down;
	switch_up_event = &switch_up;

}

void modify_frequency(int delta) {
	int result;
	result = frequency + delta;
	if (result >= 125 && result <= 8000)
		frequency = result;
}

void switch_down(int num) {
	if (num == 8) {
		mode = FREQUENCY;
	} else if (num == 9) {
		mode = TEST;
	}
	if (mode == FREQUENCY) {
		if (num == 0) {
			modify_frequency(1000);
		} else if (num == 1) {
			modify_frequency(-1000);
		} else if (num == 2) {
			modify_frequency(100);
		} else if (num == 3) {
			modify_frequency(-100);
		} else if (num == 4) {
			modify_frequency(10);
		} else if (num == 5) {
			modify_frequency(-10);
		} else if (num == 6) {
			modify_frequency(1);
		} else if (num == 7) {
			modify_frequency(-1);
		}
	}
}

void switch_up(int num) {
	
}


void update_number() {
	if (mode == FREQUENCY) {
		number[0] = frequency / 1000;
		number[1] = frequency / 100 % 10;
		number[2] = frequency / 10 % 10;
		number[3] = frequency % 10;
	} else if (mode == TEST) {
		number[0] = number[1] = number[2] = number[3] = 0;
	}
}


void update_led() {
	if (mode == FREQUENCY) {
		led[0] = 2;
		led[1] = led[2] = led[3] = led[4] = led[5] = 0;
	} else if (mode == TEST) {
		led[1] = 2;
		led[0] = led[2] = led[3] = led[4] = led[5] = 0;
	}
}
