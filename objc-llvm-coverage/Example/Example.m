#import "Example.h"

int abs(int p) {
	
	char buffer[42];
	char buffer2[sizeof(sizeof(buffer))];

    if (p < 0) {
        return -p;
    }
    return p;
}
