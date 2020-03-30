;--------------------------------------------------------------
;-----------------------macros generales-----------------------
;--------------------------------------------------------------

print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

;Macro para obtener texto del usuario
;param array = variable en donde se almacerana el texto 
getTexto macro array
LOCAL getCadena, finCadena
    xor si,si    
    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,24h
    mov array[si],al
endm

;Macro para limpiar un array 
;param buffer = array de bytes
;param numBytes = numero de bytes a limpiar
;para caracter = caracter con el que se va a limpiar 
cleanBuffer macro buffer,numBytes,caracter
LOCAL repeat 
    mov si,0
    mov cx,0
    mov cx,numBytes
    repeat:
    mov buffer[si],caracter
    inc si
    loop repeat
endm

;Macro para guardar un numero en base a su ascii
convertNumber macro var, number
LOCAL isNegative,isPositive,finish
    xor bl,bl
    cmp var[0], 45
    je isNegative

    isPositive:
        mov bl, var[0]
        sub bl, 48
        mov number[si], bl
        inc si
        cmp var[si],24h
        jne isPositive
        jmp finish
    isNegative:
        mov al, var
        sub al, 48
        neg al
        mov var, al
    finish:
        mov al, number
        add al, 1
        mov number, al
endm

;Macro to pass an 'int' to 'string'
convertAscii macro num,buffer
LOCAL divide,getDigits,cleanRemainder
    xor si, si      
    xor bx, bx      
    xor cx, cx      ;count digits
    mov al, num
    mov bl, 10      ;divisor
    
    cleanRemainder:
    xor ah,ah
    divide:
        div bl      ;ax = ax/cx
        inc cx      ;count digits
        push ax     ;
        cmp al, 0   ;quotient == 0? 
        je getDigits   
        jmp cleanRemainder
    getDigits:
        pop ax
        add ah,48
        mov buffer[si],ah
        inc si
        loop getDigits
        mov ah, 24h
        mov buffer[si],ah
endm

;macro para obtener los coeficientes
getCoefficients macro
    LOCAL while,coefficient4,coefficient3,coefficient2,coefficient1,coefficient0, finish
    print newLine
    xor cx, cx
    mov cx, 4
    mov bl, 53
    while:
        sub bl,1
        mov coefX[18],bl
        print coefX
        cmp cx, 4
        je coefficient4
        cmp cx, 3
        je coefficient3
        cmp cx, 2
        je coefficient2
        cmp cx, 1
        je coefficient1
        cmp cx, 0
        je coefficient0

        coefficient4:
            getTexto co4
            dec cx
            checkInput co4
            jmp while 
        coefficient3:
            getTexto co3
            dec cx
            checkInput co3
            jmp while
        coefficient2:
            getTexto co2
            dec cx
            checkInput co2
            jmp while
        coefficient1:
            getTexto co1
            dec cx
            checkInput co1
            jmp while
        coefficient0:
            getTexto co0
            checkInput co0
        finish:
            print newLine
endm

checkInput macro text
    checkLength text
    checkRange text[0],text[1]
endm

checkRange macro char1,char2
LOCAL checkNumber,checkSign,checkOne,checkTwo,continue,finish
    cmp si, 1
    je checkOne
    jmp checkTwo

    checkOne:
        isNumber char1
        jmp finish
    checkTwo:
        ;check sign
        cmp char1,43      ;+
        je continue     
        cmp char1,45      ;-
        je continue
        jmp errorChar
        continue:
            isNumber char2
    finish:
endm

isNumber macro char
LOCAL char,continue
    cmp char, 48
    jge continue
    jmp errorChar
    continue:
        cmp char, 57
        jg errorChar  
endm

checkLength macro text
LOCAL error1,error2,finish
    getLength text
    cmp si, 0
    je error1
    cmp si, 3
    jae error2
    jmp finish
    error1:
        errorLength1 text
    error2:
        errorLength2 text
    finish:
endm

getLength macro var
LOCAL while, finish
    xor si,si
    while:
        cmp var[si],24h
        je finish
        inc si
        jmp while
    finish:
endm

;Handling errors
errorLength1 macro var
    print error2
    cleanBuffer var, SIZEOF var, 24h
    jmp menuPrincipal
endm

errorLength2 macro var
    print error3
    cleanBuffer var, SIZEOF var, 24h
    jmp menuPrincipal
endm




convert macro array
LOCAL isNegative, divide, divide2, fin
    xor si, si
    xor cx, cx
    xor bx, bx
    xor dx, dx
    mov dl, 0ah
    test ax, 1000000000000000
    ;jnz isNegative
    jmp divide

    ;isNegative:
    ;    neg ax
    ;    mov array[si],45
    ;    inc si
    ;    jmp divide
    divide2:
        xor ah,ah
    divide:
        div dl
        push ax
        cmp al, 00h
        je fin
        jmp divide2
    fin:
        pop ax
        add ah, 30h
        mov buffer[si],ah
        inc si
        loop fin
        mov ah,24h
        mov buffer[si],ah
        inc si
endm