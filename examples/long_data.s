/* $ gcc -m32 -s -nostdlib -Wl,--build-id=none -o long_data long_data.s
 * $ upx --best -qq long_data
 *       10264 ->      2376   23.63%   linux/i386    long_data
 * ... Uncomment the .section .data below.
 * $ gcc -m32 -s -nostdlib -Wl,--build-id=none -o long_data2 long_data.s
 * $ upx --best -qq long_data2
 * upx: long_data: NotCompressibleException
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
/*.section .data*/
msg:
.string "Hello, World!\n"
msg_end:
.fill 10000, 1, 1
