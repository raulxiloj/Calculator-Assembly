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
    pusha
    mov ah, 0ch
    mov al, color
    mov bh, 0h
    mov dx, coorY
    mov cx, coorX
    int 10h
    popa
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
    
endm

thirdGrade macro

endm

cuadratic macro

endm

lineal macro
LOCAL while, finish, is_negative, is_positive, continue, plusN, plusP, minusN, minusP
    int 3
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