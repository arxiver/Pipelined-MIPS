#!/home/sofyan/anaconda3/bin/python
import re
import os
import sys
Assembly_opcode_map={}
Opcode_assembly_out=[]

One_operand_opcodes=[]
Two_operand_opcodes=[]
branches_jumps_operand_opcodes=[]
memory_opcodes=[]
Only_OpCode=[]


###########################################################################################
#                                 FILLING THE DICTIONARIES
###########################################################################################
def registers_adressing_modes_map_append():    
    Assembly_opcode_map["R0"]   = "000" 
    Assembly_opcode_map["R1"]   = "001" 
    Assembly_opcode_map["R2"]   = "010" 
    Assembly_opcode_map["R3"]   = "011" 
    Assembly_opcode_map["R4"]   = "100" 
    Assembly_opcode_map["R5"]   = "101" 
    Assembly_opcode_map["R6"]   = "110" 
    Assembly_opcode_map["R7"]   = "111" 


def oneoperand_opcode_map_append():
    Assembly_opcode_map['NOP']  = '00000' 
    Assembly_opcode_map['NOT']  = '00001' 
    Assembly_opcode_map['INC']  = '00010' 
    Assembly_opcode_map['DEC']  = '00011' 
    Assembly_opcode_map['OUT']  = '00100' 
    Assembly_opcode_map['IN']   = '00101' 

def twooperands_opcode_map_append():
    Assembly_opcode_map["SWAP"] = "01000" 
    Assembly_opcode_map["ADD"]  = "01001" 
    Assembly_opcode_map["IADD"] = "01010" 
    Assembly_opcode_map["SUB"]  = "01011" 
    Assembly_opcode_map["AND"]  = "01100"
    Assembly_opcode_map["OR"]   = "01101" 
    Assembly_opcode_map["SHL"]  = "01110"
    Assembly_opcode_map["SHR"]  = "01111"

def memory_opcode_map_append():
    Assembly_opcode_map["PUSH"] = "10000" 
    Assembly_opcode_map["POP"]  = "10001" 
    Assembly_opcode_map["LDM"]  = "10010" 
    Assembly_opcode_map["LDD"]  = "10011" 
    Assembly_opcode_map["STD"]  = "10100"

def branches_jumps_opcode_map_append():
    Assembly_opcode_map["JZ"]   = "11000" 
    Assembly_opcode_map["JMP"]  = "11001" 
    Assembly_opcode_map["CALL"] = "11010" 
    Assembly_opcode_map["RET"]  = "11011" 
    Assembly_opcode_map["RTI"]  = "11100"


#############################################################################################
#                                   FILLING THE ARRAYS
##############################################################################################
def one_operand_opcode_append():
    One_operand_opcodes.extend(['NOP','NOT','INC','DEC','OUT','IN'])

def two_operand_opcode_append():
    Two_operand_opcodes.extend(["SWAP", "ADD" , "IADD" , "SUB" , "AND" , "OR" , "SHL" , "SHR" ])

def memory_operand_opcode_append():
    memory_opcodes.extend(["PUSH" , "POP" , "LDM" , "LDD" , "STD"])

def branches_jumps_operand_opcode_append():    
    branches_jumps_operand_opcodes.extend(["JZ" , "JMP" , "CALL" , "RET" , "RTI"])

def Only_OpCode_append():
    Only_OpCode.extend(["NOP", "RET", "RTI"])


###############################################################################################
#                           FUNCTION TO LOAD ALL DICTIONARIES AND ARRAYS
################################################################################################
def LoadEveryThing():
    registers_adressing_modes_map_append()
    oneoperand_opcode_map_append()
    twooperands_opcode_map_append()
    memory_opcode_map_append()
    branches_jumps_opcode_map_append()
    one_operand_opcode_append()
    two_operand_opcode_append()
    memory_operand_opcode_append()
    branches_jumps_operand_opcode_append()
    Only_OpCode_append()


##############################################################################################
#                                     DICIMAL TO BINARY
###############################################################################################
def decimal2binary(x,n = 0):    
    binary = []
    def decimaltobinary(y,n):
        if y > 1 or n >= 1:
            decimaltobinary(y/2 , n-1)
            binary.append(int(y%2))

    Negative = False
    if(x < 0):
        Negative = True

    decimaltobinary(abs(x),n)

    if(Negative == True):
        binary[0] = '1'

    for i in range(len(binary)):
        binary[i] = str(binary[i])

    string = ''.join(binary)
    return string

