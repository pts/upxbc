;
; smart_decompress_none.nasm: position-independent ...
; by pts@fazekas.hu at Wed Jan  3 02:48:54 CET 2018
;
; $ nasm -f bin -o smart_decompress_none.bin smart_decompress_none.nasm && ndisasm -b 32 smart_decompress_none.bin >smart_decompress_none.disasm
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
push esi  ; Save non-scratch register.
push edi  ; Save non-scratch register.
; Now stack: return_address
call .after_call_next
.after_call_next:
xchg eax, edi  ; edi := eax.
pop esi
add esi, byte sz_unc - .after_call_next
lodsd  ; eax := *esi; esi += 4.
xchg eax, ecx  ; ecx := eax.
rep movsb
pop edi
pop esi
; No need to save or restore scratch registers eax and ecx (or edx).
ret

sz_unc:
dd compressed_data_end - compressed_data
compressed_data:
db 'COMPRESSED'
compressed_data_end:
