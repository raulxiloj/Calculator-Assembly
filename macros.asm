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

;Macro para guardar el coeficiente como numero y no como ascii 
convertNumber macro var
    xor bl,bl
    mov bl, var[1]
    sub bl, 48
    mov var[1], bl
endm

convertNumber2 macro num
LOCAL isNegative, finish
    xor ax, ax
    xor bx, bx
    xor dx, dx
    mov ax, 10  

    mov bl, num[1]
    sub bl, 48
    mul bx
    mov dl, num[2]
    sub dl, 48
    add al, dl
    cmp num[0], 45
    je isNegative
    jmp finish

    isNegative:
        xor ah, ah
        neg al
    finish:
        xor cx, cx
        mov cl, num[0]
        push cx
        cleanBuffer num, SIZEOF num, 24h
        pop cx
        mov num[0],cl
        mov num[1],al
endm

checkInterval macro var
LOCAL order, finish
    ;Todo check if the length don't pass the limit
    getLength var
    cmp si, 2
    je order
    jmp finish
    
    order:
        xor bx, bx
        mov bl, var[0]
        mov bh, var[1]
        mov var[0], 43
        mov var[1], bl
        mov var[2], bh
    finish:

endm

;Macro to pass an 'int' to 'string'
convertAscii macro num,buffer
LOCAL divide,getDigits,cleanRemainder
    xor si, si      
    xor bx, bx      
    xor cx, cx      ;count digits
    mov bl, 10      ;divisor
    mov al, num
    
    cleanRemainder:
        xor ah,ah
    divide:
        div bl          ;ax = ax/cx
        inc cx          ;count digits
        push ax         ;
        cmp al, 0       ;quotient == 0? 
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

;--------------------------------------------
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
        getTexto c4
        dec cx
        checkInput c4
        push bx
        convertNumber c4
        pop bx
        jmp while 
    coefficient3:
        getTexto c3
        dec cx
        checkInput c3
        push bx
        convertNumber c3
        pop bx
        jmp while
    coefficient2:
        getTexto c2
        dec cx
        checkInput c2
        push bx
        convertNumber c2
        pop bx
        jmp while
    coefficient1:
        getTexto c1
        dec cx
        checkInput c1
        push bx
        convertNumber c1
        pop bx
        jmp while
    coefficient0:
        getTexto c0
        checkInput c0
        convertNumber c0
    finish:
endm

;macro para verificar la entrada del usuario
checkInput macro text
    checkLength text
    checkRange text
endm

checkRange macro text
LOCAL checkNumber,checkSign,checkOne,checkTwo,continue,finish
    cmp si, 1
    je checkOne
    jmp checkTwo

    checkOne:
        isNumber text[0]
        mov al, text[0]
        mov text[1],al
        mov text[0],43
        jmp finish
    checkTwo:
        ;check sign
        cmp text[0],43      ;+
        je continue     
        cmp text[0],45      ;-
        je continue
        jmp errorChar
        continue:
            isNumber text[1]
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
    je errorLength1
    cmp si, 3
    jae errorLength2
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

;---------------------PRINT FUNCTION------------------------
printFunction macro
    print fx
    printCoefficient c4,52
    printCoefficient c3,51
    printCoefficient c2,50
    printCoefficient c1,49
    printCoefficient c0,48
    print newLine
endm

printCoefficient macro coefficient,variable
LOCAL printNumber, finish
    cmp coefficient[1],0
    je finish
    printSign coefficient[0]
    ;print number
    convertAscii coefficient[1],auxCo
    print auxCo             
    printVariable variable
    finish:
endm

printSign macro char
LOCAL printPlus, printMinus, finish
    cmp char,43
    je printPlus 
    jmp printMinus 
    printPlus: 
        print plus
        jmp finish
    printMinus:
        print minus
    finish:
endm

printVariable macro num
LOCAL finish
    mov bl, num
    cmp bl, 48
    je finish
    mov varX[1],num
    print varX
    finish:
endm

;---------------------DERIVE FUNCTION------------------------
deriveFunction macro 
LOCAL coefficient4, coefficient3, coefficient2, coefficient1,while
    print fx
    xor cx, cx
    xor bl, bl
    mov cx, 4

    while:
    cmp cx, 4
    je coefficient4
    cmp cx, 3
    je coefficient3
    cmp cx, 2
    je coefficient2
    cmp cx, 1
    je coefficient1

    coefficient4:
        dec cx
        mov al, c4[1]
        mov bl, 4
        mul bl
        mov number, al
        printSign c4[0]
        push cx
        convertAscii number,deriv
        pop cx
        print deriv
        printVariable 51
        jmp while
    coefficient3:
        dec cx
        mov al, c3[1]
        mov bl, 3
        mul bl
        mov number, al
        printSign c3[0]
        push cx
        convertAscii number,deriv
        pop cx
        print deriv
        printVariable 50
        jmp while
    coefficient2:
        dec cx
        mov al, c2[1]
        mov bl, 2
        mul bl
        mov number, al
        printSign c2[0]
        push cx
        convertAscii number,deriv
        pop cx
        print deriv
        printVariable 49
        jmp while
    coefficient1:
        dec cx
        mov al, c1[1]
        mov bl, 1
        mul bl
        mov number, al
        printSign c1[0]
        push cx
        convertAscii number,deriv
        pop cx
        print deriv
        printVariable 48
        print newLine
endm

;macro para obtener los intervarlos
getRange macro
    print rangeInit
    getTexto inter1
    checkInterval inter1
    convertNumber2 inter1
    print rangeEnd
    getTexto inter2
    checkInterval inter2
    convertNumber2 inter2
endm