###########################################################################################
#                                   SOME HELPER FUNCTIONS
###########################################################################################
def convert_assembly_binary(assembilylines):       
    #array of opcode lines (could be 1 or 2 or 3  i think)
    for line in assembilylines:
        if line == '':
            continue
        line=re.sub(' +', ' ',line)
        ins_type=type_of_instruction(line)
        if ins_type == 0:                         
            one_operand_assmebly_binary_convert(line)
        elif ins_type == 1:           
            two_operand_assmebly_binary_convert(line) 
        elif ins_type == 2:
            branch_operand_assmebly_binary_convert(line)
        elif ins_type == 3:          
            memory_operand_assmebly_binary_convert(line)
        else :
            Opcode_assembly_out.append(decimal2binary(int(line,16),16))

#this function will return what type of assembly line it is to deal with it
def type_of_instruction(line):    
    # one operand => 0
    # two operand  => 1
    # branch , jumps operand  => 2
    # memory => 3  
    Opcode = line.split(" ",1)[0]
    if Opcode in One_operand_opcodes:
        return 0

    if Opcode in Two_operand_opcodes:
        return 1

    if Opcode in branches_jumps_operand_opcodes:
        return 2

    if Opcode in memory_opcodes:
        return 3


###########################################################################################
#                              READ THE FILE OF INSTRUCTIONS
###########################################################################################
#this function to read assembly from file reomve the comments
#retrun array of strings (assembly lines)
def readInputFile(fileName:str):    
    #read from input file
    myfile=open(fileName, "r")
    #contents will be array of lines from assembly
    contents=myfile.readlines()
    # a directory to store key:value pairs
    assemblylines=[]    
    list_addresses=[]
    list_itr=-1
    for line in contents:        
        if(line=='\n' or line == ''):         
            continue   
        if(line.endswith("\n")):
            line = line[:-1]
        removecomments=line.split('#')[0]
        if(removecomments==''):
            continue
        removetabs=removecomments.split('\t')[0]
        if removetabs=='':
            continue
        clean_line = removetabs.upper().strip()
        if(clean_line==""):
            continue
        if(clean_line.split(' ')[0]==".ORG"):
            list_addresses.append(int(clean_line.split(' ')[1]))
            list_itr+=1
            assemblylines.append([])
        else:
            assemblylines[list_itr].append(clean_line)       
    return assemblylines,list_addresses


############################################################################################
#                         SPLIT THE INSTRUCTION TO Rs AND OPCODES
############################################################################################
def BeforeBinary(line):
    elements = []
    elements.append(line.split(" ",1)[0])
    if elements[0] not in Only_OpCode:
        elements.extend((line.split(" ",1)[1]).split(","))
    
    for i in range(0,len(elements)):
        elements[i] = elements[i].strip()

    return elements


############################################################################################
#                                       ONE OPERAND
############################################################################################
def one_operand_assmebly_binary_convert(line):
    Opcode = line.split(" ")[0]
    b_opcode=Assembly_opcode_map[Opcode]
    if(Opcode.upper()=="NOP"):
        Opcode_assembly_out.append("0"*16)
    elif(Opcode.upper()=="NOT" or Opcode.upper()=="INC" or Opcode.upper()=="DEC"):        
        r_src=Assembly_opcode_map[line.split(" ")[1]]
        assembly_line=b_opcode+r_src+"000"+r_src+"00"
        Opcode_assembly_out.append(assembly_line)
    elif(Opcode.upper()=="IN"):      
        r_src=Assembly_opcode_map[line.split(" ")[1]]
        assembly_line=b_opcode+("0"*6)+r_src+"00"
        Opcode_assembly_out.append(assembly_line)
    elif(Opcode.upper()=="OUT"):                
        r_src=Assembly_opcode_map[line.split(" ")[1]]
        assembly_line=b_opcode+r_src+("0"*8)
        Opcode_assembly_out.append(assembly_line)

    
