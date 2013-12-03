
#include "calc.h"

#define OPERAND 0
#define OPERATOR 1

#define RED 1
#define GREEN 2

extern int number[4];
extern int point[4];
extern int led[6]; //off 0, red 1, green 2
extern int number_start;
extern int led_start;
extern void (*switch_down_event)(int);
extern void (*switch_up_event)(int);
extern void (*rotary_cw_event)();
extern void (*rotary_ccw_event)();
extern int button_state[12], prev_button_state[12];
int mode;

BN_Long x, y;
char operator;
int error;
BN_Long *cur;

//View
int window;
extern int cursor_timer;
extern int cursor_status;

//This handler is triggered by systick every 1ms
//To make cursor blink
void cursor_handler() {
	if (cursor_timer > 0) {
		cursor_timer -= 1;
	} else if (cursor_timer == 0) {
		cursor_timer = 1024/2; //create 1Hz event
		cursor_status = 1 - cursor_status;
	}
}

//Calculate
void calculate() {
	if (cur == &y) {
		if (operator == '+') {
			add_long(&x, &y, &x);
		} else if (operator == '-') {
			sub_long(&x, &y, &x);
		} else if (operator == '*') {
			mul_long(&x, &y, &x);
		} else if (operator == '/') {
			error = div_long(&x, &y, &x);
		}
	}
}

//Add digit
void add_digit(int input) {
	if (cur->ul.length < MAXLENGTH - 1) {
		cur->ul.data[cur->ul.length++] = (char)input;
		window += 1;
	}
}

//Switch mode
void switch_mode() {
	if (mode == OPERAND) {
		calculate();
		window = x.ul.length - 1;
		cur = &x;
		mode = OPERATOR;
		
	} else if (mode == OPERATOR) {
		init_long(&y);
		window = 0;
		cur = &y;
		mode = OPERAND;
	}
}


//Modify operand position
void modify_window(int delta) {
	window += delta;
}

//Modify operator
void modify_operator(int dir) {
	if (dir == 1) {
		if (operator == ' ') operator = '+';
		else if (operator == '+') operator = '-';
		else if (operator == '-') operator = '*';
		else if (operator == '*') operator = '/';
		else if (operator == '/') operator = '+';
	} else if (dir == -1) {
		if (operator == ' ') operator = '/';
		else if (operator == '/') operator = '*';
		else if (operator == '*') operator = '-';
		else if (operator == '-') operator = '+';
		else if (operator == '+') operator = '/';
	}
}

//Switch_down event handler
void switch_down(int sw_idx) {
	if (mode == OPERAND) {
		if (sw_idx < 10) {
			add_digit((sw_idx + 1) % 10);
		} else if (sw_idx == 11) {
			calculate();
			window = x.ul.length - 1;
			cur = &x;
			mode = OPERAND;
			
		}
	}
	if (sw_idx == 10) {
		switch_mode();
	}
}

//Switch_up event handler
void switch_up(int sw_idx) {
}

//Rotary encoder clockwise event handler
void rotary_cw() {
	if (mode == OPERAND) {
		modify_window(1);
	} else if (mode == OPERATOR) {
		modify_operator(1);
	}
}

//Rotary encoder counter-clockwise event handler
void rotary_ccw() {
	if (mode == OPERAND) {
		modify_window(-1);
	} else if (mode == OPERATOR) {
		modify_operator(-1);
	}
}

//Display number on 4-digit display
void update_number() {
	int i;
	int current_index;
	
	for (i = 0; i < 4; i++) {
		current_index = window - (3 - i);
		if (mode == OPERAND && current_index == cur->ul.length && cursor_status == 1) {
			number[i] = 1; // cursor blinking
		} else if (current_index >= 0 && current_index < cur->ul.length) {
			number[i] = cur->ul.data[current_index] + '0';
		} else {
			number[i] = 0;
		}
	}
	point[0] = point[1] = point[2] = point[3] = 0;

}

//Update LED
void update_led() {
	led[0] = led[1] = led[2] = led[3] = led[4] = led[5] = 0;
	if (operator == '+') led[0] = (mode == OPERATOR?GREEN:RED);
	else if (operator == '-') led[3] = (mode == OPERATOR?GREEN:RED);
	else if (operator == '*') led[1] = (mode == OPERATOR?GREEN:RED);
	else if (operator == '/') led[4] = (mode == OPERATOR?GREEN:RED);
	if (cur->sign == -1) led[2] = RED;
	if (error == 1) led[5] = RED;
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
	init_long(&x);
	init_long(&y);
	cur = &x;
	window = 0;
	cursor_timer = 1;
	operator = ' ';
	error = 0;
	
	mode = OPERAND;
}

