back to: [RCP Specification](RCPSpecification.md)  
jump to: [RCP Widget](RCPWidget.md)


## Typedefinition:

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **datatype** | - |  byte | 0x2f | n | The type of the value - see datatype table.
| ... type options... | | | | | Options for the type. |
| **terminator** | 0 | byte | 0 | n | Terminator


### Datatype table:

| Datatype   | hex&nbsp;(dec)   | Length (bytes)   |
| -----------|------------------|------------------|
| custom type | 0x01 (1) | Defined by type definition. |
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
| Vector2i32 | 0x1b (27) | 2 x 4 |
| Vector2f32 | 0x1c (28) | 2 x 4 |
| Vector3i32 | 0x1d (29) | 3 x 4 |
| Vector3f32 | 0x1e (30) | 3 x 4 |
| Vector4i32 | 0x1f (31) | 4 x 4 |
| Vector4f32 | 0x20 (32) | 4 x 4 |
| String | 0x21 (33) | string-long
| RGB | 0x22 (34) | 4 |
| RGBA | 0x23 (35) | 4 |
| Enum | 0x24 (36) | Array of string-short |
| Array | 0x25 (37) | Defined by array-structure |
| List | 0x26 (38) |
| Bang | 0x27 (39) | 0 |
| Group | 0x28 (40) | 0 |
| URI | 0x2a (42) | string-long |
| IPv4 | 0x2b (43) | 4 |
| IPv6 | 0x2c (44) | 16 |
| Range | 0x2d (45) | 2 x number-type-size|
| Image | 0x2e (46) | size-prefixed image-data|
<br />  

### Boolean:

##### Boolean byte-value:  
- 0x00: false  
- not 0x00: true

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | byte | 0 | y | default value
<br />  

### Numbers:

- uint8, int8, uint16, int16, ...  
- Vector2f32, Vector2i32, Vector3f32, Vector3i32, ...  

