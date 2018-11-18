# -*- coding: utf-8 -*-

import golly as g

"""
programing instructions:

you can use only 8 variables names: a,b,c,d,e,f,g,h
h is used for storing the current program line, so be carefull, modifiying h will jump to the line h+1
the instructions are:

(let be n an integer in base 10)

write a n
-> write n to the variable a (written in 2's complement if signed)

goto n
-> go to the line n (first line is line 0)

move a b
-> b=a

jumpif a
-> jump the next line if a is not 0

print a
-> print a

add a b c
-> c=a+b

or a b c
-> c=bitwiseOR(a,b)

and a b c
-> c=bitwiseAND(a,b)

xor a b c
-> c=bitwiseXOR(a,b)

not a b
-> b=bitwiseNOT(a)

flat a b
-> b=0 if a=0; b=11111111 else

sign a b
-> write the most significant bit of a in b (sign of a if a is written in 2's complement)

increment a
-> a=a+1
"""


# write your program here 
# (this example computes Fibonacci sequence)
asm = """
write a 1
write b 1
add a b a
print a
add a b b
print b
goto 2
"""


instructions = {"goto":"0000", "move":"0001", "write":"0000", "jumpif":"0010", "print":"0011", "add":"1000", "or":"1001", "and":"1010", "xor":"1011", "not":"1100", "flat":"1101", "sign":"1110", "increment":"1111"}
addresses = {"a":"111", "b":"110", "c":"101", "d":"100", "e":"011", "f":"010", "g":"001", "h":"000"}

def twos_complement(v):
	v = bin(-v)[2:].zfill(8)
	v = "".join(["0" if c=="1" else "1" for c in v])
	v = int(v,2)+1
	v = bin(v)[2:].zfill(8)
	return v

def translateLine(line):
	
	binInstruction = "0000"
	binAddress1 = "000"
	binAddress2 = "000"
	binAddress3 = "000"
	binData = "00000000"
	
	line = line.split()
	binInstruction = instructions[line[0]]
		
	if line[0] == "write":
		n = int(line[2])
		if n >= 0:
			binData = bin(n)[2:].zfill(8)[::-1]
		else:
			binData = twos_complement(-n)[::-1]
		binAddress1 = addresses[line[1]]
		
		
	elif line[0] in ["add", "or", "and", "xor"]:
		binAddress1 = addresses[line[3]]
		binAddress2 = addresses[line[1]]
		binAddress3 = addresses[line[2]]
		
	elif line[0] in ["not", "flat", "sign", "move"]:
		binAddress1 = addresses[line[2]]
		binAddress2 = addresses[line[1]]
	
	elif line[0] in ["jumpif", "print", "increment"]:
		binAddress1 = addresses[line[1]]
		binAddress2 = addresses[line[1]]
	
	elif line[0] == "goto":
		if line[1] == 0:
			binData = "11111111"
		else:
			binData = bin(int(line[1])-1)[2:].zfill(8)[::-1]
		
	return binInstruction+binAddress1+binAddress2+binAddress3+binData
	
def translateAll(asm):
	asm = asm.split("\n")
	asm = [line for line in asm]
	translated = [translateLine(line) for line in asm if line!=""]
	return translated


def write(asm):
	binary = translateAll(asm)
	g.open("computer.mc")
	g.duplicate()
	g.setname("programmed", 0)
	g.movelayer(1, 0)
	g.dellayer()
	
	g.select([-25950, 1890, 450, 240])
	g.cut()

	for i in range(len(binary)):
		for j in range(21):
		
			if int(binary[i][j]):
				g.select([-23639+i*600+j*300, 2159+i*600-j*300, 450, 240])
				g.clear(0)
				g.paste(-23639+i*600+j*300, 2159+i*600-j*300, "or")
	
	
write(asm)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
