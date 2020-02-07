# Design
ISA design.

# Table Of Contents
- [Basics](#basics)
- [Types](#types)
- [Registers](#registers)
- [Instructions](#instructions)

# Basics
**Endianess**: Little  
**Word size**: 32 bits  
**# Operands**: 3  
**Addressing Unit**: Word  
**Address Space**: 2^32  
**Memory organization**: Princeton

# Types

- 32 bit two's complement integer
- 32 bit unsigned integer
- 32 bit IEEE 754 float

# Registers
32 mixed 32-bit registers.

Referred to in assembly as `R#` where `#` is a number.  

- `R0` through `R27` are general purpose registers
- `R28`: Program counter
- `R29`: Status
- `R30`: Stack pointer
- `R31`: Return address

# Instruction
## Arithmetic Logic Unit
For both integers and floats:

- [Add](#add)
- [Subtract](#subtract)
- Divide
- Multiply
- Compare
- Shift
  - Arithmetic Right
  - Arithmetic Left
- Compare

General bit operations:

- Shift
  - Logical Right
  - Logical Left
- And
- Or
- Xor
- Not

## Add
**Assembly**:  
*There is a separate instruction for each type.*

| Type              | Mnemonic |
| ----------------- | -------- |
| Unsigned integer  | `ADDUI`  |
| Signed integer    | `ADDSI`  |
| Float             | `ADDF`   |

`MNEMONIC <DEST> <OP1> <OP2>`

**Behavior**:  
Adds two numbers and stores the result.  

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing first number
- `<OP2>`: Register containing second number

**Organization**:

`| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | register op1 (4 bits) | register op2 (4 bits)| (9 bits extra) |`

## Memory
Word based operations:

- Load
- Store
- Push
- Pop
- Move
  
## Control
- Jump on condition
- Jump unconditional
