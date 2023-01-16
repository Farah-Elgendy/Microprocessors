; multi-segment executable file template.

data segment
;informations saved of users

id dw 14320d,12314d,12233d,12022d,12331d,11444d,15223d,11567d,12896d,16478d,14456d,15239d,32214d,33144d,31216d,45444d,47133d,51577d,61237d,19897d
pass dw  10d,11d,03d,15d,13d,05d,07d,12d,02d,01d,09d,08d,06d,00d,14d,04d,13d,14d,11d,10d

;messages to be sent 

msg1  db 10,13,"USER FOUND.......Welcome_(1)_$"          ;Together the two control codes move the cursor to the start of the next line.
msg2  db 10,13,"USER NOT FOUND .......Try again_(0)_$" 
text1  db 10,13,"Enter your id,please: $"
text2  db 10,13,"Enter your password, please:$"

ends

;stack segment
;dw   128  dup(0)     ;unintialize the stack 
;ends

code segment
start:  


; set segment registers:
mov ax, @data             ;The CS register will initialized to point to the beginning of this segment whenever the program is loaded into memory.
mov ds, ax



lea dx ,text1        ; load address of the string
mov ah,09h          ;it directs program flow to that function, and then return to the program after the function is done
int 21h            ;interrupt 

MOV CX,5
MOV DI,00H 


;id checker
;to read a 4 bits passeword we should make this type of algorithms
read: 
mov ah,01h      ;read character from standard input,result is stored in al
int 21h
SUB al,30H     ;As the ASCII values of numbers and actual number has difference of 30
 
CMP CX,5
JNE choice1
MOV BX,10000
JMP choice5

choice1:
CMP CX,4
JNE choice2
MOV BX,1000 
JMP choice5



choice2:
CMP CX,3
JNE choice3
MOV BX,100
JMP choice5

choice3:
CMP CX,2
JNE choice4
MOV BX,10
JMP choice5

choice4:
CMP CX,1
JNE choice5
MOV BX,1

;each time we jump to choice 4 when it's false



choice5:
MOV AH,00H
MUL BX        ; mul AX by BX and store the result in DX:AX
ADD DI,AX     
LOOP read


lea dx ,text2
mov ah,09h
int 21h

mov cx,2
mov bp,00h

readpass:
mov ah,01h
int 21h
SUB al,30H
cmp cx,2
jne labell
mov bx,10
jmp label1

labell:
cmp cx,1
jne label1
mov bx,1

label1:
mov ah,00h
mul bx
add bp,ax
loop readpass
     

mov cx ,20
mov si ,0  

  
;testing the id & passeword checker  
  
youridfounder:
 mov ax,id[si];
 cmp di,ax;
 je yourpassewordfounder
 add si,2            ;because it is define word 
 loop youridfounder  
 jmp nottrue     


yourpassewordfounder:
 
cmp bp,pass[si]      ;BP contains the pass entered by the user
je true
jmp nottrue


true:
lea dx ,msg1
mov ah,09h
int 21h
jmp stop

nottrue:
lea dx ,msg2
mov ah,09h
int 21h



stop:

ends

end start