![Alt RCP diagram](./RCP_diagram.svg)
(RCP example to control a host application with other devices)


# RCP
Remote Control Protocol

A binary data-format definition to describe data values and user interface elements.
It is intended to expose parameters (values) from a host application to a client in a defined way. It was created with UI clients in mind which update values at the host application. It can also be used in a non-UI case.

https://github.com/rabbitControl/RCP/wiki/F.A.Q.

## RCP Levels:
- __Value__: Number, String, Color, … This is the value without visual representation
- __Widget__ (optional): Button, Slider, … This is the visual representation of a Value. A Widget must be implemented client-side. The protocol defines standard widgets for basic types. Optionally complex types can be added when needed.
- __Layout__ (optional): Placement of widgets on a screen: The Layouting of Widgets defines how widgets are placed on screen by defining standard containers.
- __Style__ (optional): Look (colors, shading, ...) of widgets on a screen: CSS styling of widgets

The first draft version of RCP only defines 1. (Values) and 2. (Widgets)

## Status

Work in progress

Request for Comments (RFC)

Join the discussion on riot:

https://riot.im/app/#/room/#rcp:matrix.org

## Endianess

The format is using big endian

## Framing

Data Framing is not scope of this protocol.

of interest. use a:
- prefix stream with magic (e.g.: 0x04 0x0F 0x05 0x09)
- SLIP RFC 1055

## Types

- string-tiny: prefixed with size [uint8] followed by [UTF-8 string-data]
- string-short: prefixed with size [uint16] followed by [UTF-8 string-data]
- string: prefixed with size [uint32] followed by [UTF-8 string-data]

## Package

| Name          | ID hex/dec   | Value           | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **command** | - | uint8 | - | n | command of package |
| id | 0x10(16) | uint32 | 0 | y | optional packet id |
| timestamp | 0x11(17) | uint64 | 0 | y | optional timestamp |
| data | 0x12(18) | - | - | y | package data. type depends on command |
| **terminator** | 0 | uint8 | 0 | n | package terminator |

note: we may want to send id/timestamp before the data, to decide if packet is valid (udp case), prefix the value with data-id. otherwise we need to parse data to get to id/timestamp

### command table:

| command   | ID   | expected data | comment   |
|-----------|------|---------------|-----------|
| version | 0x01 | Meta Data |
| init | 0x02 | - / Parameter | if no data is sent: request for all parameters, if a paramter is sent: request for one parameter
| add | 0x03 | Parameter |
| update | 0x04 |	Parameter
| remove | 0x05 | Parameter
| updateValue | 0x06 | specialized smallest update value format
| set layout? | 0x07 | Layout data
| set style? | 0x08 | Style data


- data provider ususally send: version, add, update, remove
- data clients usually send: init, update

## Meta Data

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **version** | 0x1a	(26) | tiny-string | "" | n | semver
| **capabilities** | 0x1b (27) | 1-byte | 1 | n | capabilities of RCP
| **commands** | 0x1c (28) | 1-byte | 0 | n | (max 8 commands enough?) |
| **terminator** | 0 | 1 byte | 0 | n | terminator

### capabilities (0x1b) (1 byte)

| Bit 7   | Bit 6   | Bit 5   | Bit 4   | Bit 3   | Bit 2   | Bit 1   | Bit 0   |
|---------|---------|---------|---------|---------|---------|---------|---------|
|-|-|-|-| Style | Layout | Widget | Value |

### commands (0x1c) (1 byte)

| Bit 7   | Bit 6   | Bit 5   | Bit 4   | Bit 3   | Bit 2   | Bit 1   | Bit 0   |
|---------|---------|---------|---------|---------|---------|---------|---------|
|-|-| updateValue | remove | update | add | init | version |


