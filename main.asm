include macros.asm
.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header      db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,'$'
options     db "1. Ingresar funcion f(x)",10,13,"2. Funcion en memoria",10,13,"3. Derivada f(x)",10,13,"4. Integral F(x)",10,13,"5. Graficar funciones",10,13,"6. Reporte",10,13,"7. Modo calculadora",10,13,"8. Salir",10,13,10,13,"Ingrese una opcion: ",'$'
coefX       db "- Coeficiente de xx: ",'$'
co4         db 5 dup ('$')
co3         db 5 dup ('$')
co2         db 5 dup ('$')
co1         db 5 dup ('$')
co0         db 5 dup ('$')
number      db 2 dup (0)
newLine     db 10,'$'
prueba      db 10,13,"Esto es una prueba gg",10,13,'$'
;--------------------------Possibles errors:--------------------------
error1   db 10,10,13,"Error: Opcion invalida",10,10,13,'$'
error2   db 10,10,13,"Error: No se acepta caracteres vacios",10,10,13,'$'
error3   db 10,10,13,"Error: Solo se aceptan digitos entre -9 a +9",10,10,13,'$'
error4   db 10,10,13,"Error: caracter no reconocido",10,10,13,'$'
;----------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
    mov ax, @data
    mov ds,ax
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
        print newLine
        getCoefficients
        jmp menuPrincipal
    memoryFunction:
        ;TODO printFunction
        jmp menuPrincipal
    derivative:
        print newLine
        getTexto co0
        print newLine
        convertNumber co0, number
        convertAscii number, co1
        print co1
        print newLine
        jmp menuPrincipal
    integral:
        print prueba
        jmp menuPrincipal
    graphFunctions:
        print prueba
        jmp menuPrincipal
    report:
        print prueba
        jmp menuPrincipal
    calculator:
        print prueba
        jmp menuPrincipal
    exit:
        mov ah, 4ch
        int 21h
    invalidOption:
        print error1
        jmp menuPrincipal
    errorChar: 
        print error4
        jmp menuPrincipal
main endp

end main