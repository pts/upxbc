;
; smart_decompress.nasm: position-independent ...
; by pts@fazekas.hu at Tue Jan  2 02:27:52 CET 2018
;
; $ nasm -f bin -o smart_decompress_filter.bin smart_decompress_filter.nasm && ndisasm -b 32 smart_decompress_filter.bin >smart_decompress_filter.disasm
;
; This code is not used by upxbc. The portions used have been copied
; over manually from *.disasm .
;

bits 32

; void smart_decompress(char *outp) __attribute__((regparm(3)));
; How to call:
;   mov eax, outp  ; Output buffer of size uncompressed data size (sz_unc).
;   call smart_decompress

smart_decompress:
; Now stack: return_address
call .after_call_next
.after_call_next:
xchg eax, edx  ; We use it for: eax := edx.
pop eax
; Now eax is the address of .after_call_next.
; Now stack: return_address
add eax, dword strict sz_unc - .after_call_next  ; Patch this.
push eax  ; &outs
; Now stack: return_address &outs
push edx  ; outp
; Now stack: return_address &outs outp
push dword strict compressed_data_end - compressed_data
; Now stack: return_address &outs outp compressed_data_size
add eax, 4  ; Skip over ubufsize_internal (no uncompressed_data_size).
push eax  ; dword compressed_data
; Now stack: return_address &outs outp compressed_data_size compressed_data
call decompress  ; Patch this, in case ret_code has changed size.
.after_call_decompress:
test eax, eax
jz .decompress_ok
cli
hlt  ; Fatal error.
.decompress_ok:
pop eax
pop eax
; Now stack: return_address &outs outp
pop eax
pop eax
ret  ; May be replaced with arbitrary ret_code.

signature:
db 'UPX~'

decompress:
db 'DECOMPRESS'

sz_unc:
dd 42  ; Patch this.
compressed_data:
db 'COMPRESSED'
compressed_data_end:
