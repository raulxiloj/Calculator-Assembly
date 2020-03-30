;--------------------------------------------------------------
;------------------macros para manejar ficheros----------------
;--------------------------------------------------------------

;macro para abrir un fichero
;param file = nombre del archivo
;param &handler = num del archivo
openFile macro file,handler
    mov ah,3dh
    mov al,010b
    lea dx,file
    int 21h
    jc errorOpening
    mov handler, ax
endm

;macro para leer en un fichero
;param handler = num del archivo
;param &fileData = variable donde se almacenara los bytes leidos
;param numBytes = num de bytes a leer
readFile macro handler,fileData,numBytes
    mov ah,3fh
    mov bx, handler
    mov cx, numBytes
    lea dx, fileData
    int 21h
    jc errorReading
endm

;macro para cerrar un fichero
;param handler = num del fichero
closeFile macro handler
    mov ah,3eh
    mov bx, handler
    int 21h
endm

;macro para crear un fichero
;param file = nombre del archivo
;param &handler = num del fichero
createFile macro file,handler
    mov ah,3ch
    mov cx,00h
    lea dx, file
    int 21h
    jc errorCreating
    mov handler,ax
endm

;macro para escribir en un fichero
;param handler = num del archivo 
;param array = bytes a escribir
;param numBytes = num de bytes a escribir
writeFile macro handler,array,numBytes
    mov ah,40h
    mov bx,handler
    mov cx,numBytes
    lea dx,array
    int 21h
    jc errorWriting
endm

;macro para seguir escribiendo en una de terminada posicion del fichero 
seekEnd macro handler
    mov ah,42h
    mov al, 02h
    mov bx, handler
    mov cx, 0
    mov dx, 0
    int 21h
    jc errorAppending
endm
