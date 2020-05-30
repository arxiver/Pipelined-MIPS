# all numbers in hex format
# we always start by reset signal
#this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is the interrupt address
100

.ORG 10
LDM R2,0A #R2=0A
LDM R0,0  #R0=0
LDM R1,50 #R1=50
LDM R3,20 #R3=20
LDM R4,2  #R4=2
NOP
JMP R3    #Jump to 20

.ORG 20
SUB R0,R2,R5 #check if R0 = R2
NOP
NOP
NOP
JZ R1 #jump if R0=R2 to 50
ADD R4,R4,R4 #R4 = R4*2
OUT R4
INC R0
JMP R3 #jump to 20


.ORG 50
LDM R0,0 #R0=0
LDM R2,8 #R2=8
LDM R3,60 #R3=60
LDM R4,3  #R4=3
NOP
JMP R3 #jump to 60
.ORG 60
ADD R4,R4,R4 #R4 = R4*2
OUT R4
INC R0
AND R0,R2,R5 #when R0 < R2(8) answer will be zero
NOP
NOP
NOP
JZ R3 #jump if R0 < R2 to 60
INC R4
OUT R4