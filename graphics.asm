;-------------------------------MACROS GRAPHICS---------------------------------

setGraphicMode macro
    mov ax, 0013h
    int 10h
endm

setTextMode macro
    mov ax, 0003h
    int 10h
endm

pressKey macro
    mov ah, 10h
    int 16h
endm

;macro to draw a pixel in the graphic mode, (0,0) is in the top left corner
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

;macro to draw the axis x and y
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

;---------------------------------------------------------------------------------
;macro to plot the principal function
plotFunction macro
    setGraphicMode
    drawAxis
    checkFunction 
    pressKey        ;Press a key to continue
    setTextMode     ;back to text mode
endm

;macro to plot the derived function
plotDerived macro
    setGraphicMode
    drawAxis
    checkDerived
    pressKey        ;Press a key to continue
    setTextMode     ;back to text mode
endm

;macro to plot the derived function
plotIntegral macro
    setGraphicMode
    drawAxis
    pressKey        ;Press a key to continue
    setTextMode     ;back to text mode
endm

checkFunction macro
LOCAL isFourthGrade, isCubic, isCuadratic, isLineal, isConstant, finish
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
        thirdGrade c3,c2,c1,c0
        jmp finish
    isCuadratic:
        cuadratic c2, c1, c0
        jmp finish
    isLineal:
        lineal  c1, c0
        jmp finish
    isConstant:
        constant c0
        jmp finish
    finish:

endm

checkDerived macro
LOCAL isCubic, isCuadratic, isLineal, isConstant, finish
    cmp d3[1], 0
    jne isCubic
    cmp d2[1], 0
    jne isCuadratic
    cmp d1[1], 0
    jne isLineal
    cmp d0[0], 0
    jne isConstant
    jmp finish

    isCubic:
        thirdGrade d3,d2,d1,d0
        jmp finish
    isCuadratic:
        cuadratic d2, d1, d0
        jmp finish
    isLineal:
        lineal d1, d0
        jmp finish
    isConstant:
        constant d0
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

thirdGrade macro var3, var2, var1, var0
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
            cascadaX3 0, var3, var2, var1, var0
            neg cl
            jmp continue
        is_positive:
            mul cl
            add bl, cl
            cascadaX3 1, var3, var2, var1, var0
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

cascadax3 macro signo, var3, var2, var1, var0
LOCAL fin, positive, negative, minus3,coefficient2, minus31, minus32, minus2, minus1, minus, coefficient1, coefficient0
    cmp cl, 30 
    jg fin

    push cx
    mov ch, signo
    cmp ch, 0
    je negative

    ;------------------------------------------------------------------------------------------
    ;Positive
    pop cx

    cmp var3[0],45
    je minus31
    ;----------------x^3---------------
    pushExceptAX
    xor ch, ch
    potencia 3, cx
    popExceptAx
    ;------------------c3 * x^3----------------
    push dx
    xor dx, dx
    mov dl, var3[1]
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
    minus31: 
    ;------------------x^3--------------------
    pushExceptAX
    xor ch, ch
    potencia 3, cx
    popExceptAx
    ;-----------------c3 * x^3----------------
    push dx
    xor dx, dx
    mov dl, var3[1]
    mul dx
    pop dx
    ;-----------------scale xd----------------
    push cx
    mov cx, 500
    div cx
    pop cx
    ;----------------real value---------------
    add dx, ax 
    jmp coefficient2
    ;--------------------------------------------------------------------------------------
    negative:
    pop cx

    cmp var3[0],45
    je minus32
    ;----------------x^3---------------
    pushExceptAX
    xor ch, ch
    potencia 3, cx
    popExceptAx
    ;------------------c3 * x^3----------------
    push dx
    xor dx, dx
    mov dl, var3[1]
    mul dx
    pop dx
    ;-----------------scale xd-----------------
    pushExceptAX
    xor dx, dx
    mov cx, 500
    div cx
    popExceptAx
    ;----------------real value---------------
    add dx, ax 
    jmp coefficient2
    minus32: 
    ;------------------x^3--------------------
    pushExceptAX
    xor ch, ch
    potencia 3, cx
    popExceptAx
    ;-----------------c3 * x^3----------------
    push dx
    xor dx, dx
    mov dl, var3[1]
    mul dx
    pop dx
    ;-----------------scale xd----------------
    push cx
    mov cx, 500
    div cx
    pop cx
    ;----------------real value---------------
    sub dx, ax 
    coefficient2:
        cmp var2[0],45
        je minus2
        ;----------------x^2---------------
        pushExceptAX
        xor ch, ch
        potencia 2, cx
        popExceptAx
        ;------------------c2 * x^2----------------
        push dx
        xor dx, dx
        mov dl, var2[1]
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
        mov dl, var2[1]
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
        cmp var1[0],45
        je minus1
        ;----------------x^1---------------
        pushExceptAX
        xor ch, ch
        potencia 1, cx
        popExceptAx
        ;------------------c1 * x^1----------------
        push dx
        xor dx, dx
        mov dl, var1[1]
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
        mov dl, var1[1]
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
        cmp var0[0], 45
        je minus
        push cx
            xor ch, ch
            mov cl, var0[1]
            sub dx, cx
        pop cx
        jmp fin
        minus:
        push cx
            xor ch, ch
            mov cl, var0[1]
            add dx, cx
        pop cx


    fin:
