## RCP Levels:
- [Value](RCPValue.md):
  - Value without visual representation
  - Boolean, Numbers, String, Color, etc.
  - Custom type

- [Widget](RCPWidget.md):
  - The visual representation of a value
  - Widgets must be implemented client-side
  - The protocol defines standard widgets for basic types
  - Button, Slider, Dial, etc.
  - Custom widget

## Versioning

[Versioning](Versioning.md)

## Protocol Flow

[Protocol Flow](Flow.md)

## Endianess

For multi byte data words, network byte order (big endian) is used.

## Byte / Bits

1 byte equals to 8 bits (one octet).

## RCP Int

RCP Int is a flexible value encoding to minimize the amount of bytes necessary to transmit values.

A value encoded as `RCP Int` consits of a series of maximum 4 bytes where the most significant bit of each byte determines whether more bytes are following (0) or not (1). (Termination bit)  


      7 6 5 4 3 2 1 0 
     +-+-------------+
     |T| flexible    |
     |E|   value (7) |
     |R|             |
     |M|             |
     +-+-------------+
     
- TERM: Terminator bit
- flexible value: One part of a flexible value


To obtain the value each byte needs to be masked with 0x7F. Big endian applies for the sequence of bytes: the first byte in the data stream is the most significant byte. Implementors can use an int32 for the decoded value. RCP Int's maximum unsigned value is 2^28 = 268435456, this fits in the positive range of a int32.

E.g.: Value "1" encoded:

      7 6 5 4 3 2 1 0 
     +-+-------------+
     |1|0 0 0 0 0 0 1|	= 1
     +-+-------------+

E.g.: Value "129" encoded: 

      7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 
     +-+-------------+-+-------------+
     |0|0 0 0 0 0 0 1|1|0 0 0 0 0 0 1| = 129
     +-+-------------+-+-------------+


## Option Id

RCP uses options in all parts of the protocol to setup [Values](RCPValue.md) or [Widgets](RCPWidget.md). Senseful default values are defined for common uses. Default values for options should not to be transmitted.  

The `Option Id` consits of 8 bits (one octet) where the most significant bit determines whether more options are following (0) or not (1).  

      7 6 5 4 3 2 1 0 
     +-+-------------+
     |T| Option Id   |
     |E|     (7)     |
     |R|             |
     |M|             |
     +-+-------------+
     
- TERM: Terminator bit
- Option Id: The value of the option id
     
## Option order

Optional properties can be randomly ordered.

## Parameter Id

