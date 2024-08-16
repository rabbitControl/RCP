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


## Endianess

For multi byte data words, network byte order (big endian) is used.

## Byte / Bits

1 byte equals to 8 bits (one octet).

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
     
#### Option Id 0 (packet terminator)

An [Option Id](#Option-Id) of 0 with terminator-flag set (0x80) is used as terminator for [packets](#packet).  

## Option order

Optional properties can be randomly ordered.

## Parameter Id

The parameter-id is a unique identifier for each parameter. The paramter-id 0 is reserved and identifies the virtual [root-group](#Root-Parameter-Group).

The parameter-id is encoded in a sequence of bytes (at least one), where the most significant bit of each byte defines whether this byte is the last byte of the `Parameter Id` sequence.  
To obtain the value of the `Parameter Id`, each byte needs to be masked with 0x7F.

Implementations shall avoid sending useless 0-bytes. E.g.: if a `Parameter Id` is smaller than 128 only one byte should be sent.

NOTE: This design introduces a volatility. The protocol can be stalled by continuously sending valid parts of a paramter id, never ending it.

Big endian applies: the first byte in the data stream is the most significant byte.

      7 6 5 4 3 2 1 0 
     +-+-------------+
     |T|  Parameter  |
     |E|     Id      |
     |R|    Part     |
     |M|    (7)      |
     +-+-------------+
     
- TERM: terminator bit
- Parameter Id part: The value of the parameter id
     
E.g. Parameter Id 1:

      7 6 5 4 3 2 1 0 
     +-+-------------+
     |1|0 0 0 0 0 0 1|	= 1
     +-+-------------+

E.g. Parameter Id 129: 

      7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 
     +-+-------------+-+-------------+
     |0|0 0 0 0 0 0 1|1|0 0 0 0 0 0 1| = 129
     +-+-------------+-+-------------+


## String types

RCP uses two different string types which are defined in the following form:

- string-short:
  - A string prefixed with the string length using \<uint8> as the prefix followed by UTF-8 string-data.
- string-long:
  - A string prefixed with the string length using \<uint16> as the prefix followed by UTF-8 string-data.

## Multilanguage string:

RCP supports multiple languages by using multi-language strings. A `Multilanguage string` contains multiple versions of the string in different languages. Each language is prefixed with a [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code or `any` for no specific language.  

All the languages are transmitted at once. We decided to favour this over a different approach where languages would need to be declared and translations would need to be fetched when switching a language in a frontend.

  - A terminated list of [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) language-code (3-bytes in ascii) followed by a string-short or string-long.
  - The list is terminated with a 0-byte.
  - Additionally to the [ISO 639-3](https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) codes we define a special code for no specific language: `any` which is used as default language.


## Packet

RCP wraps data into data packets with an optional timestamp. Data can be chained.

     0               1              1/8
      7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 6 5 4 3 2 1 0 7 ...   7 6 5 4 3 2 1 0
     +-+-+-+---------+---------------+-----------------------+--------------+
     |T|M|R| Command |   Timestamp   | Command specific data |  Terminator  |
     |S|U|S|   (5)   |  (if TS is 1) | Command specific data |   (if MULT)  |
     | |L|V|         |      (64)     |  ...                  |     0x80     |
     | |T| |         |               |                       |              |
     +-+-+-+---------+---------------+-----------------------|--------------+
     
     

- TS: Timestamp flag. If this flag is set the first 64 bit after the command is a timestamp.
- MULT: If multiple data we expect a terminator, otherwise not.
- RSV: Reserved for future use.
- [Command](#command-table): The command defines what the packet data means.
- Timestamp: A 64bit timestamp if the timestamp-flag is set.
- Data: The data as defined by the command.  
- Terminator: 0x80 if MULT is set.


### Command table

| Command   | ID   | Expected data | Comment   |
|-----------|------|---------------|-----------|
| info | 0x01 | not set or [Info data](#info-data) | If no data is set in the packet it is a request for [Info Data](#info-data). In this case a info-packet with valid [Info Data](#info-data) needs to be sent back to the origin of the request.<br>If data is set in the packet it must not be answered.
| initialize | 0x02 | - | On servers: request for all parameters. A server needs to send update-packets for all parameters to (only) the requesting client to fully initialize that client. After sending all parameters the server sends "initialize" back to the client. Only after sending all parameters to a client the server starts sending incremental update packets to this client. On clients: marks the end of the initial list of parameters. Clients ignore value-updates until they receive "initialize".
| update | 0x03 | [Parameter data](#Parameter-data) | Incremental update packets must only be sent to fully initialized clients.<br>Data chaining: the data field can contain more than one [Parameter Data](#parameter-data).
| updatevalue | 0x04 | [Update value data](#Update-value-data) | See [Update value](#Update-value). Valueupdate packets must only be sent to fully initialized clients.<br>Data chaining: the data field can contain more than one [Update value](#Update-value) data.
| remove | 0x05 | [Parameter Id](#Parameter-Id) | This is used to identify parameters for deletion.<br>Data chaining: the data field can contain more than one [ID Data](#ID-data).

- Clients send:
	- info
	- initialize
	- update
	- updatevalue
- Servers send:
	- info
	- update
	- updatevalue
	- remove

## Info Data

| Name          | Option Id<br/>hex&nbsp;(dec)   | ValueType      | default value   | optional   | description   |
| --------------|--------------|----------------|-----------------|------------|---------------|
| **version**   | - | string-short    | - | n | String in [semver](https://semver.org/) format.
| applicationid       | 0x1a	(26)   | string-short    | "" |y| Can be used to identify the server/client application.
| applicationversion  | 0x1b	(27)   | string-short     | "" |y| version of application


## Parameter Data

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| **id** | - | [Parameter Id](#Parameter-Id) | - | - | Unique parameter identifier. Needs to be != 0.<br>A parameter-id of 0 identifies the virtual root group. Also see "parent".
| **typedefinition** |	- | [Typedefinition](RCPValue.md) | - | n | Typedefinition of value.<br/>See: [Typedefinition](RCPValue.md)
| value | 0x20 (32) | known from typedefinition | type-specific default | y |	The value. Byte-length is known from type.
| label | 0x21 (33)	| multilanguage string-short | "" | y | Human readable identifier.
| description | 0x22 (34) | multilanguage string-long | "" | y | The description of the parameter.
| tags | 0x23 (35)	|	string-short | "" | y | Space separated list of tags. (Tags containing spaces are not supported)
| order | 0x24 (36)	|	int32 | 0 | y | Allows to sort paramters. This is useful when using auto-layouts like a list of parameters.
| parentid | 0x25 (37)	|	[Parameter Id](#Parameter-Id) | 0 | y | Specifies a ParameterGroup as parent. See [Parameter Group](#Parameter-Group).
| widget | 0x26 (38) | [Widget data](RCPWidget.md) | default-widget (0x0001) | y | Specify the widget for this parameter. Senseful defaults are specified for different datatypes. See [Widget data](RCPWidget.md) for more information.
| userdata | 0x27 (39) | uint32 size-prefixed array of bytes | - | y | A place for various user-data.
| userid | 0x28 (40) | string-short | "" | y | A custom user-id
| readonly | 0x29 (41) | byte | 0 (false) | y | If the parameter is read-only a server does not accept remote updates. On a client the widget is disabled showing the current value.
| enabled | 0x30 (42) | byte | 1 (true) | y | If not enabled the visual representation of the parameter is disabled (grayed out). A not enabled parameter indicates a parameter currently not in use.


## Parameter Group:

A `Parameter Group` is a parameter without value and a group-typedefintion without default-value to organize parameters in a tree structure.

A parameter can only be child of excactly one group (see parent-option of parameter).

#### Default override:

| Name          | Option Id<br/>hex&nbsp;(dec)   | Type      | Default value   | Optional   | Description   |
| --------------|---------------------|-----------|-----------------|------------|---------------|
| widget | 0x26 (38) | widget data | List-widget (0x4000) | y | See: [Widget Specification](RCPWidget.md)


#### Root Parameter Group

The root `Parameter Group` is a virtual group which does always exist. It defines the highest level in the hierarchy tree.

The parameter-id of the root group is 0.

No other Parameter is allowed to use this parameter id.

To configure the root group you can send a non-multi parameter-update packet. Typically only the widget can be set on the root group.


## Update value data

To optimize the update of a parameter value a special form is defined:

| Name          | Type      | Value   | Optional   | Description   |
| --------------|-----------|---------|------------|---------------|
| **parameter id**  | [Parameter Id](#Parameter-Id)          | -         | n | Tghe Parameter id.<br>A value of 0 is invalid, the packet shall be discarded in this case.
| **mandatory part of datatype**   | Typedefinition | datatype-data | n | Mandatory part of the datatype without options.<br>Needed to be able to resolve this packet without additional lookup.
| **value**         | type of datatype  | value-data | n | the value of type as defined in Datatype.

This reduces the amount of data to be sent when only updating the value especially when chaining parameter updates.

E.g.:

Updating a parameter of \<int32> with id 1 to value 255 only needs 7 bytes:

`0x06 0x81 0x95 0x00 0x00 0x00 0xFF`
