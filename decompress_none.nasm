; by pts@fazekas.hu at Wed Jan  3 01:18:03 CET 2018
;
; Implementation of a position-independent passthrough (copying)
; decompressor for the i386 with the Linux i386 ABI.
;
; Position-independent i386 machine code for the decompress function.
; Linux i386 ABI, see http://wiki.osdev.org/System_V_ABI
; C signature: int decompress(const char *inp, unsigned ins, char *outp, unsigned *outsp) __attribute__((regparm(0)));
; Call decompress before unfilter.
; You need to know the uncompressed size first (same as the compressed size),
; put it to *outsp.
; Preallocate outp to that size.
; Pass compressed_data as inp[:ins]. Will just copy it to outp[:ins].
; Returns 0 on success. (Always if ins and *outsp are equal).
;

bits 32

decompress:
mov eax, [esp + 16]  ; outsp.
mov eax, [eax]  ; *outsp.
cmp [esp + 8], eax  ; ins == *outsp?
je .size_eq
or eax, -1  ; -1: Error.
ret
.size_eq:
push esi  ; Save non-scratch register.
push edi  ; Save non-scratch register.
mov esi, [esp + 12]  ; inp.
mov edi, [esp + 20]  ; outp.
xchg ecx, eax  ; ins to ecx.
rep movsb
pop edi
pop esi
xor eax, eax  ; 0: OK.
ret