The parameter-id is a unique identifier for each parameter. The paramter-id 0 is reserved and identifies the virtual [root-group](#Root-Parameter-Group).

The parameter-id is encoded as [RCP Int](#RCP-Int)

## RCP String

RCP string: [RCP Int](#RCP-Int) size prefix followd by UTF-8 string-data.

## RCP Language String:

RCP supports multiple languages by using RCP language string. A `RCP language string` contains multiple versions of the string in different languages. Each language is prefixed with a [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code or `any` for no specific language.  

All the languages are transmitted at once. We decided to favour this over a different approach where languages would need to be declared and translations would need to be fetched when switching a language in a frontend.

  - A terminated list of [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code (3-bytes in ascii) followed by an [RCP String](#RCP-String).
  - The list is terminated with a 0-byte.
  - Additionally to the [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) codes we define a special code for no specific language: `any` which is used as default language.


## Packet

RCP wraps data into data packets with an optional timestamp. Data can be chained.
Packets can not be chained because no packet-framing exists. Framing is assumed to be done on the transport level.

     0               1               2
      7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 ...   
     +-+-+-+---------+---------------+--------------------+
     |T|R|R|  Type   |   Timestamp   | Type specific data |
     |S|S|S|  (5)    |  (if TS is 1) | Type specific data |
     | |V|V|         |      (64)     |  ...               |
     | |1|2|         |               |                    |
     +-+-+-+---------+---------------+--------------------|
     
     

- TS: Timestamp flag. If this flag is set the first 64 bit after the type is a timestamp.
- RSV1: Reserved for future use.
- RSV2: Reserved for future use.
- [Type](#Packet-types): The type defines the packet data type.
- Timestamp: A 64bit timestamp if the timestamp-flag is set.
- Data: The data as defined by the packet type.  


### Packet types

| Type      | ID   | Packet Data   | As Command | As Response | Comment   | Since   |
|-----------|------|---------------|------------|-------------|-----------|---------|
| info | 0x01 | [Info data](#info-data) | from client | from server | See: [Version Handshake](Flow.md#version-handshake) | 1.0
| initialize | 0x02 | [RCP Int](#RCP-Int) | from client | from server |  See: [Initialization](Flow.md#initialization)<br>A server will only ever send this packet type in response. A client never answeres this packet type. | 1.0
| update | 0x03 | [Parameter data](#Parameter-data) | from client<br>from server | - | See: [Update](Flow.md#update)<br>Data chaining: the data field can contain more than one [Parameter Data](#parameter-data). | 1.0
| updatevalue | 0x04 | [Update value data](#Update-value-data) | from client<br>from server | - | See: [Update](Flow.md#update)<br>Data chaining: the data field can contain more than one [Update value data](#Update-value-data). | 1.0
| remove | 0x05 | [Parameter Id](#Parameter-Id) | from server | - | See: [Update](Flow.md#update)<br>Data chaining: the data field can contain more than one [Parameter Id](#Parameter-Id). | 1.0

## RCP Version

The RCP version consists of 2 bytes where the first byte is the major version and second byte is the minor version.

See: [Versioning](Versioning.md)

e.g.: 12 == Version 1.2

## Info Data

| Name          | Option Id<br/>hex&nbsp;(dec)   | ValueType      | Default value   | Optional   | Description   | Since   |
| --------------|--------------|----------------|-----------------|------------|---------------|----------|
| **version**   | - | [RCP Version](#RCP-Version)    | - | n | This is the version of the protocol implemented. | To ensure the handshake the definition of the RCP-Version must never change. 
| **handshake-version**   | - | [RCP Version](#RCP-Version)    | - | n | Server send their runtime-version and clients their base-version. | To ensure the handshake the definition of the RCP-Version must never change. 
| applicationid       | 0x1a	(26)   | [RCP String](#RCP-String)    | "" |y| Can be used to identify the server/client application. | 1.0
| applicationversion  | 0x1b	(27)   | [RCP String](#RCP-String)     | "" |y| version of application | 1.0

In case no optional option is present, [Info Data](Info-Data) needs to be terminated with 0x80.

## Parameter Data

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   | Since |
| --------------|---------------------|-----------|-----------------|------------|---------------|--------|
| **id** | - | [Parameter Id](#Parameter-Id) | - | n | Unique parameter identifier. Also see "parentid". | 1.0
| **typedefinition** |	- | [Typedefinition](RCPValue.md) | - | n | Typedefinition of value.<br/>See: [Typedefinition](RCPValue.md) | 1.0
| value | 0x20 (32) | known from typedefinition | type-specific default | y |	The value. Byte-length is known from type. | 1.0
| label | 0x21 (33)	| [RCP Language String](#RCP-Language-String) | "" | y | Human readable identifier. | 1.0
| description | 0x22 (34) | [RCP Language String](#RCP-Language-String) | "" | y | The description of the parameter. | 1.0
| tags | 0x23 (35)	|	[RCP String](#RCP-String) | "" | y | Space separated list of tags. (Tags containing spaces are not supported) | 1.0
| order | 0x24 (36)	|	[RCP Int](#RCP-Int) | 0 | y | Allows to sort paramters. This is useful when using auto-layouts like a list of parameters. | 1.0
| parentid | 0x25 (37)	|	[Parameter Id](#Parameter-Id) | 0 | y | Specifies a ParameterGroup as parent. See [Parameter Group](#Parameter-Group). | 1.0
| widget | 0x26 (38) | [Widget data](RCPWidget.md) | default-widget (0x0001) | y | Specify the widget for this parameter. Senseful defaults are specified for different datatypes. See [Widget data](RCPWidget.md) for more information. | 1.0
| userdata | 0x27 (39) | [RCP Int](#RCP-Int) size-prefixed array of bytes | - | y | A place for various user-data. | 1.0
| userid | 0x28 (40) | [RCP String](#RCP-String) | "" | y | A custom user-id | 1.0
| readonly | 0x29 (41) | byte | 0 (false) | y | If the parameter is read-only a server does not accept remote updates. On a client the widget is disabled showing the current value. | 1.0
| enabled | 0x30 (42) | byte | 1 (true) | y | If not enabled the visual representation of the parameter is disabled (grayed out). A not enabled parameter indicates a parameter currently not in use. | 1.0

In case no optional option is present, [Parameter Data](Parameter-Data) needs to be terminated with 0x80.

## Parameter Group:

A `Parameter Group` is a parameter without value and a group-typedefintion without default-value to organize parameters in a tree structure.

A parameter can only be child of excactly one group (see parent-option of parameter).

#### Default override:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| widget | 0x26 (38) | widget data | List-widget (0x4000) | y | See: [Widget Specification](RCPWidget.md)


#### Root Parameter Group

The root `Parameter Group` is a virtual group which does always exist. It defines the highest level in the hierarchy tree. The parameter-id of the root group is 0. No other Parameter is allowed to use this parameter id. To configure the root group you can send a non-multi parameter-update packet. A non-multi parameter-update packet is necessary because the parameter-id 0 and the [Packet Terminator](#packet) both have the same value (0x80). Typically only the widget can be set on the root group.


## Update value data

To optimize the update of a parameter value a special form is defined:

| Name          | Type      | Value   | Optional   | Description   | Since |
| --------------|-----------|---------|------------|---------------|-------|
| **parameter id**  | [Parameter Id](#Parameter-Id)          | -         | n | The Parameter id.<br>A value of 0 is invalid (the virtual root-group does not have a value). | 1.0
| **mandatory part of datatype**   | Typedefinition | datatype-data | n | Mandatory part of the datatype without options.<br>Needed to be able to resolve this packet without additional lookup. | 1.0
| **value**         | type of datatype  | value-data | n | the value of type as defined in Datatype. | 1.0

This reduces the amount of data to be sent when only updating the value especially when chaining parameter updates.

E.g.:

Updating a parameter of \<int32> with id 1 to value 255 only needs 7 bytes:

`0x06 0x81 0x95 0x00 0x00 0x00 0xFF`