############################################################################################
#                                       TWO OPERAND
############################################################################################
def two_operand_assmebly_binary_convert(line):
    Opcode = line.split(" ")[0]
    b_opcode=Assembly_opcode_map[Opcode]
    if(Opcode.upper()=="SWAP"):
        operands=line.split(" ",1)[1].replace(" ", "")
        src1,src2=operands.split(',')[0],operands.split(',')[1]
        b_src1,b_src2=Assembly_opcode_map[src1],Assembly_opcode_map[src2]
        assembly_line=b_opcode+b_src1+b_src2+("0"*5)
        Opcode_assembly_out.append(assembly_line)
    elif(Opcode.upper()=="ADD" or Opcode.upper()=="SUB" or Opcode.upper()=="AND" or Opcode.upper()=="OR"):
        operands=line.split(" ",1)[1].replace(" ", "")
        src1,src2,dst=operands.split(',')[0],operands.split(',')[1],operands.split(',')[2]
        b_src1,b_src2,b_dst=Assembly_opcode_map[src1],Assembly_opcode_map[src2],Assembly_opcode_map[dst]
        assembly_line=b_opcode+b_src1+b_src2+b_dst+("0"*2)
        Opcode_assembly_out.append(assembly_line)
    elif(Opcode.upper()=="IADD"):
        operands=line.split(" ",1)[1].replace(" ", "")
        src,dst,imm=operands.split(',')[0],operands.split(',')[1],operands.split(',')[2]
        b_src,b_dst,b_imm=Assembly_opcode_map[src],Assembly_opcode_map[dst],decimal2binary(int(imm,16),16)
        assembly_line=b_opcode+b_src+("0"*3)+b_dst+b_imm+("0"*2)
        Opcode_assembly_out.append(assembly_line[:16])
        Opcode_assembly_out.append(assembly_line[16:])
    elif(Opcode.upper()=="SHL" or Opcode.upper()=="SHR"):
        operands=line.split(" ",1)[1].replace(" ", "")
        src,dst,imm=operands.split(',')[0],operands.split(',')[0],operands.split(',')[1]
        b_src,b_dst,b_imm=Assembly_opcode_map[src],Assembly_opcode_map[dst],decimal2binary(int(imm,16),16)
        assembly_line=b_opcode+b_src+("0"*3)+b_dst+b_imm+("0"*2)
        Opcode_assembly_out.append(assembly_line[:16])
        Opcode_assembly_out.append(assembly_line[16:])
    
   
############################################################################################
#                                       BRANCH
############################################################################################
# the instruction must be uppercase
def branch_operand_assmebly_binary_convert(line):
    Opcode_assembly_out.append("".join(branch_operand_assmebly_binary_convert_private(line)))

def branch_operand_assmebly_binary_convert_private(line):
    elements = BeforeBinary(line)
    IR = ['0'] * 16
    OpCode = elements[0]

    IR[0:5] = list(Assembly_opcode_map.get(OpCode))

    if(OpCode == "RTI" or OpCode == "RET"):
        return IR

    Rdst = elements[1]
    IR[5:8] = list(Assembly_opcode_map.get(Rdst))
    return IR

############################################################################################
#                                       MEMORY
############################################################################################
def memory_operand_assmebly_binary_convert(line):
    IR = memory_operand_assmebly_binary_convert_private(line)
    Opcode_assembly_out.append("".join(IR[0:16]))
    if(BeforeBinary(line)[0] != "PUSH" and BeforeBinary(line)[0] != "POP"):
        Opcode_assembly_out.append("".join(IR[16:32]))

def memory_operand_assmebly_binary_convert_private(line):
    elements = BeforeBinary(line)
    IR = ['0'] * 32
    OpCode = elements[0]
    Rdst = elements[1]

    IR[0:5] = list(Assembly_opcode_map.get(OpCode))


    if(OpCode == "PUSH"):
        IR[8:11] = list(Assembly_opcode_map.get(Rdst))
        return IR


    if(OpCode == "POP"):
        IR[11:14] = list(Assembly_opcode_map.get(Rdst))
        return IR

    if(OpCode == "LDM"):
        Imm = decimal2binary(int(elements[2],16),16)
        IR[14:30] = list(Imm)
        IR[8:11] = list(Assembly_opcode_map.get(Rdst))
        return IR

    EA = decimal2binary(int(elements[2],16),20)
    IR[8:11] = list(Assembly_opcode_map.get(Rdst))
    IR[11:31] = EA

    return IR

#############################################################################################
#                                 Write output file 
#############################################################################################
def writeOutputFile(filename):   
    f=open(filename+"_out.txt", "w+")     
    for opline in Opcode_assembly_out:        
        f.write(opline+"\n")    


#############################################################################################
#                                           MAIN
#############################################################################################
if __name__ == "__main__":  
    LoadEveryThing()    
    filename= input("Enter assembly filename : ")
    if(len(sys.argv)>1):
        filename=sys.argv[1]
    assembly_lines=readInputFile(filename)
    
    Arr = assembly_lines[0]
    Arr2 = assembly_lines[1]
    Arr3 = []

    # convert decimal line to hexa 
    for i in Arr2:
        Arr3.append(int(str(i),16)) 

    Arr2 = Arr3
    ################################
    # print(Arr2)
    # for i in Arr:
    #     for j in i:
    #         print(j)
    #     print("=============================")

    # to decrement the org0 and org2
    Org0 = Arr2.index(0)
    Org2 = Arr2.index(2) 

    Arr[Org0][0] = hex((int(Arr[Org0][0],16)-1))[0:]
    Arr[Org2][0] = hex((int(Arr[Org2][0],16)-1))[0:]
    ################################################

    counter = 0
    for i,k in enumerate(Arr):
        while(counter < Arr2[i]):
            Opcode_assembly_out.append("XXXXXXXXXXXXXXXX")
            counter = counter + 1
        convert_assembly_binary(k)
        counter = counter + len(k)
    writeOutputFile(filename.split('.')[0])
    
    
    

    

    
