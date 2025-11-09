[org 0x0100]
jmp start
difficulty: dw 0
escToExit: db 'Press ESC to exit!'
starting: db '   Select Difficulty!   '
easy: db '   1-EASY               '
mdium: db '   2-MEDIUM              '
hard: db '   3-HARD               '
ending: db 'Game Over!'
oldkb: dd 0
alpha1: dw 0
alpha2: dw 0
alpha3: dw 0
alpha4: dw 0
alpha5: dw 0
loc1: dw 0
loc2: dw 0
loc3: dw 0
loc4: dw 0
loc5: dw 0
locBox: dw 3918
rand: dw 0
randnum: dw 0
score: dw 0
missed: dw 0


clearScreen:
push ax
push bx
push cx
push dx
push si
push di
mov cx,2000
mov di,0
clearing:
mov word[es:di],0x3720
add di,2
loop clearing
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret



printnum:     
              push bp 
              mov  bp, sp 
              push es 
              push ax 
              push bx 
              push cx 
              push dx 
              push di 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              mov  ax, [bp+4]         ; load number in ax 
              mov  bx, 10             ; use base 10 for division 
              mov  cx, 0              ; initialize count of digits 
nextdigit:    mov  dx, 0              ; zero upper half of dividend 
              div  bx                 ; divide by 10 
              add  dl, 0x30           ; convert digit into ascii value 
              push dx                 ; save ascii value on stack 
              inc  cx                 ; increment count of values  
              cmp  ax, 0              ; is the quotient zero 
              jnz  nextdigit          ; if no divide it again 
              mov  di, [bp+6]              ; point di to top left column 
nextpos:      pop  dx                 ; remove a digit from the stack 
              mov  dh, 0x3E           ; use normal attribute 
              mov [es:di], dx         ; print char on screen 
              add  di, 2              ; move to next screen location 
              loop nextpos            ; repeat for all digits on stack
 
              pop  di 
              pop  dx 
              pop  cx 
              pop  bx 
              pop  ax 
              pop  es 
              pop  bp 
              ret  4
			  
printBox:

push di

cmp word [difficulty],1
je forhard1
cmp word [difficulty],2
je formedium1
cmp word [difficulty],5
je foreasy1

forhard1:
mov word [es:di],0x3EDC


jmp skip1
formedium1:
mov word [es:di],0x3EDC
add di,2
mov word [es:di],0x3EDC
sub di,4
mov word [es:di],0x3EDC
jmp skip1

foreasy1:
mov word [es:di],0x3EDC
add di,2
mov word [es:di],0x3EDC
add di,2
mov word [es:di],0x3EDC
sub di,6
mov word [es:di],0x3EDC
sub di,2
mov word [es:di],0x3EDC

skip1:

pop di
ret


clearBox:
push di
cmp word [difficulty],1
je forhard2
cmp word [difficulty],2
je formedium2
cmp word [difficulty],5
je foreasy2


forhard2:

mov word [es:di],0x3720
jmp skip2

formedium2:

add di,2
mov word [es:di],0x3720
sub di,4
mov word [es:di],0x3720
add di,2
mov word [es:di],0x3720
jmp skip2

foreasy2:

mov word [es:di],0x3720
add di,2
mov word [es:di],0x3720
add di,2
mov word [es:di],0x3720
sub di,6
mov word [es:di],0x3720
sub di,2
mov word [es:di],0x3720


skip2:

pop di
ret		


scoreDetails:
push ax
push bx
push cx
push dx
push si
push di

mov ax,0xb800
mov es,ax
mov word [es:130],0x3e53;S
mov word [es:132],0x3e63;c
mov word [es:134],0x3e6f;o
mov word [es:136],0x3e72;r
mov word [es:138],0x3e65;e
mov word [es:140],0x3e3A;:
mov ax,142
push ax
push word [score]
call printnum 

mov word [es:16],0x3e4D;M
mov word [es:18],0x3e69;i
mov word [es:20],0x3e73;s
mov word [es:22],0x3e73;s
mov word [es:24],0x3e65;e
mov word [es:26],0x3e64;d
mov word [es:28],0x3e3A;:

mov ax,30
push ax
push word [missed]
call printnum 