## Parameter:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **id** | - | uint32 | 0 | n | unique identifier
| **type** |	- | TypeDefinition | - | n | typedefinition of value
| value | 0x20 (32) | known from typedefinition | ? | y |	value (length is known by type!)
| label | 0x21 (33)	| string-tiny | "" | y | Human readable identifier
| desc | 0x22 (34) | string-short | "" | y | can be shown as a tooltip
| order | 0x23 (35)	|	int32 | 0 | y | allows for most simple layout
| parent | 0x24 (36)	|	uint32 | 0 | y | specifies another parameterGroup as parent.
| widget | 0x25 (37) | widget data | text-input-widget | y | if not specified a default widget is used
| userdata | 0x26 (38) | size of value (uint32) followed by userdata | - | y | various user-data. e.g.: metadata, tags, ...
| terminator | 0 | 1 byte | 0 | n | terminator


## ParameterGroup:

A ParameterGroup is a Parameter without value/defaultValue and a fixed TypeDefintion (group).

A ParameterGroup allows to structure your parameters and can be used to discover parameters on different levels.


## Typedefinition:


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **datatype** | - |  uint8 (see datatype table) | 0x2f | n | type of value
| ... type options... | | ||||
| **terminator** | 0 | uint8 | 0 | n | terminator


### Datatypes: (1byte)

| datatype   | hex (dec)   | length (bytes)   |
| -----------|-------------|------------------|
| boolean | 0x10 (16) | 1 |
| int8 | 0x11 (17) | 1 |
| uint8 | 0x12 (18) | 1 |
| int16 | 0x13	(19) | 2 |
| uint16 | 0x14 (20) | 2 |
| int32 | 0x15	(21) | 4 |
| uint32 | 0x16	(22) | 4 |
| int64 | 0x17 (23) | 8 |
| uint64 | 0x18	(24) | 8 |
| float32 | 0x19 (25) | 4 |
| float64 | 0x1a (26) | 8 |
| Vector2i8 | 0x1b | 2 x 1 |
| Vector2i16 | 0x1c | 2 x 2 |
| Vector2i32 | 0x1d | 2 x 4 |
| Vector2i64 | 0x1e | 2 x 8 |
| Vector2f32 | 0x1f | 2 x 4 |
| Vector2f64 | 0x20 | 2 x 8 |
| Vector3i8 | 0x21 | 3 x 1 |
| Vector3i16 | 0x22 | 3 x 2 |
| Vector3i32 | 0x23 | 3 x 4 |
| Vector3i64 | 0x24 | 3 x 8 |
| Vector3f32 | 0x25 | 3 x 4 |
| Vector3f64 | 0x26 | 3 x 8 |
| Vector4i8 | 0x27 | 4 x 1 |
| Vector4i16 | 0x28 | 4 x 2 |
| Vector4i32 | 0x29 | 4 x 4 |
| Vector4i64 | 0x2a | 4 x 8 |
| Vector4f32 | 0x2b | 4 x 4 |
| Vector4f64 | 0x2c | 4 x 8 |
| String-tiny | 0x2d |
| String-short | 0x2e |
| String | 0x2f |
| RGB | 0x30 (48) |
| RGBA | 0x31 (49) |
| Enum | 0x32 |
| fixed Array | 0x33 |
| dynamic Array | 0x34 |
| Dict/Map | 0x35 |
| Image | 0x36 | ? |
| BANG | 0x37 | 0 |
| timetag | 0x38 | 8 |
| group | 0x39 | 0 |
| compound | 0x3a | ? |
| bin8? | |
| bin16? | |
| bin32? | |



## Typedefinition Boolean:

uint8 value:
- 0 == false
- bigger than 0 == true

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | uint8 | 0 | y | default value


## Typedefinition Numbers: uint8, int8, uint16, int16, ...

see type-table for all number-types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | of type | 0 | y | default value
| min | 0x31 (49) | of type | 0 | y | min value
| max | 0x32 (50) | of type | 0 | y | max value
| multipleof | 0x33 (51) | of type | 0 | y | multiple of value
| scale | 0x34 (52) | uint8 | 0 | < | one of these (0x00, 0x01, 0x02)
| unit | 0x35 (53) | string-tiny | "" | y | the unit of value

