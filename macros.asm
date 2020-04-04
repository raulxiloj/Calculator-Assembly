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
        ;push cx
        ;cleanBuffer num, SIZEOF num, 24h
        ;pop cx
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
        div bl          ;ax = al/bl
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
    print msgInput1
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
    clearScreen
    print msgFunction
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
    convertAscii coefficient[1],deriv
    print deriv
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
LOCAL coefficient4, coefficient3, coefficient2, coefficient1, finish
    clearScreen
    print msgDerived
    print fx
    xor ax, ax
    xor bx, bx
    xor cx, cx
    cmp c4[1],0
    je coefficient3 
    coefficient4:
        mov al, c4[1]
        mov bl, 4
        mul bl 
        mov cl, c4[0]
        mov d3[0], cl
        mov d3[1], al
        printCoefficient d3, 51
    coefficient3:
        cmp c3[1],0
        je coefficient2
        mov al, c3[1]
        mov bl, 3
        mul bl
        mov cl, c3[0]
        mov d2[0], cl
        mov d2[1], al
        printCoefficient d2, 50
    coefficient2:
        cmp c2[1],0
        je coefficient1
        mov al, c2[1]
        mov bl, 2
        mul bl
        mov cl, c2[0]
        mov d1[0], cl
        mov d1[1], al
        printCoefficient d1, 49
    coefficient1:
        cmp c1[1],0
        je finish
        mov al, c1[1]
        mov bl, 1
        mul bl
        mov cl, c1[0]
        mov d0[0], cl
        mov d0[1], al
        printCoefficient d0, 48
    finish:
        print newLine
endm

;---------------------INTEGRATE FUNCTION------------------------
integrateFunction macro
LOCAL coefficient4, coefficient3, coefficient2, coefficient1, coefficient0, finish, fixNum4, num4, fixNum3, num3, fixNum2, num2, fixNum1, num1
    clearScreen
    print msgIntegral
    print fx

    xor ax, ax
    xor bx, bx
    xor cx, cx
    cmp c4[1],0
    je coefficient3 

    coefficient4:
        mov al, c4[1]
        mov bl, 5
        div bl 
        mov cl, c4[0]
        mov i5[0], cl
        ;
        cmp al, 0
        je fixNum4
        jmp num4
        fixNum4:
            mov cl, c4[1]
            mov i5[1], cl
            mov i5[2], 5
            printCoefficientI i5, 53
            jmp coefficient3
        num4:
            mov i5[1],al
            mov i5[2],0
            printCoefficient i5, 53
    coefficient3:
        xor ax, ax
        cmp c3[1],0
        je coefficient2
        mov al, c3[1]
        mov bl, 4
        div bl
        mov cl, c3[0]
        mov i4[0], cl
        ;
        cmp al,0
        je fixNum3
        jmp num3
        fixNum3:
            mov cl, c3[1]
            mov i4[1], cl
            mov i4[2], 4
            printCoefficientI i4, 52 
            jmp coefficient2
        num3:
            mov i4[1],al
            mov i4[2],0
            printCoefficient i4, 52
    coefficient2:
        xor ax, ax
        cmp c2[1],0
        je coefficient1
        mov al, c2[1]
        mov bl, 3
        div bl
        mov cl, c2[0]
        mov i3[0], cl
        ;
        cmp al,0
        je fixNum2
        jmp num2
        fixNum2:
            mov cl, c2[1]
            mov i3[1], cl
            mov i3[2], 3
            printCoefficientI i3, 51 
            jmp coefficient1
        num2:
            mov i3[1],al
            mov i3[2],0
            printCoefficient i3, 51 
    coefficient1:
        xor ax, ax
        cmp c1[1],0
        je coefficient0
        mov al, c1[1]
        mov bl, 2
        div bl
        mov cl, c2[0]
        mov i2[0], cl
        ;
        cmp al,0
        je fixNum1
        jmp num1
        fixNum1:
            mov cl, c1[1]
            mov i2[1], cl
            mov i2[2], 2
            printCoefficientI i2, 50
            jmp coefficient0
        num1:
            mov i2[1],al
            mov i2[2],0
            printCoefficient i2, 50
    coefficient0:
        xor ax, ax
        cmp c0[1],0
        je finish 
        mov cl, c0[0]
        mov ch, c0[1]
        mov i1[0], cl
        mov i1[1], ch
        printCoefficient i1, 49 
    finish:
        print constantI
endm

printCoefficientI macro coefficient,variable
    printSign coefficient[0]
    ;print number
    convertAscii coefficient[1],deriv
    print deriv
    print fraction
    convertAscii coefficient[2],deriv
    print deriv
    cleanBuffer deriv, SIZEOF deriv, 24h
    print space
    printVariable variable
endm

;------------------------Potencia-------------------------------
potencia macro exponente, value
LOCAL while, finish
    xor bx, bx
    mov bl, exponente
    mov ax, 1

    cmp bl, 0
    jg while
    jmp finish

    while:
        cmp bx, 1
        jl finish
        mul value
        dec bx
        jmp while
    finish:
endm

pushExceptAX macro
    push bx
    push cx
    push dx
endm

popExceptAX macro
    pop dx
    pop cx
    pop bx
endm

;macro para obtener los intervarlos
getRange macro
    print msgInput3
    getTexto inter1
    checkInterval inter1
    convertNumber2 inter1
    print msgInput4
    getTexto inter2
    checkInterval inter2
    convertNumber2 inter2
endm

clearScreen macro
    setGraphicMode
    setTextMode
endm