mov di,[locBox]
call printBox

mov cx,18
mov si,escToExit
mov ah,0xbc
mov di,60
nextchar7:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar7

cmp word [missed],10
je terminate
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret



randG:
   push bp
   mov bp, sp
   pusha
   cmp word [rand], 0
   jne next

  MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
  INT     1AH
  inc word [rand]
  mov     [randnum], dx
  jmp next1

  next:
  mov     ax, 25173          ; LCG Multiplier
  mul     word  [randnum]     ; DX:AX = LCG multiplier * seed
  add     ax, 13849          ; Add LCG increment value
  ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
  mov     [randnum], ax          ; Update seed = return value

 next1:xor dx, dx
 mov ax, [randnum]
 mov cx, [bp+4]
 inc cx
 div cx
 
 mov [bp+6], dx
 popa
 pop bp
 ret 2
 
 
 
 
 



delay:
push ax
push bx
push cx
push dx
push si
push di
mov cx,0xffff
delaying1:
loop delaying1
mov cx,0xffff
delaying2:
loop delaying2
mov cx,0xffff
delaying3:
loop delaying3
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


generateRandom1:
push ax
push bx
push cx
push dx
push si
push di

sub sp, 2
push 79
call randG
pop ax
mov bl,25
div bl
add ah,65
mov dl,AH
mov dh,0x7A
mov [alpha1],dx
mov dx,[alpha1]

sub sp, 2
push 79
call randG
pop ax
mov bl,80
div bl
shl ah,1
mov dl,AH
mov dh,0
mov [loc1],dx

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
generateRandom2:
push ax
push bx
push cx
push dx
push si
push di

sub sp, 2
push 79
call randG
pop ax
mov bl,25
div bl
add ah,65
mov dl,AH
mov dh,0x79
mov [alpha2],dx
mov dx,[alpha2]

sub sp, 2
push 79
call randG
pop ax
mov bl,80
div bl
shl ah,1
mov dl,AH
mov dh,0
mov [loc2],dx

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
generateRandom3:
push ax
push bx
push cx
push dx
push si
push di

sub sp, 2
push 79
call randG
pop ax
mov bl,25
div bl
add ah,65
mov dl,AH
mov dh,0x7C
mov [alpha3],dx
mov dx,[alpha3]

sub sp, 2
push 79
call randG
pop ax
mov bl,80
div bl
shl ah,1
mov dl,AH
mov dh,0
mov [loc3],dx

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
generateRandom4:
push ax
push bx
push cx
push dx
push si
push di

sub sp, 2
push 79
call randG
pop ax
mov bl,25
div bl
add ah,65
mov dl,AH
mov dh,0x7D
mov [alpha4],dx
mov dx,[alpha4]

sub sp, 2
push 79
call randG
pop ax
mov bl,80
div bl
shl ah,1
mov dl,AH
mov dh,0
mov [loc4],dx

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
generateRandom5:
push ax
push bx
push cx
push dx
push si
push di

sub sp, 2
push 79
call randG
pop ax
mov bl,25
div bl
add ah,65
mov dl,AH
mov dh,0x7B
mov [alpha5],dx
mov dx,[alpha5]

sub sp, 2
push 79
call randG
pop ax
mov bl,80
div bl
shl ah,1
mov dl,AH
mov dh,0
mov [loc5],dx

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret





movingAlpha1:
push ax
push bx
push cx
push dx
push si
push di
mov ax,3840
cmp [loc1],ax
jge baseCondition1
jmp ignore1
baseCondition1:
mov di,[loc1]
cmp word [es:di],0x3EDC
jne noScore1
add word [score],1
jmp score1
noScore1:
add word [missed],1
score1:
mov word [es:di],0x3720
call generateRandom1
ignore1:
mov cx,[difficulty]
iteration1:
call delay
loop iteration1
mov di,[loc1]
mov word [es:di],0x3720
add di,160
mov [loc1],di
mov ax,[alpha1]
mov [es:di],ax
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret



