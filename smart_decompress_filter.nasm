;
; smart_decompress_filter.nasm: position-independent ...
; by pts@fazekas.hu at Tue Jan  2 00:07:23 CET 2018
;
; $ nasm -f bin -o smart_decompress_filter.bin smart_decompress_filter.nasm && ndisasm -b 32 smart_decompress._filter.bin >smart_decompress_filter.disasm
;
; This code is not used by upxbc. The portions used have been copied
; over manually from *.disasm .
;

bits 32

; void smart_decompress(char *outp) __attribute__((regparm(3)));
; How to call:
;   mov eax, outp  ; Output buffer of size uncompressed data size (sz_unc).
;   call smart_decompress

cto8 equ 0xb

smart_decompress_filter:
; Now stack: return_address
call .after_call_next
.after_call_next:
xchg eax, edx  ; We use it for: eax := edx.
pop eax
; Now eax is the address of .after_call_next.
push byte cto8
; Now stack (bottom with high address first): return_address cto8
add eax, dword strict sz_unc - .after_call_next  ; Patch this.
push eax  ; &outs
; Now stack: return_address cto8 &outs
push edx  ; outp
; Now stack: return_address cto8 &outs outp
push dword strict compressed_data_end - compressed_data
; Now stack: return_address cto8 &outs outp compressed_data_size
add eax, 4  ; Skip over ubufsize_internal (no uncompressed_data_size).
push eax  ; dword compressed_data
; Now stack: return_address cto8 &outs outp compressed_data_size compressed_data
call decompress  ; Patch this.
test eax, eax
jz .decompress_ok
cli
hlt  ; Fatal error.
.decompress_ok:
pop eax
pop eax
; Now stack: return_address cto8 &outs outp
pop eax
pop edx
push dword [edx]
push eax
call lxunfilter  ; Patch this, in case ret_code has changed size.
pop eax
pop eax
pop eax
ret  ; May be replaced with arbitrary ret_code.

signature:
db 'UPX~'

lxunfilter:
db 'LXUNFILTER'
decompress:
db 'DECOMPRESS'

sz_unc:
dd 42  ; Patch this.
compressed_data:
db 'COMPRESSED'
compressed_data_end:
