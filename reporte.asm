createReport macro
    getDate
    getTime
    createFile repAddr, handler
    writeFile handler, header, [SIZEOF header - 1]
    writeFile handler, date, SIZEOF date
    writeFile handler, time, SIZEOF time
    writeFile handler, repMsg1, SIZEOF repMsg1 
    seekEnd handler
    ;-----------Funcion original-------------- 
    writeFile handler, repMsg2, SIZEOF repMsg2
    writeFunction      ;print function
    ;-----------Funcion derivada--------------
    writeFile handler, repMsg3, SIZEOF repMsg3
    writeDerived        ;print derived
    ;-----------Funcion integral--------------
    writeFile handler, repMsg4, SIZEOF repMsg4
    writeIntegral       ;print integral
    closeFile handler 
endm

writeFunction macro
    writeFile handler, fx, [SIZEOF fx - 1]
    seekEnd handler
    writeCoefficients 1
    writeFile handler, newLine, [SIZEOF newLine - 1]
    seekEnd handler
    writeFile handler, newLine, [SIZEOF newLine - 1]
    seekEnd handler
endm

writeDerived macro
    writeFile handler, fx, [SIZEOF fx - 1]
    writeCoefficients 2
    writeFile handler, newLine, [SIZEOF newLine - 1]
    writeFile handler, newLine, [SIZEOF newLine - 1]
endm

writeIntegral macro
    writeFile handler, fx, [SIZEOF fx - 1]
    writeCoefficients 3
    writeFile handler, newLine, [SIZEOF newLine - 1]
    writeFile handler, newLine, [SIZEOF newLine - 1]
endm

writeCoefficients macro type 
LOCAL normal, derived, integral, finish
    mov bl, type
    cmp bl, 1
    je normal
    cmp bl, 2
    je derived
    jmp integral
    normal:
        writeCoefficient c4, 52
        writeCoefficient c3, 51
        writeCoefficient c2, 50
        writeCoefficient c1, 49
        writeCoefficient c0, 48
        jmp finish
    derived:
        writeCoefficientD d3, 51
        writeCoefficientD d2, 50
        writeCoefficientD d1, 49
        writeCoefficientD d0, 48
        jmp finish
    integral:
        writeCoefficientI i5, 53
        writeCoefficientI i4, 52
        writeCoefficientI i3, 51
        writeCoefficientI i2, 50
        writeCoefficientI i1, 49
        writeFile handler, constantI, 5
    finish:
endm

writeCoefficient macro coefficient, var
LOCAL finish
    cmp coefficient[1], 0
    je finish
    writeSign coefficient[0]
    convertAscii coefficient[1],auxCo
    writeFile handler, auxCo, [SIZEOF auxCo - 1]
    writeVariable var
    finish:
endm

writeCoefficientD macro coefficient, var
LOCAL finish, print2
    cmp coefficient[1], 0
    je finish
    writeSign coefficient[0]
    convertAscii coefficient[1],deriv
    cmp coefficient[1], 9
    jg print2
    writeFile handler, deriv, 1
    jmp finish
    print2:
        writeFile handler, deriv, 2
    finish:
        writeVariable var
endm

writeCoefficientI macro coefficient, var
LOCAL possibleF, finish, normal
    mov bl, var
    cmp bl, 49
    jg possibleF 

    normal:
        writeCoefficient coefficient, var
        jmp finish

    possibleF:
        cmp coefficient[2], 0
        je normal
        writeSign coefficient[0]
        convertAscii coefficient[1],deriv
        writeFile handler, deriv, 1
        writeFile handler, fraction, 1
        convertAscii coefficient[2],deriv
        writeFile handler, deriv, 1
        cleanBuffer deriv, SIZEOF deriv, 24h
        writeFile handler, space, 1
        writeVariable var
    finish:

endm

writeSign macro char
LOCAL printPlus, printMinus, finish
    cmp char, 43
    je printPlus 
    jmp printMinus
    printPlus:
        writeFile handler, plus, [SIZEOF plus - 1]
        jmp finish
    printMinus:
        writeFile handler, minus, [SIZEOF minus - 1] 
    finish:
endm

writeVariable macro num
LOCAL finish
    mov bl, num
    cmp bl, 48
    je finish
    mov varX[1], num
    writeFile handler, varX, [SIZEOF varX - 1]
    finish:
endm