movingAlpha2:
push ax
push bx
push cx
push dx
push si
push di
mov ax,3840
cmp [loc2],ax
jge baseCondition2
jmp ignore2
baseCondition2:
mov di,[loc2]
cmp word [es:di],0x3EDC
jne noScore2
add word [score],1
jmp score2
noScore2:
add word [missed],1
score2:
mov word [es:di],0x3720
call generateRandom2
ignore2:
mov cx,[difficulty]
iteration2:
call delay
loop iteration2
mov di,[loc2]
mov word [es:di],0x3720
add di,160
mov [loc2],di
mov ax,[alpha2]
mov [es:di],ax
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret



movingAlpha3:
push ax
push bx
push cx
push dx
push si
push di
mov ax,3840
cmp [loc3],ax
jge baseCondition3
jmp ignore3
baseCondition3:
mov di,[loc3]
cmp word [es:di],0x3EDC
jne noScore3
add word [score],1
jmp score3
noScore3:
add word [missed],1
score3:
mov word [es:di],0x3720
call generateRandom3
ignore3:
mov cx,[difficulty]
iteration3:
call delay
loop iteration3
mov di,[loc3]
mov word [es:di],0x3720
add di,160
mov [loc3],di
mov ax,[alpha3]
mov [es:di],ax
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret




movingAlpha4:
push ax
push bx
push cx
push dx
push si
push di
mov ax,3840
cmp [loc4],ax
jge baseCondition4
jmp ignore4
baseCondition4:
mov di,[loc4]
cmp word [es:di],0x3EDC
jne noScore4
add word [score],1
jmp score4
noScore4:
add word [missed],1
score4:
mov word [es:di],0x3720
call generateRandom4
ignore4:
mov cx,[difficulty]
iteration4:
call delay
loop iteration4
mov di,[loc4]
mov word [es:di],0x3720
add di,160
mov [loc4],di
mov ax,[alpha4]
mov [es:di],ax
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret



movingAlpha5:
push ax
push bx
push cx
push dx
push si
push di
mov ax,3840
cmp [loc5],ax
jge baseCondition5
jmp ignore5
baseCondition5:
mov di,[loc5]
cmp word [es:di],0x3EDC
jne noScore5
add word [score],1
jmp score5
noScore5:
add word [missed],1
score5:
mov word [es:di],0x3720
call generateRandom5
ignore5:
mov cx,[difficulty]
iteration5:
call delay
loop iteration5
mov di,[loc5]
mov word [es:di],0x3720
add di,160
mov [loc5],di
mov ax,[alpha5]
mov [es:di],ax
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


movingDown:
push ax
push bx
push cx
push dx
push si
push di

call movingAlpha4
call scoreDetails
call movingAlpha5
call scoreDetails
call movingAlpha1
call scoreDetails
call movingAlpha2
call scoreDetails
call movingAlpha3
call scoreDetails
call movingAlpha4
call scoreDetails
call movingAlpha3
call scoreDetails
call movingAlpha5
call scoreDetails
call movingAlpha2
call scoreDetails
call movingAlpha4
call scoreDetails
call movingAlpha5
call scoreDetails
call movingAlpha5
call scoreDetails
call movingAlpha3
call scoreDetails
call movingAlpha4
call scoreDetails
call movingAlpha5
call scoreDetails
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


moveleft:
push ax
push bx
push cx
push dx
push si
push di
mov di,[locBox]
call clearBox
sub di,2

cmp word [difficulty],1
je forhard3
cmp word [difficulty],2
je formedium3
cmp word [difficulty],5
je foreasy3

forhard3:
cmp di,3838
je reset2
jmp ignore7
reset2: mov di,3998


formedium3:
cmp di,3840
je reset3
jmp ignore7
reset3: mov di,3996

foreasy3:
cmp di,3842
je reset4
jmp ignore7
reset4: mov di,3994

ignore7:
mov [locBox],di
call printBox
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
moveright:
push ax
push bx
push cx
push dx
push si
push di
mov di,[locBox]
call clearBox
add di,2

cmp word [difficulty],1
je forhard4
cmp word [difficulty],2
je formedium4
cmp word [difficulty],5
je foreasy4
forhard4:
cmp di,4000
je reset5
jmp ignore8
reset5: mov di,3840


formedium4:
cmp di,3998
je reset6
jmp ignore8
reset6: mov di,3842

