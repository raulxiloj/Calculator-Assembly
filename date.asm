;Macro para obtener el tiempo actual del sistema
getTime macro
        mov ah, 2ch    ;get the current system time
        int 21h
        ;hour
        mov al, ch      
        call convert
        mov time[8],ah
        mov time[9],al
        ;minutes
        mov al,cl
        call convert
        mov time[11],ah
        mov time[12],al
        ;seconds
        mov al, dh
        call convert
        mov time[14],ah
        mov time[15],al
endm

;Macro para obtener la fecha actual del sistema
getDate macro
    mov ah,2ah
    int 21h
    ;day
    mov al, dl 
    call convert
    mov date[8], ah
    mov date[9], al
    ;month
    mov al, dh
    call convert
    mov date[11], ah
    mov date[12], al
    ;year
    ;mov year, cx
endm 
