include macros.asm
.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header    db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,'$'
options   db "1. Ingresar funcion f(x)",10,13,"2. Funcion en memoria",10,13,"3. Derivada f'(x)",10,13,"4. Integral F(x)",10,13,"5. Graficar funciones",10,13,"6. Reporte",10,13,"7. Modo calculadora",10,13,"8. Salir",10,13,10,13,"Ingrese una opcion: ",'$'
prueba    db 10,13,"Esto es una prueba",10,10,13,'$'
;--------------------------Possibles errors:--------------------------
error1    db 10,10,13,"Error: opcion invalida",10,10,13,'$'
;----------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
    mov ax, @data
    mov ds,ax
    menuPrincipal:
        print header
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
        print prueba
        jmp menuPrincipal
    memoryFunction:
        print prueba
        jmp menuPrincipal
    derivative:
        print prueba
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
main endp
end main