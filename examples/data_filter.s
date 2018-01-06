/* $ gcc -m32 -s -nostdlib -Wl,--build-id=none -o data_filter data_filter.s
 * $ upx --best -qq data_filter
 *    1031376 ->    428732   41.57%   linux/i386    data_filter
 * $ python -c 'import sys; print "filter=0x%x" % ord(sys.stdin.read()[-8 : -7])' <data_filter
 * filter=0x49
 * ... Uncomment the .section .data below.
 * $ gcc -m32 -s -nostdlib -Wl,--build-id=none -o data_filter2 data_filter.s
 * $ upx --best -qq data_filter2
 *    1031424 ->    458308   44.43%   linux/i386    data_filter2
 * $ python -c 'import sys; print "filter=0x%x" % ord(sys.stdin.read()[-8 : -7])' <data_filter2
 * filter=0x0
 * $ upx -V | head -1
 * upx 3.94
 */
.globl _start
_start:
mov $4, %eax  /* __NR_write */
xor %ebx, %ebx
inc %ebx  /* STDOUT_FILENO == 1 */
mov $msg, %ecx
mov $(msg_end - msg - 1), %edx
int $0x80
xor %eax, %eax  /* exit_code := 0 */
xor %ebx, %ebx
inc %eax  /* __NR__exit */
int $0x80
ret
.globl msg
msg:
.string "Hello, World!\n"
msg_end:
.fill 10000, 1, 1
/*.section .data*/
.incbin "/bin/sh"
