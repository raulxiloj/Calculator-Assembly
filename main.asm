include macros.asm
include graphics.asm
include files.asm
include analisis.asm
include reporte.asm
include date.asm
.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header       db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,"FACULTAD DE INGENIERIA",10,"CIENCIAS Y SISTEMAS",10,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,"NOMBRE: RAUL XILOJ",10,"CARNET: 201612113",10,"SECCION: A",10,'$'
options      db 10,13,"1. Ingresar funcion f(x)",10,13,"2. Funcion en memoria",10,13,"3. Derivada f(x)",10,13,"4. Integral F(x)",10,13,"5. Graficar funciones",10,13,"6. Reporte",10,13,"7. Modo calculadora",10,13,"8. Salir",10,13,10,13,"Ingrese una opcion: ",'$'
graphMenu    db 10,10,13,"1. Graficar original f(x)",10,13,"2. Graficar derivada f(x)",10,13,"3. Graficar integral F(x)",10,13,"4. Regresar",10,13,10,13,"Ingrese una opcion: ",'$'
inter1       db 5 dup ('$')
inter2       db 5 dup ('$')
auxInter     db 5 dup ('$')
coefX        db "- Coeficiente de xx: ",'$'
fx           db 10,10,"       f(x) =",'$'
plus         db " + ",'$'
minus        db " - ",'$'
fraction     db "/",'$'
varX         db "xx",'$'
space        db " ",'$'
constantI    db " + C ",10,'$'
;---------------------------------Function-----------------------------------
c4           db 5 dup ('$')
c3           db 5 dup ('$')
c2           db 5 dup ('$')
c1           db 5 dup ('$')
c0           db 5 dup ('$')
;--------------------------------Derivada-----------------------------------
d3           db 2 dup (0)
d2           db 2 dup (0)
d1           db 2 dup (0)
d0           db 2 dup (0)
;--------------------------------Integral-----------------------------------
i5           db 3 dup (0)
i4           db 3 dup (0)
i3           db 3 dup (0) 
i2           db 3 dup (0)
i1           db 3 dup (0)
;---------------------------------------------------------------------------
number       db ?
auxCo        db 0,'$'
deriv        db 3 dup ('0'),'$'
newLine      db 10,'$'
res          db 5 dup ('$')
postfix      db 1000 dup('$')
stackPost    db 0
;--------------------------------Reporte-------------------------------------
repAddr      db "c:\p5\reporte.txt",0
repMsg1      db 10,10,9,9,9,9,"Reporte practica no. 5",10,9,9,9,9,"----------------------",10,10
repMsg2      db "Funcion original:",10,"----------------"
repMsg3      db "Funcion derivada:",10,"----------------"
repMsg4      db "Funcion integral:",10,"----------------"
date         db 10,"Fecha: dd/mm/2020  "
time         db 10,"Hora:  00:00:00" 
repSuccess   db 10,"Reporte generado con exito",10,'$'
;----------------------------------Messages----------------------------------
msgInput1    db 10,"Ingrese los coeficientes:",10,10,'$' 
msgInput2    db 10,"Ingrese la ruta del archivo: ",'$'
msgInput3    db 10,10,13, "Ingrese el valor inicial del intervalo: ",'$'
msgInput4    db "Ingrese el valor final del intervalo: ",'$'
msgOp        db 10,"Operacion: ",'$'
msgRes       db 10,"Resultado: ",'$'
msgFunction  db 10,"Funcion en memoria: ",'$'
msgDerived   db 10,"Derivada de la funcion: ", '$'
msgIntegral  db 10,"Integral de la funcion: ", '$'
;-----------------------------File variables---------------------------------
file1        db 50 dup('$')    
file2        db 50 dup('$')
fileSize     dw ? 
handler      dw ? 
fileData     db 1000 dup('$')
reading      db "Leyendo el archivo...",'$'
;----------------------------Possibles errors--------------------------------
error1       db 10,13,"Error: Opcion invalida",10,13,'$'
error2       db 10,13,"Error: No se acepta caracteres vacios",10,13,'$'
error3       db 10,13,"Error: Solo se aceptan digitos entre -9 a +9",10,13,'$'
error4       db 10,13,"Error: caracter no reconocido",10,13,'$'
error5       db 10,13,"Error al abrir archivo",10,13,'$'
error7       db 10,13,"Error al escribir en el archivo",10,13,'$'
error8       db 10,13,"Error al crear el archivo",10,13,'$'
error9       db 10,13,"Error al leer el archivo",10,13,'$'
error10      db 10,13,"Error al cerrar el archivo",10,13,'$'
error11      db 10,13,"Error: caracter no reconocido en el archivo -> ",'$'
error12      db 10,13,"Error: no se esperaba ese caracter en esa posicion", 10,13,'$'
error13      db 10,13,"Error: se esperaba ; al final de la cadena",10,13,'$'
error14      db 10,13,"Error: moviendo el puntero del fichero",10,13,'$'
prueba       db 10,13,"Esto es una prueba gg",10,13,'$'
;----------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
    mov ax, @data
    mov ds,ax
    clearScreen
    print newLine
    print header
    menuPrincipal:
        print options
        getChar 
        cmp al, '1'
        je insertFunction
        cmp al, '2'
        je memoryFunction
        cmp al, '3'
        je derivative
        cmp al, '4'
        je integral
        cmp al, '5'
        je graphFunctions
        cmp al, '6'
        je report
        cmp al, '7'
        je calculator
        cmp al, '8'
        je exit
        jmp invalidOption
    insertFunction:
        clearScreen
        getCoefficients
        jmp menuPrincipal
    memoryFunction:
        printFunction
        jmp menuPrincipal
    derivative:
        deriveFunction
        jmp menuPrincipal
    integral:
        integrateFunction
        jmp menuPrincipal
    graphFunctions:
        jmp secondMenu
    report:
        clearScreen
        createReport
        print repSuccess
        jmp menuPrincipal
    calculator:
        clearScreen
        print msgInput2
        getPath file1
        fixPath
        analisis 
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    exit:
        mov ah, 4ch
        int 21h
    secondMenu:
        clearScreen
        print graphMenu
        getChar 
        cmp al, '1'
        je plot1
        cmp al, '2'
        je plot2
        cmp al, '3'
        je plot3
        cmp al, '4'
        je menuPrincipal
        print error1
        jmp secondMenu
    plot1:
        clearScreen
        getRange
        plotFunction
        jmp menuPrincipal
    plot2:
        clearScreen
        getRange
        plotDerived
        jmp menuPrincipal
    plot3:
        clearScreen
        getRange
        plotIntegral
        jmp menuPrincipal
    invalidOption:
        print error1
        jmp menuPrincipal
    errorChar: 
        print error4
        jmp menuPrincipal
    errorLength1:
        print error2
        cleanBuffer c4, SIZEOF c4, 24h
        cleanBuffer c3, SIZEOF c3, 24h
        cleanBuffer c2, SIZEOF c2, 24h
        cleanBuffer c1, SIZEOF c1, 24h
        cleanBuffer c0, SIZEOF c0, 24h
        jmp menuPrincipal
    errorLength2:
        print error3
        cleanBuffer c4, SIZEOF c4, 24h
        cleanBuffer c3, SIZEOF c3, 24h
        cleanBuffer c2, SIZEOF c2, 24h
        cleanBuffer c1, SIZEOF c1, 24h
        cleanBuffer c0, SIZEOF c0, 24h
        jmp menuPrincipal
    errorOpening:
        print error5
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    errorReading:
        print error9
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    errorCreating:
        print error8
        jmp menuPrincipal
    errorWriting:
        print error7
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    errorClosing:
        print error10
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    errorAppending:
        print error14
        jmp menuPrincipal
    lexicalError:
        print error11
        printChar cl
        print newLine
        cleanBuffer file1, SIZEOF file1, 24h
        cleanBuffer file2, SIZEOF file2, 24h
        jmp menuPrincipal
    syntaxError:
        print error12
        jmp menuPrincipal
    syntaxEOF:
        print error13
        jmp menuPrincipal
main endp

; Procedimiento para convertir de binario -> ascii
; input : AL=binary code
; output : AX=ASCII code
convert proc
    aam 
    add ax, 3030h
ret
convert endp

end main