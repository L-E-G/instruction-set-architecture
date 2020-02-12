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
	- [Load](#load)
	- [Store](#store)
	- [Push](#push)
	- [Pop](#pop)
	- [Move](#move)
  - [Control](#control)
	- [Jump](#jump)

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

## Bit Organization Syntax
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
Some registers have aliases.  

- `R0` through `R27` are general purpose registers
- `R28`, `PC`: Program counter
- `R29`, `STS`: Status, see [Status Codes](#status-codes) for details
- `R30`, `SP`: Stack pointer
- `R31`, `RA`: Return address

# Status Codes
The special status code `11111` is used to denote null status `NS`. This will 
match any of the below status codes if used as a condition code.

Status codes valid for any type:

| Binary  | Assembly | Meaning                  |
| ------  | -------- | ------------------------ |
| `00000` | `NE`     | Not equal                |
| `00001` | `E`      | Equal                    |
| `00010` | `GT`     | Greater than             |
| `00011` | `LT`     | Less than                |
| `00100` | `GTE`    | Greater than or equal to |
| `00101` | `LTE`    | Less than or equal to    |
| `00111` | `OF`     | Overflow                 |
| `01000` | `Z`      | Zero                     |
| `01001` | `NZ`     | Not zero                 |

Status codes specifically for float:

| Binary  | Assembly | Meaning       |
| ------  | -------- | ------------- |
| `01010` | `UF`     | Underflow     |
| `01011` | `NAN`    | Not a number  |
| `01100` | `NM`     | Normalized    |
| `01101` | `INF`    | Infinity      |
| `01110` | `MS`     | Mantissa sign |
| `01111` | `ES`     | Exponent sign |

# Instructions
3 instruction types:

| Type Field Binary | Type    |
| ----------------- | ------- |
| `00`              | ALU     |
| `01`              | Memory  |
| `10`              | Control |

## Arithmetic Logic Unit
**Instructions**:

36 total instructions.

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
  
**Bit Organization**:

The operation field of each ALU instruction has the following meaning:

| Binary   | Operation                                             |
| -------  | -------------                                         |
| `000001` | Add unsigned integer                                  |
| `000010` | Add signed integer                                    |
| `000011` | Add float                                             |
| `000100` | Subtract unsigned integer                             |
| `000101` | Subtract signed integer                               |
| `000110` | Subtract float                                        |
| `000111` | Divide unsigned integer                               |
| `001000` | Divide signed integer                                 |
| `001001` | Divide float                                          |
| `001010` | Multiply unsigned integer                             |
| `001011` | Multiply signed integer                               |
| `001100` | Multiply float                                        |
| -        | -                                                     |
| `001101` | Compare unsigned integer                              |
| `001110` | Compare signed integer                                |
| `001111` | Compare float                                         |
| -        | -                                                     |
| `010000` | Arithmetic shift left signed integer register direct  |
| `010001` | Arithmetic shift left float register direct           |
| `010010` | Arithmetic shift right signed integer register direct |
| `010011` | Arithmetic shift right float register direct          |
| `010100` | Arithmetic shift left signed integer immediate        |
| `010101` | Arithmetic shift left float immediate                 |
| `010110` | Arithmetic shift right signed integer immediate       |
| `010111` | Arithmetic shift right float immediate                |
| -        | -                                                     |
| `011000` | Logical shift left register direct                    |
| `011001` | Logical shift left immediate                          |
| `011010` | Logical shift right register direct                   |
| `011011` | Logical shift right immediate                         |
| -        | -                                                     |
| `011100` | And register direct                                   |
| `011101` | And immediate                                         |
| `011110` | Or register direct                                    |
| `011111` | Or immediate                                          |
| `100000` | Xor register direct                                   |
| `100001` | Xor immediate                                         |
| -        | -                                                     |
| `100010` | Not                                                   |

### Arithmetic Instructions
**Assembly**:

```
{OPERATION}{TYPE} <DEST> <OP1> <OP2>
```

4 operations * 3 types = 12 total instructions.

**Bit Organization**:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | `<OP2>` | Not Used |
| --------- | ---- | --------- | -------- | ------- | ------- | -------- |
| 5         | 2    | 6         | 5        | 5       | 5       | 4        |

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

**Bit Organization**:

| Condition | Type | Operation | `<OP1>` | `<OP2>` | Not Used |
| --------- | ---- | --------- | ------- | ------- | -------- |
| 5         | 2    | 6         | 5       | 5       | 9        |

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

**Bit Organization**:

`<OP1>` register direct:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | Not Used |
| --------- | ---- | --------- | -------- | ------- | -------- |
| 5         | 2    | 6         | 5        | 5       | 9        |

`<OP1>` immediate:

| Condition | Type | Operation | `<DEST>` | `<OP1>` |
| --------- | ---- | --------- | -------- | ------- |
| 5         | 2    | 6         | 5        | 14      |

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

- `<DEST>`: Destination register
- `<OP1>`: 14-bit immediate value or register which contains amount to shift

### Logical Shift
**Assembly**:

```
LS{DIRECTION} <DEST> <OP1>
```

2 directions * 2 addressing modes: 4 total instructions.

**Bit Organization**:

`<OP1>` register direct:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | Not Used |
| --------- | ---- | --------- | -------- | ------- | -------- |
| 5         | 2    | 6         | 5        | 5       | 9        |

`<OP1>` immediate:

| Condition | Type | Operation | `<DEST>` | `<OP1>` |
| --------- | ---- | --------- | -------- | ------- |
| 5         | 2    | 6         | 5        | 14      |

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

- `<DEST>`: Destination register
- `<OP1>`: 14-bit immediate value or register which contains amount to shift.

### 3 Operand Logic
**Assembly**:

```
{OPERATION} <DEST> <OP1> <OP2>
```

3 operations * 2 addressing modes = 8 total instructions.

**Bit Organization**:

`<OP2>` register direct:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | `<OP2>` | Not Used |
| --------- | ---- | --------- | -------- | ------- | ------- | -------  |
| 5         | 2    | 6         | 5        | 5       | 5       | 4        |

`<OP2>` immediate:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | `<OP2>` |
| --------- | ---- | --------- | -------- | ------- | ------- |
| 5         | 2    | 6         | 5        | 5       | 9       |

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

- `<DEST>`: Register result will be placed
- `<OP1>`: Register containing value to perform logic operation on
- `<OP2>`: 9-bit immediate value or register to use as second operand in 
  logic operation
  
### Not
**Assembly**:

```
NOT <DEST> <OP1>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<DEST>` | `<OP1>` | Not Used |
| --------- | ---- | --------- | -------- | ------- | -------- |
| 5         | 2    | 6         | 5        | 5       | 9        |

**Behavior**:

Inverts all the bits in `<OP1>` and stores them in `<DEST>`.

**Operands**:

- `<DEST>`: Register to store result
- `<OP1>`: Register containing value to invert


## Memory
5 total instructions.

Word based operations:

- Load ([Docs](#load))
- Store ([Docs](#store))
- Push ([Docs](#push))
- Pop ([Docs](#pop))
- Move ([Docs](#move))

**Bit Organization**:

The operation field of each memory instruction has the following meaning:

| Binary   | Operation |
| -------- | --------- |
| `000`    | Load      |
| `001`    | Store     |
| `010`    | Push      |
| `011`    | Pop       |
| `100`    | Move      |

### Load
**Assembly**:
```
LDR <DEST> <ADDR>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<DEST>` | `<ADDR>` | Not Used |
| --------- | ---- | --------- | -------- | -------- | -------- |
| 5         | 2    | 3         | 5        | 5        | 12       |

**Behavior**:

Reads a word of memory from the address specified by the `<ADDR>` register into 
the `<DEST>` register.

**Operands**:

- `<DEST>`: Register to store result
- `<ADDR>`: Register containing the memory address to access

### Store
**Assembly**:
```
STR <SRC> <ADDR>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<SRC>` | `<ADDR>` | Not Used |
| --------- | ---- | --------- | ------- | -------- | -------- |
| 5         | 2    | 3         | 5       | 5        | 12       |

**Behavior**:

Writes a word of data from the `<SRC>` register to the memory address specified
by the `<ADDR>` register.

**Operands**:

- `<SRC>`: Register containing data
- `<ADDR>`: Register containing the memory address to store data

### Push
**Assembly**:
```
PUSH <SRC>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<SRC>` | Not Used |
| --------- | ---- | --------- | ------- | -------- |
| 5         | 2    | 3         | 5       | 17       |

**Behavior**:

Writes the contents of the `<SRC>` register to the word below the stack pointer
in memory (`SP - 1`). Then sets the stack pointer register to this word.

**Operands**:

- `<SRC>`: Register containing the data to be stored on stack

### Pop
**Assembly**:
```
POP <DEST>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<DEST>` | Not Used |
| --------- | ---- | --------- | -------- | -------- |
| 5         | 2    | 3         | 5        | 17       |

**Behavior**:

Reads a word from the memory address specified by the stack pointer register
into the `<DEST>` register. Then increments the stack pointer register by one.

**Operands**:

- `<DEST>`: The destination register for data being popped off stack

### Move
**Assembly**:
```
MV <DEST> <SRC>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | Operation | `<DEST>` | `<SRC>`  | Not Used |
| --------- | ---- | --------- | -------- | -------- | -------- |
| 5         | 2    | 3         | 5        | 5        | 12       |

**Behavior**:

Transfers the contents of the `<SRC>` register to the `<DEST>` register.

**Operands**:

- `<DEST>`: The destination register
- `<SRC>`: The source register

## Control
1 total instruction.

- Jump ([Docs](#jump))

**Bit Organization**:

Since there is currently only 1 control instruction there is no operation field.

### Jump
**Assembly**:
```
<CONDITION>JMP <ADDR>
```

1 total instruction.

**Bit Organization**:

| Condition | Type | `<ADDR>` | Extra |
| --------- | ---- | -------- | ----- |
| 5         | 2    | 5        | 22    |

**Behavior**:

Only executes if the status register matches the value specified
by `<CONDITION>`. If no condition is specified defaults to null status (`NS`).

Sets the program counter register to the value stored in the `<ADDR>` register.

**Operands**:

- `<ADDR>`: Register containing new program counter value
