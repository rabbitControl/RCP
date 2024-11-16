back to: [RCP Specification](RCPSpecification.md)  
jump to: [RCP Widget](RCPWidget.md)


## Typedefinition:

### Datatype Id

The `Datatype Id` consits of 8 bits (one octet) where the most significant bit determines whether options are following (0) or not (1).

      7 6 5 4 3 2 1 0 
     +-+-------------+
     |T| Datatype Id |
     |E|     (7)     |
     |R|             |
     |M|             |
     +-+-------------+
     
- TERM: terminator bit. It marks the end of options.  
<br />


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| **Datatype Id** | - |  [Datatype Id](#Datatype-Id) | 0x21 | n | The type of the value - see [datatype table](#Datatype-table). | 1.0
| ... type options... | | | | | Options for the type. See below. |


### Datatype table:

| Datatype   | Datatype Id<br/>hex&nbsp;(dec)   | Length (bytes)   |
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
| String | 0x21 (33) | [RCP String](RCPSpecification.md#RCP-String)
| RGB | 0x22 (34) | 3 |
| RGBA | 0x23 (35) | 4 |
| RGB Float | 0x24 (36) | 3 x 4 |
| RGBA Float | 0x25 (37) | 4 x 4 |
| Enum | 0x26 (38) | Array of [RCP String](RCPSpecification.md#RCP-String) |
| Array | 0x27 (39) | Defined by array-structure |
| List | 0x28 (40) |
| Bang | 0x29 (41) | 0 |
| Group | 0x2a (42) | 0 |
| URI | 0x2b (43) | [RCP String](RCPSpecification.md#RCP-String) |
| IPv4 | 0x2c (44) | 4 |
| IPv6 | 0x2d (45) | 16 |
| Range | 0x2e (46) | 2 x number-type-size|
| Image | 0x2f (47) | size-prefixed image-data|
<br />  

### Boolean:

##### Boolean data:  
One byte is used for the boolean value.  
- 0x00: false  
- not 0x00: true

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since |
| --------------|---------------------|-----------|-----------------|------------|---------------|-----|
| default | 0x30 (48) | byte | 0 | y | default value | 1.0
<br />  

### Numbers:

- uint8, int8, uint16, int16, ...  
- Vector2f32, Vector2i32, Vector3f32, Vector3i32, ...  

See [Datatype table](#datatype-table) for all number-types.  
Floating point values follow the [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/) standard.


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| default | 0x30 (48) | of type | 0 | y | default value | 1.0
| minimum | 0x31 (49) | of type | minimum of type | y | Smallest allowed value (inclusive) | 1.0
| maximum | 0x32 (50) | of type | maximum of type | y | Biggest allowed value (inclusive) | 1.0
| stepsize | 0x33 (51) | of type | 0 | y | The stepsize must be >= 0. It constrains possible values to a multiple of the stepsize. A value of 0 means: no constraint. | 1.0
| unit | 0x34 (52) | [RCP String](RCPSpecification.md#RCP-String) | "" | y | The unit of the value. | 1.0
<br />  

### Range:

Range for number types: see [Datatype table](#datatype-table) for all number-types.

##### Range data:  
2 consecutive values of the number type.  
e.g.:   
Range-data for a number of type \<int8>: `0x01 0x0a`


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| **elementtype** | - | TypeDefinition |0x99 | n | Number type-defintion of range element.<br />Default: float32 without options. | 1.0
| default | 0x30 (48) | Range data | 0 1 | y | default value | 1.0
<br />  

### String

##### String data: 
[RCP String](RCPSpecification.md#RCP-String)  
<br />  

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| default | 0x30 (48) | [RCP String](RCPSpecification.md#RCP-String) | 0 | y | default value | 1.0
| regular expression | 0x31 (49) | [RCP String](RCPSpecification.md#RCP-String) | 0 | y | A regular expression to define allowed string values. E.g.: limit the amount of newlines: "\\A(?>[^\r\n]*(?>\r\n?\|\n)){0,3}[^\r\n]*\\z" | 1.0
<br />  


### Color: RGB

##### Color data:
3 bytes to encode the channels R, G, B  

e.g. RGB:  
* Red: `0xFF 0x00 0x00`  
* Green: `0x00 0xFF 0x00`  
* Blue: `0x00 0x00 0xFF`  


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|-----|
| default | 0x30 (48) | 3 bytes | 0 | y | default value | 1.0
<br />  


### Color: RGBA

##### Color data:
4 bytes to encode the channels R, G, B, A  

e.g. RGBA:  
* Red opaque: `0xFF 0x00 0x00 0xFF`  
* Red transparent: `0xFF 0x00 0x00 0x00`  
* Green opaque: `0x00 0xFF 0x00 0xFF`  
* Blue 50% transparent: `0x00 0x00 0xFF 0x80`


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| default | 0x30 (48) | 4 bytes | 0 | y | default value | 1.0
<br />  


### Color: RGB Float

##### Color data:
3 float32 (big-endian) to encode the channels R, G, B in the range of 0 .. 1  

e.g. RGBA:  
* Red: `0x0000803f 0x00000000 0x00000000`  
* Green: `0x00000000 0x0000803f 0x00000000`  
* 50% Blue: `0x00000000 0x00000000 0x0000003f`


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|-----|
| default | 0x30 (48) | 3 x 4 bytes | 0 | y | default value | 1.0
<br />  


### Color: RGBA Float

##### Color data:
4 float32 (big-endian) to encode the channels R, G, B, A in the range of 0 .. 1  

e.g. RGBA:  
* Red opaque: `0x0000803f 0x00000000 0x00000000 0x0000803f`  
* Red transparent: `0x0000803f 0x00000000 0x00000000 0x00000000`  
* Green opaque: `0x00000000 0x0000803f 0x00000000 0x0000803f`  
* Blue 50% transparent: `0x00000000 0x00000000 0x0000803f 0x0000003f`


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| default | 0x30 (48) | 4 x 4 bytes | 0 | y | default value | 1.0
<br />  

### Enum

##### Enum data:
[RCP Int](RCPSpecification.md#RCP-Int) size-prefixed array of [RCP Int](RCPSpecification.md#RCP-Int)-indices representing the selection in the enum.  

e.g.: a selection of 2 indices (0 and 1):  
`0x82 0x80 0x81`  
<br />


| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|-------|
| default | 0x30 (48) | Enum data | 0 | y | default value, selection indices | 1.0
| entries | 0x31 (49) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed array of [RCP Language String](RCPSpecification.md#RCP-Language-String) | 0 | y | list of enumerations | 1.0
| minimum selection count | 0x32 (50) | [RCP Int](RCPSpecification.md#RCP-Int) | 0 | y | the minimum amount of allowed selected items (<= maximum selection count) | 1.0
| maximum selection count | 0x33 (51) | [RCP Int](RCPSpecification.md#RCP-Int) | 1 | y | the maximum amount of allowed selected items (>= minimum selection count) | 1.0
<br />  

### Array

##### Array structure:  
\<dimension-count> followed by \<elements per dimension>  
dimension-count: [RCP Int](RCPSpecification.md#RCP-Int)  
elements per dimension: one [RCP Int](RCPSpecification.md#RCP-Int) per dimension  

E.g.: a 3-dimensional array with 2 times 2 times 1 elements (int[2][2][1]):  `3 2 2 1`. Encoded in RCP Int: `0x83 0x82 0x82 0x81`.  

##### Array data:  
Number of bytes defined by the element-type and the structure.  
<br />  

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| **elementtype** | - | TypeDefinition | - | n | TypeDefintion of array elements (all except array, list) | 1.0
| **structure** | - | Array structure | - | n | defines the structure of the array: number of dimensions and elements per dimensions | 1.0
| default | 0x30 (48) | Array data | - | y | default value | 1.0
<br />  

### List

##### List data (TBD):  
A [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed list of values for each dimension.

e.g.:  
`[] –> 0`  
`[a] -> 1 a`  
`[a, b] -> 2 a b`  
`[ [a, b, c], [d, e, f] ] -> 2 3 a b c 3 d e f`  
`[ [a, b, c], [d, e] ] -> 2 3 a b c 2 d e`  
`[ [ [1], [2], [3] ], [ [4], [5], [6] ] ] ->
2 3 1 1 1 2 1 3 3 1 4 1 5 1 6`  
<br />

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| **elementtype** | - | TypeDefinition | - | n | TypeDefintion of array elements (all except array, list) | 1.0
| default | 0x30 (48) | List data | 0 | y | default value | 1.0
| minimum | 0x32 (50) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed of [RCP Int](RCPSpecification.md#RCP-Int) | 0 | y | The minimum list-length per dimension. | 1.0
| maximum | 0x33 (51) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed of [RCP Int](RCPSpecification.md#RCP-Int) | 0 | y | The maximum list-length per dimension. | 1.0
<br />  

### URI:

##### Uri data:
[RCP String](RCPSpecification.md#RCP-String)

filter definition: 
- "dir": for choosing a directory
- pairs of: human-readable-string|*.suffix: for choosing a file

e.g.: txt files (*.txt)|*.txt|All files (*.*)|*.*

e.g.: dir

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|------|
| default | 0x30 (48) | [RCP String](RCPSpecification.md#RCP-String) | 0 | y | default value | 1.0
| filter | 0x31 (49) | [RCP String](RCPSpecification.md#RCP-String) | 0 | y | If empty no filter is set and all files/pathes are allowed. see filter definition above. | 1.0
| schema | 0x32 (50) | [RCP String](RCPSpecification.md#RCP-String) | 0 | y | A space seperated list with allowed schemas. e.g. "file ftp http https".<br/>Empty string means all schemes are allowed. | 1.0
<br />  

### IPv4:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|-----|
| default | 0x30 (48) | 4 bytes | 0 | y | default value | 1.0
<br />  

### IPv6:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| default | 0x30 (48) | 16 bytes | 0 | y | default value | 1.0
<br />  

### Image:

#### Image-data:
[RCP Int](RCPSpecification.md#RCP-Int) size-prefix followed by \<image-data>  
image-data: bytes of one of the following image-formats: JPEG, PNG, BMP, GIF  

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| default | 0x30 (48) | image-data | 0 | y | default image | 1.0
<br />  

### Custom Type:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since
| --------------|---------------------|-----------|-----------------|------------|---------------|----|
| **size** | - | [RCP Int](RCPSpecification.md#RCP-Int) | - | n | The amount of bytes for that value. | 1.0
| default | 0x30 (48) | size-amount of bytes | - | y | default value | 1.0
| typeid | 0x31 (49) | [RCP Int](RCPSpecification.md#RCP-Int)  | - | y | ID of custom type. The ID must be sent on initialize but can be omitted on incremental updates. | 1.0
| config | 0x32 (50) | [RCP Int](RCPSpecification.md#RCP-Int) size-prefixed byte-array | - | y | Custom config - can be anything. | 1.0
