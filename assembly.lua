-- programing instructions:
-- 
-- you can use only 8 variables names: a,b,c,d,e,f,g,h
-- h is used for storing the current program line, so be carefull, modifiying h will jump to the line h+1
-- the instructions are:
-- 
-- (let be n an integer in base 10)
-- 
-- write a n
-- -> write n to the variable a (written in 2's complement if signed)
-- 
-- goto n
-- -> go to the line n (first line is line 0)
-- 
-- move a b
-- -> b=a
-- 
-- jumpif a
-- -> jump the next line if a is not 0
-- 
-- print a
-- -> print a
-- 
-- add a b c
-- -> c=a+b
-- 
-- or a b c
-- -> c=bitwiseOR(a,b)
-- 
-- and a b c
-- -> c=bitwiseAND(a,b)
-- 
-- xor a b c
-- -> c=bitwiseXOR(a,b)
-- 
-- not a b
-- -> b=bitwiseNOT(a)
-- 
-- flat a b
-- -> b=0 if a=0; b=11111111 else
-- 
-- sign a b
-- -> write the most significant bit of a in b (sign of a if a is written in 2's complement)
-- 
-- increment a
-- -> a=a+1

-- write your program here 
-- (this example computes Fibonacci sequence)
asm = [[
  write a 1
  write b 1
  add a b a
  print a
  add a b b
  print b
  goto 2
]]

instructions = {
  ["goto"] = "0000",
  ["move"] = "0001",
  ["write"] = "0000",
  ["jumpif"] = "0010",
  ["print"] = "0011",
  ["add"] = "1000",
  ["or"] = "1001",
  ["and"] = "1010",
  ["xor"] = "1011",
  ["not"] = "1100",
  ["flat"] = "1101",
  ["sign"] = "1110",
  ["increment"] = "1111",
}
addresses = {
  ["a"] = "111",
  ["b"] = "110",
  ["c"] = "101",
  ["d"] = "100",
  ["e"] = "011",
  ["f"] = "010",
  ["g"] = "001",
  ["h"] = "000",
}

function toBinary(n)
  -- Convert to hexadecimal string.
  ret = string.format('%.2x', n)

  -- Convert to binary string.
  local lookup = {
    ["0"] = "0000",
    ["1"] = "0001",
    ["2"] = "0010",
    ["3"] = "0011",
    ["4"] = "0100",
    ["5"] = "0101",
    ["6"] = "0110",
    ["7"] = "0111",
    ["8"] = "1000",
    ["9"] = "1001",
    ["a"] = "1010",
    ["b"] = "1011",
    ["c"] = "1100",
    ["d"] = "1101",
    ["e"] = "1110",
    ["f"] = "1111",
  }
  return ret:gsub(".", lookup)
end

function twosComplement(v)
  local lookup = {
    ["0"] = "1",
    ["1"] = "0",
  }

  v = toBinary(v)
  v = v:gsub(".", lookup)
  v = tonumber(v) + 1
  return toBinary(v)
end

function translateLine(line)
  -- Split the line by spaces. E.g. "write a 1" becomes {"write","a","1"}.
  local tokens = {}
  for token in line:gmatch("%S+") do
    table.insert(tokens, token)
  end

  local binInstruction = instructions[tokens[1]]
  local binAddress1 = "000"
  local binAddress2 = "000"
  local binAddress3 = "000"
	local binData = "00000000"

  if tokens[1] == "write" then
    binAddress1 = addresses[tokens[2]]

    local n = tonumber(tokens[3])
    if n >= 0 then
      binData = string.reverse(toBinary(n))
    else
      binData = string.reverse(twosComplement(-n))
    end

  elseif tokens[1] == "add"
      or tokens[1] == "or"
      or tokens[1] == "and"
      or tokens[1] == "xor" then
    binAddress1 = addresses[tokens[4]]
    binAddress2 = addresses[tokens[2]]
    binAddress3 = addresses[tokens[3]]

  elseif tokens[1] == "not"
      or tokens[1] == "flat"
      or tokens[1] == "sign"
      or tokens[1] == "move" then
    binAddress1 = addresses[tokens[3]]
    binAddress2 = addresses[tokens[2]]

  elseif tokens[1] == "jumpif"
      or tokens[1] == "print"
      or tokens[1] == "increment" then
    binAddress1 = addresses[tokens[2]]
    binAddress2 = addresses[tokens[2]]

  elseif tokens[1] == "goto" then
    if tokens[2] == "0" then
			binData = "11111111"
    else
      binData = string.reverse(toBinary(tonumber(tokens[2]) - 1))
    end
  end

  return binInstruction .. binAddress1 .. binAddress2 .. binAddress3 .. binData
end

function translateAll(asm)
  local binary = {}
  for line in asm:gmatch("([^\n]*)\n?") do
    if line ~= "" then
      table.insert(binary, translateLine(line))
    end
  end

  return binary
end

function write(asm)
  local g = golly()

  binary = translateAll(asm)
  g.open("computer.mc")
  g.duplicate()
  g.setname("programmed", 0)
  g.movelayer(1, 0)
  g.dellayer()

  g.select({-25950, 1890, 450, 240})
  g.cut()

  for i = 1, #binary do
    for j = 1, 21 do
      if binary[i]:sub(j,j) == "1" then
        g.select({
          -23639 + (i-1) * 600 + (j-1) * 300,
          2159 + (i-1) * 600 - (j-1) * 300,
          450, 240
        })
        g.clear(0)
        g.paste(
          -23639 + (i-1) * 600 + (j-1) * 300,
          2159 + (i-1) * 600 - (j-1) * 300,
          "or"
        )
      end
    end
  end
end

write(asm)