foreasy4:
cmp di,3996
je reset7
jmp ignore8
reset7: mov di,3844

ignore8:
ignore6:
mov [locBox],di
call printBox
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

hook09h:
push ax
in al, 0x60
cmp al, 0x4b
jne nextcmp1
call moveleft
jmp exit
nextcmp1:
cmp al, 0x4d
jne nextcmp2
call moveright
jmp exit
nextcmp2:
cmp al,0x1
jne nomatch
call terminate
nomatch:
pop ax
jmp far [cs:oldkb]
kbreturn:
exit: 
mov al, 0x20
out 0x20, al
pop ax
iret

firstpage:

mov ax,0xb800
mov es,ax
call clearScreen
mov cx,26
mov di,1654
nextbord1:
mov word [es:di],0x37DC
add di,2
loop nextbord1
mov word [es:di],0x37DC
add di,160
mov cx,4
nextbord2:
mov word [es:di],0x77DC
add di,160
loop nextbord2
mov word [es:di],0x77DC
sub di,2
mov cx,26
nextbord3:
mov word [es:di],0x37DC
sub di,2
loop nextbord3
mov cx,5
nextbord4:
mov word [es:di],0x77DC
sub di,160
loop nextbord4
mov word [es:di],0x37DC

;Printing Large TEXT
mov di,532
mov cx,5
c1:
mov word [es:di],0x7020
add di,160
loop c1
mov di,1172
mov cx,5
c2:
mov word [es:di],0x7020
add di,2
loop c2
mov di,532
mov cx,5
c3:
mov word [es:di],0x7020
add di,2
loop c3

mov di,544
mov cx,5
a1:
mov word [es:di],0x7020
add di,160
loop a1
mov di,552
mov cx,5
a2:
mov word [es:di],0x7020
add di,160
loop a2
mov di,544
mov cx,5
a3:
mov word [es:di],0x7020
add di,2
loop a3
mov di,864
mov cx,5
a4:
mov word [es:di],0x7020
add di,2
loop a4

mov di,556
mov cx,5
t1:
mov word [es:di],0x7020
add di,2
loop t1
mov di,560
mov cx,5
t2:
mov word [es:di],0x7020
add di,160
loop t2

mov di,568
mov cx,5
c11:
mov word [es:di],0x7020
add di,2
loop c11
mov di,568
mov cx,5
c22:
mov word [es:di],0x7020
add di,160
loop c22
mov di,1208
mov cx,5
c33:
mov word [es:di],0x7020
add di,2
loop c33

mov di,580
mov cx,5
h1:
mov word [es:di],0x7020
add di,160
loop h1
mov di,586
mov cx,5
h2:
mov word [es:di],0x7020
add di,160
loop h2
mov di,900
mov cx,4
h3:
mov word [es:di],0x7020
add di,2
loop h3

mov di,2908
mov cx,5
a11:
mov word [es:di],0x7020
add di,160
loop a11
mov di,2916
mov cx,5
a22:
mov word [es:di],0x7020
add di,160
loop a22
mov di,2908
mov cx,5
a33:
mov word [es:di],0x7020
add di,2
loop a33
mov di,3228
mov cx,5
a44:
mov word [es:di],0x7020
add di,2
loop a44

mov di,2920
mov cx,5
l1:
mov word [es:di],0x7020
add di,160
loop l1
mov di,3560
mov cx,5
l2:
mov word [es:di],0x7020
add di,2
loop l2

mov di,2932
mov cx,5
p1:
mov word [es:di],0x7020
add di,160
loop p1
mov di,2940
mov cx,2
p2:
mov word [es:di],0x7020
add di,160
loop p2
mov di,2932
mov cx,5
p3:
mov word [es:di],0x7020
add di,2
loop p3
mov di,3252
mov cx,5
p4:
mov word [es:di],0x7020
add di,2
loop p4

mov di,2944
mov cx,5
h11:
mov word [es:di],0x7020
add di,160
loop h11
mov di,2950
mov cx,5
h22:
mov word [es:di],0x7020
add di,160
loop h22
mov di,3264
mov cx,4
h33:
mov word [es:di],0x7020
add di,2
loop h33

