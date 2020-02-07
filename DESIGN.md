# Design
ISA design.

# Table Of Contents
- [Basics](#basics)
- [Instruction Types](#instruction-types)

# Basics
**Endianess**: Little  
**Word size**: 32 bits  
**Types**: Integers, floats  
**# Operands**: 3  
**Addressing Unit**: Word  
**Address Space**: 2^32  
**Memory organization**: Princeton

# Instruction Types
## Arithmetic Logic Unit
For both integers and floats:

- Add
- Subtract
- Divide
- Multiply
- Compare
- Shift
  - Right
	- Logical
    - Arithmetic
  - Left
	- Logical
    - Arithmetic
- And
- Or
- Xor
- Not
- Compare

## Memory
Word based operations:

- Load
  - Memory into register
- Store
  - Register into memory
  
## Control
- Jump on condition
- Jump unconditional