endm

cuadratic macro var2, var1, var0
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
            cascadaX2 var2, var1, var0
            neg cl
            jmp continue
        is_positive:
            mul cl
            add bl, cl
            cascadaX2 var2, var1, var0
        continue:
            ;Draw
            drawPixel bx, dx, 0ch
            inc cl
            cmp cl, ch
            jg finish
            jmp while 
    finish:
endm

cascadaX2 macro var2, var1, var0
LOCAL minus2, minus1, continue, minus0, fin, coefficient1, coefficient0
    cmp cl, 80
    jg fin
    ;------------coefficient 2---------------
    cmp var2[0],45
    je minus2
    ;Positivo
    ;---------------x^2---------------
    pushExceptAX 
    xor ch, ch
    potencia 2, cx
    popExceptAx
    ;---------------c2*x^2--------------
    push dx 
    xor dx, dx
    mov dl, var2[1]
    mul dx
    pop dx
    ;-----------------Scale xd-------------
    pushExceptAX
    xor dx, dx
    mov cx, 500
    div cx
    popExceptAx
    ;--------------real value---------------
    sub dx, ax
    jmp coefficient1
    ;Negativo
    minus2:
        ;---------------x^2---------------
        pushExceptAX 
        xor ch, ch
        potencia 2, cx
        popExceptAx
        ;---------------c2*x^2--------------
        push dx 
        xor dx, dx
        mov dl, var2[1]
        mul dx
        pop dx
        ;-----------------Scale xd-------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;--------------real value---------------
        add dx, ax
    coefficient1:
        xor ax, ax
        cmp var1[0],45
        je minus1
        ;positivo
        ;---------------x^1---------------
        pushExceptAX 
        xor ch, ch
        potencia 1, cx
        popExceptAx
        ;---------------c1*x^1--------------
        push dx 
        xor dx, dx
        mov dl, var1[1]
        mul dx
        pop dx
        ;-----------------Scale xd-------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;--------------real value---------------
        sub dx, ax
        jmp coefficient0
    minus1:
        ;---------------x^1---------------
        pushExceptAX 
        xor ch, ch
        potencia 1, cx
        popExceptAx
        ;---------------c1*x^1--------------
        push dx 
        xor dx, dx
        mov dl, var1[1]
        mul dx
        pop dx
        ;-----------------Scale xd-------------
        pushExceptAX
        xor dx, dx
        mov cx, 500
        div cx
        popExceptAx
        ;--------------real value---------------
        add dx, ax
    coefficient0:
    ;coefficient 0
    cmp var0[0],45
    je minus0
    push cx
        xor ch, ch
        mov cl, var0[1]
        sub dx, cx
    pop cx
    jmp fin
    minus0:
    push cx
        xor ch, ch
        mov cl, var0[1]
        add dx, cx
    pop cx
    fin:

endm

lineal macro var1, var0
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

constant macro var0
LOCAL while, temp, finish, plus, minus, continue
    xor bx, bx
    xor cx, cx   
    mov cl, inter1[1]
    mov ch, inter2[1]
    mov bl, 160     ;x
    mov dl, 100     ;y
    ;checkSign coefficient
    cmp var0[0], 43
    je plus 
    jmp minus

    plus: 
        sub dl, var0[1]
        jmp continue
    minus:
        add dl, var0[1]
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