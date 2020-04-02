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

