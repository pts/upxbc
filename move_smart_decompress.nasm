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
stack_usage equ 0x200

; This code saves and restores all registers it modifies, including flags. For decompression uses 44 bytes of stack space (excluding its return address).
move_smart_decompress:
push eax  ; Dummy value, will be replaced by lamsd later with the return address of smart_decompress. caller_stack_usage += 4.
pushf  ; caller_stack_usage += 4.
pusha  ; caller_stack_usage += 8 * 4.
mov ebp, esp  ; Save original ESP to EBP.
; Now stack: return_address
call .after_call_next
.after_call_next:
pop eax
lea eax, [byte eax - .after_call_next + move_smart_decompress]  ; EAX := linear address of move_smart_decompress (lamsd).
mov [ebp + 9 * 4], eax  ; Overwrite the dummy return address of smart_decompress with the real one.
mov ecx, dword strict smart_decompress_size  ; Patch smart_decompress_size in this.
lea esi, [dword eax + ubufsize + stack_usage]  ; Patch ubufsize + stack_usage in this.
and esi, byte -4  ; Align to multiple of 4. The UPX LZMA decompressor requires this. Also it's faster this way.
mov esp, esi
lea esi, [byte eax + ecx + (smart_decompress - move_smart_decompress) - 1]
lea edi, [byte esp + ecx - 1]
std
rep movsb  ; Copy smart_decompress[:smart_decompress_size] to move_smart_decompress+ubufsize...
cld
; The outp argument (output buffer pointer) of the smart_decompress call below is already in EAX.
jmp esp  ; Jump to the copied smart_decompress function.

smart_decompress:
;db 'SMARTDECOM'

; Replace the `ret' at the end of smart_decompress with:

mov esp, ebp
popa  ; Doesn't pop ESP.
popf
ret

%if 0  ; Current.
00000000  50                push eax
00000001  9C                pushf
00000002  60                pusha
00000003  89E5              mov ebp,esp
00000005  E800000000        call 0xa
0000000A  58                pop eax
0000000B  8D40F6            lea eax,[eax-0xa]
0000000E  894524            mov [ebp+0x24],eax
00000011  B910000000        mov ecx,PATCH(smart_decompress_size)
00000016  8DB0A0020000      lea esi,[eax+PATCH(ubufsize + stack_usage)]
0000001C  83E6FC            and esi,byte -0x4
0000001F  89F4              mov esp,esi
00000021  8D74082E          lea esi,[eax+ecx+0x2e]
00000025  8D7C0CFF          lea edi,[esp+ecx-0x1]
00000029  FD                std
0000002A  F3A4              rep movsb
0000002C  FC                cld
0000002D  FFE4              jmp esp
0000002F  89EC              mov esp,ebp
00000031  61                popa
00000032  9D                popf
00000033  C3                ret
00000034
%endif

%if 0  ; Previous.
00000000  E800000000        call 0x5
00000005  5B                pop ebx
00000006  B910000000        mov ecx, 0x10
0000000B  8D740B1D          lea esi, [ebx+ecx+0x1d]
0000000F  8DBE7D000000      lea edi, [esi+0x7d]
00000015  41                inc ecx
00000016  FD                std
00000017  F3A4              rep movsb
00000019  FC                cld
0000001A  8D43FB            lea eax, [ebx-0x5]
0000001D  50                push eax
0000001E  E97D000000        jmp 0xa0
00000023  C3                ret
00000024
%endif

