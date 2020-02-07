# Design
ISA design.

# Table Of Contents
- [Documentation Syntax](#documentation-syntax)
- [Fundamentals](#fundamentals)
- [Types](#types)
- [Registers](#registers)
- [Status Codes](#status-codes)
- [Instructions](#instructions)
  - [Arithmetic Logic Unit](#arithmetic-logic-unit)
	- [Add, Subtract, Divide, Multiply](#arithmetic-instructions)
	- [Compare](#compare)
	- [Arithmetic Shift Left / Right](#arithmetic-shift)
	- [Logical Shift Left / Right](#logical-shift)
	- [And, Or, Xor](#3-operand-logic)
	- [Not](#not)
  - [Memory](#memory)
  - [Control](#control)

# Documentation Syntax
## Assembly Documentation Syntax
Instruction assembly is documented using the following syntax:

- A word in curly brackets signifies a variation of an instruction's mnemonic. 
  A table will be present which specifies valid values, the curly brackets and 
  their contents should be replaced with one of these values.
  - Example:  
	```
	DO{OPERATION}
	```
	
	`{OPERATION}` indicates that part of the mnemonic must be replaced
	by a value from the `{OPERATION}` table below.
	
	| `{OPERATION}` | Operation |
	| ------------- | --------- |
	| `F`           | Foo       |
	| `B`           | Bar       |

	For example a mnemonic of `DOF` indicates that the "Foo" operation should 
	take place.
- A word in angle brackets signifies an instruction operand. Look for the 
  "operands" section of the instruction documentation for more detail.
  - Example:  
	```
	DO <DEST> <OP1> <OP2>
	```
	
	In the above `<DEST>`, `<OP1>`, and `<OP2`> are all operands which should be
	replaced by operand values when writing assembly.

	For example the assembly line `DO R1 R2 R3` has a `<DEST>` operand value of 
	`R1`, a `<OP1>` operand value of `R2`, and a `<OP2>` operand value of `R3`.

## Bit Organization
Instructions have a bit organization section which details the binary format of 
the instruction itself.  

The format of this section is a table, where the top header row indicates the 
purpose of the bits, and the box directly beneath each item in the header row
indicates how many bits are reserved for the described purpose.

The leftmost part of the table represents the least significant bits, and the
rightmost part of the table represents the most significant bits.

Example:

| Type | Operation | `<DEST>` | `<OP1>` | `<OP2>` |
| ---- | --------- | -------- | ------- | ------- |
| 4    | 6         | 4        | 8       | 2       |

Indicates that the "Type" field takes up 4 bits, the "Operation" field takes up
6 bits, the `<DEST>` field takes up 4 bits, and so on.

The binary number:

```
MSB                  LSB
|                      |
v                      v
101011001011110100011001
```

Would translate to the following values for the fields defined in the example:

| Field     | Value      |
| --------- | ---------- |
| Type      | `1001`     |
| Operation | `010001`   |
| `<DEST>`  | `1111`     |
| `<OP1>`   | `10110010` |
| `<OP2>`   | `10`       |

# Fundamentals
**Endianess**: Little  
**Word size**: 32 bits  
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

# Instructions
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

**Bit Organization**:

| Condition | Type | Opcode | Dest | OP1 | OP2 | Extra |
| --------- | ---- | ------ | ---- | --- | --- | ----- |
| 4         | 2    | 5      | 4    | 4   | 4   | 9     |

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

8 bits available for immediate/register fields.

- `<DEST>`: Register to store result
- `<OP1>`: Register containing first number
- `<OP2>`: Register containing second number

### Compare
**Assembly**:

```
CMP{TYPE} <OP1> <OP2>
```

3 types = 3 total instructions.

**Organization**:
```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | immediate op1 (8 bits) | immediate op2 (8 bits)| (1 bits extra) |
```

**Behavior**:

Compares `<OP1>` to `<OP2>` and stores the result in the status register.  

Each operand must be the same type, which is specified by appending `{TYPE}`:

| `{TYPE}` | Type             |
| -------- | ---------------- |
| `UI`     | Unsigned integer |
| `SI`     | Signed integer   |
| `F`      | Float            |

**Operands**:

8 bits available for immediate/register fields.

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

**Organization**:

```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | immediate op1 (8 bits) | (9 bits extra) |
```

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

8 bits available for immediate/register fields.

- `<DEST>`: Destination register
- `<OP1>`: x-bit immediate value or register which contains amount to shift.

### Logical Shift
**Assembly**:

```
LS{DIRECTION} <DEST> <OP1>
```

2 directions * 2 addressing modes: 4 total instructions.

**Organization**:

```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | immediate op1 (8 bits) | (9 bits extra) |
```

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

8 bits available for immediate/register fields

- `<DEST>`: Destination register
- `<OP1>`: x-bit immediate value or register which contains amount to shift.

### 3 Operand Logic
**Assembly**:

```
{OPERATION} <DEST> <OP1> <OP2>
```

3 operations * 2 addressing modes = 8 total instructions.

**Organization**:

```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | immediate op1 (8 bits) | immediate op2 (8 bits) | (1 bits extra) |
```

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

8 bits for immediate/register fields

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

**Organization**:

```
| condition (4 bits) | instruc. type (2 bits) | Opcode (5 bits) | register dest. (4 bits) | immediate op1 (4 bits) | (13 bits extra) |
```

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
