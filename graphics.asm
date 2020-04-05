;---------------------GRAPHIC---------------------------------
plotFunction macro
    setGraphicMode
    drawAxis
    checkFunction 
    ;drawInterval
    ;press a key to exit
    mov ah, 10h
    int 16h
    setTextMode     ;back to text mode
endm

plotDerived macro

endm

plotIntegral macro

endm

setGraphicMode macro
    mov ax, 0013h
    int 10h
endm

setTextMode macro
    mov ax, 0003h
    int 10h
endm

;draw a pixel
drawPixel macro coorX, coorY, color
LOCAL fin
    xor si, si
    mov si, coorY
    cmp si, 0
    jl fin
    cmp si, 200
    jg fin
    pusha
    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, coorY
    mov cx, coorX
    int 10h
    popa
    fin:
endm

drawAxis macro
LOCAL eje_x, eje_y
    xor cx, cx
    mov cx, 320
    eje_x:
        drawPixel cx, 100,4fh
        loop eje_x
        mov cx, 200    
    eje_y:
        drawPixel 160, cx, 4fh
        loop eje_y
endm

checkFunction macro
LOCAL isFourthGrade, isCubic, isCuadratic, isConstant, finish
    cmp c4[1], 0
    jne isFourthGrade
    cmp c3[1], 0
    jne isCubic
    cmp c2[1], 0
    jne isCuadratic
    cmp c1[1], 0
    jne isLineal
    cmp c0[0], 0
    jne isConstant
    jmp finish

    isFourthGrade:
        fourthGrade
        jmp finish
    isCubic:
        thirdGrade
        jmp finish
    isCuadratic:
        cuadratic 
        jmp finish
    isLineal:
        lineal 
        jmp finish
    isConstant:
        constant
        jmp finish
    finish:

endm

fourthGrade macro
LOCAL while, is_negative, is_positive, continue, finish
    xor ax, ax
    xor bx, bx          
    xor cx, cx          ;cl = inter1 | ch = inter2
    mov cl, inter1[1]   
    mov ch, inter2[1]

    while:
        xor ax, ax
        mov bl, 160         ;x
        mov dl, 100         ;y (160,100) - (0,0)
        ;checkSign
        test cl,cl    
        js is_negative
        jmp is_positive
        ;---------------Axis x----------------
        is_negative:
            neg cl
            sub bl, cl      ;where x start
            ;y
            cascadaX4
            neg cl
            jmp continue
        is_positive:
            mul cl
            add bl, cl
            cascadaX4
        ;-------------Axis y-------------------
        continue:
            ;Draw
            drawPixel bx, dx, 0ch
            inc cl
            cmp cl, ch
            jg finish
            jmp while 
    finish:
endm

cascadaX4 macro
LOCAL coefficient3, coefficient2, coefficient1, coefficient0, minus4,minus3,minus2,minus1,minus, fin
    int 3
    ;Coefficient 4
    cmp cl, 10
    jg fin

    cmp c4[0], 45
    je minus4 
        ;x^4
        pushExceptAX
        xor ch, ch
        potencia 4, cx
        popExceptAx
        ;------------------c4 * x^4----------------
        push dx
        xor dx, dx
        mov dl, c4[1]
        mul dx
        pop dx
        ;-----------------scale xd-----------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;----------------real value---------------
        sub dx, ax 
        jmp coefficient3
    minus4: 
        ;------------------x^4--------------------
        pushExceptAX
        xor ch, ch
        potencia 4, cx
        popExceptAx
        ;-----------------c4 * x^4----------------
        push dx
        xor dx, dx
        mov dl, c4[1]
        mul dx
        pop dx
        ;-----------------scale xd----------------
        push cx
        mov cx, 500
        div cx
        pop cx
        ;----------------real value---------------
        add dx, ax 
    coefficient3:
        cmp c3[0],45
        je minus3
        ;----------------x^3---------------
        pushExceptAX
        xor ch, ch
        potencia 3, cx
        popExceptAx
        ;------------------c3 * x^3----------------
        push dx
        xor dx, dx
        mov dl, c3[1]
        mul dx
        pop dx
        ;-----------------scale xd-----------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;----------------real value---------------
        sub dx, ax 
        jmp coefficient2
        minus3: 
        ;------------------x^3--------------------
        pushExceptAX
        xor ch, ch
        potencia 3, cx
        popExceptAx
        ;-----------------c3 * x^3----------------
        push dx
        xor dx, dx
        mov dl, c3[1]
        mul dx
        pop dx
        ;-----------------scale xd----------------
        push cx
        mov cx, 500
        div cx
        pop cx
        ;----------------real value---------------
        add dx, ax 
    coefficient2:
        cmp c2[0],45
        je minus2
        ;----------------x^2---------------
        pushExceptAX
        xor ch, ch
        potencia 2, cx
        popExceptAx
        ;------------------c2 * x^2----------------
        push dx
        xor dx, dx
        mov dl, c2[1]
        mul dx
        pop dx
        ;-----------------scale xd-----------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;----------------real value---------------
        sub dx, ax 
        jmp coefficient1
        minus2: 
        ;------------------x^2--------------------
        pushExceptAX
        xor ch, ch
        potencia 2, cx
        popExceptAx
        ;-----------------c2 * x^2----------------
        push dx
        xor dx, dx
        mov dl, c2[1]
        mul dx
        pop dx
        ;-----------------scale xd----------------
        push cx
        mov cx, 500
        div cx
        pop cx
        ;----------------real value---------------
        add dx, ax 
    coefficient1:
        cmp c1[0],45
        je minus1
        ;----------------x^1---------------
        pushExceptAX
        xor ch, ch
        potencia 1, cx
        popExceptAx
        ;------------------c1 * x^1----------------
        push dx
        xor dx, dx
        mov dl, c1[1]
        mul dx
        pop dx
        ;-----------------scale xd-----------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;----------------real value---------------
        sub dx, ax 
        jmp coefficient0
        minus1: 
        ;------------------x^1--------------------
        pushExceptAX
        xor ch, ch
        potencia 3, cx
        popExceptAx
        ;-----------------c1 * x^1----------------
        push dx
        xor dx, dx
        mov dl, c1[1]
        mul dx
        pop dx
        ;-----------------scale xd----------------
        push cx
        mov cx, 500
        div cx
        pop cx
        ;----------------real value---------------
        add dx, ax 
    coefficient0:
        cmp c0[0], 45
        je minus
        push cx
            xor ch, ch
            mov cl, c0[1]
            sub dx, cx
        pop cx
        jmp fin
        minus:
        push cx
            xor ch, ch
            mov cl, c0[1]
            add dx, cx
        pop cx
    fin:

