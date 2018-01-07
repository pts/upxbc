;
; smart_decompress_elftiny.nasm: position-dependent Linux i386 ELF decompressor entry point without filter
; by pts@fazekas.hu at Fri Jan  5 21:00:25 CET 2018
;
; $ nasm -f bin -o smart_decompress_elftiny.bin smart_decompress_elftiny.nasm && ndisasm -b 32 smart_decompress_elftiny.bin >smart_decompress_elftiny.disasm
;
; This code is not used by upxbc. The portions used have been copied
; over manually from *.disasm .
;

bits 32

ubufsize equ 0x5678
ins equ 0x1234  ; Compressed data size.
outp equ 0x445566
inp  equ 0x112233
unfilter_size equ 0x100
uncompressed_entry equ 0x447700

compressed_entry:
push dword ubufsize
; Push the old value of esp, i.e. the address of uncompressed_size.
push esp         ; &ubufsize
push dword outp  ; outp
push dword ins   ; ins
push dword inp   ; inp
; Stack: ubufsize &ubufsize outp ins inp (<--top)
call decompress
test eax, eax
jz .decompress_ok
cli
hlt  ; Fatal error.
.decompress_ok:
; Stack: ubufsize &ubufsize outp ins inp (<--top)
add esp, byte 5 * 4
; For System V ABI atexit: https://stackoverflow.com/a/32967009/97248
; Page 55, section 3-29 of: http://www.sco.com/developers/devspecs/abi386-4.pdf
; Without it, the program linked against uClibc and glibc segfaults at exit.
xor edx, edx
jmp dword uncompressed_entry

signature:
db 'UPX~'

; Now comes: decompress; inp: compressed_data.

; int decompress(const char *inp, unsigned ins, char *outp, unsigned *ubufsizep) __attribute__((regparm(0)));
decompress:
db 'DECOMPRESS'