## Typedefinition Vector: Vector2f32, Vector2i8, Vector4f32, ...

VectorXY

where X specifies the size

where Y specifies the type

see type-table for a full list of available Vector-types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | X times Y | 0 | y | default value
| min | 0x31 (49) | X times Y | 0 | y | min value
| max | 0x32 (50) | X times Y | 0 | y | max value
| multipleof | 0x33 (51) | X times Y | 0 | y | multiple of value
| scale | 0x34 (52) | uint8 | 0 | < | one of these (0x00, 0x01, 0x02)
| unit | 0x35 (53) | string-tiny | "" | y | the unit of value

### scale table

| Name   | hex   |
|--------|-------|
| Linear | 0x00 |
| Log | 0x01 |
| exp2 | 0x02 |

## Typedefinition String: string, string-tiny, string-short

size-prefixed UTF-8 string

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | string (-tiny, -short) | 0 - | y | default value


## Typedefinition Color: RGB, RGBA

Colors are in byte-order with 8-bits per channel

e.g. RGBA:

Red: 0xFF 0x00 0x00 0xFF

Green: 0x00 0xFF 0x00 0xFF

Blue: 0x00 0x00 0xFF 0xFF


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | uint32 | 0 | y | default value


## Typedefinition Enum

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | enum | 0 | y | default value
| entries | 0x31 (49) | uint16 number followed by <number> string-tiny | 0 | y | list of enumerations


## Typedefinition fixed Array

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **subtype** | - | TypeDefinition | StringType | n | TypeDefintion of array elements
| **length** | - | uint32 | 0 | n | length of fixed array
| default | 0x30 (48) | fixed array of subtype | - | y | default value


## Typedefinition dynamic Array

length-prefixed values of subtype.

e.g.: <length uint32> value value value

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **subtype** | - | TypeDefinition | StringType | n | TypeDefintion of array elements
| default | 0x30 (48) | dynamic array of subtype | 0 - | y | default value


## Typedefinition Compound

A compound type is a combination of other known types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **subtypes** | - | dynamic array of TypeDefinition | 0 | n | TypeDefintion of array elements
| default | 0x30 (48) | listing of values defined by subtypes | - | y | default value


## Widget (0x24):

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| type | 0x50 (80) | uint16 | text input | y | type of widget.  see widget type-table
| enabled | 0x51 (81) | uint8 | true | y | if widget allows user input
| visible | 0x52 (82) |	uint8 | true | y | if widget is visible
| label-visible | 0x53	(83) | uint8 | true | y | if label is visible
| value-visible | 0x54 (84) | uint8 | true | y | if value is visible
| label-position | 0x55 (85) | uint8 | 0 | y | see label-position table
| **terminator** | 0 | uint8 | 0 | n | terminator

### Widget type table:

| typename   | hex   |
|------------|-------|
| Textbox | 0x10 |
| Numberbox | 0x11 |
| Button | 0x12 |
| Checkbox | 0x13 |
| Radiobutton | 0x14 |
| Slider | 0x15 |
| Dial | 	0x16 |
| Colorbox | 0x17 |
| Table | 0x18 |
| Treeview | 0x19 |
| Dropdown | 0x1a |
| XYField | 0x1b |

### label-position table:

| typename   | hex   |
|------------|-------|
| left | 0x00 |
| right | 0x01 |
| top | 0x02 |
| bottom | 0x03 |
| center | 0x04 |


## updateValue

to optimize the update of the value of a parameter, there is a specialized updateValue command in the form:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| command       | 0x06         | uint8          | -               | n | updateValue command
| parameter id  |              | uint32          | 0               | n | parameter id
| type id       |              | uint8          | 0               | n | type-id
| value         |              | type of type-id  | ?               | n | the value

this reduces the amount of data to be sent for a simple value udpate.

e.g.:

updating a int32 with id 01 to value 255:

0x06 0x00 0x00 0x00 0x01 0x15 0x00 0x00 0x00 0xFF (10 bytes)
