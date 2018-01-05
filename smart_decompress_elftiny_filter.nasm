;
; by pts@fazekas.hu at Fri Jan  5 21:00:25 CET 2018
; $ nasm -f bin -o smart_decompress_elftiny_filter.bin smart_decompress_elftiny_filter.nasm && ndisasm -b 32 smart_decompress_elftiny_filter.bin >smart_decompress_elftiny_filter.disasm
;

bits 32

ubufsize equ 0x5678  ; ch.ubufsize.
outp equ 0x445566  ; load_addr.
ins equ 0x1234  ; len(ch.compressed_data).
inp  equ 0x112233  ; cp_load_addr + cp_prefix_size.
filter_cto equ 0x46
unfilter_size equ 0x100
uncompressed_entry equ 0x447700  ; entry_addr.

compressed_entry:
push byte filter_cto
push dword ubufsize
; Push the old value of esp, i.e. the address of uncompressed_size.
push esp         ; &ubufsize
push dword outp  ; outp
push dword ins   ; ins
push dword inp   ; inp
; Stack: filter_cto ubufsize &ubufsize outp ins inp (<--top)
call decompress
test eax, eax
jz .decompress_ok
cli
hlt  ; Fatal error.
.decompress_ok:
; Stack: filter_cto ubufsize &ubufsize outp ins inp (<--top)
pop eax
pop eax
pop eax
pop ebx
push eax
; Stack: filter_cto ubufsize outp
call unfilter
; Stack: filter_cto ubufsize outp
pop eax
pop eax
pop eax
; For System V ABI atexit: https://stackoverflow.com/a/32967009/97248
; Page 55, section 3-29 of: http://www.sco.com/developers/devspecs/abi386-4.pdf
; Without it, the program linked against uClibc and glibc segfaults at exit.
xor edx, edx
jmp dword uncompressed_entry

signature:
db 'UPX~'

; Now comes: unfilter; decompress; inp: compressed_data.

; void unfilter(char *outp, unsigned ubufsize, unsigned filter_cto) __attribute__((regparm(0)));
unfilter:
times unfilter_size db 'U'
; int decompress(const char *inp, unsigned ins, char *outp, unsigned *ubufsizep) __attribute__((regparm(0)));
decompress:
db 'DECOMPRESS'
