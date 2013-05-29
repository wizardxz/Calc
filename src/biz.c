
#define FREQUENCY 0
#define TEST 1

#define REVIEW_ERASE 0
#define REVIEW_PLAYBACK 1
#define REVIEW_ERASE_WARNING 2
#define REVIEW_RESET_PENDING 3
#define REVIEW_RESET 4

#define RED 1
#define GREEN 2


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

extern int present_tones_timer;
extern int present_tones_status;

extern int review_timer;
extern int review_status;
extern int review_warning_timer;
extern int review_warning_status;

void biz_init();


//This handler is triggered by systick every 1ms
//To make present tones LED blink
void present_tones_handler() {
	if (present_tones_timer > 0) {
		present_tones_timer -= 1;
	} else if (present_tones_timer == 0) {
		present_tones_timer = 1024/2/3; //create 3Hz event
		present_tones_status = 1 - present_tones_status;
	}
}

//This handler is triggered by systick every 1ms
//To update review state
void review_handler() {
	if (review_timer >= 0) {
		review_timer += 1;
		if (review_timer == 1024) {
			review_status = REVIEW_PLAYBACK;
		} else if (review_timer == 1024*5) {
			review_status = REVIEW_ERASE_WARNING;
			review_warning_timer = 0;
		} else if (review_timer == 1024*10) {
			review_status = REVIEW_RESET_PENDING;
		} else if (review_timer == 1024*12) {
			review_status = REVIEW_RESET;
		}
		if (review_status == REVIEW_ERASE_WARNING) {
			review_warning_timer += 1;
			if (review_warning_timer == 1024/2/(review_timer / 1024)) {
				review_warning_status = 1 - review_warning_status;
				review_warning_timer = 0;
			}
		} else if (review_status == REVIEW_RESET) {
			biz_init();
		}
		
	}
}

//Modify frequency, validate frequency
void modify_frequency(int delta) {
	int result;
	result = frequency + delta;
	if (result >= 125 && result <= 8000)
		frequency = result;
}

//Modify intensity, validate intensity
void modify_intensity(int delta) {
	int result;
	result = intensity + delta;
	if (result >= -10 && result <= 110)
		intensity = result;
}

//Switch_down event handler
void switch_down(int num) {
	if (num == 8) {//Frequency mode button SW9
		mode = FREQUENCY;
	} else if (num == 9) {//Test mode button SW10
		mode = TEST;
		present_tones_timer = 0; //Enable present_tones blink
	}
	if (mode == FREQUENCY) {
		//Frequency adjust buttons SW1-SW8
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
	} else if (mode == TEST) {
		if (num == 10) {//Review button SW11
			review_timer = 0; //Enable review
			review_status = REVIEW_ERASE;
		} else if (num == 11) {//Record button SW12
			//TODO display frequency or intensity
		}
	}
}

//Switch_up event handler
void switch_up(int num) {
	if (num == 9) {
		present_tones_timer = -1; //Disable present_tones blink
	}
	if (mode == TEST) {
		if (num == 10) {
			if (review_status == REVIEW_ERASE 
			|| review_status == REVIEW_PLAYBACK 
			|| review_status == REVIEW_ERASE_WARNING)
				review_timer = -1;
			if (review_status == REVIEW_ERASE_WARNING) {
				review_status = REVIEW_ERASE;
			}
		}
	}
}


//Rotary encoder clockwise event handler
void rotary_cw() {
	modify_intensity(5);
}

//Rotary encoder counter-clockwise event handler
void rotary_ccw() {
	modify_intensity(-5);
}

//Display frequency or intensity on 4-digit display
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

//Update LED
void update_led() {
	led[0] = led[1] = led[2] = led[3] = led[4] = led[5] = 0;
	if (mode == FREQUENCY) {
		led[0] = GREEN;
	} else if (mode == TEST) {
		led[1] = GREEN;
	}
	if (present_tones_status == 1 && present_tones_timer >= 0) {
		led[5] = RED;
	}
	if (review_status == REVIEW_PLAYBACK) {
		led[2] = GREEN;
	} else if (review_status == REVIEW_ERASE_WARNING && review_warning_status == 1) {
		led[4] = RED;
	} else if (review_status == REVIEW_RESET_PENDING) {
		led[3] = RED;
	}
	
}

//Assign event to handler function
void event_init() {
	switch_down_event = &switch_down;
	switch_up_event = &switch_up;
	rotary_cw_event = &rotary_cw;
	rotary_ccw_event = &rotary_ccw;
}

//Init business logic
void biz_init() {
	frequency = 125;
	intensity = 0;
	present_tones_timer = -1;
	review_timer = -1;
	review_status = REVIEW_ERASE;
	mode = FREQUENCY;
}
