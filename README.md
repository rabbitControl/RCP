![Alt RCP diagram](./RCP_diagram.svg)
(RCP example to control a host application with other devices)


# RCP
Remote Control Protocol

A binary data-format definition to describe data values and user interface elements.
It is intended to expose parameters (values) from a host application to a client in a defined way. It was created with UI clients in mind which update values at the host application. It can also be used in a non-UI case.

[F.A.Q.](https://github.com/rabbitControl/RCP/wiki/F.A.Q.)

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
- multilanguage: list of: [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code (3-bytes in ascii) followed by string-tiny, string-short or string. list is terminated with 0. additional to the ISO 639-3 codes we define a special code for no specific language: "any"

## Package

| Name          | ID hex/dec   | Value           | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **command** | - | byte | - | n | command of package |
| timestamp | 0x11(17) | uint64 | 0 | y | optional timestamp |
| data | 0x12(18) | - | - | y | package data. type depends on command |
| **terminator** | 0 | byte | 0 | n | package terminator |

note: we may want to send id/timestamp before the data, to decide if packet is valid (udp case), prefix the value with data-id. otherwise we need to parse the data before to get id/timestamp

chaining Parameters: data can contain more than one Parameter.

### command table:

| command   | ID   | expected data | comment   |
|-----------|------|---------------|-----------|
| version | 0x01 | Version Data |
| initialize | 0x02 | null or ID Data | if no data is sent: request for all parameters. sends update command(s) to client.
| discover | 0x03 | null or ID Data | if no data is sent: request for all parameters. parameters are sent without typdedefinition-options, without value and userdata. discover only discovers on level, no subgroups are discovered. sends update command(s) to client.
| update | 0x04 |	Parameter
| remove | 0x05 | Parameter
| updatevalue | 0x06 | specialized smallest update-value format


- data provider ususally send: version, add, update, updateValue, remove
- data clients usually send: discover, initialize, update, updateValue


## ID Data

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **id**         | - | int16  | 0 | n | id of parameterGroup or Parameter
| **terminator** | 0 | 1 byte | 0 | n | terminator



## Version Data

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| version       | 0x1a	(26)   | tiny-string    | "" | y | semver
| **terminator** | 0 | 1 byte | 0 | n | terminator


## Parameter:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **id** | - | int16 | - | n | unique identifier (can not be 0. see: parent)
| **typedefinition** |	- | TypeDefinition | - | n | typedefinition of value
| value | 0x20 (32) | known from typedefinition | ? | y |	value (length is known by type!)
| label | 0x21 (33)	| multilanguage string-tiny | "" | y | Human readable identifier
| description | 0x22 (34) | multilanguage string-short | "" | y | can be shown as a tooltip
| tags | 0x23 (35)	|	string-tiny | "" | y | space separated list of tags
| order | 0x24 (36)	|	int32 | 0 | y | allows for most simple layout
| parentid | 0x25 (37)	|	int16 | 0 | y | specifies another parameterGroup as parent.
| widget | 0x26 (38) | widget data | text-input-widget | y | if not specified a default widget is used
| userdata | 0x27 (39) | size-prefixed bytearray | - | y | various user-data. e.g.: metadata, tags, ...
| userid | 0x28 (40) | string-tiny | "" | y | user id
| terminator | 0 | 1 byte | 0 | n | terminator


## ParameterGroup:

A ParameterGroup is a Parameter without value/defaultValue and a fixed TypeDefintion (group).

A ParameterGroup allows to structure your parameters and can be used to discover parameters on different levels.

A Parameter can only be child of excactly one group.


## Root Parameter Group

This parameter group is a virtual Parameter-group which does always exist.
It defines the highes level in the hirarchy tree.

The id of the root-group is 0.

No other Parameter is allowed to have this id.



## Typedefinition:


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **datatype** | - |  byte (see datatype table) | 0x2f | n | type of value
| ... type options... | | ||||
| **terminator** | 0 | byte | 0 | n | terminator


### Datatypes: (1byte)

| datatype   | hex (dec)   | length (bytes)   |
| -----------|-------------|------------------|
| custom type | 0x01 (1) | defined by typedef |
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
| Vector2i32 | 0x1b | 2 x 4 |
| Vector2f32 | 0x1c | 2 x 4 |
| Vector3i32 | 0x1d | 3 x 4 |
| Vector3f32 | 0x1e | 3 x 4 |
| Vector4i32 | 0x1f | 4 x 4 |
| Vector4f32 | 0x20 | 4 x 4 |
| String | 0x21 | size prefixed
| RGB | 0x22 (34) |
| RGBA | 0x23 (35) |
| Enum | 0x24 (36) |
| fixed Array | 0x25 (37) |
| dynamic Array | 0x26 (38) |
| BANG | 0x27 (39) | 0 |
| group | 0x28 (40) | 0 |
| URI | 0x2a (42) | size prefixed
| IPv4 | 0x2b (43) | 4
| IPv6 | 0x2c (44) | 16
| range | 0x2d (45) |



### Typedefinition Boolean:

byte value:
- 0 == false
- bigger than 0 == true

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | byte | 0 | y | default value


### Typedefinition Numbers:

uint8, int8, uint16, int16, ...  
see type-table for all number-types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | of type | 0 | y | default value
| minimum | 0x31 (49) | of type | minimum of type | y | min value
| maximum | 0x32 (50) | of type | maximum of type | y | max value
| multipleof | 0x33 (51) | of type | 0 | y | multiple of value
| scale | 0x34 (52) | byte | 0 | y | one of these (0x00, 0x01, 0x02)
| unit | 0x35 (53) | string-tiny | "" | y | the unit of value


### Typedefinition Range:

range for number types: see type-table for all number-types.

range-data:
2 consecutive values of type

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | int32 | n | Number TypeDefintion of range element
| default | 0x30 (48) | range-data | element-type-default element-type-default | y | default value



### Typedefinition Vector: Vector2f32, Vector2i8, Vector4f32, ...

VectorXY  
where X specifies the size  
where Y specifies the type

see type-table for a full list of available Vector-types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | X times Y | 0 | y | default value
| minimum | 0x31 (49) | X times Y | 0 | y | min value
| maximum | 0x32 (50) | X times Y | 0 | y | max value
| multipleof | 0x33 (51) | X times Y | 0 | y | multiple of value
| scale | 0x34 (52) | byte | 0 | y | one of these (0x00, 0x01, 0x02)
| unit | 0x35 (53) | string-tiny | "" | y | the unit of value

#### scale table

| Name   | hex   |
|--------|-------|
| Linear | 0x00 |
| Log | 0x01 |
| exp2 | 0x02 |

### Typedefinition String: string

4-byte size-prefixed UTF-8 string

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | rcp string | 0 - | y | default value
| regular expression | 0x31 (49) | rcp string | "" | y | regular expression to define the form. e.g. limit amount of newlines in text: "\\A(?>[^\r\n]*(?>\r\n?|\n)){0,3}[^\r\n]*\\z"


### Typedefinition Color: RGB, RGBA

Colors are in byte-order with 8-bits per channel

e.g. RGBA:  
Red: 0xFF 0x00 0x00 0xFF  
Green: 0x00 0xFF 0x00 0xFF  
Blue: 0x00 0x00 0xFF 0xFF


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | int32 | 0 | y | default value



### Typedefinition Enum

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | string-tiny | value 0 means: first-element | y | default value
| entries | 0x31 (49) | list of string-tiny, terminated with 0 (0-length string-tiny) | 0 | y | list of enumerations
| multiselect | 0x32 (50) | boolean | false | y | allow multiple selections or not


### Typedefinition Array

array-structure:  
dimension-count followed by elements per dimension  
dimension-count: <int32>  
elements per dimension: dimension-count x <int32>  

e.g.  
3-dimensionsal array with 2 times 2 times one elements (int[2][2][1]):  
3 2 2 1

array-data:  
array-structure followed by number of bytes defined by the element-type and the array-structure


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | StringType | n | TypeDefintion of array elements (all except array, list)
| default | 0x30 (48) | array-data | - | y | default value
| structure | 0x31 (49) | array-structure | 0 | y | defines the structure of the array: number of dimensions and elements per dimensions



### Typedefinition List

list-data:  
a size-prefixed list of values for each dimension recursively.

e.g.:  
[] –> 0  
[0] -> 1 0  
[a, b] -> 2 a b  
[[a, b, c], [d, e, f]] -> 2 3 a b c 3 d e f  
[[a, b, c], [d, e]] -> 2 3 a b c 2 d e


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | StringType | n | TypeDefintion of array elements (all except array, list)
| default | 0x30 (48) | list-data | 0 | y | default value
| minimum | 0x32 | one-dimensional list of <int32> | 0 | y | minimum length of list per dimension. if minimum length of a dimension is not specified, then the minimum length is 0.
| maximum | 0x33 | one-dimensional list of <int32> | 0 | y | maximum length of list per dimension. if maximum length of a dimension is not specified, then the maximum length is max-int.
 

### URI:

size-prefixed UTF-8 string forming an URI

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | string | 0 - | y | default value
| filter | 0x31 (49) | string-tiny | - | y | empty (all files), "dir" or a file-filter as defined [here](https://msdn.microsoft.com/en-us/library/system.windows.forms.filedialog.filter(v=vs.110).aspx).
| schema | 0x32 (50) | string-tiny | - | y | space-seperated list with allowed schemas. e.g. "file ftp http https"


### IPv4:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | 4 bytes | - | y | default value


### IPv6:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | 16 bytes | - | y | default value


### Custom Type:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **size** | - | uint32 | - | n | byte-length of type
| default | 0x30 (48) | size-amount of bytes | - | y | default value
| uuid | 0x31 (49) | UUID: 16 bytes  | - | y | UUID of custom type. this must be unique to avoid widget-conflicts. !0
| config | 0x32 (50) | 4-byte size-prefixed byte-array | - | y | custom config, can be anything


## Widget (0x24):

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **type** | 0x50 (80) | uint16 | 0x0011: textbox | n | type of widget. see widget type-table and widget options
| enabled | 0x51 (81) | byte | true | y | if widget allows user input
| visible | 0x52 (82) |	byte | true | y | if widget is visible
| label-visible | 0x53	(83) | byte | true | y | if label is visible
| value-visible | 0x54 (84) | byte | true | y | if value is visible
| label-position | 0x55 (85) | byte | 0 | y | see label-position table
| **terminator** | 0 | byte | 0 | n | terminator

### Widget type table:

| typename   | hex   | description
|------------|-------|--------------|
| Custom Widget | 0x0001 | a custom widget
| Info | 0x0010 | For discovery: only shows datatype, label. groupParameters are collapsable
| Textbox | 0x0011 |
| Bang | 0x0012 |
| Press | 0x0013 |
| Toggle | 0x0014 |
| Numberbox | 0x0015 |
| Dial | 	0x0016 |
| Slider | 0x0017 |
| Slider2d | 0x0018 |
| Range | 0x0019 |
| Dropdown | 0x001a |
| Radiobutton | 0x001b |
| Colorbox | 0x001c |
| Table | 0x001d |
| Filechooser | 0x001e |
| Directorychooser | 0x001f |
| IP | 0x0020 |
| List | 0x8000 | Layouting Widget for Groups
| Listpage | 0x8001 | Layouting Widget for Groups
| Tabs | 0x8002 | Layouting Widget for Groups

### label-position table:

| typename   | hex   |
|------------|-------|
| left | 0x01 |
| right | 0x02 |
| top | 0x03 |
| bottom | 0x04 |
| center | 0x05 |


### Textbox:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| multiline | 0x56 (86) | boolean | false | y | enable/disable multiline textfield
| wordwrap | 0x57 (87) | boolean | false | y | enable/disable word wrap
| password | 0x58 (88) | boolean | false | y | enable/disable if testbox is a password input


### Numberbox:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| precision | 0x56 (86) | uint8 | 2 | y | set precision for numberbox
| format | 0x57 (87) | uint8 | 0x01 | y | set format of numberbox: dec/hex/bin
| stepsize | 0x58 (88) | T of value | if Value.multipleof > 0, then value.multipleof. Else dependent on value.subtype: If real: 0.01. If int: 1 | y | a value always must be within it’s definition. Therefore If stepsize collides with value.multipleof, then value.multipleof is used: to keep value within it’s defintion.
| cyclic | 0x59 (89) | boolean | false | y | inspector should wrap around value

## format table:

| typename   | hex   |
|------------|-------|
| dec | 0x01 |
| hex | 0x02 |
| bin | 0x03 |


### BangButton:
- fires on press

### ToggleButton (Checkbox):
- Switch: toggles it's state on each press

### PressButton:
- onPress sends 1, onRelease sends 0


### Radiobutton:


### Slider:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| horizontal | 0x56 (86) | boolean | true | y | if slider is horizontal


### Dial:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| cyclic | 0x56 (86) | boolean | false | y | if dial is cyclic


### Colorbox:

### Table:
work-in-progress:
option: labels for dimensions: array of labels

### Dropdown:

### Range:
```
min		             max
|----------------------------|
      |------|
      v1     v2
```

### Custom Widget:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| uuid          | 0x56 (86) | UUID: 16-byte     | 0 | y | UUID of custom widget. this must be unique to avoid widget-conflicts. !0
| config        | 0x57 (87) | 4-byte size-prefixed byte-array | - | y | custom config, can be anything


## updateValue

to optimize the update of the value of a parameter, there is a specialized updateValue command in the form:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| command       | 0x06         | byte           | -               | n | updateValue command
| parameter id  |              | int16          | 0               | n | parameter id
| mandatory part of datatype   |              | byte           | 0               | n | datatype
| value         |              | type of datatype  | ?               | n | the value

this reduces the amount of data to be sent for a simple value udpate.

e.g.:

updating a int32 with id 0x01 to value 255:

0x06 0x01 0x01 0x15 0x00 0x00 0x00 0xFF (8 bytes)
