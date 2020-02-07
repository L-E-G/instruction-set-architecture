# Design
ISA design.

# Table Of Contents
- [Basics](#basics)
- [Registers](#registers)
- [Instructions](#instructions)

# Basics
**Endianess**: Little  
**Word size**: 32 bits  
**Types**: Integers, floats  
**# Operands**: 3  
**Addressing Unit**: Word  
**Address Space**: 2^32  
**Memory organization**: Princeton

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

- Add ([Integer](#integer-add), [Float](#float-add))
- Subtract
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

## Integer Add
**Assembly**: `ADD <DEST> <OP1> <OP2>`  

**Behavior**:  
Adds two integers and stores the result.  
`<DEST> = <OP1> + <OP2>`

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing first integer
- `<OP2>`: Register containing second integer

## Float Add
**Assembly**: `ADD <DEST> <OP1> <OP2>`  

**Behavior**:  
Adds two floats and stores the result.  
`<DEST> = <OP1> + <OP2>`

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing first float
- `<OP2>`: Register containing second float

## Memory
Word based operations:

- Load
- Store
- Push
- Pop
  
## Control
- Jump on condition
- Jump unconditional
