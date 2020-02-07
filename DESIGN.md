# Design
ISA design.

# Table Of Contents
- [Documentation Syntax](#documentation-syntax)
- [Fundamentals](#fundamentals)
- [Types](#types)
- [Registers](#registers)
- [Status Codes](#status-codes)
- [Instructions](#instructions)

# Documentation Syntax
## Assembly Documentation Syntax
Instruction assembly is documented using the following syntax:

- A word in curly brackets signifies a variation of an instruction's mnemonic. 
  A table will be present which specifies valid values, the curly brackets and 
  their contents should be replaced with one of these values.
- A word in angle brackets signifies an instruction operand

# Fundamentals
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
- `R29`: Status, see [Status Codes](#status-codes) for details
- `R30`: Stack pointer
- `R31`: Return address

# Status Codes

Status codes valid for any type:

| Binary | Assembly | Meaning                  |
| ------ | -------- | ------------------------ |
| `0000` | `NE`     | Not equal                |
| `0001` | `E`      | Equal                    |
| `0010` | `GT`     | Greater than             |
| `0011` | `LT`     | Less than                |
| `0100` | `GTE`    | Greater than or equal to |
| `0101` | `LTE`    | Less than or equal to    |
| `0111` | `OF`     | Overflow                 |
| `1000` | `Z`      | Zero                     |
| `1001` | `NZ`     | Not zero                 |

Status codes specifically for float:

| Binary | Assembly | Meaning       |
| ------ | -------- | ------------- |
| `1010` | `UF`     | Underflow     |
| `1011` | `NAN`    | Not a number  |
| `1100` | `NM`     | Normalized    |
| `1101` | `INF`    | Infinity      |
| `1110` | `MS`     | Mantissa sign |
| `1111` | `ES`     | Exponent sign |

# Instruction
## Arithmetic Logic Unit
Typed arithmetic instructions ([Docs](#arithmetic-instructions)):

- Add
- Subtract
- Divide
- Multiply

Typed general instructions:

- Compare ([Docs](#compare))
- Shift ([Docs](#arithmetic-shift))
  - Arithmetic Right
  - Arithmetic Left

Untyped general instructions:

- Shift ([Docs](#logical-shift))
  - Logical Right
  - Logical Left
- 3 operand logic ([Docs](#3-operand-logic))
  - And
  - Or
  - Xor
- 2 operand logic
  - Not ([Docs](#not))

### Arithmetic Instructions
**Assembly**:

```
{OPERATION}{TYPE} <DEST> <OP1> <OP2>
```

4 operations * 3 types = 12 total instructions.

**Organization**:

```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | register op1 (4 bits) | register op2 (4 bits)| (9 bits extra) |
```

**Behavior**:

Performs a basic arithmetic operation, determine by `{OPERATION}`:

| `{OPERATION}` | Behavior        |
| ------------- | --------------- |
| `ADD`         | `<OP1> + <OP2>` |
| `SUB`         | `<OP1> - <OP2>` |
| `DIV`         | `<OP1> / <OP2>` |
| `MLT`         | `<OP1> * <OP2>` |

Each operand must be the same type, which is specified by appending `{TYPE}`:

| `{TYPE}` | Type             |
| -------- | ---------------- |
| `UI`     | Unsigned integer |
| `SI`     | Signed integer   |
| `F`      | Float            |

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing first number
- `<OP2>`: Register containing second number

### Compare
**Assembly**:

```
CMP{TYPE} <OP1> <OP2>
```

3 types = 3 total instructions.

**Behavior**:

Compares `<OP1>` to `<OP2>` and stores the result in the status register.  

Each operand must be the same type, which is specified by appending `{TYPE}`:

| `{TYPE}` | Type             |
| -------- | ---------------- |
| `UI`     | Unsigned integer |
| `SI`     | Signed integer   |
| `F`      | Float            |

**Operands**:

- `<OP1>`: Register containing first number to compare, on the left hand side of
  the comparison
- `<OP2>`: Register containing number to compare to `<OP1>`, on the right hand 
  side of the comparison
  
### Arithmetic Shift
**Assembly**:

```
AS{DIRECTION}{TYPE} <DEST> <OP1>
```

2 directions * 2 types * 2 addressing modes: 8 total instructions.

**Behavior**:

Performs an arithmetic shift (respects the sign of the number) on `<OP1>` and 
stores the result in `<DEST>`.

`<OP1>` can either be an immediate value or a register.  

The direction bits are shifted is specified by `{DIRECTION}`:

| `{DIRECTION}` | Direction |
| ------------- | --------- |
| `L`           | Left      |
| `R`           | Right     |

The type of `<OP1>` is specified by appending `{TYPE}`:

| `{TYPE}` | Type             |
| -------- | ---------------- |
| `I`      | Signed integer   |
| `F`      | Float            |

**Operands**:

TODO: Document how many bits are available for immediate values.

- `<DEST>`: Destination register
- `<OP1>`: x-bit immediate value or register which contains amount to shift.

### Logical Shift
**Assembly**:

```
LS{DIRECTION} <DEST> <OP1>
```

2 directions * 2 addressing modes: 4 total instructions.

**Behavior**:

Performs a logical shift (ignores the sign of the number) on `<OP1>` and 
stores the result in `<DEST>`.

`<OP1>` can either be an immediate value or a register.  

The direction bits are shifted is specified by `{DIRECTION}`:

| `{DIRECTION}` | Direction |
| ------------- | --------- |
| `L`           | Left      |
| `R`           | Right     |

**Operands**:

TODO: Document how many bits are available for immediate values.

- `<DEST>`: Destination register
- `<OP1>`: x-bit immediate value or register which contains amount to shift.

### 3 Operand Logic
**Assembly**:

```
{OPERATION} <DEST> <OP1> <OP2>
```

3 operations * 2 addressing modes = 8 total instructions.

**Behavior**:

Performs a logic operation on `<OP1>` and `<OP2>` and stores the result in the
`<DEST>` register. 

If `<OP2>` is an immediate value it will be padded with `0`'s to be 32 bits.

The logic operation is specified by `{OPERATION}`:

| `{OPERATION}` | Operation |
| ------------- | --------- |
| `AND`         | And       |
| `OR`          | Or        |
| `NOT`         | Not       |

**Operands**:

TODO: Document how many bits are available for immediate values.

- `<DEST>`: Register result will be placed
- `<OP1>`: Register containing value to perform logic operation on
- `<OP2>`: x-bit immediate value or register to use as second operand in 
  logic operation
  
### Not
**Assembly**:

```
NOT <DEST> <OP1>
```

1 total instruction.

**Behavior**:

Inverts all the bits in `<OP1>` and stores them in `<DEST>`.

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing value to invert

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
