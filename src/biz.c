
#define FREQUENCY 0
#define TEST 1

extern int number[4];
extern int led[6]; //off 0, red 1, green 2
extern int number_start;
extern int led_start;
extern void (*switch_down_event)(int);
extern void (*switch_up_event)(int);
extern void (*rotary_cw_event)();
extern void (*rotary_ccw_event)();
extern int button_state[12], prev_button_state[12];
int mode;
int frequency;
int intensity;


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

void modify_intensity(int delta) {
	int result;
	result = intensity + delta;
	if (result >= -10 && result <= 110)
		intensity = result;
}

void rotary_cw() {
	modify_intensity(5);
}

void rotary_ccw() {
	modify_intensity(-5);
}

void update_number() {
	if (mode == FREQUENCY) {
		number[0] = 48 + frequency / 1000;
		number[1] = 48 + frequency / 100 % 10;
		number[2] = 48 + frequency / 10 % 10;
		number[3] = 48 + frequency % 10;
	} else if (mode == TEST) {
		int abs_value;
		char sign;
		int i, j;
		if (intensity < 0) {
			sign = '-';
			abs_value = -intensity;
		} else {
			sign = 0;
			abs_value = intensity;
		}
		for (i = 0; i < 4; i++) {
			if (abs_value == 0 && i > 0) {
				number[3 - i] = sign;
				for (j = i + 1; j < 4; j++) {
					number[3 - j] = 0;
				}
				break;
			}
			number[3 - i] = 48 + abs_value % 10;
			abs_value /= 10;
		}
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

void biz_init() {
	frequency = 125;
	intensity = 0;
	mode = FREQUENCY;
	
	switch_down_event = &switch_down;
	switch_up_event = &switch_up;
	rotary_cw_event = &rotary_cw;
	rotary_ccw_event = &rotary_ccw;
}