mov cx,24
mov si,starting
mov ah,0xEF
mov di,1816
nextchar1:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar1

mov cx,24
mov si,easy
mov ah,0x3A
mov di,1976
nextchar3:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar3

mov cx,24
mov si,mdium
mov ah,0x39
mov di,2136
nextchar4:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar4

mov cx,24
mov si,hard
mov ah,0x3c
mov di,2296
nextchar5:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar5

mov di,2956
mov cx,5
a111:
mov word [es:di],0x7020
add di,160
loop a111
mov di,2964
mov cx,5
a222:
mov word [es:di],0x7020
add di,160
loop a222
mov di,2956
mov cx,5
a333:
mov word [es:di],0x7020
add di,2
loop a333
mov di,3276
mov cx,5
a444:
mov word [es:di],0x7020
add di,2
loop a444

mov di,2968
mov cx,5
b1:
mov word [es:di],0x7020
add di,160
loop b1
mov di,2976
mov cx,5
b2:
mov word [es:di],0x7020
add di,160
loop b2
mov di,2968
mov cx,5
b3:
mov word [es:di],0x7020
add di,2
loop b3
mov di,3288
mov cx,5
b4:
mov word [es:di],0x7020
add di,2
loop b4
mov di,3608
mov cx,5
b5:
mov word [es:di],0x7020
add di,2
loop b5

mov di,2980
mov cx,5
e1:
mov word [es:di],0x7020
add di,160
loop e1
mov di,2980
mov cx,5
e2:
mov word [es:di],0x7020
add di,2
loop e2
mov di,3300
mov cx,5
e3:
mov word [es:di],0x7020
add di,2
loop e3
mov di,3620
mov cx,5
e4:
mov word [es:di],0x7020
add di,2
loop e4

mov di,2992
mov cx,5
t11:
mov word [es:di],0x7020
add di,2
loop t11
mov di,2996
mov cx,5
t22:
mov word [es:di],0x7020
add di,160
loop t22

mov di,3004
mov cx,2
s1:
mov word [es:di],0xff20
add di,160
loop s1
mov di,3004
mov cx,5
s2:
mov word [es:di],0xff20
add di,2
loop s2
mov di,3324
mov cx,5
s3:
mov word [es:di],0xff20
add di,2
loop s3
mov di,3644
mov cx,5
s4:
mov word [es:di],0xff20
add di,2
loop s4
mov di,3332
mov cx,2
s5:
mov word [es:di],0xff20
add di,160
loop s5

mov ah, 0
int 16h
cmp al,49
je difficulty1
cmp al,50
je difficulty2
cmp al,51
je difficulty3
jmp start
difficulty1:
 mov word [difficulty],5
jmp skip
difficulty2:
 mov word [difficulty],2
jmp skip
difficulty3:
mov word [difficulty],1

ret



start:
call firstpage
skip:
xor ax,ax
mov es, ax
mov ax, [es:9*4]
mov word[oldkb], ax
mov ax, [es:9*4+2]
mov word[oldkb+2], ax
mov word [es:9h*4],hook09h
mov [es:9h*4+2], cs
mov ax,0xb800
mov es,ax
call clearScreen
mov di,3918
call printBox
call generateRandom1
call generateRandom2
call generateRandom3
call generateRandom4
call generateRandom5
infinite:
call movingDown
jmp infinite
terminate:
call clearScreen
mov word [es:130],0x3e53;S
mov word [es:132],0x3e63;c
mov word [es:134],0x3e6f;o
mov word [es:136],0x3e72;r
mov word [es:138],0x3e65;e
mov word [es:140],0x3e3A;:
mov ax,142
push ax
push word [score]
call printnum 

mov word [es:16],0x3e4D;M
mov word [es:18],0x3e69;i
mov word [es:20],0x3e73;s
mov word [es:22],0x3e73;s
mov word [es:24],0x3e65;e
mov word [es:26],0x3e64;d
mov word [es:28],0x3e3A;:

mov ax,30
push ax
push word [missed]
call printnum 
mov cx,10
mov si,ending
mov ah,0xbc
mov di,1830
nextchar2:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextchar2
mov ax,0x4c00
int 21h