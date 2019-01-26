-> back to [RCP Specification](RCPSpecification.md)

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
| Array | 0x25 (37) |
| List | 0x26 (38) |
| BANG | 0x27 (39) | 0 |
| group | 0x28 (40) | 0 |
| URI | 0x2a (42) | size prefixed
| IPv4 | 0x2b (43) | 4
| IPv6 | 0x2c (44) | 16
| range | 0x2d (45) |
| Image | 0x2e (46) |



### Typedefinition Boolean:

byte value:
- 0 == false
- bigger than 0 == true

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | byte | 0 | y | default value


### Typedefinition Numbers:

uint8, int8, uint16, int16, ...  Vector2f32, Vector2i32, Vector3f32, Vector3i32, ...
see type-table for all number-types.

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | of type | 0 | y | default value
| minimum | 0x31 (49) | of type | minimum of type | y | min value
| maximum | 0x32 (50) | of type | maximum of type | y | max value
| multipleof | 0x33 (51) | of type | 0 | y | multiple of value
| scale | 0x34 (52) | byte | 0 | y | one of these (0x00, 0x01, 0x02)
| unit | 0x35 (53) | string-tiny | "" | y | the unit of value

#### scale table

| Name   | hex   |
|--------|-------|
| Linear | 0x00 |
| Log | 0x01 |
| exp2 | 0x02 |

### Typedefinition Range:

range for number types: see type-table for all number-types.

range-data:
2 consecutive values of type

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | int32 | n | Number TypeDefintion of range element
| default | 0x30 (48) | range-data | element-type-default element-type-default | y | default value

### Typedefinition String: string

4-byte size-prefixed UTF-8 string

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | rcp string | 0 - | y | default value
| regular expression | 0x31 (49) | rcp string | "" | y | regular expression to define the form. e.g. limit amount of newlines in text: "\\A(?>[^\r\n]*(?>\r\n?|\n)){0,3}[^\r\n]*\\z"


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

#### rcp-array-structure:  
dimension-count followed by elements per dimension  
dimension-count: <int32>  
elements per dimension: dimension-count x <int32>  

e.g.  
3-dimensionsal array with 2 times 2 times one elements (int[2][2][1]):  
3 2 2 1

#### rcp-array-data:  
number of bytes defined by the element-type and the structure


| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | - | n | TypeDefintion of array elements (all except array, list)
| **structure** | - | rcp-array-structure | 0 | n | defines the structure of the array: number of dimensions and elements per dimensions
| default | 0x30 (48) | rcp-array-data | - | y | default value


### Typedefinition List

list-data:  
a size-prefixed list of values for each dimension recursively.

e.g.:  
[] –> 0  
[0] -> 1 0  
[a, b] -> 2 a b  
[ [a, b, c], [d, e, f] ] -> 2 3 a b c 3 d e f  
[ [a, b, c], [d, e] ] -> 2 3 a b c 2 d e


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


### Image:

#### rcp-image-data:
size prefix: int32  
image-data: bytes of one of the following image-formats: JPEG, PNG, BMP, GIF  

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| default | 0x30 (48) | rcp-image-data | - | y | default image


### Custom Type:

| Name          | ID hex/dec   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **size** | - | uint32 | - | n | byte-length of type
| default | 0x30 (48) | size-amount of bytes | - | y | default value
| uuid | 0x31 (49) | UUID: 16 bytes  | - | y | UUID of custom type. this must be unique to avoid widget-conflicts. !0
| config | 0x32 (50) | 4-byte size-prefixed byte-array | - | y | custom config, can be anything
