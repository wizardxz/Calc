#define MAXLENGTH 100
#define DOUBLEMAXLENGTH 200
typedef struct bn_ulong_type {
   char data[MAXLENGTH];
   int length;
} BN_ULong;

typedef struct bn_long_type {
   BN_ULong ul;
   int sign;
} BN_Long;

void copy_ulong(BN_ULong *, BN_ULong *);
void copy_long(BN_Long *, BN_Long *);