See [Datatype table](#datatype-table) for all number-types.  
Floating point values follow the [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/) standard.


| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | of type | 0 | y | default value
| minimum | 0x31 (49) | of type | minimum of type | y | Smallest allowed value
| maximum | 0x32 (50) | of type | maximum of type | y | Biggest allowed value
| stepsize | 0x33 (51) | of type | 0 | y | The stepsize must be >= 0. It constrains possible values to a multiple of the stepsize. A value of 0 means: no constraint.
| unit | 0x34 (52) | string-short | "" | y | The unit of the value.
<br />  

### Range:

Range for number types: see [Datatype table](#datatype-table) for all number-types.

##### Range data:  
2 consecutive values of the number type where the first value in the data is the lower value and the seconds is the higher value of the range.  
e.g.:   
Range-data for a number of type \<int8>: `0x01 0x0a`


| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **elementtype** | - | byte-array | TypeDefinition | n | Number type-defintion of range element
| default | 0x30 (48) | Range data | 0 0 | y | default value
<br />  

### String

##### String data: 
string-long  
<br />  

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | string-long | 0 | y | default value
| regular expression | 0x31 (49) | string-long | 0 | y | A regular expression to define allowed string values. E.g.: limit the amount of newlines: "\\A(?>[^\r\n]*(?>\r\n?|\n)){0,3}[^\r\n]*\\z"
<br />  

### Color: RGB, RGBA

##### Color data:
int32  
Colors are represented in a 32bit value in byte-order (big-endian) with 8-bits per channel:

e.g. RGBA:  
* Red opaque: `0xFF 0x00 0x00 0xFF`  
* Red transparent: `0x00 0x00 0x00 0xFF`  
* Green opaque: `0xFF 0x00 0xFF 0x00`  
* Blue 50% transparent: `0x80 0xFF 0x00 0x00`

e.g. RGB:  
* Red: `0xFF 0x00 0x00 0xFF`  
* Green: `0xFF 0x00 0xFF 0x00`  
* Blue: `0xFF 0xFF 0x00 0x00`  


| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | int32 | 0 | y | default value
<br />  

### Enum

##### Enum data:
Enum data is a size-prefixed array of \<uint16>-indices representing the selection in the enum. 
Size-prefix: \<uint16>

e.g.: a selection of 2 indices (0 and 1):  
`0x00 0x02 0x00 0x00 0x00 0x01`

value is a size-prefixed array of uint16.

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | Enum data | 0 | y | default value, selection indices
| entries | 0x31 (49) | size-prefixed (uint16) array of string-short | 0 | y | list of enumerations
| minimum selection count | 0x32 (50) | uint16 | 0 | y | the minimum amount of allowed selected items (<= maximum selection count)
| maximum selection count | 0x33 (51) | uint16 | 1 | y | the maximum amount of allowed selected items (>= minimum selection count)
<br />  

### Array

##### Array structure:  
\<dimension-count> followed by \<elemente per dimension>  
dimension-count: \<int32>  
elements per dimension: dimension-count x \<int32>  

E.g.: a 3-dimensionsal array with 2 times 2 times 1 elements (int[2][2][1]):  `3 2 2 1`

##### Array data:  
Number of bytes defined by the element-type and the structure.  
<br />  

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | - | n | TypeDefintion of array elements (all except array, list)
| **structure** | - | Array structure | - | n | defines the structure of the array: number of dimensions and elements per dimensions
| default | 0x30 (48) | Array data | - | y | default value
<br />  

### List

##### List data:  
A size-prefixed list of values for each dimension.

e.g.:  
`[] –> 0`  
`[a] -> 1 a`  
`[a, b] -> 2 a b`  
`[ [a, b, c], [d, e, f] ] -> 2 3 a b c 3 d e f`  
`[ [a, b, c], [d, e] ] -> 2 3 a b c 2 d e`  
`[ [ [1], [2], [3] ], [ [4], [5], [6] ] ] ->
2 3 1 1 1 2 1 3 3 1 4 1 5 1 6`  
<br />

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **elementtype** | - | TypeDefinition | - | n | TypeDefintion of array elements (all except array, list)
| default | 0x30 (48) | List data | 0 | y | default value
| minimum | 0x32 (50) | one-dimensional list of \<int32> | 0 | y | The minimum length of list per dimension. If minimum length of a dimension is not specified, then the minimum length is 0.
| maximum | 0x33 (51) | one-dimensional list of \<int32> | 0 | y | The maximum length of list per dimension. If maximum length of a dimension is not specified, then the maximum length is the maximum value of int32.
<br />  

### URI:

##### Uri data:
string-long

Size-prefixed UTF-8 string forming an URI

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | string-long | 0 | y | default value
| filter | 0x31 (49) | string-short | 0 | y | If empty no filter is set and all files/pathes are allowed. A value of "dir" or a file-filter as defined [here](https://msdn.microsoft.com/en-us/library/system.windows.forms.filedialog.filter(v=vs.110).aspx) restricts the value.
| schema | 0x32 (50) | string-short | 0 | y | A space seperated list with allowed schemas. e.g. "file ftp http https".<br/>Emptry string means all schemes are allowed.
<br />  

### IPv4:

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | 4 bytes | 0 | y | default value
<br />  

### IPv6:

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | 16 bytes | 0 | y | default value
<br />  

### Image:

#### Image-data:
\<size-prefix> followed by \<image-data>  
size-prefix: uint32  
image-data: bytes of one of the following image-formats: JPEG, PNG, BMP, GIF  

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| default | 0x30 (48) | image-data | 0 | y | default image
<br />  

### Custom Type:

| Name          | ID hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **size** | - | uint32 | - | n | The amount of bytes for that value.
| default | 0x30 (48) | size-amount of bytes | - | y | default value
| uuid | 0x31 (49) | UUID: 16 bytes  | - | y | UUID of custom type. This must be a valid UUID (!= 0) to avoid custom value-conflicts. The UUID must be sent on initialize but can be omitted on updates.
| config | 0x32 (50) | uint32 size-prefixed byte-array | - | y | Custom config - can be anything.
