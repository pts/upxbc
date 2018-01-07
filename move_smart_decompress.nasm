;
; move_smart_decompress.nasm: position-independent ...
; by pts@fazekas.hu at Wed Jan  3 04:01:29 CET 2018
;
; $ nasm -f bin -o move_smart_decompress.bin move_smart_decompress.nasm && ndisasm -b 32 move_smart_decompress.bin >move_smart_decompress.disasm
;
; This code is not used by upxbc. The portions used have been copied
; over manually from *.disasm .
;

bits 32

; Assert: ubufsize >= (smart_decompress - move_smart_decompress).

ubufsize equ 0xa0
smart_decompress_size equ 0x10

; This code destroys (overwrites) many registers, and it doesn't restore them,
; so it doesn't conform to the Linux i386 ABI.
move_smart_decompress:
; Now stack: return_address
call .after_call_next
.after_call_next:
pop ebx
; Now ebx contains the address of .after_call_next.
mov ecx, dword strict smart_decompress_size  ; Patch smart_decompress_size in this.
lea esi, [ebx + ecx + smart_decompress - .after_call_next - 1]
lea edi, [dword esi + move_smart_decompress + ubufsize - smart_decompress]  ; Patch ubufsize in this.
inc ecx
std
rep movsb  ; Copy smart_decompress[:smart_decompress_size] to move_smart_decompress+ubufsize...
cld
lea eax, [ebx + move_smart_decompress - .after_call_next]  ; Output memory address of the smart_decompress call: move_smart_decompress.
push eax  ; Return address of the moved smart_decompress call.
;jmp dword strict move_smart_decompress + ubufsize  ; Relative jump, easy.
db 0xe9
dd move_smart_decompress + ubufsize - .after_final_jmp  ; % Patch ubufsize in this.
.after_final_jmp:

smart_decompress:
;db 'SMARTDECOM'

