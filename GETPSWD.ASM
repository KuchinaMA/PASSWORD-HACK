.286
.model tiny
.code

org 100h

Start:
		mov ah, 09h
		mov dx, offset Request           ; print request to enter a password
		int 21h

		call GetLine                     ; read entered password

		call CheckPassword

		mov ax, 4c00h
		int 21h



;------------------------------------------------
; Reads one string
; Entry: dx = addres of buffer where to read string
; Exit:  dx = addres of read string, ax = string length
; Destr: ax
;------------------------------------------------
GetLine 	proc

		lea dx, Buffer
		mov ah, 0ah
		mov [Buffer], 100d               ; max string length
		int 21h
		add dx, 02d                      ; move dx to beginning of string

		mov bx, offset Buffer
		inc bx
		mov al, [bx]                     ; [Buffer+1] is length of entered string
		xor ah, ah

		ret
		endp


;------------------------------------------------
; Compares entered password to correct one,
; if password is correct prints "Allowed"
; else "Denied"
; Entry: dx = addres of string with entered password
;        ax = number of symbols in entered password
; Exit:  none
; Destr: ax, bx, cx, dx
;------------------------------------------------

CheckPassword	proc

                ;push ax                          ; number of symbols in entered password
                ;push dx                          ; addres of string with entered password

                ;mov dx, offset Password          ; addres of correct password
                ;push dx

                ;call Strcmp
                ;add sp, 06d

                ;cmp cx, 1
                ;jne IncorrectPassword

                mov cx, ax                       ; number of symbols in entered password
                push cx
                call CountHash
                pop cx
                call CountHash7
                add ax, bx                       ; count hash for entered string

                cmp ax, 245h
                jne IncorrectPassword

                mov ah, 09h
                mov dx, offset CorrectAns
                int 21h
                jmp Finish

IncorrectPassword:

                mov ah, 09h
                mov dx, offset IncorrectAns
                int 21h

Finish:         ret
                endp

;------------------------------------------------
; Compares two strings
; Entry: 1st arg = addres of first string
;        2nd arg = addres of first string
;        3rd arg = number of elements to compare
; Exit:  ax = 1 if strings are equal, 0 if not equal
; Destr: es, si, di, cx
;------------------------------------------------

;StrCmp          proc
                ;CLD

                ;push ds
                ;pop es

                ;push bp                          ; save bp
                ;mov bp, sp

                ;mov di, [bp + 4]                 ; first string
                ;mov si, [bp + 6]                 ; second string
                ;mov cx, [bp + 8]                 ; length

                ;repe cmpsb                       ; cmp ds:[SI++] to es:[DI++] | (SI - DI)

                ;jne NotEqual

                ;mov cx, 1
                ;jmp FinishCmp

;NotEqual:        mov cx, 0

;FinishCmp:     pop bp
                ;ret
                ;endp


; sum in ax

;------------------------------------------------
; Counts sum of ASCII of symbols in entered string
; Entry: none
; Exit:  ax = sum of ASCII of symbols
; Destr: di, dx
;------------------------------------------------

CountHash   	proc

            	xor ax, ax             ; sum will be in ax, so ax = 0 in the beginning

            	mov di, offset Buffer
            	add di, 2
            	xor dx, dx

Count:      	mov dl, [di]
            	add ax, dx             ; add new ASCII code to sum
            	inc di                 ; to get new symbol

            	loop Count

            	ret
            	endp

; sum in bx

;------------------------------------------------
; Counts sum of ASCII of symbols (mod 7) in entered string
; and multiplies them by 8
; Entry: none
; Exit:  bx = hash sum
; Destr: di, dx
;------------------------------------------------

CountHash7  	proc

            	push ax

            	xor bx, bx             ; sum will be in bx, so bx = 0 in the beginning

            	mov di, offset Buffer
            	add di, 2
            	xor dx, dx

Count7:    	    mov dl, [di]
            	xor ax, ax             ; ax = 0
            	mov al, dl

            	mov dl, 7
            	div dl                 ; dl/7

                mov al, ah             ; dl (mod 7) in al
            	xor ah, ah
            	add bx, ax

            	inc di

            	loop Count7

            	shl bx, 3              ; bx *= 8

            	pop ax
            	ret
            	endp




Request		db 'Please enter the password: $'
Buffer		db 10, ?, 10 dup('$')
IncorrectAns	db 0ah, 'Denied$'
CorrectAns      db 0ah, 'Allowed$'
;Password    	db 'Aboba$'

end Start
