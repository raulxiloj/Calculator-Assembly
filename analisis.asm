analisis macro
    openFile file2
    readFile handler, fileData, SIZEOF fileData
    closeFile handler
    lexicalAnalysis
    syntaxAnalysis
    ;toPostfix
endm

lexicalAnalysis macro 
LOCAL while, continue, finish, error
    xor si, si
    xor cx, cx

    while:
        cmp si, fileSize
        jge finish

        mov cl, fileData[si]
        ;math symbols
        cmp cl, '+'
        je continue
        cmp cl, '-'
        je continue
        cmp cl, '*'
        je continue 
        cmp cl, '/'
        je continue
        ;spaces
        cmp cl, 32
        je continue
        ;EFO (;)
        cmp cl, ';'
        je continue
        ;numbers
        cmp cl, '0'
        jl error
        cmp cl, '9'
        jg error

        continue: 
            inc si
            jmp while
        
        error:
            jmp lexicalError  

        finish:                
endm

syntaxAnalysis macro
LOCAL while, finish, continue, symbol, continue, error, space
    xor si, si
    xor ax, ax  ;flag for numbers
    xor bx, bx  ;flag for symbols
    
    while:
        cmp si, fileSize
        jge finish

        mov cl, fileData[si]
        ;Symbols
        cmp cl, '+'
        je symbol
        cmp cl, '-'
        je symbol 
        cmp cl, '*'
        je symbol
        cmp cl, '/'
        je symbol
        ;space
        cmp cl, 32
        je space
        ;EOF
        cmp cl, ';'
        je space
        ;check if numbers >= 2
        cmp ax, 2
        jge error

        inc ax
        mov bx, 0
        jmp continue

        symbol:
            cmp ax, 1
            je error
            cmp bx, 1
            je error
            mov ax, 0
            mov bx, 1 

        space:
            cmp ax, 1
            je error

        continue: 
            inc si
            jmp while

        error: 
            jmp syntaxError

        finish:
endm

toPostfix macro
LOCAL while, continue, finish, plus, minus
    mov stackPost, 0
    xor si, si
    xor cx, cx  ;sizeOf postfix string
    xor bx, bx

    while:
        cmp si, fileSize
        jge finish

        mov bl, fileData[si]
        ;space
        cmp bl, 32
        je continue
        ;symbols
        cmp bl, '+'
        je plus
        cmp bl, '-'
        je minus
        cmp bl, '*'
        je times
        cmp cl, '/'
        je divs

        ;mov num to postfix
        push si
        mov si, cx
        mov postfix[si],bl
        pop si
        inc cx
        jmp continue

        plus:
            precedencia 1, '+'
            jmp continue

        minus:
            precedencia 1, '-'
            jmp continue

        times:
            precedencia 2, '*'
            jmp continue

        divs:
            precedencia 2, '/'
            jmp continue

        continue:
            inc si
            jmp while
        
        finish:
            vaciarPila
            print newLine
            print postfix
endm

precedencia macro op, sym
LOCAL isEmpty, equal, greater, lower, finish
    int 3
    cmp stackPost, 0
    je isEmpty

    pop ax
    cmp al, op
    je equal
    cmp al, op
    jl greater
    jmp lower

    equal:;When is equal it's replaced 
        push si
        mov si, cx
        mov postfix[si], ah
        pop si

        mov al, op
        mov ah, sym
        push ax
        inc cx
        jmp finish

    greater:;When is greater it's just added to the 'stack'
        inc stackPost
        push ax
        mov al, op
        mov ah, sym
        push ax
        jmp finish
    
    lower:;When is lower it empty the stack 
        push ax
        vaciarPila

    isEmpty:
        inc stackPost
        mov al, op
        mov ah, sym
        push ax
    
    finish:
endm

vaciarPila macro
LOCAL while, finish
    while:
        cmp stackPost, 0
        je finish
        pop bx
        push si
        mov si, cx
        mov postfix[si], bh
        pop si
        inc cx
        dec stackPost
        jmp while
    finish:
endm