endm

thirdGrade macro

endm

cuadratic macro
LOCAL while, finish, is_negative, is_positive, continue
    xor ax, ax
    xor bx, bx          
    xor cx, cx          ;cl = inter1 | ch = inter2
    mov cl, inter1[1]   
    mov ch, inter2[1]

    while:
        xor ax, ax
        mov bl, 160         ;x
        mov dl, 100         ;y (160,100) - (0,0)
        ;checkSign
        test cl,cl    
        js is_negative
        jmp is_positive
        is_negative:
            neg cl
            sub bl, cl  
            pushExceptAX     
            potencia 2, cl 
            popExceptAx
            neg cl
            cascadaX2
            jmp continue
        is_positive:
            mul cl
            add bl, cl
            pushExceptAX     
            potencia 2, cl 
            popExceptAx
            ;sub dl, al
            cascadaX2
        continue:
            inc cl
            xor dh, dh
            ;check axis x
            drawPixel bx, dx, 0ch
            cmp cl, ch
            jg finish
            jmp while 
    finish:
endm

cascadaX2 macro
LOCAL plus2,minus2, plus1, minus1, continue, plus0, minus0, fin, coefficient1, coefficient0
    ;coefficient 2
    cmp c2[0],43
    je plus2
    jmp minus2
    plus2:
        mul c2[1]
        sub dl, al
        jmp coefficient0
    minus2:
        mul c2[1]
        sub dl, al
    coefficient1:
    ;coefficient 1
        xor ax, ax
        cmp c1[0],43
        je plus1
        jmp minus1
    plus1:
        mov al, c1[1]
        mul cl
        sub dl, al
        jmp coefficient0
    minus1:
        mov al, c1[1]
        mul cl
        add dl, al
    coefficient0:
    ;coefficient 0
        cmp c0[0],43
        je plus0
        jmp minus0
    plus0:
        sub dl, c0[1]
        jmp fin
    minus0:
        add dl, c0[1]
    fin:

endm

lineal macro
LOCAL while, finish, is_negative, is_positive, continue, plusN, plusP, minusN, minusP
    xor ax, ax
    xor bx, bx          ;x
    xor cx, cx          ;cl = inter1 | ch = inter2
    mov cl, inter1[1]   
    mov ch, inter2[1]
    mov dl, 100         ;y 
    mov bl, 160         ;(160,100) - (0,0)
    
    while:
        mov al, c1[1]       ;al = coeficiente
        mov dl, 100
        mov bl, 160 
        ;checkSign
        test cl, cl     
        js is_negative
        jmp is_positive
        is_negative:
            neg cl
            sub bl, cl      
            mul cl
            neg cl
            add dl, al
            ;todo check sign coefficient 0
            cmp c0[0],43
            je plusN
            jmp minusN
            plusN:
                sub dl,c0[1]
                jmp continue
            minusN:
                add dl, c0[1]
                jmp continue
        is_positive:
            mul cl
            sub dl, al
            add bl, cl
            cmp c0[0],43
            je plusP
            jmp minusP
            plusP:
                sub dl, c0[1]
                jmp continue
            minusP:
                add dl, c0[1]
        continue:
            inc cl
            xor dh, dh
            ;check axis x
            drawPixel bx, dx, 0ch
            cmp cl, ch
            jne while 
            jmp finish
    finish:

endm

constant macro
LOCAL while, temp, finish, plus, minus, continue
    xor bx, bx
    xor cx, cx   
    mov cl, inter1[1]
    mov ch, inter2[1]
    mov bl, 160     ;x
    mov dl, 100     ;y
    ;checkSign coefficient
    cmp c0[0], 43
    je plus 
    jmp minus

    plus: 
        sub dl, c0[1]
        jmp continue
    minus:
        add dl, c0[1]
    continue:
        cmp inter1[0],45
        je temp
        add bl, inter1[1]
    
    while:
        inc cl
        xor dh, dh
        drawPixel bx, dx, 0ch
        inc bl
        cmp cl, ch
        jne while 
        jmp finish
    temp:
        neg cl
        sub bl, cl
        neg cl
        jmp while
    finish:
endm

drawInterval macro
LOCAL while, temp, finish
    xor bx, bx          ;x
    xor cx, cx          ;cl = inter1  | ch = inter2
    mov cl, inter1[1]
    mov ch, inter2[1]
    mov bl, 160         ;Punto de inicio
    cmp inter1[0],45
    je temp
    add bl, inter1[1]
     
    while:
    inc cl
    drawPixel bx, 100, 0ch
    inc bl
    cmp cl, ch
    jne while 
    jmp finish
    temp:
        neg cl
        sub bl, cl
        neg cl
        jmp while
    finish:
endm