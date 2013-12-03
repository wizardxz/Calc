#include "calc.h"

void init_ulong(BN_ULong *ul) {
	ul->length = 0;
}

void init_long(BN_Long *l) {
   l->sign = 1;
   init_ulong(&(l->ul));
}

void copy_ulong(BN_ULong *dest, BN_ULong *src) {
	int i;
	dest->length = src->length;
	for (i = 0; i < dest->length; i++) {
		dest->data[i] = src->data[i];
	}
}

void copy_long(BN_Long *dest, BN_Long *src) {
	dest->sign = src->sign;
	copy_ulong(&dest->ul, &src->ul);
}


void add_ulong(BN_ULong *a, BN_ULong *b, BN_ULong *r) {
	char data[MAXLENGTH];
	int ia = a->length - 1;
	int ib = b->length - 1;
	int ir = 0;
	int v = 0, c = 0;
	while (ia >= 0 || ib >= 0 || c != 0) {
		v = c;
		if (ia >= 0) v += a->data[ia];
		if (ib >= 0) v += b->data[ib];
		if (ir < MAXLENGTH) {
			data[ir++] = v % 10;
		} else {
			//TODO: overflow
		}
		c = v / 10;
		ia--;
		ib--;
	}
	r->length = ir;
	// reverse
	for (ir = 0; ir < r->length; ir++) {
		r->data[ir] = data[r->length - 1 - ir];
	}

}

void sub_ulong(BN_ULong *a, BN_ULong *b, BN_ULong *r) {
	//a must be bigger than b
	char data[MAXLENGTH];
	int ia = a->length - 1;
	int ib = b->length - 1;
	int ir = 0;
	int v = 0, c = 0;
	while (ia >= 0 || ib >= 0) {
		v = c;
		if (ia >= 0) v += a->data[ia];
		if (ib >= 0) v -= b->data[ib];
		if (v < 0) {
			v += 10;
			c = -1;
		} else {
			c = 0;
		}
		data[ir++] = v;
		ia--;
		ib--;
	}
	while (ir > 0) {
		if (data[ir - 1] == 0) {
			ir--;
		} else {
			break;
		}
	}
	r->length = ir;
	// reverse
	for (ir = 0; ir < r->length; ir++) {
		r->data[ir] = data[r->length - 1 - ir];
	}
	if (r->length == 0) {
		r->length = 1;
		r->data[0] = 0;
	}
}

int cmp_ulong(BN_ULong *a, BN_ULong *b) {
	int i;
    if (a->length > b->length) return 1;
    else if (a->length < b->length) return -1;
    else {
        for (i = 0; i < a->length; i++) {
            if (a->data[i] > b->data[i]) return 1;
            else if (a->data[i] < b->data[i]) return -1;
        }
        return 0;
    }
}

void mul_ulong(BN_ULong *a, BN_ULong *b, BN_ULong *r) {
    int i, j, h;
    int v, c = 0;
    h = 0;
    int data[MAXLENGTH];
    while (1) {
        v = c;
        for (i = 0; i < a->length; i++) {
            j = h - i;
            if (j >= 0 && j < b->length) {
                v += a->data[a->length - 1 - i] * b->data[b->length - 1 - j] ;
            }
        }
        if (v == 0 && h > a->length - 1 && h > b->length - 1) break;
        data[h] = v % 10;
        c = v / 10;
        h++;
    }
 
    r->length = h;
    // reverse
    for (i = 0; i < r->length; i++) {
        r->data[i] = data[r->length - 1 - i];
    }
}

void lshift_ulong(BN_ULong *a, int num) {
    int i;
    for (i = 0; i < num; i++) {
        a->data[i + a->length] = 0;
    }
    a->length += num;
}

int div_ulong(BN_ULong *a, BN_ULong *b, BN_ULong *r) {
    int i;
    BN_ULong c, acopy;
    int data[MAXLENGTH];
    int h = a->length - b->length;
    int max = 0;
 
    if (b->length == 1 && b->data[0] == 0) return 1;
	copy_ulong(&acopy, a);
    a = &acopy;
    for (i = 0; i <= h; i++) {
        data[i] = 0;
    }
    while (1) {
        copy_ulong(&c, b);
        lshift_ulong(&c, h);
        if (cmp_ulong(&c, a) <= 0) {
            sub_ulong(a, &c, a);
            data[h] += 1;
            if (h > max) max = h;
        } else {
            if (h == 0) {
                break;
            } else {
                h -= 1;
            }
        }
    }
    r->length = max + 1;
    // reverse
    for (i = 0; i < r->length; i++) {
        r->data[i] = data[r->length - 1 - i];
    }
	return 0;
}

void add_long(BN_Long *a, BN_Long *b, BN_Long *r) {
    if (a->sign * b->sign == 1) {
        add_ulong(&a->ul, &b->ul, &r->ul);
        r->sign = a->sign;
    } else {
        if (cmp_ulong(&a->ul, &b->ul) >= 0) {
            sub_ulong(&a->ul, &b->ul, &r->ul);
            r->sign = a->sign;
        } else {
            sub_ulong(&b->ul, &a->ul, &r->ul);
            r->sign = b->sign;
        }
    }
}

void sub_long(BN_Long *a, BN_Long *b, BN_Long *r) {
    BN_Long bcopy;
	copy_long(&bcopy, b);
    b = &bcopy;
    b->sign *= -1;
    add_long(a, b, r);
}

void mul_long(BN_Long *a, BN_Long *b, BN_Long *r) {
    mul_ulong(&a->ul, &b->ul, &r->ul);
    r->sign = a->sign * b->sign;
}

int div_long(BN_Long *a, BN_Long *b, BN_Long *r) {
    int error = div_ulong(&a->ul, &b->ul, &r->ul);
    r->sign = a->sign * b->sign;
	return error;
}
