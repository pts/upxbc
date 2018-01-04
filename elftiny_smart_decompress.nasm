;
; by pts@fazekas.hu at Thu Jan  4 22:20:27 CET 2018
; $ nasm -f bin -o elftiny_smart_decompress.bin elftiny_smart_decompress.nasm && ndisasm -b 32 elftiny_smart_decompress.bin >elftiny_smart_decompress.disasm
;

bits 32

load_addr equ 0x08040201
entry_addr equ 0x080402ff
mov eax, dword load_addr  ;  Patch load_addr in this.
push dword entry_addr  ; Patch entry_addr in this.

smart_decompress:
;db 'SMARTDECOM'

