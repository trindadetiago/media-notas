.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\macros\macros.asm

includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data

        Number1 dword 0
        Number2 dword 0
        Number3 dword 0
        
        UserInput1 db 10 DUP(0)
        UserInput2 db 10 DUP(0)
        UserInput3 db 10 DUP(0)
        
        Message1 db "Por favor escreva a primeira nota: ", 0
        Message2 db "Por favor escreva a segunda nota: ", 0
        Message3 db "Por favor escreva a terceira nota: ", 0

        InvalidInputMessage db "Entrada Invalida, digite um numero entre 0 e 10:", 0Ah, 0
        RetryInputMessage db "Tente novamente: ", 0
        
        SumString db 10 DUP(0)
        AvgString db 10 DUP(0)
        IntPartString db 10 DUP(0)
        FracPartString db 10 DUP(0)
        CombinedString db 10 DUP(0)

        Message4 db "Soma das notas: ", 0
        Message5 db "Media final: ", 0
        NumSum dword 0
        NumAvg dword 0
        IntAvg dword 0
        FloatAvg dword 0

        Final dword 0
        IntFinal dword 0
        FloatFinal dword 0
        
        MessageAproved db "O aluno foi aprovado de ano.", 0
        MessageReproved db "O aluno foi reprovado de ano.", 0
        MessageFinal db "A aluno vai para a final. Eis quantos pontos ele precisa: ", 0



.code

start:
        ; Take the user inputs first

        invoke StdOut, addr Message1
        ReadInput1:
            invoke StdIn, addr UserInput1, 10
            invoke StripLF, addr UserInput1
            invoke atodw, addr UserInput1
            mov Number1, eax

            cmp eax, 0
            jl InvalidInput1
            cmp eax, 10
            jg InvalidInput1
            jmp ContinueInput1

        InvalidInput1:
            invoke StdOut, addr InvalidInputMessage
            jmp ReadInput1 ;

        ContinueInput1:

        invoke StdOut, addr Message2
        ReadInput2:
            invoke StdIn, addr UserInput2, 10
            invoke StripLF, addr UserInput2
            invoke atodw, addr UserInput2
            mov Number1, eax

            cmp eax, 0
            jl InvalidInput2
            cmp eax, 10
            jg InvalidInput2
            jmp ContinueInput2

        InvalidInput2:
            invoke StdOut, addr InvalidInputMessage
            jmp ReadInput2 ;

        ContinueInput2:

        invoke StdOut, addr Message3
        ReadInput3:
            invoke StdIn, addr UserInput3, 10
            invoke StripLF, addr UserInput3
            invoke atodw, addr UserInput3
            mov Number3, eax

            cmp eax, 0
            jl InvalidInput3
            cmp eax, 10
            jg InvalidInput3
            jmp ContinueInput3

        InvalidInput3:
            invoke StdOut, addr InvalidInputMessage
            jmp ReadInput3 ;

        ContinueInput3:
        
        ; invoke StdOut, addr UserInput1
        ; printf("\n")
        ; invoke StdOut, addr UserInput2
        ; printf("\n")
        ; invoke StdOut, addr UserInput3
        ; printf("\n")

        ; Remove the CRLF

        invoke StripLF, addr UserInput1
        invoke StripLF, addr UserInput2
        invoke StripLF, addr UserInput3


        ; convert them to numbers from strings

        invoke atodw, addr UserInput1
        mov Number1, eax

        invoke atodw, addr UserInput2
        mov Number2, eax
        
        invoke atodw, addr UserInput3
        mov Number3, eax
        
        ; add the numbers

        mov eax, Number1
        add eax, Number2
        add eax, Number3
        mov NumSum, eax

        ; avarage the numbers
        
        imul eax, 100 
        mov ebx, 3
        cdq
        idiv ebx
        mov NumAvg, eax

        ; separate the integer and fractional parts
        
        mov eax, NumAvg         ; Load number into eax
        mov ebx, 100            ; Divisor is 100
        cdq                     ; Sign-extend eax into edx:eax
        idiv ebx                ; Divide the value in edx:eax by 100
        mov IntAvg, eax

        mov ebx, NumAvg         ; Load number into ebx
        imul eax, 100           ; Multiply integer part by 100
        sub ebx, eax            ; Subtract integer part with the big avarage
        mov FloatAvg, ebx      

        ; convert the sum and avg, integer and fractional to strings and display it

        invoke dwtoa, NumSum, addr SumString
        invoke dwtoa, IntAvg, addr IntPartString
        invoke dwtoa, FloatAvg, addr FracPartString

        ; print the sum and avg on the screen

        invoke StdOut, addr Message4
        invoke StdOut, addr SumString
        printf("\n")
        invoke StdOut, addr Message5
        invoke StdOut, addr IntPartString
        printf(",")
        invoke StdOut, addr FracPartString
        printf("\n")

        ; -------------------- APROVED, REPROVED OR FINAL ----------------------

        mov ebx, IntAvg
        
        ; Compare eax with 7
        cmp ebx, 7
        jge bigger_than_7  ; Jump if eax is greater than or equal to 7
        
        ; Compare eax with 4
        cmp ebx, 4
        jl smaller_than_4  ; Jump if eax is less than 4
        
        ; ################  > 4 & < 7 ################ 
        
        mov eax, NumAvg
        imul eax, 6
        mov ebx, eax
        
        ; Subtract the result from 500 and store it in eax

        sub ebx, 5000
        imul ebx, -1

        ; Divide the result by 4
        mov eax, ebx
        mov ecx, 4
        cdq            
        idiv ecx
        mov ebx, eax
        mov Final, ebx

        ; separate int and float parts

        mov eax, Final         ; Load number into eax
        mov ebx, 100            ; Divisor is 100
        cdq                     ; Sign-extend eax into edx:eax
        idiv ebx                ; Divide the value in edx:eax by 100
        mov IntFinal, eax

        mov ebx, Final         ; Load number into ebx
        imul eax, 100           ; Multiply integer part by 100
        sub ebx, eax            ; Subtract integer part with the big avarage
        mov FloatFinal, ebx      

        ; print

        invoke StdOut, addr MessageFinal
        printf("%d,%d", IntFinal, FloatFinal)

        ; ################ > 7 ################       
         
        jmp done  
        
        bigger_than_7:
        
        invoke StdOut, addr MessageAproved

        jmp done 

        ; ################ < 4 ################ 
        
        smaller_than_4:
        
        invoke StdOut, addr MessageReproved
        
        done:


        invoke Sleep, 200000


        
end start